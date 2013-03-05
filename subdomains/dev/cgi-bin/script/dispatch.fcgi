#!/usr/bin/env perl

use strict;
use warnings;

use File::Basename 'dirname';
use File::Spec::Functions qw/catdir splitdir/;

# Source directory has precedence
my @base = (splitdir(dirname(__FILE__)), '..');
my $lib = join('/', @base, 'lib' );
-e catdir(@base, 't') ? unshift(@INC, $lib) : push(@INC, $lib);
push(@INC, join('/', @base, 'extlib') );

# Check if Mojo is installed
eval 'use Mojolicious::Commands';
die <<EOF if $@;
It looks like you don't have the Mojo Framework installed.
Please visit http://mojolicious.org for detailed installation instructions.

EOF

# Application
$ENV{MOJO_APP} ||= 'GG';
$ENV{MOJO_HOME} =  "../"; #'/www/gg9.local/cgi-bin';
$ENV{MOJO_MODE} = 'development'; #(production)(development)
$ENV{MOJO_NO_IPV6} = 1;
$ENV{MOJO_NO_TLS} = 1;
$ENV{SCRIPT_NAME} = "/";
$ENV{DOCUMENT_ROOT} = $ENV{DOCUMENT_ROOT} || '/www/gg9.local/httpdocs/';

# Start commands
Mojolicious::Commands->start;
