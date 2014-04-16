package GG::Plugins::Weather;

use Mojo::Base 'Mojolicious::Plugin';

use utf8;
use XML::Simple;

sub register {
	my ( $self, $app, $opts ) = @_;

	$opts ||= {};

	$app->log->debug("register GG::Plugin::Weather");

	$app->helper( weather__=> sub{
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
			temp 		=> $temp>0 ? '+'.$temp : $temp,
			img			=> $img,
			city 		=> $city,
			template	=> 'Plugins/_weather',
			partial		=> 1,
		);

	});
}
1;