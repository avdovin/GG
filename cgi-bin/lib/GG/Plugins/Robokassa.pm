package GG::Plugins::Robokassa;

use utf8;

use Mojo::Base 'Mojolicious::Plugin';

my $MRH_URL   = "https://merchant.roboxchange.com/Index.aspx";

use Mojo::Util qw(md5_sum);
our $VERSION = '0.04';
my ( $MRH_LOGIN, $MRH_PASS1, $MRH_PASS2 ) = ( undef,undef,undef );

sub register {
  my ($self, $app, $conf) = @_;

  $MRH_LOGIN = $conf->{mrh_login};
  $MRH_PASS1 = $conf->{mrh_pass1};
  $MRH_PASS2 = $conf->{mrh_pass2};
  my $ORDER_TBL = $conf->{order_table};

  my $DEBUG     = $conf->{test} ? 1 : undef;

  $app->log->debug("register GG::Plugins::Robokassa");

  my $routes = $app->routes;

  $routes->get("/robokassa/:req_alias" => [req_alias => qr/(fail|success)/])->to(
    cb => sub{
      my $self = shift;
      $self->render( template   => 'Plugins/Robokassa/'.$self->stash('req_alias'), layout => 'default');
    }
  );

  $routes->get("/robokassa/result")->to(
    cb => sub {
      my $self = shift;

      my $order_exists = $self->stash->{order_id} = ($self->param('InvId') and $ORDER_TBL) ? $self->dbi->select($ORDER_TBL, 'ID', {ID => $self->param('InvId')})->list : undef;

      my $text = '';
      if ( $order_exists and check_payment( $self )){
        $text = 'OK' . $order_exists;
        eval("$self->content_common->robokassa_success_callback");
      }else{
        $text = 'ERR';
      }
      $self->render(text => $text, layout  => undef);
    }
  );

  $app->helper( 'robokassa.generate_payment_url' => sub {
    my $self = shift;

    my %params = (
      MerchantLogin => $MRH_LOGIN,
      OutSum        => 0,
      InvId         => 0,
      Shp           => {},
      @_
    );

    $params{IsTest} = 1 if $DEBUG;

    my $qs = {};
    delete $params{InvId} unless $params{InvId};
    foreach my $key (keys %params){
      if (ref $params{$key}){
        foreach my $sub (sort keys %{$params{$key}}){
          $qs->{$key.'_'.ucfirst($sub)} = $params{$key}->{$sub};
        }
      }else{
        $qs->{$key} = $params{$key};
      }
    };

    $qs->{SignatureValue} = signature( $self, %params);

    my @qs = ();

    foreach (sort keys %$qs){
      push @qs, "$_=$$qs{$_}";
    }

    return $MRH_URL.'?'.(join('&', @qs));
  });
}

sub check_payment{
  my $self = shift;
  my %params = (
    @_
  );

  my $my_crc = signature($self, from_qs => 1);

  return lc $my_crc eq lc $self->param('SignatureValue') ? 1 : 0;
}

sub signature{
  my $self = shift;
  my %params = (
    from_qs   => 0,
    @_,
  );

  %params = ( %params, %{$self->req->params->to_hash} ) if $params{from_qs};

  my $str = "";

  if( !$params{from_qs} ){
    $str .= "$MRH_LOGIN:";
  }
  $str .= "$params{OutSum}:";
  $str .= "$params{InvId}:" if $params{InvId};
  $str .= ( $params{from_qs} ? $MRH_PASS2 : $MRH_PASS1 );

  return md5_sum($str);
}

1;
