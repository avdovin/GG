package GG::Admin::Texts;

use utf8;

use Mojo::Base 'GG::Admin::AdminController';

sub _init{
	my $self = shift;

	$self->def_program('texts');

	$self->get_keys(controller => $self->app->program->{key_razdel});

	my $config = {
		controller_name	=> $self->app->program->{name},
		#controller		=> 'keys',
	};

	$self->stash->{txt_razdel} 	= 'lst_texts';

	my $access_where = $self->def_access_where( base => $self->stash->{txt_razdel}, show_empty => 0);

	if($self->param('list_table')){
		my (undef, $kr, $lng) = split(/_/, $self->param('list_table'));
		$self->stash->{key_razdel} = $kr;
		#$self->sysuser->save_settings( lang => $lng );
		$self->getArraySQL(	select	=> '`ID` AS `razdel`,`name` AS `name_razdel`',
							from 	=> $self->stash->{txt_razdel},
							where	=> "`key_razdel`='$kr' $access_where",
							stash	=> '',
						);
	}

	if(!$self->sysuser->settings->{'texts_razdel'}){
		$self->getArraySQL(	select	=> 	'`ID` AS `razdel`,`key_razdel`,`name` AS `name_razdel`',
							from	=>	$self->stash->{txt_razdel},
							where	=> 	"`".$self->sysuser->settings->{'lang'}."`='1' $access_where",
							stash	=> 	'');

		$self->sysuser->save_settings(texts_razdel => $self->stash->{razdel});
	}


	unless($self->send_params->{replaceme}){
		$self->send_params->{replaceme} = $self->stash->{controller};
		$self->stash->{replaceme} = $self->send_params->{replaceme} .= '_'.$self->stash->{list_table} if $self->stash->{list_table};
	}

	if($self->send_params->{razdel} and $self->param('do') ne 'chrazdel'){
		$self->changeRazdel;
	}

	$self->stash->{razdel} ||= $self->sysuser->settings->{'texts_razdel'};

	if(!$self->stash->{key_razdel} && !$self->getArraySQL(	select	=> 	'`ID` AS `razdel`,`key_razdel`,`name` AS `name_razdel`',
															from	=>	$self->stash->{txt_razdel},
															where	=> 	"`ID`='".$self->stash->{razdel}."' AND `".$self->sysuser->settings->{'lang'}."`='1' $access_where",
															sys		=> 1,
															stash	=> 	'')){

		unless($self->getArraySQL(	select	=> 	'`ID` AS `razdel`,`key_razdel`,`name` AS `name_razdel`',
									from	=>	$self->stash->{txt_razdel},
									where	=> 	"`".$self->sysuser->settings->{'lang'}."`='1' $access_where",
									sys		=> 1,
									stash	=> 	'')){
			$self->admin_msg_errors("Доступных данных нет");
		}
	}

	$self->stash->{win_name} = $self->stash->{name_razdel};
	$self->app->lkeys->{texts}->{razdel}->{settings}->{where} = " AND `".$self->sysuser->settings->{'lang'}."`='1' ";

	$self->stash->{list_table} = 'texts_'.$self->stash->{key_razdel}.'_'.$self->sysuser->settings->{'lang'};

	$self->stash($_, $config->{$_}) foreach (keys %$config);

	$self->stash->{index} ||= $self->send_params->{index};
	$self->stash->{group} ||= $self->send_params->{group} || 1;

	$self->stash->{list_table} = "texts_".$self->stash->{key_razdel}."_".$self->sysuser->settings->{'lang'};

	foreach ( qw(list_table replaceme)){
		$self->param_default($_ => $self->send_params->{$_} ) if $self->send_params->{$_};
	}

	$self->stash->{replaceme} = $self->send_params->{replaceme};
	$self->stash->{lkey} = $self->stash->{controller};
	$self->stash->{lkey} .= '_'. $self->send_params->{list_table} if $self->send_params->{list_table};
	$self->stash->{script_link} = '/admin/'.$self->stash->{controller}.'/body';

	#$self->stash->{dir_field} = ($self->sysuser->settings->{'lang'} ne "ru") ? "texts_".$self->stash->{key_razdel}."_".$self->sysuser->settings->{'lang'} : "texts_".$self->stash->{key_razdel};
	$self->stash->{dir_field} = "texts_".$self->stash->{key_razdel}."_".$self->sysuser->settings->{'lang'};

	#Groupname
	my $kr = $self->stash->{key_razdel};
	$self->app->program->{groupname} = $self->app->program->{settings}->{'groupname_'.$kr} if($kr && $self->app->program->{settings}->{'groupname_'.$kr});

	# init vars
	#$self->stash->{folder} 		= '/image/texts/';
	#$self->stash->{docfolder} 	= '/docfiles/';
}

sub body{
	my $self = shift;

	$self->_init;

	my $do = $self->param('do');

	given ($do){

		when('list_container') 			{ $self->list_container; }

		# Доп действия для texts
		when('text') 					{ $self->stash->{group} = 2; $self->edit; }
		when('link') 					{ $self->render('/Admin/getlink'); }
		when(/list(s)?_select/) 		{ $self->lists_select; }

		when('upload') 					{

			if(my $item = $self->getArraySQL(	from => $self->stash->{list_table}, where => "`ID`='".$self->stash->{index}."'") ){
				my $lfield = $self->param('lfield');
				my $folder = $self->lkey(name => $lfield, controller => 'texts', setting => 'folder');

				return $self->file_download( path => $folder.$item->{ $lfield });

			}
			return $self->render_not_found;
		}

		default							{
			$self->default_actions($do);
		}

	}

}

sub changeRazdel{
	my $self = shift;

	$self->sysuser->save_ses_settings(texts_razdel => $self->send_params->{razdel});
	$self->sysuser->save_ses_settings($self->stash->{replaceme}.'_sfield' => 'ID');

	#$self->sysuser->save_settings(texts_razdel => $self->send_params->{razdel});
	#$self->sysuser->save_settings($self->stash->{replaceme}.'_sfield' => 'ID');
	$self->stash->{razdel} = $self->send_params->{razdel};
}

sub lists_select{
	my $self = shift;

	my $menu = "obj.options[obj.options.length] = new Option('-----', '0');";
	my ($where, $from);
	my $select = "`ID`,`name`";
	my (%keys);

	if($self->stash->{keystring}){

		$where 	= "`ID` > 0 AND `name` LIKE '%".$self->stash->{keystring}."%' ";
		$from	= $self->stash->{list_table};
		$keys{$_} = 1 foreach ($self->dbi->getKeysSQL(from => $from));
		$select .= ",`alias` " if($keys{alias});
		$where  .= " AND `link` = ''" if($keys{link});
		$select .= ",`docfile`,`folder`" if($keys{docfile});
	}

	my $sch = 0;
	my $tmp = "";
	for my $item ($self->getHashSQL(	select	=> $select,
										from 	=> $from,
										where 	=> $where." ORDER BY `name`",
										)){
		if($self->stash->{keystring}){
			my $name = $item->{name};
			$name 	=~ s/'//g;
			$name 	=~ s/&laquo;/"/;
			$name 	=~ s/&raquo;/"/;
			my $val = "";
			$val 	= $self->url_for('text', alias => $item->{alias}) if $keys{alias};
			$val 	= $item->{folder}.$item->{docfile} if $keys{docfile};
			$tmp 	.= "obj.options[obj.options.length] = new Option('$name', '$val');";
		}

		$sch++;
	}
	$menu .= "document.getElementById('ok_' + out).innerHTML = \"<span style='background-color:lightgreen;width:45px;padding:3px'>найдено: $sch</span>\";\n";
	$menu .= $tmp;
	$self->render( text => $menu );
#

}

sub tree{
	my $self = shift;

	my $controller = $self->stash->{controller};
	my $table = $self->stash->{list_table};
	my $access_table = $self->sysuser->access->{table};

	$self->stash->{param_default} .= "&first_flag=1";

	$self->param_default('replaceme' => '');

	my $lang = $self->sysuser->settings->{'lang'};

	my $folders = $self->getHashSQL(	from 	=> $self->stash->{txt_razdel},
										where 	=> "`$lang`='1'",
										sys 	=> 1,
										) || [];

	my @tmp = ();
	foreach (@$folders){
		#$folders->[$i]->{replaceme} = $controller.$table;#$folders->[$i]->{ID};
		my $table = "texts_".$_->{key_razdel}."_$lang";

		push @tmp, {
				ID 			=> $controller.$_->{ID},
				name 		=> $_->{name},
				param_default => "&list_table=".$table."&first_flag=1&lang=$lang",
				replaceme	=> 'replaceme',##$controller.$table,
				tabname		=> $table,
				click_type  => 'list_filtered_clear',
				params 		=> {
					razdel 	=> $_->{ID}
				},
		} if $access_table->{$table}->{r};

	}

	$self->render( folders => \@tmp, items => [], template => 'Admin/tree_block');
}

sub tree_block{
	my $self = shift;

	my $items = [];
	my $index = $self->stash->{index};
	my $controller = $self->stash->{controller};
	my $table = $self->stash->{list_table};

	my ($tmp, $kr, $lang) = split(/_/, $table);
	my $key_razdel = $tmp."_".$kr."_$lang";

	my $existFields = {
		'dir' 		=> $self->dbi->exists_keys(from => $table, lkey => "dir") ? 1 : 0,
		$key_razdel => $self->dbi->exists_keys(from => $table, lkey => $key_razdel) ? 1 : 0,
		'tdate'		=> $self->dbi->exists_keys(from => $table, lkey => "tdate") ? 1 : 0,
	};

	$self->param_default('replaceme' => '');
	$self->param_default('list_table' => '');
	my $stash = $self->stash;

	if ($existFields->{tdate}) {
		$stash->{date_flag} = 1;
		$stash->{pid} = defined $stash->{pid} ? $stash->{index} : 0;

		if($existFields->{'dir'}){
			$stash->{count} = $self->dbi->getCountCol( from => $table, where => "`dir`='0' AND `$key_razdel`='".$stash->{pid}."'");
			$stash->{count_dir} = $self->dbi->getCountCol( from => $table, where => "`dir`='1' AND `$key_razdel`='".$stash->{pid}."'");
		}
	}

	if (!$stash->{count_dir} and $existFields->{tdate} ){
		my $where  = "";
		my $select = "";
		my $param_default = "";

		my $send_params = $self->send_params;
		if (!$send_params->{year} and !$send_params->{month} and !$send_params->{day}) {
		   $where .= " GROUP BY YEAR(`tdate`)";
		   $select = ",YEAR(`tdate`) AS `name`";

		} elsif ($send_params->{year} and !$send_params->{month} and !$send_params->{day}) {
		   $where .= " AND YEAR(`tdate`)='".$send_params->{year}."' GROUP BY MONTH(`tdate`)";
		   $select = ",MONTH(`tdate`) AS `name`";

		} elsif ($send_params->{year} and $send_params->{month} and !$send_params->{day}) {
		   $where .= " AND YEAR(`tdate`)='".$send_params->{year}."' AND MONTH(`tdate`)='".$send_params->{month}."' GROUP BY DAY(`tdate`)";
		   $select = ",DAY(`tdate`) AS `name`";

		} elsif ($send_params->{year} and $send_params->{month} and $send_params->{day}) {
		   $where .= " AND YEAR(`tdate`)='".$send_params->{year}."' AND MONTH(`tdate`)='".$send_params->{month}."' AND DAY(`tdate`)='".$send_params->{day}."' ";

		}

		my %month = (1 => "Январь", 2 => "Февраль", 3 => "Март", 4 => "Апрель", 5 => "Май", 6 => "Июнь", 7 => "Июль", 8 => "Август", 9 => "Сентябрь", 10 => "Октябрь", 11 => "Ноябрь", 12 => "Декабрь");

		if(	$self->sysuser->access->{table}->{$table}->{r} &&
			$self->getHashSQL(	select	=> "`ID`,`name`".($existFields->{'dir'} ? ',`dir`' : '')." $select",
								from 	=> $table,
								where 	=> "`tdate`!='0000-00-00' ".($existFields->{$key_razdel} ? "AND `$key_razdel`='".$stash->{pid}."'" : "" )." $where ORDER BY `ID`",
								stash	=> "items") ){
			$items = $stash->{items};
			foreach my $i (0..$#$items){
				my $item = $items->[$i];

				$items->[$i]->{flag_plus} = 1;
				$items->[$i]->{icon} = 'folder';
				$items->[$i]->{replaceme} = $controller;
				$items->[$i]->{click_type} = 'list';

				if (!$send_params->{year} and !$send_params->{month} and !$send_params->{day}) {
					$param_default = "&year=$$item{name}";
					$items->[$i]->{params} = {
						tdate 	=> sprintf( "%04d-%02d-%02d", $item->{name}),
						razdel 			=> $self->stash->{razdel},
					};

				} elsif ($send_params->{year} and !$send_params->{month} and !$send_params->{day}) {
					$param_default = "&year=".$send_params->{year}."&month=$$item{name}";
					$items->[$i]->{params} = {
						tdate 	=> sprintf( "%04d-%02d-%02d", $send_params->{year}, , $$item{name}, '00'),
						razdel 			=> $self->stash->{razdel},
					};

				} elsif ($send_params->{year} and $send_params->{month} and !$send_params->{day}) {
					$param_default = "&year=".$send_params->{year}."&month=".$send_params->{month}."&day=$$item{name}";
					$items->[$i]->{params} = {
						tdate 	=> sprintf( "%04d-%02d-%02d", $send_params->{year}, , $send_params->{month}, $$item{name}),
						razdel 			=> $self->stash->{razdel},
					};

				} elsif ($send_params->{year} and $send_params->{month} and $send_params->{day}) {
					$param_default = "&year=".$send_params->{year}."&month=".$send_params->{month}."&day=".$send_params->{day};

					$items->[$i]->{click_type} 	= 'text';
					$items->[$i]->{flag_plus} 	= 0;
					$items->[$i]->{icon} 		= "doc";
					$items->[$i]->{replaceme} 	= $controller.'_'.$table.$item->{ID};

				}

				$items->[$i]->{key_element} 	= $table;
				$items->[$i]->{param_default}	= "&list_table=$table&pid=".$stash->{pid}.$param_default."&replaceme=".$items->[$i]->{replaceme};

				if ($send_params->{year} and !$send_params->{month} and !$send_params->{day}) {
					$items->[$i]->{name} = $month{ $items->[$i]->{name} };
				}
				$items->[$i]->{name} 	  =~ s/["']+//g;

			}
		}

	} else {
		my $dir  = "";
		my $index_folder = "";
		my $sort = "";
		$self->stash->{click_type} = "text";

		if ($existFields->{'dir'}) {
			$dir = ",`dir`";
		}
		if ($existFields->{$key_razdel}) {
			$index_folder = "AND `$key_razdel`='$index'";
		}
		$sort = $self->dbi->exists_keys(from => $table, lkey => "rating") ? "rating" : "name";

		if ($self->sysuser->access->{table}->{$table}->{r} &&
			$self->getHashSQL(	select	=> "`ID`,`name`".$dir,
								from 	=> $table,
								where 	=> "1 $index_folder ORDER BY `$sort`",
								stash	=> "items") ){

			$items = $stash->{items};
			foreach my $i (0..$#$items){
				my $item = $items->[$i];

				$items->[$i]->{key_element} 	= $table;
				$items->[$i]->{tabname} 	  	= $table.$item->{ID};
				$items->[$i]->{replaceme} 		= $controller.'_'.$table.$item->{ID};
				$items->[$i]->{param_default}	= "&list_table=$table&replaceme=".$items->[$i]->{replaceme};

				if ($item->{dir}) {
					$items->[$i]->{flag_plus} = 1;
				} elsif (!$dir and $index_folder) {
					my $count = $self->dbi->getCountCol( from => $table, where => "`$key_razdel`='".$item->{ID}."'");

					if ($count) {
						$items->[$i]->{flag_plus} = 1;
						$items->[$i]->{replaceme} = $controller;
						$items->[$i]->{click_type} = 'list';
						$items->[$i]->{params} = {
							$key_razdel 	=> $items->[$i]->{ID},
							razdel 			=> $self->stash->{razdel},
						};
					} else {
						$items->[$i]->{flag_plus} = 0;
						$items->[$i]->{icon} = "doc";
					}

				} else {
					$items->[$i]->{icon} = "doc";
				}

				$items->[$i]->{name} 	  =~ s/["']+//g;
				$items->[$i]->{tabname} =~ s/["']+//g;
		    }
		}
	}

	$self->render( json => {
					content	=> $self->render_to_string( items => $items, template => 'Admin/tree_elements'),
					items	=> [{
							type	=> 'eval',
							value	=> "treeObj['".$controller."'].initTree();"
					}]
	});

}

sub delete{
	my $self = shift;

	my $index = $self->stash->{index};
	my $table = $self->stash->{list_table};
	if ($self->getArraySQL( from => $table, where => $index, stash => 'anketa')) {

		my $dir_field = $self->stash->{dir_field};

		if($self->dbi->exists_keys(table => $self->stash->{list_table}, lkey => $dir_field)){
			if($self->dbi->query("SELECT `ID` FROM `$table` WHERE `$dir_field`='$index'")->hash){
				$self->admin_msg_errors('Удалить нельзя: в папке есть документы');
				return $self->edit();
			}
		}

		if($self->dbi->exists_keys(table => $self->stash->{list_table}, lkey => 'delnot') && ( $self->stash->{anketa}->{delnot} || $self->dbi->query("SELECT `ID` FROM `$table` WHERE `ID`='$index' AND `delnot`='1'")->hash ) ){
			$self->admin_msg_errors('Удалить нельзя: системная запись');
			return $self->edit();
		}



		if($self->delete_info( from => $table, where => $index )){

			# if($self->stash->{anketa}->{pict}){
			# 	$self->file_delete_pict(index => $index, lfield => 'pict', pict => $self->stash->{anketa}->{pict});
			# }

			# if($self->stash->{anketa}->{docfile}){
			# 	eval{
			# 		unlink ($ENV{DOCUMENT_ROOT}.$self->stash->{anketa}->{folder}.$self->stash->{anketa}->{docfile});
			# 	};
			# 	warn $@ if $@;
			# }

			$self->stash->{tree_reload} = 1;

			$self->save_logs( 	name 	=> 'Удаление записи из таблицы '.$table,
								comment	=> "Удалена запись из таблицы [$index] «".$self->stash->{anketa}->{name}."» . Таблица ".$self->stash->{list_table});

			$self->define_anket_form( noget => 1, access => 'd', table =>$table);

		}

	} else {

	$self->save_logs( 	name 	=> 'Попытка удаления записи из таблицы '.$table,
						comment	=> "Неудачная попытка удаления записи из таблицы [$index]. Таблица ".$table.".\n ".$self->msg_no_wrap);

	$self->block_null;
	}

}

sub save{
	my $self = shift;
	my %params = @_;

	$self->stash->{index} = 0 if $params{restore};

	$self->send_params->{size} = 0 if($self->send_params->{docfile} && !$self->stash->{index});

	# проверяем что данный модуль уже не выбран на других страницах сайта
	if(my $url_for = $self->send_params->{url_for}){
		if (my $item = $self->dbi->query("SELECT `ID`, `name` FROM `".$self->stash->{list_table}."` WHERE `url_for`='$url_for' ".($self->stash->{index} ? ' AND `ID`!='.$self->stash->{index} : '') )->hash){
			$self->admin_msg_errors("Данный модуль уже используется на странице - $item->{name} # $item->{ID}");
			$self->edit;
		}
	}

	if( $self->save_info( table => $self->stash->{list_table}) ){
		# $self->file_save_pict( 	filename 	=> $self->send_params->{pict},
		# 						lfield		=> 'pict',
		# 						) if $self->send_params->{pict};

		# if($self->send_params->{docfile}){
		# 	my $docfile = $self->send_params->{docfile};

		# 	my (undef, $docfile_saved, $type_file) = $self->file_save_from_tmp( filename => $self->send_params->{docfile}, lfield => 'docfile' );

		# 	my $folder = $self->lkey(name => 'docfile', controller => 'texts', setting => 'folder');
		# 	my $size = -s $self->static_path.$folder.$docfile_saved || 0;

		# 	$self->save_info(send_params => 0, table => $self->stash->{list_table}, field_values => {size => $size, docfile => $docfile_saved} );
		# }

		if($params{restore}){
			$self->stash->{tree_reload} = 1;
			$self->save_logs( 	name 	=> 'Восстановление записи в таблице '.$self->stash->{list_table},
								comment	=> "Восстановлена запись в таблице [".$self->stash->{index}."]. Таблица ".$self->stash->{list_table}.". ".$self->msg_no_wrap);
			return $self->info;
		}

		if($params{continue}){
			$self->admin_msg_success("Данные сохранены");
			return $self->edit;
		}
		elsif( $self->stash->{group} >= $#{$self->app->program->{groupname}} + 1){
			return $self->info;
		}
		$self->stash->{group}++;
	}

	return $self->edit;
}

sub info{
	my $self = shift;
	my %params = @_;

	my $table = $self->stash->{list_table};

	if ($self->send_params->{flag_add}) {
		$self->def_context_menu( lkey => 'add_info');

	} elsif(scalar(@{$self->app->program->{groupname}}) == 2){
		$self->def_context_menu( lkey => 'print_info_text');

	} else {
		$self->def_context_menu( lkey => 'print_info');
	}
	$self->define_anket_form( access => 'r', table => $table);
}

sub edit{
	my $self = shift;
	my %params = @_;

	$self->def_context_menu( lkey => 'edit_info');

	# Создание папки
	if($params{dir}){
		$self->stash->{page_name} = "Создание новой папки в разделе «".$self->stash->{name_razdel}."»";
		$self->param_default('dir' => $self->stash->{anketa}->{dir} = 1 );
	}

	$self->define_anket_form( access => 'w');
}

sub delete_list_items{
	my $self = shift;
	my %params = (
		table => $self->stash->{list_table},
		@_,
	);

	my $table = delete $params{table};
	my $dir_field = $self->stash->{dir_field};
	my $list_items = $self->stash->{listindex} || return;
	foreach my $id (split(/,/, $list_items)) {
		next unless $id;

		my $no_del = 0;
		if (my $item = $self->getArraySQL(from => $table, where => $id, sys => 1)) {
			if($item && $item->{dir} && $self->dbi->exists_keys(from => $table, lkey => $dir_field)){
				if($self->getArraySQL(from => $table, where => "`$dir_field`='$id'", sys => 1)){
					$no_del = 1;
				}
			}

			if(!$no_del && $self->delete_info( from => $table, where => $id )){
				# if($item->{pict}){
				# 	$self->file_delete_pict(index => $id, lfield => 'pict', folder =>  $item->{folder}, pict => $item->{pict});
				# }

				# if($item->{docfile}){
				# 	eval{
				# 		unlink($ENV{DOCUMENT_ROOT}.$item->{folder}.$item->{docfile});
				# 	};
				# 	warn $@ if $@;
				# }
				$self->stash->{tree_reload} = 1;

				$self->save_logs( 	name 	=> 'Удаление записи из таблицы '.$table,
									comment	=> "Удалена запись из таблицы [".$id."]. Таблица ".$table);
			}
		}

	}
}

sub list_container{
	my $self = shift;
	my %params = @_;

	$self->changeRazdel if $self->param('razdel');

	$self->delete_list_items if $self->stash->{delete};
	$self->hide_list_items( lfield => 'viewtext') 		if $self->param('hide');
	$self->show_list_items( lfield => 'viewtext') 		if $self->param('show');

	$self->stash->{enter} = 1 if $params{enter};


	if ($self->dbi->exists_keys( table => $self->stash->{list_table}, lkey => "dir")) {
		$self->def_context_menu( lkey => 'table_list_dir');
	} else {
		$self->def_context_menu( lkey => 'table_list');
	}

	#$self->stash->{win_name} ||= "Раздел: Основные тексты";

	$self->stash->{listfield_groups_buttons} = {delete => "удалить", show => 'публиковать', hide => 'скрыть'};

	return $self->list_items(%params, container => 1)
}

sub list_items{
	my $self = shift;
	my %params = @_;

	my $list_table = $self->stash->{list_table};
	$self->render_not_found unless $list_table;

	if($self->stash->{key_razdel} eq 'main' or $self->stash->{key_razdel} eq 'news'){
		$self->stash->{listfield_buttons} =  [qw(delete edit text print)]

	} elsif($self->stash->{key_razdel} eq 'docfiles'){
		$self->stash->{listfield_buttons} =  [qw(delete edit upload)]

	} else {
		$self->stash->{listfield_buttons} =  [qw(delete edit)]
	}
	$params{table} = $list_table;

	$self->define_table_list(%params);
}

1;
