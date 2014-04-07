package GG::Admin::Banners;

use utf8;

use Mojo::Base 'GG::Admin::AdminController';

sub _init{
	my $self = shift;

	$self->def_program('banners');

	$self->get_keys( type => ['lkey', 'button'], controller => $self->app->program->{key_razdel});

	my $config = {
		controller_name	=> $self->app->program->{name},
		#controller		=> 'keys',
	};

	$self->stash->{list_table} ||= 'data_banner';

	$self->stash($_, $config->{$_}) foreach (keys %$config);

	$self->stash->{index} ||= $self->send_params->{index};

	unless($self->send_params->{replaceme}){
		$self->send_params->{replaceme} = $self->stash->{controller};
		$self->send_params->{replaceme} .= '_'.$self->stash->{list_table} if $self->stash->{list_table};
	}
	#$self->send_params->{replaceme} .= $self->stash->{index} || '';

	foreach ( qw(list_table replaceme)){
		$self->param_default($_ => $self->send_params->{$_} ) if $self->send_params->{$_};
	}

	$self->stash->{replaceme} = $self->send_params->{replaceme};
	$self->stash->{lkey} = $self->stash->{controller};
	$self->stash->{lkey} .= '_'. $self->send_params->{list_table} if $self->send_params->{list_table};
	$self->stash->{script_link} = '/admin/'.$self->stash->{controller}.'/body';

	$self->stash->{folder} = '/image/bb/';
}

sub body{
	my $self = shift;

	$self->_init;

	my $do = $self->param('do');

	given ($do){

		when('list_container') 			{ $self->list_container; }
		when('enter') 					{ $self->list_container( enter => 1); }
		when('list_items') 				{ $self->list_items; }

		when('print') 					{ $self->print_choose; }
		when('print_anketa') 			{
			$self->print_anketa(
				title 	=> "Раздел «".$self->stash->{name_razdel}."»",
			);
		}

		when('delete_file') 			{ $self->field_delete_file(
				fields => [qw(folder docfile type_file size)]
			);
		}
		when('delete_pict') 			{ $self->field_delete_pict( render => 1); }
		when('field_upload_swf') 		{ $self->field_upload_swf; }
		when('file_upload_tmp') 		{ $self->render( text => $self->file_upload_tmp ); }

		when('upload') 					{
			my $item = $self->getArraySQL(	from => $self->stash->{list_table}, where => "`ID`='".$self->stash->{index}."'");
			$self->file_download( path => $self->stash->{folder}.$item->{docfile});
		}

		when('menu_button') 			{
			$self->def_menu_button(
				key 		=> $self->app->program->{menu_btn_key},
				controller	=> $self->app->program->{key_razdel},
			);
		}

		when('filter_take') 			{ $self->filter_take( render => 1); }
		when('quick_view') 				{ $self->quick_view; }

		when('set_qedit') 				{ $self->set_qedit; }
		when('set_qedit_i') 			{ $self->set_qedit(info => 1); }
		when('save_qedit') 				{ $self->save_qedit; }
		when('save_qedit_i') 			{ $self->save_qedit; }

		when('filter') 					{ $self->filter_form; }
		when('filter_save') 			{ $self->filter_save; }
		when('filter_clear') 			{ $self->filter_clear();  $self->list_container(); }

		when('add') 					{ $self->edit( add => 1); }
		when('edit') 					{ $self->edit; }
		when('info') 					{ $self->info; }
		when('save') 					{ $self->save; }
		when('save_continue‎')			{ $self->save( continue => 1); }
		when('delete') 					{ $self->delete; }
		when('restore') 				{ $self->save( restore => 1); }

		when('tree') 					{ $self->tree; }
		when('tree_block') 				{ $self->tree_block; }
		when('tree_reload') 			{ $self->tree_block; }

		when('lists_select') 			{ $self->lists_select; }

		default							{ $self->render( text => "действие не определенно"); }
	}
}

sub lists_select{
	my $self = shift;

	my $lfield = $self->param('lfield');
	$lfield =~ s{^fromselect}{};
	my $keystring = $self->param('keystring');

	my $selected_vals = $self->send_params->{$lfield};
	$selected_vals =~ s{=}{,}gi;

	my $sch = 0;
	my $list_out = "";

	my $where  = "`ID` > 0";
	   $where .= " AND `name` LIKE '%$keystring%' ORDER BY `name`";

	my (@array_lang);
	foreach ($self->dbi->getTablesSQL()) { if ($_ =~ m/texts_main_([\w]+)/) {push(@array_lang, $1);} }

	# Смотрим в разделах:
	for my $item ($self->dbi->query("SELECT `ID`,`name`,`key_razdel` FROM `lst_texts` WHERE $where")->hashes){
		my $name  = &def_name_list_select("Раздел: ", $item->{name});
		my $index = "$$item{key_razdel}:0";
		$list_out .= "lstobj[out].options[lstobj[out].options.length] = new Option('$name', '$index');\n" if $name;

		$sch++;
	}

	foreach my $l (@array_lang) {
		for my $item ($self->dbi->query("SELECT `ID`,`name` FROM `texts_main_${l}` WHERE $where")->hashes){
			my $name  = &def_name_list_select("Страница ($l): ", $item->{name});

			my $index = "$l:main:$$item{ID}";
			$list_out .= "lstobj[out].options[lstobj[out].options.length] = new Option('$name', '$index');\n" if $name;

			$sch++;
		}
	}
	$list_out .= "document.getElementById('ok_' + out).innerHTML = \"<span style='background-color:lightgreen;width:45px;padding:3px'>найдено: ".$sch."</span>\";\n";
	$self->render( text => $list_out);

	sub def_name_list_select {
		my ($title, $name) = @_;

		$name =~ s/&laquo;/"/;
		$name =~ s/&raquo;/"/;
		$name =~ s/["']+//g;

		return $title.$name;
	}

}

sub tree{
	my $self = shift;

	my $controller = $self->stash->{controller};
	my $table = $self->stash->{list_table};

	$self->stash->{param_default} .= "&first_flag=1";

	$self->param_default('replaceme' => '');

	my $folders = $self->getHashSQL(	select	=> "`ID`,`name`",
										from 	=> 'data_banner_advert_block',
										where 	=> "`ID`>0",
										sys		=> 1) || [];

	foreach my $i (0..$#$folders){
		$folders->[$i]->{replaceme} = $table.$folders->[$i]->{ID};
	}

	my $items = $self->getHashSQL(	select	=> "`ID`,`name`",
									from 	=> 'data_banner',
									where 	=> "`id_advert_block`=''");

	foreach my $i (0..$#$items){
		$items->[$i]->{icon}		= 'image';
		$items->[$i]->{replaceme} = $controller.'_'.$table.$items->[$i]->{ID};
		$items->[$i]->{name} = "[".$items->[$i]->{ID}."] ".$items->[$i]->{name};
		$items->[$i]->{param_default} = "&replaceme=".$items->[$i]->{replaceme};
	}

	$self->render( folders => $folders, items => $items, template => 'Admin/tree_block');
}

sub tree_block{
	my $self = shift;

	my $items = [];
	my $index = $self->stash->{index};
	my $controller = $self->stash->{controller};
	my $table = $self->stash->{list_table};

	$self->param_default('replaceme' => '');

	my $banner_place = "(`id_advert_block`='$index' OR (`id_advert_block` LIKE '$index=%' OR `id_advert_block` LIKE '%=$index=%' OR `id_advert_block` LIKE '%=$index'))";

	$items = $self->getHashSQL(	select	=> "`ID`,`name`",
								from 	=> $table,
								where 	=> "$banner_place ORDER BY `name` ",
								) || [];

	foreach my $i (0..$#$items){
		$items->[$i]->{name} =  "[".$items->[$i]->{ID}."] ".$items->[$i]->{name};;
		$items->[$i]->{icon} = 'image';
		$items->[$i]->{replaceme} = $controller.'_'.$table.$items->[$i]->{ID};
		$items->[$i]->{param_default} = "&replaceme=".$items->[$i]->{replaceme};
	}

	$self->render( json => {
					content	=> $self->render( items => $items, template => 'Admin/tree_elements', partial => 1),
					items	=> [{
							type	=> 'eval',
							value	=> "treeObj['".$self->stash->{controller}."'].initTree();"
					},
					]
	});

}

sub delete{
	my $self = shift;

	$self->backup_doptable;

	if ($self->getArraySQL( from => $self->stash->{list_table}, where => $self->stash->{index}, stash => 'anketa')) {

		if($self->stash->{dop_table}){
			if($self->delete_info( from => $self->stash->{list_table}, where => $self->stash->{index})){
				#$self->restore_doptable;
				return $self->field_dop_table_reload;
			}
		}

		if($self->delete_info( from => $self->stash->{list_table}, where => $self->stash->{index} )){

			if($self->stash->{anketa}->{docfile}){
				eval{
					unlink ($ENV{DOCUMENT_ROOT}.$self->stash->{folder}.$self->stash->{anketa}->{docfile});
				};
				warn $@ if $@;
			}

			# Удаление статистика к банeру
			$self->dbi->query("DELETE FROM `dtbl_banner_stat` WHERE `id_banner`='".$self->stash->{index}."'");
			$self->dbi->query("OPTIMIZE TABLE `dtbl_banner_stat`");

			$self->stash->{tree_reload} = 1;

			$self->save_logs( 	name 	=> 'Удаление записи из таблицы '.$self->stash->{list_table},
								comment	=> "Удалена запись из таблицы [".$self->stash->{index}."] «".$self->stash->{anketa}->{name}."» . Таблица ".$self->stash->{list_table});

			$self->define_anket_form( noget => 1, access => 'd', table => $self->stash->{list_table});

		}

	} else {

	$self->save_logs( 	name 	=> 'Попытка удаления записи из таблицы '.$self->stash->{list_table},
						comment	=> "Неудачная попытка удаления записи из таблицы [".$self->stash->{index}."]. Таблица ".$self->stash->{list_table}.". ".$self->msg_no_wrap);

	$self->block_null;
	}

}

sub save{
	my $self = shift;
	my %params = @_;

	if ($self->param('list_page')) { # Сохранение выбранных страниц
		my $list_page = $self->param('list_page');
		$list_page =~ s/,/\n/g;
		$list_page .= "\n";
		$self->send_params->{list_page} = $list_page;
	}

	$self->backup_doptable;

	unless($self->stash->{index}){
		$self->send_params->{'week'} = '-1';
		$self->send_params->{'time'} = '-1';
	}

	$self->stash->{index} = 0 if $params{restore};

	if( $self->save_info( table => $self->stash->{list_table}) ){

		if($params{restore}){
			$self->stash->{tree_reload} = 1;
			$self->save_logs( 	name 	=> 'Восстановление записи в таблице '.$self->stash->{list_table},
								comment	=> "Восстановлена запись в таблице [".$self->stash->{index}."]. Таблица ".$self->stash->{list_table}.". ".$self->msg_no_wrap);
			return $self->info;
		}

		if($self->send_params->{docfile}){
			my $docfile = $self->send_params->{docfile};
			my (undef, $docfile_saved, $type_file, $size) = $self->file_save_from_tmp( filename => $docfile, to => $self->stash->{folder}.$docfile );

			$self->save_info(send_params => 0, table => $self->stash->{list_table}, field_values => {docfile => $docfile_saved, type_file => $type_file, size => $size} );



			# Изменяем размер баннера под выбранное баннерное место
			if($self->send_params->{width} && $self->send_params->{height}){
				my $img_ext = [qw(jpg jpeg gif png)];

				$type_file = lc($type_file);
				if(grep {$type_file eq $_}  @$img_ext){
					$self->resize_pict(
						crop 	=> 1,
						file 	=> $self->app->static->paths->[0].$self->stash->{folder}.$docfile,
						width 	=> $self->send_params->{width},
						height 	=> $self->send_params->{height},
						retina 	=> $self->lkey(name => 'docfile', setting => 'retina' ),
					);
				}
			}

		}


		# Если закачена картинка и не указаны размеры подрезаем под размеры баннерного места
#		if($self->send_params->{id_advert_block} && $self->getArraySQL(	from 	=> $self->stash->{list_table},
#								where	=> "`ID`='".$self->stash->{index}."'",
#								stash	=> 'banner')
#			){
#			my $img_ext = [qw(jpg jpeg gif png)];
#			$self->stash->{banner} ||= {};
#
#			if($self->stash->{banner}->{docfile}){
#				my $type_file = ($self->stash->{banner}->{docfile} =~ m/([^.]+)$/)[0] || '';
#				if(grep(/$type_file/, @$img_ext) and !$self->stash->{banner}->{width} and !$self->stash->{banner}->{height}){
#
#					if(my $place = $self->dbi->query("SELECT * FROM `lst_advert_block` WHERE `ID`='".$self->stash->{banner}->{id_advert_block}."' AND `width`!='' AND `height`!=''")->hash){
#						my ($w, $h) = $self->image_set( file => $self->stash->{folder}.$self->stash->{banner}->{docfile}, width => $place->{width}, height => $place->{height} );
#						$self->save_info( table => $self->stash->{list_table}, field_values => { width => $w, height => $h});
#					}
#
#				}
#			}
#		}

		if($params{continue}){
			$self->admin_msg_success("Данные сохранены");
			return $self->edit;
		}
		elsif( $self->stash->{group} >= $#{$self->app->program->{groupname}} + 1){
			return $self->info;
		}
		$self->stash->{group}++;
	}

	if($self->stash->{dop_table}){
		$self->restore_doptable;
		return $self->render( json => {
				content	=> $self->has_errors ? "ERROR" : "OK",
				items	=> $self->init_dop_tablelist_reload(),
		});
	}

	return $self->edit;

}

sub info{
	my $self = shift;
	my %params = @_;

	my $table = $self->stash->{list_table};

	if ($self->send_params->{flag_add}) {
		$self->def_context_menu( lkey => 'add_info');
	} else {
		$self->def_context_menu( lkey => 'print_info');
	}

	if($self->stash->{index}){
		$self->getArraySQL(	from 	=> $self->stash->{list_table},
							where	=> "`ID`='".$self->stash->{index}."'",
							stash	=> 'anketa');

		$self->def_list_page if $self->stash->{anketa}->{list_page};
	}

	$self->define_anket_form( access => 'r', table => $table, noget => 1);
}

sub def_list_page{
	my $self = shift;
	my $list_page = $self->stash->{anketa}->{list_page};
	return unless $list_page;

	my $labels = {};
	my $list = {};
	my @list_page = ();

	$list_page =~ s/\r//g;
	foreach my $lp (split(/\n/, $list_page)) {
		my $name_select = '';
		if ($lp) {
			push(@list_page, $lp);
			my ($l, $r, $id) = split(/:/, $lp);
			if ($r =~ m/\d/ && $r == 0) {
				my $item = $self->dbi->query("SELECT `name` FROM `lst_texts` WHERE `key_razdel`='$l' LIMIT 0,1")->hash;
				$name_select = "Раздел: ".$$item{name};
			} else {
				my $item = $self->dbi->query("SELECT `name` FROM `texts_${r}_${l}` WHERE `ID`='$id' LIMIT 0,1")->hash;
				$name_select = "Страница ($l): ".$$item{name};
			}
			$labels->{$lp} = $name_select;
			$list->{$lp} = $name_select;
		}
	}
	$self->lkey(name => 'list_page')->{list} = $list;
	$self->_def_list_labels($self->lkey(name => 'list_page'));

	$self->stash->{anketa}->{list_page} = join("=", @list_page);
}

sub edit{
	my $self = shift;
	my %params = @_;

	$self->def_context_menu( lkey => 'edit_info');

	if($self->stash->{dop_table}){
		$self->backup_doptable();
	}

	if($self->stash->{index}){
		$self->getArraySQL(	from 	=> $self->stash->{list_table},
							where	=> "`ID`='".$self->stash->{index}."'",
							stash	=> 'anketa');

		$self->def_list_page if $self->stash->{anketa}->{list_page};

		if($self->stash->{group} == 2 &&
			$self->stash->{anketa}->{id_advert_block} &&
			!$self->stash->{anketa}->{width} &&
			!$self->stash->{anketa}->{height}
			){
			my @placesIds = split('=', $self->stash->{anketa}->{id_advert_block});
			my $place = $self->dbi->query("SELECT * FROM `data_banner_advert_block` WHERE `ID`='".$placesIds[0]."' AND `width`!='' AND `height`!=''")->hash;

			$self->stash->{anketa}->{width} = $place->{width};
			$self->stash->{anketa}->{height} = $place->{height};
		}
	}


	$self->define_anket_form( access => 'w', noget => 1);
}

sub list_container{
	my $self = shift;
	my %params = @_;

	$self->delete_list_items if $self->stash->{delete};
	$self->hide_list_items( lfield => 'view') 		if $self->param('hide');
	$self->show_list_items( lfield => 'view') 		if $self->param('show');

	$self->stash->{enter} = 1 if $params{enter};

	my $list_table = $self->stash->{list_table};

	if($list_table eq 'data_banner'){
		$self->stash->{win_name} = "Список баннеров";
		$self->def_context_menu( lkey => 'table_list');

	} elsif($list_table eq 'data_banner_advert_block'){
		$self->stash->{win_name} = "Рекламные места";
		$self->def_context_menu( lkey => 'table_list_view');

	} elsif($list_table eq 'data_banner_advert_users'){
		$self->stash->{win_name} = "Рекламодатели";
		$self->def_context_menu( lkey => 'table_list');

	}

	$self->stash->{listfield_groups_buttons} = {delete => "удалить", show => 'публиковать', hide => 'скрыть'};

	return $self->list_items(%params, container => 1)
}

sub list_items{
	my $self = shift;
	my %params = @_;

	my $list_table = $self->stash->{list_table};
	$self->render_not_found unless $list_table;

	$self->stash->{listfield_buttons} =  [qw(delete edit print)];

	$params{table} = $list_table;

	$self->define_table_list(%params);
}

1;
