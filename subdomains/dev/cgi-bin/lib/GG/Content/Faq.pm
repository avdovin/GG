package GG::Content::Faq;

use utf8;

use Mojo::Base 'GG::Content::Controller';

sub list{
	my $self = shift;
	
	my $items = $self->dbi->query("SELECT * FROM `data_faq` WHERE `active`='1' ORDER BY `rdate`")->hashes;
	
	my %FORM = ();

	# Добавление нового отзыва
	if($self->req->method eq 'POST'){
		$self->get_keys( type => ['lkey'], key_program => 'faq');

		my $send_params = $self->app->send_params;
		my $lkeys = $self->app->lkeys;
		
		delete @{$self->stash}{ qw(form_error) };

		foreach (keys %$lkeys){
	    	if($lkeys->{$_}->{settings}->{saveform}){
	    		my $lkey = $lkeys->{$_}->{lkey};
	
	    		$FORM{ $lkey } = {
	    			value	=> '',
	    			error	=> ''
	    		};
	    		
	    		if($send_params->{ $lkey }){
	    			$FORM{ $lkey }->{value} = $send_params->{ $lkey };
	
	    		} elsif($lkeys->{$_}->{settings}->{obligatory} && !$send_params->{ $lkey }){
					$FORM{ $lkey }->{error} = 'Не заполнено обязательное поле';
					$self->stash('form_error', 1);
					    			
	    		}
	    	}
	    }
	    
	    if(!$self->stash('form_error')){
	    	$self->save_info(table => 'data_faq');
	    	$self->stash->{success} = 1;

			my $email_body = 	$self->render_partial(	form		=> \%FORM,
		   												template	=> "Faq/mail" );
		
			$self->app->plugin(mail => {
			    from     => 'no-reply@'.$self->req->url->{base}->{host},
			    encoding => 'base64',
		    	how      => 'sendmail',
		    	howargs  => [ '/usr/sbin/sendmail -t' ],
		    	type	 => 'text/html;charset=utf-8',
		  	});	
		  	
		  	eval{										
				$self->mail(
			    	to      => $self->app->vars->{email_admin}->value,
		    		subject => 'Получен новый вопрос с сайта '.$self->app->vars->{site_name}->value,
		    		data    => $email_body,
		  		);
		  	};	
	    }		    
	    
	}
	
	$self->render(
					items		=> $items,
					form		=> \%FORM,
					template	=> 'Faq/list',
	);	
}

1;
