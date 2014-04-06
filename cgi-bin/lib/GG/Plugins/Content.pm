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


	$app->helper( content__news_list => sub {
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

		my $dbTable = 'texts_news_'.$self->lang;

		if($params{limit}){
			my $count = $self->dbi->getCountCol(from => $dbTable, where => $where);
			$self->def_text_interval( total_vals => $count, cur_page => $params{page}, col_per_page => $params{limit} );
			$params{npage} = $params{limit} * ($params{page} - 1);
			$where .= " LIMIT $params{npage},$params{limit} ";
		}

		my $items = $self->app->dbi->query("
			SELECT *
			FROM `$dbTable`
			WHERE $where
		")->hashes;

		return $self->render(
			items		=> $items,
			template 	=> 'Texts/_news_list_items',
			partial		=> 1
		);
	});

	$app->helper( content__news_anons => sub {
		my $self   = shift;
		my %params = @_;

		my $dbTable = 'texts_news_'.$self->lang;
		my $items = $self->app->dbi->query("SELECT * FROM `$dbTable` WHERE `viewtext`='1' ORDER BY `tdate` DESC LIMIT 0,2")->hashes;

		return $self->render(
			items	=> $items,
			template => 'Texts/news_anons',
			partial	=> 1
		);
	});

	$app->helper(
		content__weather=> sub{
				my $self = shift;
				my $dir = $ENV{DOCUMENT_ROOT};
				my $country = shift;
				my $city = shift;

				my $infoXML = XML::Simple->new()->XMLin("$dir/xml_weather/cities.xml");

				my $city_id;
				$city_id = $infoXML->{country}->{$country}->{city}->{id} if $infoXML->{country}->{$country}->{city}->{id};
				unless ($city_id){
					foreach (%{$infoXML->{country}->{$country}->{city}}){
						if ($infoXML->{country}->{$country}->{city}->{$_}->{content} eq $city){
							$city_id = $_;
						}
					}
				}

				return unless $city_id;
				getstore("http://export.yandex.ru/weather-ng/forecasts/$city_id.xml", $dir."/xml_weather/$city_id.xml") unless (-e "$dir/xml_weather/$city_id.xml");

				my $XML  = XML::Simple->new()->XMLin("$dir/xml_weather/$city_id.xml");

				my $temp = $XML->{fact}->{temperature}->{content};

				my $img = $XML->{fact}->{'image-v2'}->{content};

				return $self->render(
						temp 	=> $temp>0 ? '+'.$temp : $temp,
						img		=> $img,
						city 	=> $city,
						template	=> 'Countrys/_weather',
						partial	=> 1,
				);

		}

	);
}
1;