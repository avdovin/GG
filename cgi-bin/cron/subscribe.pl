#!/usr/bin/perl

# Mac os lib path
use lib '/opt/local/lib/perl5/vendor_perl/5.12.4/darwin-thread-multi-2level/';
use lib '/opt/local/lib/perl5/site_perl/5.12.4/darwin-thread-multi-2level';

$ENV{TZ} = 'Europe/Moscow';

use MojoX::Loader;

$ENV{DOCUMENT_ROOT} = '/home/roman/www/demo.local/httpdocs';

my $subscribe = MojoX::Loader->load(
  app        => 'GG',
  controller => 'GG::Content::Subscribe',
  prefix     => ''
);


# Устанавливаем соединение с базой
$subscribe->dbi_connect;

# проверяем и делаем рассылку по новостям и новинкам
$subscribe->cron_send_refs;
