package GG::Command::db;

use Mojo::Base 'Mojolicious::Commands';

use File::Spec;
use File::Path;
use Getopt::Long qw(GetOptions :config no_ignore_case no_auto_abbrev);

our $VERSION = '0.02';

has description => "GG commands\n";
has namespaces  => sub { ['GG::Command::db'] };
has hint        => <<EOF;

See 'APPLICATION db help COMMAND' for more information on a specific
command.
EOF
has message => sub { shift->extract_usage . "\nCommands:\n" };

sub help { shift->run(@_) }

1;

=encoding utf8

=head1 NAME

GG::Command::db - DB generator command

=head1 SYNOPSIS

  Usage: APPLICATION db help COMMAND [OPTIONS]
