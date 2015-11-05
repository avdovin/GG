package GG::Command::db::clear_sessions;
use Mojo::Base 'Mojolicious::Command';

has description => 'Clear db anonymous session';
has usage => sub { shift->extract_usage };

sub run {
  my ($self, @args) = @_;
  my $params = {days => 14, map { split('=') } @args};

  die "dbi connect failed" unless $self->app->dbi_connect;

  $self->app->dbi->query(
    "DELETE FROM `anonymous_session` WHERE DATEDIFF(NOW(), `time`) >= $$params{days}"
  );

  print "Successfully deleted\n";
}

1;

=encoding utf8

=head1 NAME

GG::Command::db::clear_sessions - App generator command

=head1 SYNOPSIS

  Usage: APPLICATION db clear_sessions

=head1 DESCRIPTION
  clear anonymous sessions, the only arguments is days, default: 14 (ex. clear_sessions days=5)
