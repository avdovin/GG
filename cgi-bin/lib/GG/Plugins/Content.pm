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
		
					return $self->render( json => $vals );			
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
		    $vals->{html} = $self->render( template => 'Texts/callback_message_success', partial => 1);
		    
		    $self->render( json => $vals );
		}
	);	
	

	$app->helper(
		news_list => sub {
			my $self   = shift;
			my %params = (
				page	=> 1,
				@_
			);
			
			my 	$where = " `viewtext`='1' ";
				$where .= " AND YEAR(tdate)='".$self->param('year')."' "	if $self->param('year');
				$where .= " ORDER BY `tdate` DESC ";
				
			if($params{limit}){
				my $count = $self->dbi->getCountCol(from => 'texts_news_ru', where => $where);
				$self->def_text_interval( total_vals => $count, cur_page => $params{page}, col_per_page => $params{limit} );
				$params{npage} = $params{limit} * ($params{page} - 1);
				$where .= " LIMIT $params{npage},$params{limit} "; 
			}			
			
			my $items = $self->app->dbi->query("
				SELECT * 
				FROM `texts_news_ru` 
				WHERE $where
			")->hashes;

			return $self->render( 
							items		=> $items, 
							template 	=> 'Texts/_news_list_items',
							partial		=> 1);			

		}
	);	
	
	$app->helper(
		news_anons => sub {
			my $self   = shift;
			my %params = @_;
			
			my $items = $self->app->dbi->query("SELECT * FROM `texts_news_ru` WHERE `viewtext`='1' ORDER BY `tdate` DESC LIMIT 0,2")->hashes;

			return $self->render( 
							items	=> $items, 
							template => 'Texts/news_anons',
							partial	=> 1);			

		}
	);		

}
1;