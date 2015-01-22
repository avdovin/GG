#!/usr/bin/perl

use FindBin;
BEGIN { unshift @INC, "$FindBin::Bin/../../lib", "$FindBin::Bin/../../extlib" }

use MojoX::Loader;

$ENV{DOCUMENT_ROOT} = "$FindBin::Bin/../../../";

my $import = MojoX::Loader->load(app => 'GG', controller => 'GG::Import::Commerceml', prefix => '../../');

$import->init(
	path_catalog_items 	=> 'sync/import.xml',
	path_catalog_items_backup 	=> 'sync/backup/import.xml',
	path_catalog_offers => 'sync/offers.xml',
	path_catalog_offers_backup => 'sync/backup/offers.xml',
);

$import->app->static->paths(['/var/www/fabstore/data/www/fabstore.ru/']);

$import->dbi_connect;

# Импорт остатков
$import->load_catalog;

# импорт цен
$import->load_catalog_offers;

# импорт картинок
$import->load_images;
