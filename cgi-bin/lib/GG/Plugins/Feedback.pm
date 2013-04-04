package GG::Plugins::Feedback;

use utf8;

use Mojo::Base 'Mojolicious::Plugin';



sub register {
	my ($self, $app, $conf) = @_;
	
	
	$app->routes->route("feedback")->to(admin_name => 'Контакты', lang => 'ru',layout => 'default', alias =>  'contacts', cb => sub{
		my $self   = shift;
		my %params = @_;
		
		$self->feedback_form(%params)	
			
	})->name('feedback');

	
	$app->helper(
		feedback_form => sub {
			my $self = shift;
			my %params = (
				template	=> "Feedback/form",
				@_
			);
			
			$self->stash('header', { title	=> 'Контакты'});
			
			my $method = $self->req->method;
			
			$self->stash->{success} = 0;

			if($method eq 'POST'){
			   	$self->get_keys( type => ['lkey'], key_program => 'feedback');
			    
			    my $send_params = $self->app->send_params;
			    
			    my $lkeys = $self->app->lkeys->{'feedback'};
			    
				
				
				delete @{$self->stash}{ qw(errors) };
				
				my $errors = {};
			    foreach (keys %$lkeys){
			   	
			    	if($lkeys->{$_}->{settings}->{saveform}){
			    		my $lkey = $lkeys->{$_}->{lkey};
			
			    		if($send_params->{ $lkey }){
			    			$self->stash->{$lkey} = $send_params->{ $lkey } || '';
			
			    		} elsif($lkeys->{$_}->{settings}->{obligatory} && !$send_params->{ $lkey }){
			    			$errors->{ $lkey } = 'Не заполнено обязательное поле';
			    		}
			    	}
			    }
			    
			    # проверка капчи
			    #if(!$self->check_captcha($send_params->{captcha})){
			    #	$errors->{'captcha'} = 'Введенное значение не соответствует коду на картинке';
			    #}
			    $self->stash->{errors} = $errors;
			    
			    if(!keys %$errors){
			    	$self->stash->{success} = 1;
			
					my $email_body = 	$self->render_mail(	template	=> "Feedback/letter" );
				
					$self->mail(
				    	to      => $self->get_var(name => 'email_admin', controller => 'global', raw => 1),
				    	subject => 'Новое сообщение с сайта '.$self->get_var(name => 'site_name', controller => 'global', raw => 1),
				    	data    => $email_body,
				  	);	
			    }			
			}
			
			$self->render(	errors		=> $self->stash->{errors} || {},
							template	=> $params{template} );				
				
		}	
	);
}



1;
