#!/usr/bin/perl

use lib '/www/hatber.local/cgi-bin/lib';
use lib '/www/hatber.local/cgi-bin/extlib';

use lib '/home/vhosts/msopt.ru/cgi-bin/lib';
use lib '/home/vhosts/msopt.ru/cgi-bin/extlib';

use MojoX::Loader;

$ENV{DOCUMENT_ROOT} = '/home/vhosts/msopt.ru/httpdocs';

my $import = MojoX::Loader->load(app => 'GG', controller => 'GG::Import', prefix => '../');

# Импорт картинок
$import->imgs;


# Импорт остатков
$import->inventory;