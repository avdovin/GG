package GG::Command::gg;

use Mojo::Base 'Mojolicious::Command';
use Mojo::Util 'class_to_path';

use File::Spec;
use File::Path;
use Getopt::Long qw(GetOptions :config no_ignore_case no_auto_abbrev);   # Match Mojo's commands

our $VERSION = '0.01';

has description => "GG commands\n";
has usage => <<USAGE;
usage $0 COMMAND

COMMANDS
clear_sessions - clear anonymous sessions, the only arguments is days, default: 14 (ex. clear_sessions days=5)

USAGE

sub run {
  my ($self, @args) = @_;

  return if !$args[0] or !( defined &{$args[0]} );

  my $function_name = splice @args, 0, 1;
  my $params = { map { split('=') } @args };

  $self->app->dbi_connect;

  eval($self->$function_name($params)) and exit;
}

sub clear_sessions {
  my $self = shift;

  my %params = (
      days     => 14,
      %{$_[0]}
  );

  $self->app->dbi->query("DELETE FROM `anonymous_session` WHERE DATEDIFF(NOW(), `time`) >= $params{days}");

  print "Successfully deleted\n";
};
1;
