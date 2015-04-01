package GG::Content::Texts;

use utf8;
use Mojo::Base 'GG::Content::Controller';

sub redirect_to_first_item{
	my $self = shift;

	$self->stash->{key_razdel} ||= 'news';

	my $db_table = 'texts_'.$self->stash->{key_razdel}.'_'.$self->lang;

	return $self->render_not_found unless my $item = $self->dbi->query(qq/
		SELECT `alias`
		FROM `$db_table`
		WHERE `viewtext`='1' ORDER BY `tdate` DESC
		LIMIT 0,1
	/)->hash;

	$self->redirect_to($self->stash->{key_razdel}.'/'.$item->{alias})
}

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
		where 		=> $self->stash->{'where'} || '',
		lang_tables => defined $self->stash->{'lang_tables'} ? $self->stash->{'lang_tables'} : 1,
		limit		=> 0,	# $self->get_var(name => 'news_limit', controller => 'texts', raw => 1),
		@_
	);

	my $key_razdel	= delete $params{key_razdel};
	my $table		= "texts_".$key_razdel."_".($params{lang_tables} ? $self->lang : 'ru');
	my $template 	= $key_razdel.'_list';

	if($self->stash->{alias}){

		if(my $mainPage = $self->dbi->query("SELECT `name`,`title`,`keywords`,`description` FROM `texts_main_ru` WHERE `alias`='".$self->stash->{alias}."' AND `viewtext`='1'")->hash){

			$self->meta_title( $mainPage->{title} || $mainPage->{name} );
			$self->meta_keywords( $mainPage->{keywords} );
			$self->meta_description( $mainPage->{description} );
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
	my 	$where  = " `viewtext`='1' ";
		$where .= " AND `dir`='0'" 												if $self->dbi->exists_keys(from => $table, lkey => 'dir');
		$where .= " AND YEAR($params{order_field})='".$self->param('year')."' "	if $self->param('year');
		$where .= " AND MONTH($params{order_field})='".$self->param('month')."' "	if $self->param('month');
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

	return $self->render_not_found unless my $text = $self->dbi->query("SELECT *, DATE_FORMAT(updated_at,'%a, %d %b %Y %T') AS updated_at_rfc822 FROM `texts_main_".$self->lang."` WHERE $where")->hash;

	#AJAX request
	return $self->render( text => $text->{text}) if ($self->req->is_xhr);

	if($text->{url_for} && $self->stash->{redirect_to_url_for}){
		my $href = $self->menu_item($text);
		return $self->redirect_to_301($href);
	}

  $self->meta_title( $text->{title} || $text->{name} );
  $self->meta_keywords( $text->{keywords} );
  $self->meta_description( $text->{description} );

	# Wed, 24 Sep 2014 19:15:45 GMT
  $self->res->headers->last_modified( $text->{updated_at_rfc822}.' GMT' )
    if ($text->{'updated_at'} && $text->{'updated_at'} ne '0000-00-00 00:00:00'  && !(scalar keys %{$self->userdata}));

	my $template = $self->stash->{template} ||= "Texts/_body_default";
  $self->render(
    item		=> $text,
    template	=> $template,
    layout		=> $text->{'layout'} || 'default',
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

  my $where  = " ";
     $where .= " AND `dir`='0'"  if $self->dbi->exists_keys(from => $table, lkey => 'dir');
     $where .= " AND `viewtext`='1' ";


#	my $order = "ID";
#	foreach (qw (tdate)){
#		if ($self->dbi->exists_keys(from => $table, lkey => $_)) {
#			$order = $_;
#			last;
#		}
#	}


  return $self->render_not_found unless my $item = $self->dbi->query(qq/
			SELECT *, DATE_FORMAT(updated_at,'%a, %d %b %Y %T') AS updated_at_rfc822
			FROM `$table`
			WHERE `alias`='$alias' $where LIMIT 1/)->hash;

  if($self->stash->{alias}){
    if(my $textSection = $self->dbi->query("SELECT `name`,`title` FROM `texts_main_".$self->lang."` WHERE `alias`='".$self->stash->{alias}."' AND `viewtext`='1'")->hash){
      $self->meta_title( $textSection->{title} || $textSection->{name} );
    }
  }

  $self->meta_title( $item->{title} || $item->{name} );
  $self->meta_keywords( $item->{keywords} );
  $self->meta_description( $item->{description} );

  $self->res->headers->last_modified( $item->{updated_at_rfc822}.' GMT' )
    if ($item->{'updated_at'} && $item->{'updated_at'} ne '0000-00-00 00:00:00'  && !(scalar keys %{$self->userdata}));

	#$text->{index_after} = $self->get_index_after(from => $table, index => $ID, ring => $ring, where => $where, order => $order);
	#$text->{index_befor} = $self->get_index_befor(from => $table, index => $ID, ring => $ring, where => $where, order => $order);

	$self->render(
    item		=> $item,
    template	=> $template
  );
}


1;
