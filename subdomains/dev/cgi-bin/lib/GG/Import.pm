package GG::Import;

use utf8;

use Mojo::Base 'GG::Controller';

use File::Copy;
use XML::Simple;

my $MINI = '120x131~montage,102x122~montage,75x96~montage,329x417~montage';

sub inventory{
    my $self = shift;
    
    return unless(-f $ENV{DOCUMENT_ROOT}.'/import/inventory.xml');
	
	copy($ENV{DOCUMENT_ROOT}.'/import/inventory.xml', $ENV{DOCUMENT_ROOT}.'/import/inventory_tmp.xml', 8*1024);
	unlink($ENV{DOCUMENT_ROOT}.'/import/inventory.xml');
	
    $self->dbi_connect();
    my $dbh = $self->dbi->dbh;
    
	my $ref = XMLin($ENV{DOCUMENT_ROOT}.'/import/inventory_tmp.xml', ForceArray => 1);
	
	my $items = $ref->{Variant};
	
	$dbh->do("UPDATE `data_catalog_items` SET `quantity`='0' WHERE 1");
	
	my $sth = $dbh->prepare("UPDATE `data_catalog_items` SET `quantity`=? WHERE `sync`=? AND `variantcode`=?");
	
	foreach my $item (@$items){
		$item->{Inventory} =~ s{\D+}{}gi;
		$item->{VariantCode} ||= '';
	
		$sth->execute($item->{Inventory}, $item->{ItemNo}, $item->{VariantCode})
		
	}	

	$sth->finish();
	
	copy($ENV{DOCUMENT_ROOT}.'/import/inventory_tmp.xml', $ENV{DOCUMENT_ROOT}.'/import/backup/inventory.xml', 8*1024);
	unlink($ENV{DOCUMENT_ROOT}.'/import/inventory_tmp.xml');
}


sub imgs{
    my $self = shift;
    
    return unless(-f $ENV{DOCUMENT_ROOT}.'/import/images.zip');

	copy($ENV{DOCUMENT_ROOT}.'/import/images.zip', $ENV{DOCUMENT_ROOT}.'/import/images_tmp.zip', 8*1024);
	unlink($ENV{DOCUMENT_ROOT}.'/import/images.zip');
	   
    my $imgFolder = '/image/catalog/items/';
    $self->dbi_connect();
    my $dbh = $self->dbi->dbh;

    my $imgs = $self->file_extract_zip( path => $ENV{DOCUMENT_ROOT}.'/import/images_tmp.zip' );
    my $sth = $dbh->prepare("UPDATE `data_catalog_items` SET `images`=1 WHERE `sync`=?");
    
    my $sth_check_item = $dbh->prepare("SELECT `sync` FROM `data_catalog_items` WHERE `sync`=? LIMIT 0,1");
    
    foreach my $img (@{$imgs}) {
		
		#(undef, $pict_saved, $type_file) = $self->file_save_from_tmp( filename => $img->{filename}, to => $imgFolder.$img->{filename} );
		#warn $img->{filename};
		#warn $imgFolder.$img->{filename};
		
		# Пропускаем картинку если такого товара нет в базе
		next if($sth->execute($img->{filename}) eq '0E0');
		
		foreach my $d (split(/,/, $MINI)) {
			if($d =~ /([\d]+)x([\d]+)~([\w]+)/){
				my ($w, $h) = ($1, $2);
				my %type = ($3 	=> 1);
				
				my ($path, $pict, $ext) = $self->file_save_from_tmp(filename => $img->{filename}, to => $imgFolder.$img->{filename}, prefix => $w."x".$h );
	
				$self->resize_pict(
								file	=> $path,
								width	=> $w,
								height	=> $h,
								%type
				);
			} elsif($d =~ /([\d]+)x([\d]+)/){
				my ($w, $h) = ($1, $2);
				
				my ($path, $pict, $ext) = $self->file_save_from_tmp(filename => $img->{filename}, to => $imgFolder.$img->{filename}, prefix => $w."x".$h );
							
				$self->resize_pict(
								file	=> $path,
								width	=> $w,
								height	=> $h
				);
				
			} else {

				my ($path, $pict, $ext) = $self->file_save_from_tmp(filename => $img->{filename}, to => $imgFolder.$img->{filename}, prefix => $d );
	
				$self->resize_pict(
								file	=> $path,
								fsize	=> $d,
				);						
			}
			
		}
						
		#$img->{filename} =~ s/\D//g;
		$sth->execute($img->{filename});
		
	}
	
	$sth->finish();
	
	copy($ENV{DOCUMENT_ROOT}.'/import/images_tmp.zip', $ENV{DOCUMENT_ROOT}.'/import/backup/images.zip', 8*1024);
	unlink($ENV{DOCUMENT_ROOT}.'/import/images_tmp.zip');
	
	return 1;
}

1;