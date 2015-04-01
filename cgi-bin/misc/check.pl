#!/usr/bin/perl

my $str1 = 'abc';
my $str2 = 'abcd';
my $num1 = 1000;
my $num2 = 100213.1123;

print $str1 != $str2;
print "\n";
print $num1 != $num2;
print "\n";
print $str1 ne $str2;
print "\n";
print $num1 ne $num2;
print "\n";


print "001" == "0001" ? "true" : "false", "\n";
print "10" eq "010" ? "true" : "false", "\n";