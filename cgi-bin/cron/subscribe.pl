#!/usr/bin/perl

$ENV{TZ} = 'Europe/Moscow';

use Mojo::Server;

# Load application with mock server
my $server = Mojo::Server->new;
my $app    = $server->load_app('../script/dispatch.cgi');

# Access fully initialized application
print for @{$app->static->paths};
