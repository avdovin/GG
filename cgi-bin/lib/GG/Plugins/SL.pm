package GG::Plugins::SL;

use Mojo::Base 'Mojolicious::Plugin';
use Mojo::Util qw(b64_encode);
use utf8;

my $API_KEY = undef;
my $API_URL = 'http://client-shop-logistics.ru/index.php?route=deliveries/api';

sub register {
  my ( $self, $app, $opts ) = @_;

  $opts ||= {};

  my $API_KEY = $opts->{sl_api_key} || '';

  return $app->log->fatal('Shop Logistics plugin tried to register, but no api key defined') unless $API_KEY;

  $app->log->debug("register ".__PACKAGE__);

  $app->helper('sl.request'       => sub {
    my $self = shift;
    use Mojo::UserAgent;

    my $ua = Mojo::UserAgent->new;
    my $body = _build_request($self, @_);

    return $ua->post($API_URL => form => {xml => $body})->res->dom;
  });
}
sub _build_request{
  my $self = shift;
  my %params = (
    api_id    => $API_KEY,
    @_,
  );
  my $str = "<request>";
  foreach (keys %params){
    $str .= "<$_>".$params{$_}."</$_>";
  };
  $str .= "</request>";

  return b64_encode($str);
}
1;
