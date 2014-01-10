package GG::Content::Users;

use utf8;

use Mojo::Base 'GG::Content::Controller';

my $UserTable = 'data_users';

sub profile{
	my $self = shift;

	$self->stash->{profile} = 1;
	return $self->register;
}

sub activate{
	my $self = shift;

	# check activate

	my $user_id = $self->stash->{user_id};
	my $cck = $self->stash->{cck};

	my $success = 0;
	if(my $user = $self->dbi->query("SELECT * FROM `data_users` WHERE `ID`='$user_id' AND `cck`='$cck' AND `active`='0' ")->hash){
		$success = 1;

		$self->dbi->dbh->do("UPDATE `data_users` SET `active`=1, `cck`='' WHERE `ID`=?", undef, $user_id);

		my $rdate = $self->setLocalTime(1);
		my $xml = $self->render_partial(
			user 		=> $user,
			template	=> 'Users/register',
			format		=> 'xml',
		);

		eval{
			$rdate =~ s{:}{_}gi;
			open( FILE, '>', $ENV{DOCUMENT_ROOT}.'/import/out/'.$self->stash->{index}.'_'.$rdate.'.xml' ) or die $!;
			print FILE $xml;
			close FILE;
		};
		if($@){
			warn $@ if $@;
		}


		my $email_body = 	$self->render_partial(	template	=> "Users/register_success_mail_activate", format => 'html' );
		eval{
			$self->mail(
					to      => $self->get_var('email_admin'),
					subject => 'Новый пользователь зарегистрировался на сайте '.$self->get_var(name => 'site_name', controller => 'global'),
					data    => $email_body,
			);

			$self->mail(
					to      => $self->stash->{email},
					subject => 'Ваша учетная запись активирована на сайте '.$self->get_var(name => 'site_name', controller => 'global'),
					data    => $email_body,
			);
		};

	}


	$self->render(
		success		=> $success,
		template	=> 'Users/register_success_activated'
	)
}

sub register{
	my $self = shift;

	my $is_profile = $self->stash->{profile} || 0;

	$self->get_keys( type => ['lkey'], no_global => 1, controller => 'users');

	#my $lkeys = $self->app->lkeys->{users};
	my $send_params = $self->send_params;

	my $json = {};

	my $fields = {
		name 		=> {
			label 			=> 'Ваше имя',
			required 		=> 1,
			error_text 		=> 'Укажите Ваше имя',
		},
		phone 		=> {
			label 			=> 'Номер телефона',
			required 		=> 1,
			error_text 		=> 'Укажите контактный номер телефона',
		},
		email 		=> {
			label 			=> 'Электронная почта',
			required 		=> 1,
			error_text 		=> 'Укажите электронную почту',
		},
		city 		=> {
			label 			=> 'Город',
			required 		=> 1,
			error_text 		=> 'Укажите город',
		},
		password 		=> {
			label 			=> 'Пароль',
			required 		=> 1,
			error_text 		=> 'Укажите пароль',
		}
	};


	# unless($is_profile){
	# 	unless($self->check_captcha($self->param('code'))){
	# 		$outFields->{code} = 'Код не верен';
	# 	}
	# } else {
	# 	$lkeys->{password}->{settings}->{obligatory} = 0;
	# }

	foreach my $f (keys %$fields){
		if( $send_params->{$f} ){
			$self->stash->{ $f } = $send_params->{$f}

		}
		elsif($fields->{ $f }->{required}){
			$json->{errors}->{$f} = $fields->{ $f }->{error_text};

		}
	}

	if($self->stash->{password} && $self->stash->{password} ne $self->param('confpassword')){
		$json->{errors}->{confpassword} = 'Пароли не совпадают';
	}

	unless(keys %{ $json->{errors} }){

		if( $self->dbi->query("SELECT `email` FROM `data_users` WHERE `email`='".$self->stash->{email}."' LIMIT 0,1")->hash ){
			$json->{errors}->{email} = 'Данный E-mail уже зарегистрирован';
		}
	}

	unless(keys %{ $json->{errors} }){

		$self->send_params->{active} = 1;

		if(my $user_id = $self->save_info( table => 'data_users')){
			$json->{user_id} = $user_id;

			my $email_body = $self->render_mail(
				user_id		=> $user_id,
				partial		=> 1,
				template	=> "Users/_register",
			);


			$self->mail(
				to      => $self->stash->{email},
				subject => 'Вы зарегистрировались на сайте '.$self->get_var(name => 'site_name', controller => 'global', raw => 1),
				data    => $email_body,
			);

			$self->_do_auth($user_id);
			$json->{user_id} = $user_id;
		}
		else {
			$json->{errors}->{global} = 'Системная ошибка, повторите попытку позже';
		}
	}

	$self->render( json => $json );
}

sub auth{
	my $self = shift;

	my $email = $self->param('email');
	my $password = $self->param('password');

	my $json = {
		errors	=> {},
	};

	if(!$email){
		$json->{errors}->{email} = 'Укажите E-mail';

	} elsif(!$password){
		$json->{errors}->{password} = 'Укажите Пароль';

	} elsif( my $user = $self->app->dbi->query(qq/
		SELECT `ID`,`active`
		FROM `data_users`
		WHERE `email`='$email' AND `password`='$password'
		/)->hash){

			if($user->{active}){
				$self->_do_auth($user->{ID});
				$json->{user_id} = $user->{ID};
			} else {
				$json->{errors}->{global} =  'Учетная запись заблокирована';
			}

	} else {
		$json->{errors}->{global} =  'Ошибка E-mail и/или Пароля';

	}

	$self->render(
		json 	=> $json
	);
}

sub remember{
	my $self = shift;

	my $email = $self->param('email');

	my $json = {
		errors => {},
	};

	if(my $user = $self->app->dbi->query(qq/
			SELECT `ID`,`active`
			FROM `data_users`
			WHERE `email`='$email'
			/)->hash){

			my $new_password = substr($self->defCCK(), 0, 10 );
			$self->app->dbi->update("data_users", { password => $new_password }, "`ID`='$$user{ID}'");

			my $email_body = $self->render_mail(
				new_password => $new_password,
				partial		=> 1,
				template	=> "Users/_remember",
			);

			$self->mail(
				to      => $user->{email},
				subject => 'Восстановление пароля на сайте '.$self->get_var(name => 'site_name', controller => 'global', raw => 1),
				data    => $email_body,
			);

	}
	else {
		$json->{errors}->{global} = 'Адрес не найден';
	}

	$self->render( json => $json );
}

sub logout{
	my $self = shift;

	if($self->is_auth){
		my $user_id = $self->app->user->{ID};
		$self->dbi->update_hash('data_users', { cck => ''}, "`ID`='$user_id'");
		$self->app->user->{auth} = 0;

		# Скидываем корзину
		# if(keys %{$self->userdata->{basket}}){
		# 	$self->userdata->{basket} = {};
		# 	$self->save_userdata;
		# }
	}

	$self->cookie('user_id', '', {
		path 	=> '/',
		expires	=>  time-1000
	});

	$self->redirect_to($self->tx->req->content->headers->header('referer') || '/');
}

sub _do_auth{
	my $self = shift;
	my $user_id = shift;

	$self->app->dbi->update("data_users", { cck => $self->app->user->{cck}, vdate => $self->setLocalTime(1) }, "`ID`='$user_id'");

	# $self->cookie('user_id', $user_id, {
	# 	path 	=> '/',
	# 	expires	=> $self->app->sysuser->userinfo->{cck} ? time+360000000 : time-1000
	# });
}

1;
