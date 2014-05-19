package GG::Plugins::Weather;

use Mojo::Base 'Mojolicious::Plugin';

use utf8;
use XML::Simple;

sub register {
	my ( $self, $app, $opts ) = @_;

	$opts ||= {};

	$app->log->debug("register GG::Plugin::Weather");

	$app->helper( weather=> sub{
		my $self = shift;
		my $dir = $ENV{DOCUMENT_ROOT};
		my %params = @_;

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

	});
}
1;