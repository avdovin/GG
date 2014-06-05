package GG::Plugins::Weather;

use Mojo::Base 'Mojolicious::Plugin';

use utf8;
#use XML::Simple;
use Mojo::UserAgent;
use File::stat;

my $CityId = 26063; # Санкт-Петербург, http://weather.yandex.ru/static/cities.xml
my $TmpFilename  = '__weaher.csv';

sub register {
	my ( $self, $app ) = @_;

	$app->log->debug("register GG::Plugin::Weather");

	my $ua = Mojo::UserAgent->new;


	# Получает погоду с сервиса яндекс используя код города
	$app->helper( weather_by_city_id => sub{
		my $self 	= shift;
		my $cityId 	= shift;

		my $tmpDir = $self->file_tmpdir;
		my $localtime = $self->setLocalTime;

		# проверяем есть ли уже файл с погодой на сегодня
		if(-e $tmpDir.$TmpFilename ){
			my $data = $self->file_read_data( path => $tmpDir.$TmpFilename);

			my @dataVals = split(';', $data);
			if($dataVals[0] eq $localtime){

				return $self->render(
					temp 		=> $dataVals[1],
					icon 		=> $dataVals[2],
					template 	=> 'Plugins/Weather/_weather_by_city',
					partial 	=> 1,
				);
			}
		}

		my $city_id = $cityId || $CityId;
		my $xmlUrl = "http://export.yandex.ru/weather-ng/forecasts/$city_id.xml";

		$ua->get($xmlUrl => sub {
			my ($ua, $tx) = @_;

			if(my $res = $tx->success){

				my $dom = $tx->res->dom;
				$dom->xml(1);

				my $temp = $dom->at('fact temperature')->text;
				my $icon = $dom->at('fact image-v2')->text;
				my $data = $localtime.';'.$temp.';'.$icon;


				$self->file_save_data(
					path  	=> $tmpDir.$TmpFilename,
					data 	=> $data,
				);

				return $self->render(
					temp 		=> $temp,
					icon 		=> $icon,
					template 	=> 'Plugins/Weather/_weather_by_city',
					partial 	=> 1,
				);
			}
			else {
				my $err = $tx->error;
				warn "$err->{code} response: $err->{message}" if $err->{code};
				warn "Connection error: $err->{message}";
			}
		});

		return '';
	});
}

1;

=head
return unless ($params{id} || ($params{city} && $params{country}));

mkdir $dir."/xml_weather" unless ( -d $dir."/xml_weather" );

getstore("http://weather.yandex.ru/static/cities.xml", $dir."/xml_weather/cities.xml") unless (-e $dir."/xml_weather/cities.xml");


my $infoXML = XML::Simple->new()->XMLin($dir."/xml_weather/cities.xml");

my $city_id = $params{'id'} if $params{'id'};

unless ($city_id){
	$city_id = $infoXML->{country}->{$params{country}}->{city}->{id} if $infoXML->{country}->{$params{country}}->{city}->{id};
}


unless ($city_id){
	foreach (%{$infoXML->{country}->{$params{country}}->{city}}){
		if ($infoXML->{country}->{$params{country}}->{city}->{$_}->{content} eq $params{city}){
			$city_id = $_;
		}
	}
}
return unless $city_id && !ref($city_id);

if (-e $dir."/xml_weather/$city_id.xml"){
	my $time = time;
	my $filetime = (stat($dir."/xml_weather/$city_id.xml"))[9];
	my $day_in_sec = 60*60*24;
	if ($time-$filetime > $day_in_sec){
		getstore("http://export.yandex.ru/weather-ng/forecasts/$city_id.xml", $dir."/xml_weather/$city_id.xml");
	}
};

getstore("http://export.yandex.ru/weather-ng/forecasts/$city_id.xml", $dir."/xml_weather/$city_id.xml") unless (-e $dir."httpdocs/xml_weather/$city_id.xml");

my $XML  = XML::Simple->new()->XMLin($dir."/xml_weather/$city_id.xml");
my @arritems;
my $items = {};
foreach my $d (@{$XML->{day}}){
	$items->{date} = $d->{date};
	foreach my $k (@{$d->{day_part}}){
		if ($k->{typeid}==2){
			$items->{from} = $k->{temperature_from}>0 ? "+".$k->{temperature_from} : $k->{temperature_from};
			$items->{to} = $k->{temperature_to}>0 ? "+".$k->{temperature_to} : $k->{temperature_to};
			$items->{pict} = $k->{'image-v2'}->{content};

		}
	}
	push @arritems, $items;
	$items = {};
}

return $self->render(
		city 		=> $params{city}||'',
		items   	=> \@arritems,
		template	=> 'Plugins/Weather/_weather',
		partial		=> 1,
);
=cut