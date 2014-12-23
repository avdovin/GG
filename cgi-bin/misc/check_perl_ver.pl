#!/usr/bin/env perl

use strict;
use warnings;

use CGI::Carp qw(fatalsToBrowser);

my $command= $];
my $title = "Perl Version";

print "Content-type: text/html\n\n";
print "<html><head><title>$title</title></head><body>";

print "<h1>$title</h1>\n";
print "Perl version : ".$command;