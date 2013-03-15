package GG::Plugins::Content;

use Mojo::Base 'Mojolicious::Plugin';

use utf8;

sub register {
	my ( $self, $app, $opts ) = @_;

	$opts ||= {};

	$app->log->debug("register GG::Plugin::Content");

	$app->helper(
		callbackSend => sub {
		    my $self = shift;
			
			my $vals = {
				error	=> '',
			};
			my $data = {};
	
			my %fields = (
				callback_name	=> 'Имя',
				callback_phone	=> 'Телефон',
			); 
			foreach (keys %fields){
				if($self->param($_)){
					$data->{$_} = $self->param($_);
				} else {
						
					$vals->{error} = 'Не заполенно обязательное поле - '.$fields{$_};
					$vals->{error_field} = $_;
		
					return $self->render_json( $vals );			
				}
			}
						
		    if(!$vals->{error}){
	
				my $email_body = 	$self->render_mail( 
					vals => $data,	
					template	=> "Texts/callback"
				);
			
				$self->mail(
			    	to      => $self->get_var(name => 'email_admin', controller => 'global'),
			    	subject => 'Заказ обратного звонка с сайта '.$self->get_var(name => 'site_name', controller => 'global'),
			    	data    => $email_body,
			  	);	
		    }
		    $vals->{html} = $self->render_partial( template => 'Texts/callback_message_success');
		    
		    $self->render_json( $vals );
		}
	);	
	

	
	$app->helper(
		news_anons => sub {
			my $self   = shift;
			my %params = @_;
			
			my $items = $self->app->dbi->query("SELECT * FROM `texts_news_ru` WHERE `viewtext`='1' ORDER BY `tdate` DESC LIMIT 0,2")->hashes;

			return $self->render_partial( 
							items	=> $items, 
							template => 'Texts/news_anons');			

		}
	);		

}
1;