package GG::Plugins::Geo;

use utf8;

use Mojo::Base 'Mojolicious::Plugin';

use Socket;
our $VERSION = '1';

# !!!IMPORT GEO BASE FIRST!!!

sub register {
	my ( $self, $app, $opts ) = @_;

	$opts ||= {};


	$app->helper( geo__chech_ip => sub {
		my $self 	= shift;
    return unless my $ip    = shift || $self->ip;
    
    my $ip_int = ip2long($ip);
    $ip_int =~ s{\D+}{}gi;

    my $result = {
      country_id  => 0,
      city_id     => 0,
      city_name   => '',
      country_name  => '',
    };
    # Ищем по российским и украинским городам
    my $sql = "select * from (select * from net_ru where begin_ip<=$ip_int order by begin_ip desc limit 1) as t where end_ip>=$ip_int";
    if(my $row = $self->dbi->query($sql)->hash){
      my $result->{'city_id'} = $row->{'city_id'};
      $sql = "select * from net_city where id='$$result{city_id}'"; 
      if(my $row = $self->dbi->query($sql)->hash){
        $result->{'city_name'} = $row->{'name_ru'};
        $result->{'country_id'} = $row->{'country_id'};
      } 
    }
    # Если не нашли - ищем страну и город по всему миру
    unless($result->{'city_id'}) {
      $sql = "select * from (select * from net_euro where begin_ip<=$ip_int order by begin_ip desc limit 1) as t where end_ip>=$ip_int";
      if(my $row = $self->dbi->query($sql)->hash){
        $result->{'country_id'} = $row->{'country_id'};
      }
      else{
        # Ищем страну в мире
        $sql = "select * from (select * from net_country_ip where begin_ip<=$ip_int order by begin_ip desc limit 1) as t where end_ip>=$ip_int";
        if(my $row = $self->dbi->query($sql)->hash){
          $result->{'country_id'} = $row->{'country_id'};    
        }
      }
      
      # Ищем город в глобальной базе
      $sql = "select * from (select * from net_city_ip where begin_ip<=$ip_int order by begin_ip desc limit 1) as t where end_ip>=$ip_int";
      if(my $row = $self->dbi->query($sql)->hash){
        $result->{'city_id'} = $row->{'city_id'};
        $sql = "select * from net_city where id='$$result{city_id}'";
        if(my $row = $self->dbi->query($sql)->hash){
          $result->{'city_name'} = $row->{'name_ru'};
          $result->{'country_id'} = $row->{'country_id'};
        } 
      }
    }
    
    return $result;
	});
}

sub ip2long {
  return unpack("N",inet_aton(shift))
}

sub long2ip {
  return inet_ntoa(pack("N*", shift));
}

1;