#!/usr/bin/perl

use strict;
use ExtUtils::Installed;
use Term::ANSIColor qw(:constants);

my @modules;
my $installed = ExtUtils::Installed->new();

my %modules = (
  'JavaScript::Minifier::XS'   => '0',
  'Socket'                     => '1.97',
  'CSS::Minifier::XS'          => '0',
  'Crypt::Eksblowfish::Bcrypt' => '0',
);

print "Module\tVersion\n";

foreach my $m (keys %modules) {
  my $ver = '';
  eval { $ver = $installed->version($m); };
  $ver = $@ if $@;

  if ($ver =~ /is not installed/) {
    print RED, "$ver";
  }
  elsif ($ver < $modules{$m}) {
    print RED, "$m version $modules{$m} required--this is only version $ver";
  }
  else {
    print CYAN, "$m $ver";
  }
  print RESET;
}
print "\n";
