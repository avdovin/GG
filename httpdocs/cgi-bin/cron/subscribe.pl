#!/usr/bin/perl

use lib '/www/adriatica.local/cgi-bin/lib';
use lib '/www/adriatica.local/cgi-bin/extlib';

#use lib '/home/vhosts/msopt.ru/cgi-bin/lib';
#use lib '/home/vhosts/msopt.ru/cgi-bin/extlib';

use MojoX::Loader;

#$ENV{DOCUMENT_ROOT} = '/home/vhosts/msopt.ru/httpdocs';
$ENV{DOCUMENT_ROOT} = '/www/adriatica.local/httpdocs/';

my $subscribe = MojoX::Loader->load(app => 'GG', controller => 'GG::Admin::Subscribe', prefix => '../../../');

$subscribe->dbi_connect;
$subscribe->send_letter_cron;
