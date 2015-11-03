#!/usr/bin/env perl


use FindBin;
BEGIN { unshift @INC, "$FindBin::Bin/../lib", "$FindBin::Bin/../extlib" }

use MojoX::Loader;

$ENV{DOCUMENT_ROOT} = "$FindBin::Bin/../../";

my $cron = MojoX::Loader->load(app => 'GG', controller => 'GG::Cron', prefix => '../');

$cron->dbi_connect;

$cron->clear_anonymous_sessions;
