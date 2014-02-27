#!/usr/bin/perl

use lib '/home/roman/www/tsum.local/cgi-bin/lib';
use lib '/home/roman/www/tsum.local/cgi-bin/extlib';

use lib '/var/www/hatber/data/www/hatber.ru/cgi-bin/lib';
use lib '/var/www/hatber/data/www/hatber.ru/cgi-bin/extlib';

# Mac os lib path
use lib '/opt/local/lib/perl5/vendor_perl/5.12.4/darwin-thread-multi-2level/';
use lib '/opt/local/lib/perl5/site_perl/5.12.4/darwin-thread-multi-2level';

$ENV{TZ} = 'Europe/Moscow';

use MojoX::Loader;

#$ENV{DOCUMENT_ROOT} = '/var/www/hatber/data/www/hatber.ru';
$ENV{DOCUMENT_ROOT} = '/home/roman/www/tsum.local/httpdocs';

my $subscribe = MojoX::Loader->load(app => 'GG', controller => 'GG::Content::Subscribe', prefix => '');


# Устанавливаем соединение с базой
$subscribe->dbi_connect;

# проверяем и делаем рассылку по новостям и новинкам
$subscribe->cron_send_refs;