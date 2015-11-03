package GG::Cron;

use utf8;

use Mojo::Base 'Mojolicious::Controller';

sub clear_anonymous_sessions{
  shift->clear_anonymous_sessions_helper;
}
1;
