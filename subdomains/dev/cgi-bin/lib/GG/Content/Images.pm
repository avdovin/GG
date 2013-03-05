package GG::Content::Images;

use strict;
use warnings;
use utf8;

use base 'GG::Controller';

# This action will render a template
sub images_list{
    my $self = shift;

	my $key_razdel	 	= $self->stash('key_razdel');
	my $table 			= "images_$key_razdel";
	my $template		= "Images/${key_razdel}_list";
	my $subID			= $self->stash('sub_ID') || 0;
	my $ring			||= 0;

	my 	$where 	= " 1 ";
		$where .= " AND `dir`='0'" if($self->dbi->exists_keys(from => $table, lkey => 'dir'));
		$where .= " AND `image_${key_razdel}`='$subID' " if $subID;
	
	
	my 	$order 	= "ID";
		$order  = "rating" if($self->dbi->exists_keys(from => $table, lkey => 'rating'));
			
	my @items = $self->dbi->query(qq/
		SELECT *
		FROM `$table`
		WHERE $where ORDER BY `$order`,`ID`
	/)->hashes;
	
	my $image = $self->param('image') || 0;
   
    $self->render(	subid		=> $subID,
    				image		=> $image,
     				rows		=> \@items,
    				template	=> $template);	
}


sub images_item{
	my $self = shift;
	
	my $ID 				= $self->stash('ID');
	my $key_razdel	 	= $self->stash('key_razdel');
	my $table 			= "images_$key_razdel";
	my $template		= "Images/${key_razdel}_item";
	my $subID			= $self->stash('sub_ID') || 0;
	my $ring			||= 0;
	
	my 	$where 	= " 1 ";
		$where .= " AND `ID`='$ID'" if $ID;
		$where .= " AND `dir`='0'" if($self->dbi->exists_keys(from => $table, lkey => 'dir'));
		$where .= " AND `image_${key_razdel}`='$subID' " if $subID;
	
	
	my 	$order 	= "ID";
		$order  = "rating" if($self->dbi->exists_keys(from => $table, lkey => 'rating'));
	
	my $image = $self->dbi->query(qq/
				SELECT * 
				FROM `$table` 
				WHERE $where LIMIT 0,1/)->hash;
	
	unless($image){
		$self->app->static->serve_404;
		return;
	}
	
	$image->{index_after} = $self->get_index_after(from => $table, index => $ID, ring => $ring, where => $where, order => $order);
	$image->{index_befor} = $self->get_index_befor(from => $table, index => $ID, ring => $ring, where => $where, order => $order);
	
    $self->render(	item		=> $image,
    				template	=> $template);		
}
1;
