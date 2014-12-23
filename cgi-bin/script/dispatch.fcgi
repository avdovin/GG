#!/usr/bin/env perl

use strict;
use warnings;

BEGIN { $ENV{'MAGICK_THREAD_LIMIT'}=2; }

use FindBin;
BEGIN { unshift @INC, "$FindBin::Bin/../lib", "$FindBin::Bin/../extlib" }

# Mac os lib path
#use lib '/System/Library/Perl/Extras/5.16';

$ENV{'MOJO_APP'} ||= 'GG';
$ENV{'MOJO_HOME'} =  "../"; #'/www/gg9.local/cgi-bin';
$ENV{'MOJO_MODE'} = 'production'; #(production)(development)
$ENV{'MOJO_NO_IPV6'} = 1;
$ENV{'MOJO_NO_TLS'} = 1;
$ENV{'SCRIPT_NAME'} = "/";
$ENV{'MOJO_REVERSE_PROXY'} = 1;
$ENV{'TZ'} = 'Europe/Moscow';


$ENV{'MOJO_I18N_DEBUG'} = 0;
$ENV{'MOJO_ASSETPACK_DEBUG'} = 0;

# Start command line interface for application
require Mojolicious::Commands;
#Mojolicious::Commands->start_app( $ENV{MOJO_APP} );
#run in fastcgi
Mojolicious::Commands->start_app($ENV{'MOJO_APP'}, 'fastcgi');
