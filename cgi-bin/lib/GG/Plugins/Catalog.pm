package GG::Plugins::Catalog;

use Mojo::Base 'Mojolicious::Plugin';

use utf8;

sub register {
  my ($self, $app, $opts) = @_;
  $app->log->debug("register ".__PACKAGE__);
}
1;
