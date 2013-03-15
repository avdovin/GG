package GG::Content::User;

use utf8;

use Mojo::Base 'GG::Content::Controller';

my @req_fields = qw(name email password fname mname phone company post);

sub profile{
	my $self = shift;
	
	my $errors = $self->stash->{errors} = {};
	
	my $user = $self->app->user;
	if(delete $self->stash->{profile_save}){
		$self->get_keys( type => ['lkey'], key_program => 'users');
		my $sendParams = $self->send_params;
		
		delete $sendParams->{email};
		
		unless($sendParams->{curpassword} = $self->param('curpassword')){
			$errors->{curpassword} = 'Укажите текущий пароль';
		}

		if($sendParams->{curpassword} ne $user->{password}){
			$errors->{curpassword} = 'Указан не верный пароль';
		} 
		
		$sendParams->{password} = $self->param('newpassword') if $self->param('newpassword');
		
		unless(keys %$errors){
			$self->stash->{'index'} = $user->{ID};
			$self->save_info(
				table	=> 'data_users',
			);
			
			$self->flash(success => 1);
			return $self->redirect_to('/user/profile');
		}
	}
	
	my $manager = $$user{id_manager} ? $self->dbi->query("SELECT * FROM `data_projects_managers` WHERE `ID`='$$user{id_manager}' LIMIT 0,1 ")->hash : {};

	my $project = $self->dbi->query("SELECT * FROM `data_projects_items` WHERE `id_user`='$$user{ID}' LIMIT 0,1 ")->hash || {};

	$self->render(
		user		=> $user,
		manager 	=> $manager,
		project 	=> $project,
		errors 		=> $errors,
		template 	=> 'User/profile'
	)
}

sub register{
	my $self = shift;
	
	$self->get_keys( type => ['lkey'], key_program => 'users');
	my $sendParams = $self->send_params;
	
	my $json = {};
	my $errors = {};
	if($sendParams->{password} ne $self->param('password_confirm')){
		$errors->{password_confirm} = 'Пароли не совпадают';
	}
	
	foreach (@req_fields){
		unless($sendParams->{$_}){
			$errors->{$_} = 'Не заполнено обязательное поле';
		}
	}
	
	if($sendParams->{email}){
		if($self->dbi->query("SELECT * FROM `data_users` WHERE `email`='$$sendParams{email}' LIMIT 0,1")->hash){
			$errors->{email} = 'Такая почта уже зарегистрирована';
		}
	}
	
	if(!keys %$errors){
		$sendParams->{active} = 1;
		
		my $user_id = $self->save_info(
			table	=> 'data_users',
		);
		
		my $emailBody = $self->render_mail(	
			send_params		=> $sendParams,
			template		=> "User/register" 
		);
   		
   							
#		$self->mail(
#    		to      => $sendParams->{email},
#    		subject => 'Вы зарегистрировались на сайте '.$self->get_var(name => 'site_name', controller => 'global', raw => 1),
#    		data    => $emailBody,
#  		);
#  		
#		$self->mail(
#    		to      => $self->get_var(name => 'email_admin', controller => 'global', raw => 1),
#    		subject => 'Зарегистрировался новый пользователь на сайте '.$self->get_var(name => 'site_name', controller => 'global', raw => 1),
#    		data    => $emailBody,
#  		);	
		
		# Авторизация пользователя
		$json->{cck} = $self->app->user->{cck};
		$json->{user_id} = $user_id;
	}
	
	$self->render_json({
		errors 	=> $errors,
		success	=> keys %$errors ? 0 : 1,
		%$json
	});
}

sub send_to_manager{
	my $self = shift;
	
	my $json = {};
	
	my $subject = $self->param('subject');
	my $message = $self->param('message');
	
	if(!$subject){
		$json->{errors} = "Укажите тему";
	
	} elsif(!$message){
		$json->{errors} = "Сообщение пустое";
		
	}
	
	my $user = $self->app->user;
	my $manager = $self->dbi->query("SELECT * FROM `data_projects_managers` WHERE `ID`='$$user{id_manager}' LIMIT 0,1 ")->hash || {};
	unless($manager->{ID}){
		$json->{errors} = "У вас еще нет менеджера";
	}
	
	unless($json->{errors}){
		my $siteName = $self->get_var(name => 'site_name', controller => 'global', raw => 1);
		my $mail =  <<HEAD;
    		
    		<h2>Сообщение от пользователя «$$user{name}»	с сайта $siteName</h2>
    		<hr />
    		
    		$message
HEAD


		$self->mail(
    		to      => $manager->{email},
    		subject => $subject,
    		data    => $mail,
  		);
	}
	
	$self->render_json($json);
}


sub auth{
	my $self = shift;
	my %params = (
		email 		=> $self->param('email'),
		password	=> $self->param('password'),
		render 		=> 1,
		@_
	);
	
	my $email = delete $params{email};
	my $password = delete $params{password};
	
	my $errors = {};
	my $vals = {
    	errors	=> {},
    	host	=> '/', #HTTP_REFERER
    };
    
    $errors->{email} = 'Введите E-mail' unless $email;
	$errors->{password} = 'Введите Пароль' unless $password;

	unless($$vals{error}){
		if(my $user = $self->dbi->query(qq/
				SELECT * FROM `data_users` 
				WHERE `email`='$email' AND `password`='$password'
				/)->hash){
			
			if($user->{active}){
			
				$self->dbi->update_hash("data_users", { 
					cck 	=> $self->app->user->{cck},
					vdate	=> $self->setLocalTime(1),
				}, "`ID`='$$user{ID}'");
				$vals->{success} = 1;
				$self->stash->{user_id} = $user->{ID};
					
			} else {
				$errors->{general} = 'Учетная запись заблокирована';
			}
		} else {
			$errors->{general} = 'Ошибка E-mail и/или Пароля';
		}
	}
	
	return ($self->app->user->{cck}, $self->stash->{user_id}) unless $params{render};
	
	$vals->{errors} = $errors;
	$vals->{success} = keys %$errors ? 0 : 1;
	
	if($vals->{success}){
		#$vals->{cck} = $self->app->user->{cck};
		$vals->{user_id} = $self->stash->{user_id};
	}
	
	$self->render_json( $vals );
	
}

sub logout{
	my $self = shift;

	if($self->is_auth){
		my $user_id = $self->app->user->{ID};
		$self->dbi->update_hash("data_users", { cck => ''}, "`ID`='$user_id'");
		$self->app->user->{auth} = 0;
	}
	
	$self->redirect_to('/');
}
1;
