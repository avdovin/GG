package GG::Plugins::YTranslate;

use utf8;

use Mojo::Base 'Mojolicious::Plugin';

sub register {
  my ($self, $app, $conf) = @_;

  $app->log->debug("register ".__PACKAGE__);

  my $API_KEY = "trnsl.1.1.20150921T114400Z.967fa3a0261faece.c0c4f9746acfa6f4309442c7f271ec6834a4f778";

  use Mojo::UserAgent;
  my $UA = Mojo::UserAgent->new(max_redirects => 5);

  $app->helper( translate => sub {
    my $self = shift;

    return '' unless my $text = shift;

    my %params = (
      key     => $API_KEY,
      text    => $text,
      lang    => 'ru',
      @_
    );

    my $res = $UA->get('https://translate.yandex.net/api/v1.5/tr.json/translate' => form => \%params)->res->json;

    return $res->{code} == 200 ? $res->{text}->[0] : undef;
  });

}


1;
