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

			if($self->req->method eq 'POST'){
				my $send_params = $self->req->params->to_hash;
				my $json = {
					errors 	=> {},
					message_success => '',
				};

				my $fields = {
					callback_name 		=> {
						label 			=> 'Ваше имя',
						required 		=> 1,
						error_text 	=> 'Укажите Ваше имя',
					},
					callback_phone 		=> {
						label 			=> 'Номер телефона',
						required 		=> 1,
						error_text 	=> 'Укажите контактный номер телефона',
					},
					callback_city 		=> {
						label 			=> 'Город',
						required 		=> 1,
						error_text 	=> 'Укажите Ваш город',
					}
				};


				foreach my $f (keys %$fields){
					if( $send_params->{$f} ){
						$self->stash->{ $f } = $send_params->{$f}

					}
					elsif($fields->{ $f }->{required}){
						$json->{errors}->{$f} = $fields->{ $f }->{error_text};

					}

				}

				unless(keys %{ $json->{errors} }){
					my $email_body = 	$self->render_mail(
						template	=> "Texts/_callback_admin"
					);

					# $self->mail(
					# 	to      => $self->get_var(name => 'email_admin', controller => 'global', raw => 1),
					# 	subject => 'Заказ обратного звонка с сайта '.$self->get_var(name => 'site_name', controller => 'global', raw => 1),
					# 	data    => $email_body,
					# );

					$json->{message_success} = $self->render(
						template 	=> 'Texts/_callback_message_success',
						partial 	=> 1,
					);
				}

				return $self->render(
					json => $json
				);
			}
	});


	$app->helper(
		news_list => sub {
			my $self   = shift;
			my %params = (
				page	=> 1,
				@_
			);

			my 	$where = " `viewtext`='1' ";
				if(my $year = $self->param('year')){
					if($year =~ /\-/){
						my ($y1, $y2) = split('-', $year);
						$where .= " AND (YEAR(tdate)>=$y1 AND YEAR(tdate)<=$y2) "	;
					}
					else {
						$where .= " AND YEAR(tdate)='$year' ";
					}

				}
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