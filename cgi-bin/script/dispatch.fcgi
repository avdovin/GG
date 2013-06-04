#!/usr/bin/env perl

use strict;
use warnings;

BEGIN { $ENV{MAGICK_THREAD_LIMIT}=2; }

use FindBin;
use lib "$FindBin::Bin/../lib";
use lib "$FindBin::Bin/../extlib";

# Mac os lib path
use lib '/opt/local/lib/perl5/vendor_perl/5.12.4/darwin-thread-multi-2level/';
use lib '/opt/local/lib/perl5/site_perl/5.12.4/darwin-thread-multi-2level';

#$ENV{MOJO_APP} ||= 'GG';
$ENV{MOJO_HOME} =  "../"; #'/www/gg9.local/cgi-bin';
$ENV{MOJO_MODE} = 'development'; #(production)(development)
$ENV{MOJO_NO_IPV6} = 1;
$ENV{MOJO_NO_TLS} = 1;
$ENV{SCRIPT_NAME} = "/";
$ENV{DOCUMENT_ROOT} = $ENV{DOCUMENT_ROOT} || '/www/gg9.local/httpdocs/';
$ENV{MOJO_REVERSE_PROXY} = 1;


# Start command line interface for application
require Mojolicious::Commands;
Mojolicious::Commands->start_app('GG');
#run in fastcgi
#Mojolicious::Commands->start_app('GG', 'fastcgi');
