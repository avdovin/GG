package GG::Plugins::Admin;
use Mojo::Base 'Mojolicious::Plugin';

use utf8;
use GG::CLS::Users;

sub register {
	my ($self, $app, $conf) = @_;

	unless (ref($app)->can('sysuser')){
		ref($app)->attr('sysuser');
	}
	unless (ref($app)->can('program')){
		ref($app)->attr('program');
	}


	$app->sessions->default_expiration(3600*24*7*48);
	$app->sessions->cookie_name("GG");
	#$app->sessions->cookie_path('/admin/');

	push @{$app->plugins->namespaces}, 'GG::Admin::Plugins';

	$app->plugin('table_list');
	$app->plugin('anket_form');
	$app->plugin('init_json' );
	$app->plugin('fields' );

	my %defaults = (
		namespace   => 'GG::Admin',
		controller  => 'global',
		cb          => undef
	);

	my $r = $app->routes;

	$r->route('/admin/nothing')->to(%defaults, cb => sub {
		shift->render( data => '');
	});

	$r->route('/admin')->to(%defaults, cb => sub {
		my $self = shift;

		$self->admin_getUser;

		$self->render(template	=> "Admin/page_start" );
	})->name('login_form');

	$r->route('/admin/form_auth')->to(%defaults, cb => sub {
		my $self = shift;

		# Проверяем валидность сессии
		if( $self->admin_getUser( updateAccess => 1, password => $self->param('authpassword') || '' ) ){

			# Просчитываем права
			$self->app->sessions->cookie_path('/admin/');

			$self->render(template	=> "Admin/quick_auth_reload" );
		} else{
			$self->render(template	=> "Admin/form_auth" );
		}
	});


	$r->route('/admin/logout')->to(%defaults, cb => sub {
		my $self = shift;

		if($self->admin_getUser){
			$self->admin_logout();
		}

		$self->redirect_to('login_form');
	});

	$app->helper( admin_logout => sub {
			my $self   = shift;
			my $resetCck = shift || 1;

			if( my $login = $self->cookie('admin_login') ){

				#$self->app->dbi->query("UPDATE `sys_users` SET cck='' WHERE `login`='$login'") if $resetCck;
				$self->dbi->dbh->do("DELETE FROM `sys_users_session` WHERE `id_user`=? AND `cck`=? ",
					undef, $self->app->sysuser->userinfo->{ID}, $self->app->sysuser->userinfo->{cck} );

				$self->cookie('admin_cck', '', {
						path 	=> '/admin',
						expires	=> time-1000
					}
				);

				$self->cookie('admin_login', '', {
						path 	=> '/',
						expires	=>  time-1000
					}
				);

				$self->cookie('vfe', '', {
						path 	=> '/',
						expires	=> time-1000
					}
				);
			}

			$self->render( json => {
				content	=> 'LOGOUT',
				items 	=> [],
			});
	});

	my $admin_route = $r->bridge('/admin')->to(%defaults, cb => sub {
		my $self = shift;

		unless($self->admin_getUser){

			$self->redirect_to('login_form');
			return;
		}
		$self->stash->{document_root} = $self->app->home->rel_dir( "../" )."/";

	});
	$admin_route->route('/auth')->to(%defaults, cb => sub{ shift->render(template	=> "Admin/form_auth" )});

	$admin_route->route('/:controller/body')->to(action => 'body')->name('admin_routes_to_body');
	$admin_route->route('/:controller/:action')->name('admin_routes');


	$app->hook(
		before_dispatch => sub {
			my $self = shift;

			$self->app->sysuser(GG::CLS::Users->new( dbi => $self->app->dbi));
		}
	);


	$app->helper(
		admin_getUser => sub {
			my $self   = shift;
			my %params = (
				updateAccess	=> 0,
				password		=> '',
				@_
			);

			$params{login} ||= $self->param('userlogin') || $self->cookie('admin_login');
			$params{cck} ||= $self->param('cck') || $self->cookie('admin_cck');

			$self->app->sysuser->auth(0);

			if ($params{password}) {	# есть пароль и нет ключа сессии

				return unless $self->admin_checklogin( %params);


				$self->cookie('admin_cck', $self->app->sysuser->userinfo->{cck}, {
						path 	=> '/admin',
						expires	=> $self->app->sysuser->userinfo->{cck} ? time+360000000 : time-1000
					}
				);

				$self->cookie('admin_login', $self->app->sysuser->userinfo->{login}, {
						path 	=> '/',
						expires	=> $self->app->sysuser->userinfo->{cck} ? time+360000000 : time-1000
					}
				);

				my $vfe = $self->app->sysuser->userinfo->{login} && $self->app->sysuser->userinfo->{vfe} ? 1 : '' && $self->app->sysuser->userinfo->{cck} ? 1 : '';
				$self->cookie('vfe', $vfe, {
						path 	=> '/',
						expires	=> $vfe ? time+360000000 : time-1000
					}
				);


				# Очистка логов
				if( my $days_count = $self->app->get_var(name => 'time_log', controller => 'global') ){
					$self->app->dbh->do("DELETE FROM `sys_datalogs` WHERE TO_DAYS(NOW())-TO_DAYS(`rdate`)>$days_count");

					# 	Очистка юзер хистори
					$self->app->dbh->do("DELETE FROM `sys_history` WHERE TO_DAYS(NOW())-TO_DAYS(`rdate`)>$days_count");
					$self->app->dbh->do("OPTIMIZE TABLE `sys_history`");
				}
				# очистка старых сессий
				$self->app->dbh->do("DELETE FROM `sys_users_session` WHERE TO_DAYS(NOW())-TO_DAYS(`time`)>5");

			} else {

				return unless $self->admin_checkCCK(%params);
			}

			if($params{password} or $params{updateAccess}){
				$self->app->sysuser->clearAccess;
				$self->app->sysuser->check_modul_access();
			} else {
				$self->app->sysuser->restore_access;
			}

			return 1;
		}
	);

	$app->helper(
		admin_checkCCK => sub {
			my $self   = shift;
			my %params = (
				cck		=> '',
				login	=> '',
				from	=> 'sys_users',
				@_
			);

			if($self->param('auth')){
				if (!$params{login})  	 {
					$self->admin_msg_errors('Отсутствует логин') && return;
				}
				if (!$params{password})  	 {
					$self->admin_msg_errors('Отсутствует пароль') && return;
				}
			}

			if (!$params{cck})  	{
				$self->admin_msg_errors('Отсутствует ключ сессии') && return;

			} else {
				$params{where} = "`login`='$params{login}'";
			}

			my $ip  = $self->tx->remote_address;

			my $sql = "SELECT * FROM `$params{from}` WHERE $params{where}";
			my $user = $self->app->dbi->query($sql)->hash;

			unless($user){
				$self->admin_msg_errors('Ошибка login и/или пароля') && return;
			}

			if(my $session = $self->dbi->query("SELECT * FROM `sys_users_session` WHERE `id_user`='$$user{ID}' AND `cck`='$params{cck}'")->hash ){

				$self->dbi->dbh->do("UPDATE `sys_users_session` SET `time`=NOW() WHERE `id_user`='$$user{ID}' AND `cck`='$params{cck}' ");

				$self->app->sysuser->userinfo($user);
				$self->app->sysuser->sys($user->{sys});

				$self->app->sysuser->userinfo->{session} = $session;

				$self->app->sysuser->set_settings($user->{settings});
				$self->app->sysuser->userinfo->{cck} = $params{cck};

				# восстанавливаем настройки из сессии пользователя
				$self->app->sysuser->restore_ses_settings;

				$self->app->sysuser->auth(1);
			}
			else {
				$self->admin_msg_errors('Сессия прервана. Требуется повторная авторизация');
			}

			return $self->app->sysuser->auth;
		}
	);

	$app->helper(
		admin_checklogin => sub {
			my $self   = shift;
			my %params = (
				from 	=> 'sys_users',
				count	=> 10,
				login	=> '',
				password	=> '',
				@_
			);

			if (!$params{password})  {
				$self->admin_msg_errors('Пароль не указан') && return;
			}
			if (!$params{login})  	 {
				$self->admin_msg_errors('Login не указан') && return;
			}
			else {
				$params{where} = "`login`='$params{login}'";
			}

			my $ip  = $self->tx->remote_address;

			my $sql = "SELECT *,HOUR(NOW())-HOUR(btime) AS `bhour` FROM `$params{from}` WHERE $params{where} LIMIT 0,1";
			my $user = $self->app->dbi->query($sql)->hash;

			unless($user){
				$self->save_logs(name => 'Пожалуйста, введите верные логин и пароль #1', comment => "Логин: $params{login}, Пароль: $params{password}", program => 'auth');
				$self->admin_msg_errors(' Пожалуйста, введите верные логин и пароль. <br />Помните, оба поля чувствительны к регистру.') && return;
			}

			if ($user->{count} && ($user->{count} >= $params{count}) and ($user->{bhour} <= 3)) { # Проверка на количество неправильных попыток авторизации
				$self->save_logs(name => 'Попытка подбора пароля. Доступ для данного аккаунта временно ограничен', comment => "Логин: $params{login}, Пароль: $params{password}", program => 'auth' );
				$self->admin_msg_errors('Попытка подбора пароля. Доступ для данного аккаунта временно ограничен');

				# TODO: Send wrong auth mail
				eval{
					$self->mail(
						to      => $self->get_var( name => 'email_admin', controller => 'global', raw => 1 ),
						subject => 'Попытка подбора пароля на сайте '.$self->get_var( name => 'site_name', controller => 'global', raw => 1 ),
						data    => "Логин: <b>$params{login}</b> <br />Пароль: <b>$params{password}</b>, IP: <b>$ip</b>",
					);
				};

				return;

			} elsif ($user->{bhour} && ($user->{bhour} > 3)) { # Прошло больше трех часов с момента неправильной авторизации
				$sql = "UPDATE `$params{from}` SET `count`=0,`btime`='0000-00-00 00:00:00',`bip`='$ip' WHERE `login` = '$$self{user}{login}'";
				$self->app->dbi->query($sql);
			}

			if ($user->{password} && $params{password} && $user->{password} ne $params{password}) {  # Неверный пароль
				$sql = "UPDATE `$params{from}` SET `count`=`count`+1,`btime`=NOW(),`bip`='$ip' WHERE `login` = '$$user{login}'";
				$self->app->dbi->query($sql);

				my $count = $user->{count}+1;
				$self->admin_msg_errors(" Пожалуйста, введите верные логин и пароль. <br />Помните, оба поля чувствительны к регистру. <br />Попытка ($count из $params{count})");
				$self->save_logs(name => "Пожалуйста, введите верные логин и пароль #2. Попытка ($count из $params{count})", comment => "Логин: $params{login}, Пароль: $params{password}", program => 'auth');

			} else {
				$self->app->sysuser->userinfo($user);
				$self->app->sysuser->sys($user->{sys});

				my $cck = $self->defCCK($user->{login}, $user->{password});

				$self->app->dbi->query(qq/
					UPDATE `$params{from}`
					SET `count`='0',`btime`='0000-00-00 00:00:00'
					WHERE `ID`='$$user{ID}'
				/);
				$self->dbi->dbh->do("REPLACE `sys_users_session`(cck, time, host, ip, id_user) VALUES (?, NOW(), ?, ?, ?)", undef,
					$cck, $self->host, $ip, $user->{ID} );

				$self->app->sysuser->set_settings($user->{settings});
				$self->app->sysuser->{userinfo}->{cck} = $cck;
				$self->app->sysuser->auth(1);
			}

			return $self->app->sysuser->auth;

		}
	);

	$app->helper(
		save_logs => sub {
			my $self = shift;
			my %params = (
				name		=> '',
				comment		=> '',
				ip			=> $self->tx->remote_address || '',
				id_program	=> 0,
				eventtype	=> 0,
				event		=> '',
				id_sysuser  => 0,
				@_
			);
			return unless $params{name};

			if($params{event} eq 'add'){
				$params{eventtype} = 1;
			} elsif($params{event} eq 'delete'){
				$params{eventtype} = 2;
			} elsif($params{event} eq 'update'){
				$params{eventtype} = 3;
			} elsif($params{event} eq 'restore'){
				$params{eventtype} = 4;
			}

			if($self->app->sysuser){
				$params{id_sysuser} ||= $self->app->sysuser->userinfo->{ID};
			}
			if($self->app->sysuser){
				$params{id_sysusergroup} ||= $self->app->sysuser->userinfo->{id_group_user};
			}

			if($self->app->program){
				$params{id_program} ||= $self->app->program->{ID};
			}

			$self->app->dbi->insert_hash('sys_datalogs', {
				name 			=> $params{name},
				id_sysuser		=> $params{id_sysuser},
				id_sysusergroup		=> $params{id_sysusergroup},
				id_program		=> $params{id_program},
				ip				=> $params{ip},
				comment			=> $params{comment},
				eventtype		=> $params{eventtype},
			});
		}
	);

	$app->helper(
		has_errors => sub {
			my $self = shift;
			my $errors = $self->stash->{message}->{errors} || [];
			return scalar(@$errors);
		}
	);

	$app->helper(
		msg_no_wrap => sub {
			my $self  = shift;

			$self->stash->{msg_no_wrap} = 1;
			return $self->admin_msg;
		}
	);

	$app->helper(
		admin_msg => sub {
			my $self  = shift;

			#if($self->flash('admin_msg_errors')){
			#	$self->admin_msg_errors($self->flash('admin_msg_errors'));
			#} elsif($self->flash('admin_msg_success')){
			#	$self->admin_msg_success($self->flash('admin_msg_success'));
			#}

			$self->stash->{message}->{errors} ||= [];
			if(scalar(@{ $self->stash->{message}->{errors} })){
				return $self->admin_msg_errors;
			}
			return $self->admin_msg_success;
		}
	);

	$app->helper(
		admin_msg_success => sub {
			my $self  = shift;

			if($_[0]){
				push @{$self->stash->{message}->{success}}, $_[0];
			} else {
				my $msg = $self->stash->{message}->{success} || [];
				if(scalar(@$msg) > 0){
					my $no_wrap = delete $self->stash->{msg_no_wrap} || 0;
					return (!$no_wrap ? "<div class='message-success'>": "").join("<br />", @$msg).(!$no_wrap ? "</div>" : "");
				}
			}
		}
	);

	$app->helper(
		admin_msg_errors => sub {
			my $self  = shift;

			if($_[0]){
				push @{$self->stash->{message}->{errors}}, $_[0];
			} else {
				my $msg = $self->stash->{message}->{errors} || [];
				if(scalar(@$msg) > 0){
					my $no_wrap = delete $self->stash->{msg_no_wrap} || 0;
					return (!$no_wrap ? "<div class='message-error'>": "").join("<br />", @$msg).(!$no_wrap ? "</div>" : "");
				}
			}

		}
	);

	$app->helper(
		render_admin_msg_errors => sub {
			my $self  = shift;
			$self->admin_msg_errors($_[0]);
			$self->stash->{status} = 200;
			$self->stash->{inline} = $self->admin_msg_errors;
			$self->render;

		}
	);

	$app->helper(
		param_default => sub {
			my $self      = shift;
			if($_ [0]) {
				my %params = @_;
				foreach (keys %params){
					if($params{$_}){
						$params{$_} =~ s{\.}{}gi if($_ eq 'replaceme');
						$params{$_} =~ s{\/}{}gi if($_ eq 'replaceme');
						$self->stash->{param_default_keys}->{$_} = $params{$_};
					} else {
						delete $self->stash->{param_default_keys}->{$_};
					}
				}

				$self->stash->{param_default} = '&'.join("&", map{"$_=".$self->stash->{param_default_keys}->{$_} } keys %{$self->stash->{param_default_keys}} );
			} else {
				return ($self->stash->{param_default} ||= {});
			}
		}
	);

	# sysUser helpers
	$app->helper( is_sysuser_sys => sub {
		return shift->sysuser->sys;
	});



}

1;
