package GG::Content::Auth;

use utf8;

use Mojo::Base 'GG::Content::Controller';

sub auth_register_form{
	my $self = shift;
	
	$self->get_keys( type => ['lkey','list'], key_program => 'user');
	
	my $lkeys = $self->app->lkeys;
	my @keys = ();
	
	foreach my $k (keys %$lkeys) { $$lkeys{$k}{settings}{rating} = 0 unless defined  $$lkeys{$k}{settings}{rating}}
	foreach my $k (sort {$$lkeys{$a}{settings}{rating} <=> $$lkeys{$b}{settings}{rating}} keys %$lkeys) {
		if($$lkeys{$k}{settings}{regform}){
			push @keys, $k;
		}	
	}

	my $output_form = $self->def_anket_form( controller => 'Auth', keys => \@keys, access => 'w', template_fields => { w => 'template_reg', r => 'template_save'});
	
	return $self->render(
							form		=> $output_form,
							template 	=> 'Auth/register_form');		
}


sub auth_register_save{
	my $self = shift;
	
	$self->get_keys( type => ['lkey','list'], key_program => 'user');
	
	my $lkeys = $self->app->lkeys;
	
	my @keys = ();
	my @obligatory = ();
	
	foreach my $k (keys %$lkeys) { $$lkeys{$k}{settings}{rating} = 0 unless defined  $$lkeys{$k}{settings}{rating}}
	foreach my $k (sort {$$lkeys{$a}{settings}{rating} <=> $$lkeys{$b}{settings}{rating}} keys %$lkeys) {
		if($$lkeys{$k}{settings}{regform}){
			push @keys, $k;
			
			push @obligatory, $k if($$lkeys{$k}{settings}{obligatory});
		}	
	}
	
	my $send_params = $self->stash('send_params');

	
	my $errors	= {};
 	foreach (@obligatory){
		unless ($send_params->{$_}){
			$errors->{$_} = {
				text	=> 'Не заполнено обязательное поле'
			};
		}
	}
	
	if($send_params->{password} ne $send_params->{confpassword}){
		$errors->{confpassword} = { text	=> 'Пароли не совпадают' };
	}
	
	$send_params->{active} = 1;
	
	if(!keys %$errors && $self->insert_hash('sys_users_common', $send_params)){
		delete $self->flash->{errors};
		
		my $email_body = 	$self->render_partial(	form		=> $send_params,
   													template	=> "Auth/register_mail" );
   									
		$self->mail(
    		to      => $send_params->{email},
    		subject => 'Вы зарегистрировались на сайте '.$self->vars->{site_name}->value,
    		data    => $email_body,
  		);
		
		return $self->redirect_to('text', alias => 'register_success');
	} else {
		unless(keys %$errors){
			$errors->{global} = 'Системная ошибка, повторите попытку позже ...';
		}
		$self->flash->{errors} = $errors;
		return $self->auth_register_form();
			
	}
}

sub auth_profile_form{
	my $self = shift;
	
	$self->redirect_to('auth_register_form') unless($self->is_auth);
	
	$self->get_keys( type => ['lkey','list'], key_program => 'user');
	
	my $lkeys = $self->app->lkeys;
	my @keys = ();
	
	foreach my $k (keys %$lkeys) { $$lkeys{$k}{settings}{rating} = 0 unless defined  $$lkeys{$k}{settings}{rating}}
	foreach my $k (sort {$$lkeys{$a}{settings}{rating} <=> $$lkeys{$b}{settings}{rating}} keys %$lkeys) {
		if($$lkeys{$k}{settings}{regform}){
			push @keys, $k;
		}	
	}
	
	
	$self->stash('send_params', $self->app->user);

	my $output_form = $self->def_anket_form( controller => 'Auth', keys => \@keys, access => 'w', template_fields => { w => 'template_reg', r => 'template_save'});
	
	return $self->render(
							form		=> $output_form,
							template 	=> 'Auth/profile_form');		
}

sub auth_auth{
	my $self = shift;
	
	my $email = $self->param('email');
	my $password = $self->param('password');
	
	my $vals = {
    	error	=> '',
    	host	=> '/', #HTTP_REFERER
    };
    
    $vals->{error} = 'Введите Ваш E-mail' unless $email;
	$vals->{error} = 'Введите Ваш Пароль' unless $email;

	unless($$vals{error}){
		if(my $user = $self->dbi->query(qq/
				SELECT * FROM `sys_users_common` 
				WHERE `email`='$email' AND `password`='$password' AND `active`='1'
				/)->hash){

			$self->update_hash("sys_users_common", { cck => $self->app->user->{cck}}, "`ID`='$$user{ID}'");
			$vals->{success} = 1;
		} else {
			$vals->{error} = 'Ошибка E-mail и/или Пароля';
		}
	}
	
	$self->render_json( $vals );
	
}

sub auth_logout{
	my $self = shift;

	if($self->app->user->{auth}){
		my $user_id = $self->app->user->{ID};
		$self->update_hash("sys_users_common", { cck => ''}, "`ID`='$user_id'");
		$self->app->user->{auth} = 0;
	}
	
	$self->redirect_to('/');
}
1;
