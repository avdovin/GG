package GG::Admin::Images;

use utf8;

use Mojo::Base 'GG::Admin::AdminController';

sub _init{
	my $self = shift;
	
	$self->def_program('images');
	
	$self->get_keys( type => ['lkey', 'button'], controller => $self->app->program->{key_razdel});
	
	my $config = {
		controller_name	=> $self->app->program->{name},
		#controller		=> 'keys',
	};
	
	$self->stash->{img_razdel} 	= 'lst_images';
	
	my $access_where = $self->def_access_where( base => $self->stash->{img_razdel}, show_empty => 0);
	
	
	if($self->param('list_table')){
		my (undef, $kr) = split(/_/, $self->param('list_table'));
		$self->stash->{key_razdel} = $kr;
		$self->getArraySQL(	select	=> '`ID` AS `razdel`,`name` AS `name_razdel`',
							from 	=> $self->stash->{img_razdel},
							where	=> "`key_razdel`='$kr' $access_where",
							stash	=> '', 
						);	
	}

	if(!$self->sysuser->settings->{'images_razdel'}){
		$self->getArraySQL(	select	=> 	'`ID` AS `razdel`,`key_razdel`,`name` AS `name_razdel`',
							from	=>	$self->stash->{img_razdel},
							where	=> 	"1 $access_where",
							stash	=> 	'');

		$self->sysuser->save_settings(images_razdel => $self->stash->{razdel});
	}
	$self->stash->{razdel} = $self->send_params->{razdel} || $self->sysuser->settings->{'images_razdel'};
	
	if(!$self->stash->{key_razdel} && !$self->getArraySQL(	select	=> 	'`ID` AS `razdel`,`key_razdel`,`name` AS `name_razdel`',
															from	=>	$self->stash->{img_razdel},
															where	=> 	"`ID`='".$self->stash->{razdel}."' $access_where",
															stash	=> 	'')){
		unless($self->getArraySQL(	select	=> 	'`ID` AS `razdel`,`key_razdel`,`name` AS `name_razdel`',
									from	=>	$self->stash->{img_razdel},
									where	=> 	"1 $access_where",
									stash	=> 	'')){
			$self->admin_msg_errors("Доступных данных нет");																	
		}															
	}

	unless($self->send_params->{replaceme}){
		$self->send_params->{replaceme} = $self->stash->{controller};
		$self->stash->{replaceme} = $self->send_params->{replaceme} .= '_'.$self->stash->{list_table} if $self->stash->{list_table};
	}
		
	if($self->send_params->{razdel} and $self->param('do') ne 'chrazdel'){
		$self->changeRazdel;
	}
		
	$self->stash->{win_name} = 'Раздел: '.$self->stash->{name_razdel};
	
	$self->stash->{list_table} = 'images_'.$self->stash->{key_razdel};

	$self->stash($_, $config->{$_}) foreach (keys %$config);
	
	$self->stash->{index} ||= $self->send_params->{index};
	$self->stash->{group} ||= $self->send_params->{group} || 1;
	
	 
	foreach ( qw(list_table replaceme)){
		$self->param_default($_ => $self->send_params->{$_} ) if $self->send_params->{$_};
	}
		
	$self->stash->{replaceme} = $self->send_params->{replaceme};
	$self->stash->{lkey} = $self->stash->{controller};
	$self->stash->{lkey} .= '_'. $self->send_params->{list_table} if $self->send_params->{list_table};
	$self->stash->{script_link} = '/admin/'.$self->stash->{controller}.'/body';
	
	$self->stash->{dir_field} = 'image_'.$self->stash->{key_razdel};
	
	#Groupname
	my $kr = $self->stash->{key_razdel};
	$self->app->program->{groupname} = $self->app->program->{settings}->{'groupname_'.$kr} if($kr && $self->app->program->{settings}->{'groupname_'.$kr});

}

sub body{
	my $self = shift;
	
	$self->_init;
	
	my $do = $self->param('do');

	given ($do){
		
		when('list_container') 			{ $self->list_container; }
		when('enter') 					{ $self->list_container( enter => 1); }
		when('list_items') 				{ $self->list_items; }
		
		when('delete_pict') 			{ $self->field_delete_pict( render => 1, fields => [qw(pict)]); }
		when('field_upload_swf') 		{ $self->field_upload_swf; }
		when('file_upload_tmp') 		{ $self->render( text => $self->file_upload_tmp ); }
		
		when('menu_button') 			{ 
			$self->def_menu_button( 
				key 		=> $self->app->program->{menu_btn_key},
				controller	=> $self->app->program->{key_razdel},
			); 
		}

		when('chrazdel') 				{
			$self->changeRazdel;
		}
		when('chlang') 					{ 
			$self->sysuser->save_settings(lang => $self->stash->{lang});
			$self->sysuser->save_settings($self->stash->{replaceme}.'_sfield' => 'ID');
			$self->list_container; 
		}
		
		# Загрузка архива
		when('zipimport')	 			{ $self->zipimport; }
		when('zipimport_save')	 		{ $self->zipimport_save; }
		when('zipimport_save_pict')	 	{ $self->zipimport_save_pict; }
		
		when('sel_treeblock') 			{ $self->field_select_dir; }
				
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
		when('add_dir') 				{ $self->edit( add => 1, dir => 1); }
		when('edit') 					{ $self->edit; }
		when('info') 					{ $self->info; }
		when('save') 					{ $self->save; }
		when('delete') 					{ $self->delete; }
		when('restore') 				{ $self->save( restore => 1); }

		when('tree') 					{ $self->tree; }
		when('tree_block') 				{ $self->tree_block; }
		when('tree_reload') 			{ $self->tree_block; }
				
		when('restore') 				{ $self->save( restore => 1); }
		
		when('lists_select') 			{ $self->lists_select; }
		
		default							{ $self->render_text("действие не определенно"); }
	}
}

sub changeRazdel{
	my $self = shift;
	
	$self->sysuser->save_settings(images_razdel => $self->send_params->{razdel});
	$self->sysuser->save_settings($self->stash->{replaceme}.'_sfield' => 'ID');
	$self->list_container;	
}

sub zipimport{
	my $self = shift;
	
	$self->param_default('lfield' => 'pict');
	
	my @keys = qw(zip);
	push @keys, $self->stash->{dir_field};
	
	$self->define_anket_form(template => 'anketa_zipimport', access => 'w', render_html => 1, keys => \@keys);	
}

sub zipimport_save{
	my $self = shift;
	
	my $files = $self->file_extract_zip( path => $self->file_tmpdir.$self->send_params->{zip} );

	my $html = $self->render_partial( files => $files, template => 'Admin/Plugins/File/zipimport_img_node');

	$self->render_json({html => $html, count => scalar(@$files)});
}

sub zipimport_save_pict{
	my $self = shift;
	
	my $lfield = $self->send_params->{lfield};
	
	if($self->file_save_pict( 	filename 	=> $self->send_params->{filename},
								lfield		=> $lfield,
	)){
		my $vals = {
			name	=> $self->send_params->{filename},
			viewimg	=> 1,
			rating	=> 99
		};

		$self->save_info(table => $self->stash->{list_table}, field_values => $vals );
	};
	
	my $item = $self->dbi->query("SELECT `pict`,`folder` FROM `".$self->stash->{list_table}."` WHERE `ID`='".$self->stash->{index}."'")->hash;
	
	my $folder = $self->lfield_folder( lfield => $lfield ) || $item->{folder};
	$self->render_json({filename	=> $item->{pict}, src => $folder.$item->{pict} });
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
	$self->render_text($list_out);

	sub def_name_list_select {
		my ($title, $name) = @_;
		
		$name =~ s/&laquo;/"/;
		$name =~ s/&raquo;/"/;
		$name =~ s/["']+//g;
		
		return $title.$name;
	}

}


sub delete{
	my $self = shift;
	
	$self->backup_doptable;
	
	if ($self->getArraySQL( from => $self->stash->{list_table}, where => $self->stash->{index}, stash => 'anketa')) {

		if($self->stash->{dop_table}){
			if($self->delete_info( from => $self->stash->{list_table}, where => $self->stash->{index})){
				$self->restore_doptable;
				return $self->field_dop_table_reload;			
			}
		}
		
		if($self->delete_info( from => $self->stash->{list_table}, where => $self->stash->{index} )){
			
			if($self->stash->{anketa}->{pict}){
				$self->file_delete_pict(lfield => 'pict', folder =>  $self->stash->{anketa}->{folder}, pict => $self->stash->{anketa}->{pict});
			}
			
			# Удаление статистика к банeру
			$self->dbi->query("DELETE FROM `dtbl_banner_stat` WHERE `id_banner`='".$self->stash->{index}."'");
			$self->dbi->query("OPTIMIZE TABLE `dtbl_banner_stat`");
			
			$self->stash->{tree_reload} = 1;
	
			$self->save_logs( 	name 	=> 'Удаление записи из таблицы '.$self->stash->{list_table},
								comment	=> "Удалена запись из таблицы [".$self->stash->{index}."]. Таблица ".$self->stash->{list_table});
			
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
	
	my $table = $self->stash->{list_table};
	
	$self->backup_doptable;
				
	$self->stash->{index} = 0 if $params{restore};
	
	if($self->save_info( table => $self->stash->{list_table})){
		
		if($params{restore}){
			$self->stash->{tree_reload} = 1;
			$self->save_logs( 	name 	=> 'Восстановление записи в таблице '.$self->stash->{list_table},
								comment	=> "Восстановлена запись в таблице [".$self->stash->{index}."]. Таблица ".$self->stash->{list_table}.". ".$self->msg_no_wrap);
			return $self->info;			
		}

		$self->file_save_pict( 	filename 	=> $self->send_params->{pict},
								lfield		=> 'pict',
								fields		=> {pict => 'pict'},
								) if $self->send_params->{pict};

		
		if($params{restore}){
			$self->stash->{tree_reload} = 1;
			$self->save_logs( 	name 	=> 'Восстановление записи в таблице '.$self->stash->{list_table},
								comment	=> "Восстановлена запись в таблице [".$self->stash->{index}."]. Таблица ".$self->stash->{list_table}.". ".$self->msg_no_wrap);
			return $self->info;			
		}
												
		if($self->stash->{group} >= $#{$self->app->program->{groupname}} + 1){
			return $self->info;
		}
		$self->stash->{group}++;
	} 
	
	if($self->stash->{dop_table}){
		$self->restore_doptable;
		return $self->render_json({
				content	=> "OK",
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
	}
	
	$self->define_anket_form( access => 'r', table => $table, noget => 1);	
}

sub edit{
	my $self = shift;
	my %params = @_;
	
	$self->def_context_menu( lkey => 'edit_info');

	# Создание папки
	if($params{dir}){
		$self->stash->{page_name} = "Создание новой папки в разделе «".$self->stash->{name_razdel}."»";
		$self->stash->{anketa}->{dir} = 1;
	}
		
	if($self->stash->{dop_table}){
		$self->backup_doptable();
	}

	if($self->stash->{index}){
		$self->getArraySQL(	from 	=> $self->stash->{list_table},
							where	=> "`ID`='".$self->stash->{index}."'",
							stash	=> 'anketa');	
		
	}
	

	$self->define_anket_form( access => 'w', noget => 1);
}

sub list_container{
	my $self = shift;
	my %params = @_;
	
	$self->delete_list_items(has_pict => 1) if $self->stash->{delete};
	
	$self->stash->{enter} = 1 if ($params{enter});
	
	if ($self->dbi->exists_keys( table => $self->stash->{list_table}, lkey => "dir")) {
		$self->def_context_menu( lkey => 'table_list_dir');
	} else {
		$self->def_context_menu( lkey => 'table_list');
	}
	
	$self->stash->{listfield_groups_buttons} = {delete => "удалить"};
		
	return $self->list_items(%params, container => 1)
}

sub list_items{
	my $self = shift;
	my %params = @_;
	
	my $list_table = $self->stash->{list_table};
	$self->render_not_found unless $list_table;
			
	$params{table} = $list_table;

	$self->define_table_list(%params);
}

sub tree{
	my $self = shift;
	
	my $controller = $self->stash->{controller};
	my $table = $self->stash->{list_table};
	
	$self->stash->{param_default} .= "&first_flag=1";
	
	$self->param_default('replaceme' => '');
	
	my $folders = $self->getHashSQL(	from 	=> $self->stash->{img_razdel}, 
										sys 	=> 1,
										where 	=> "1 ".$self->stash->{access_where}, 
										) || [];

	my @tmp = ();
	foreach (@$folders){
		#$folders->[$i]->{replaceme} = $controller.$table;#$folders->[$i]->{ID};
		my $table = "images_".$_->{key_razdel};
		
		push @tmp, {
				ID => $controller.$_->{ID}, 
				name => $_->{name},
				param_default => "&list_table=".$table."&first_flag=1",
				replaceme	=> $controller.$table,
				tabname		=> $table,
		} if $self->sysuser->access->{table}->{$table}->{r};
	}

	$self->render( folders => \@tmp, items => [], template => 'Admin/tree_block');
}

sub tree_block{
	my $self = shift;
	
	my $items = [];
	my $index = $self->stash->{index};
	my $controller = $self->stash->{controller};
	my $table = $self->stash->{list_table};
	
	$self->param_default('replaceme' => '');
	
	if($self->sysuser->access->{table}->{$table}->{r}){
		$items = $self->getHashSQL(	select	=> "`ID`,`name`,`dir`,`type_file`",
									from 	=> $table, 
									where 	=> "`".$self->stash->{dir_field}."`='$index' "
									) || [];
			
		foreach my $i (0..$#$items){
			my $item = $items->[$i];
			if ($item->{dir}) {
				$items->[$i]->{flag_plus} = 1;
			} elsif($item->{type_file}){
				$items->[$i]->{icon} = $items->[$i]->{type_file};
			} else {
				$items->[$i]->{type_file} = 'image';
			}

			$items->[$i]->{key_element} 	= $table;
			$items->[$i]->{tabname} 	  	= $table.$item->{ID};
			$items->[$i]->{replaceme} = $controller.'_'.$table.$items->[$i]->{ID};
			$items->[$i]->{param_default} = "&list_table=$table&replaceme=".$items->[$i]->{replaceme}; 
		}	
	}
	
	$self->render_json({
					content	=> $self->render_partial( items => $items, template => 'Admin/tree_elements'),
					items	=> [{
							type	=> 'eval',
							value	=> "treeObj['".$self->stash->{controller}."'].initTree();"
					},
					]
				});	
	
}

1;
