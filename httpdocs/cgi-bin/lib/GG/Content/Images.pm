package GG::Content::Images;

use utf8;

use base 'GG::Controller';

sub images_list{
    my $self = shift;

    my $keyRazdel 	= $self->stash->{key_razdel} || 'gallery';
    my $dbTable  	= "images_$keyRazdel";
    my $template 	= $keyRazdel."_list";

	#return $self->render_not_found unless my $gallery = $self->dbi->query("SELECT * FROM `$dbTable` WHERE `ID`='$subID' AND `dir`='1' AND `viewimg`='1' ")->hash;
	my	$where = 	" `viewimg`='1' ";
	
	my $gallery = {};
	if(my $dirAlias = $self->stash->{dir_alias}){
		
		return $self->render_not_found unless $gallery = $self->dbi->query("SELECT * FROM `$dbTable` WHERE `alias`='$dirAlias' AND `dir`='1' AND `viewimg`='1' ")->hash;
		
		$where .= 	" AND `image_$keyRazdel`='$$gallery{ID}' AND `dir`='0' ";
		
	} else {
		$where .= 	" AND `dir`='1' ";
		
		$template = $keyRazdel."_dir_list";
	}
	
	my $items = $self->dbi->query(qq/
		SELECT *
		FROM `$dbTable`
		WHERE $where ORDER BY `rating`,`name`
	/)->hashes;
	
    $self->render(	gallery 	=> $gallery,
     				items		=> $items,
    				template	=> 'Images/'.$template);	
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
