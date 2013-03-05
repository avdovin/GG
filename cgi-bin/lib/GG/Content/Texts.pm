package GG::Content::Texts;

use utf8;
use Mojo::Base 'GG::Content::Controller';

sub events_item{
    my $self = shift;
	my %params = @_;

	return $self->list_item( %params );	
}

sub events_arhive_list{
    my $self = shift;
	my %params = @_;
	
	$params{where} = " AND `tdate` <= NOW() ";
	$self->stash->{arhive} = 1;
		
	return $self->texts_list( %params );
}

sub events_list{
    my $self = shift;
	my %params = @_;
	
	$params{where} = " AND `tdate` > NOW() ";
	
	return $self->texts_list( %params );	
}

# This action will render a template
sub texts_list{
    my $self = shift;
	my %params = (
		key_razdel	=> $self->stash('key_razdel'),
		date		=> $self->stash('date') || "tdate",
		order_desc	=> 'desc',
		order_field	=> $self->stash('date') || "tdate",
		select		=> '*',
		page		=> $self->stash('page') || 1,
		limit		=> 0,	#$self->vars->{news_limit}->value
		@_
	);
	
	my $key_razdel	= delete $params{key_razdel};
	my $table		= "texts_".$key_razdel."_".$self->lang;
	my $template 	= $key_razdel.'_list';


	if($self->stash->{alias}){
		
		if(my $mainPage = $self->dbi->query("SELECT `name`,`title`,`keywords`,`description` FROM `texts_main_ru` WHERE `alias`='".$self->stash->{alias}."' AND `viewtext`='1'")->hash){
			$self->metaHeader( title => $mainPage->{title} || $mainPage->{name}, keywords => $mainPage->{keywords}, description	=>	$mainPage->{description} );
		}

	}
	

	if($self->stash->{level}){
		my $level = $self->stash->{level};
		$template .= "_level_$level";
		
		my $last_alias = $self->stash->{'alias_'.$level};		
		my $last_item = $self->dbi->query("SELECT `dir` FROM `$table` WHERE `viewtext`='1' AND `alias`='$level'")->hash;
		return $self->render_not_found unless $last_item;
		
		unless($last_item->{dir}){
			return $self->item_by_alias(%params);
		}
		
		$self->stash->{ $key_razdel.'_'.$level } = $last_item;
		
		$params{where} = " AND `texts_".$key_razdel."_".$self->lang."`='$$last_item{ID}' ";		
#		foreach my $i (1..$deep){
#			my $alias = $self->stash->{'alias_'.$i};
#		}
	}

	
# Условия выборки:
	my 	$where  = "`viewtext`='1' ";
		$where .= " AND `dir`='0'" 												if $self->dbi->exists_keys(from => $table, lkey => 'dir');
		$where .= " AND YEAR($params{order_field})='".$self->param('year')."' "	if $self->param('year');
	  	$where .= " $params{where} " 											if $params{where};	# Дополнительные параметры выборки

	# Список с учетом выбранной папки (по alias)
	if($self->stash->{group_alias}){
		return $self->render_not_found unless my $parentDir = my $mainPage = $self->dbi->query("SELECT * FROM `$table` WHERE `dir`='1' AND `alias`='".$self->stash->{group_alias}."' AND `viewtext`='1'")->hash;
		
		$where .= " AND `$table`='$$parentDir{ID}' ";
		$self->metaHeader( title => $parentDir->{title} || $parentDir->{name}, keywords => $parentDir->{keywords}, description	=>	$parentDir->{description} );
	}
	
		$where .= " ORDER BY ".($self->dbi->exists_keys(from => $table, lkey => 'rating') ? ' `rating`,' : '')."`$params{order_field}` $params{order_desc} ".($params{order_field} ne 'ID' ? ",`ID` desc" : "");
	if($params{limit}){
		my $count = $self->dbi->getCountCol(from => $table, where => $where);
		$self->def_text_interval( total_vals => $count, cur_page => $params{page}, col_per_page => $params{limit} );
		$params{npage} = $params{limit} * ($params{page} - 1);
		$where .= " LIMIT $params{npage},$params{limit} "; 
	}

	my $items = $self->dbi->query(qq/
		SELECT *
		FROM `$table`
		WHERE $where
	/)->hashes;

    $self->render(	template	=> "Texts/$template",
    				items		=> $items);
    
}

sub text_main_item{
	my $self = shift;

	my $alias = $self->stash('alias');

	
	my 	$where	= 	"`viewtext`='1'";
		$where	.= 	" AND `alias`='$alias'";
	
	return $self->render_not_found unless my $text = $self->dbi->query("SELECT * FROM `texts_main_".$self->lang."` WHERE $where")->hash;

	#AJAX request
	my $header = $self->req->headers->header('X-Requested-With');
	return $self->render_text($text->{text}) if ($header && $header eq 'XMLHttpRequest');
	
	if($text->{url_for}){
		my $href = $self->menu_item($text);
		return $self->redirect_to_301($href);
	}
	
	$self->metaHeader(title => $$text{title} || $$text{name}, keywords => $$text{keywords}, description => $$text{description});
		
    $self->render(	info		=> $text, 
    				template	=> "Texts/body_default",
    				layout		=> $text->{layout} || 'default',
    );	
}


sub text_list_item{
	my $self = shift;
	my %params = (
		where	=> "`ID`='".$self->stash('ID')."'",
		@_
	);
	
	my $ring	  ||= 0;
	my $alias		= $self->stash('list_item_alias');
	my $key_razdel 	= $self->stash('key_razdel');
	my $template	= "Texts/".$key_razdel."_item";
	my $table 		= "texts_".$key_razdel."_".$self->lang;
	
	my 	$where  = " ";
		$where .= " AND `dir`='0'" 		if $self->dbi->exists_keys(from => $table, lkey => 'dir');
		$where .= " AND `viewtext`='1' ";


#	my $order = "ID";
#	foreach (qw (tdate)){
#		if ($self->dbi->exists_keys(from => $table, lkey => $_)) {
#			$order = $_;
#			last;
#		}
#	}

		
	return $self->render_not_found unless my $item = $self->dbi->query(qq/
			SELECT * 
			FROM `$table` 
			WHERE `alias`='$alias' $where LIMIT 0,1/)->hash;		

	if($self->stash->{alias}){
		$self->stash->{header}->{title} = [];
		my $title = [];
		if(my $mainPage = $self->dbi->query("SELECT `name`,`title` FROM `texts_main_ru` WHERE `alias`='".$self->stash->{alias}."' AND `viewtext`='1'")->hash){
			push @$title, $mainPage->{title} || $mainPage->{name};
		}

		push @$title,  $item->{title} || $item->{name};
		$self->metaHeader( title => $title, keywords => $item->{keywords}, description	=>	$item->{description} );
		
	} else {
		
		$self->metaHeader( title => $item->{title} || $item->{name}, keywords => $item->{keywords}, description	=>	$item->{description} );
	}
		
	
	#$text->{index_after} = $self->get_index_after(from => $table, index => $ID, ring => $ring, where => $where, order => $order);
	#$text->{index_befor} = $self->get_index_befor(from => $table, index => $ID, ring => $ring, where => $where, order => $order);
	
    $self->render(	item		=> $item,
    				template	=> $template);	
}


1;
