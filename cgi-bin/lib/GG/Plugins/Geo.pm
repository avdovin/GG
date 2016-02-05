package GG::Plugins::Geo;
# based on http://sypexgeo.net/
use utf8;

use Mojo::Base 'Mojolicious::Plugin';

use Geo::Sypex qw/SXGEO_BATCH/;
use Socket;

our $VERSION = '0.1';

sub register {
  my ($self, $app, $opts) = @_;

  $opts ||= {};
  # check db exists
  my $db = $ENV{MOJO_HOME}.'/geo/';
  unless( -e $db.'SxGeoCity.dat' || -e $db.'SxGeo.dat'  ){
    die "GG::Plugins::Geo database files not found";
  }else{
    $db .= 'SxGeoCity.dat';
  }

  my $include_cities = [];
  if( $opts->{geo} and $opts->{geo}->{include} ){
    $include_cities = $opts->{geo}->{include};
  }

  $app->log->debug("register GG::Plugins::Geo");

  $app->routes->route("/ajax/set_city")->to(
    cb => sub {
      my $self = shift;
      $self->current_user_data->{city} = $self->param('city');
      $self->save_userdata;
      return $self->render(status => 204, text => '', layout => undef);
  })->name('ajax_set_city');


  $app->helper('geo.cities_list' => sub {
   return $include_cities;
  });

  $app->helper('geo.get_city' => sub {
    my $self = shift;
    my $city = $self->current_user_data->{city} || undef;
    return $city if $city;

    if( my $ip = $self->ip ){
      my $sxgeo = Geo::Sypex->new( $db, SXGEO_BATCH );
      my $geodata = $sxgeo->get( $ip, 'city_ru' );

      if( $geodata and $geodata->{city_ru} ){
       unless( scalar @$include_cities ){
         $city = $geodata->{city_ru};
       }elsif( grep { $_ eq $geodata->{city_ru} } @$include_cities ){
         $city = $geodata->{city_ru};
       }
      }
    }

    if( $city ){
      $self->current_user_data->{city} = $city;
      $self->save_userdata;
    }

    return $city;
  });
}

1;
