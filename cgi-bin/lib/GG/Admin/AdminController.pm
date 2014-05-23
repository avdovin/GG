package GG::Admin::AdminController;

use utf8;

use Mojo::Base 'GG::Controller';

sub sysuser{ shift->app->sysuser }

sub is_sys_auth {shift->app->sysuser->auth}

sub render_not_auth {shift->redirect_to('login_form');}

sub render_forbidden { shift->render('forbidden', status => 403) }

sub default_actions{
	my $self = shift;
	my $do = shift;

	given ($do){
		when('list_container') 			{ $self->list_container; }
		when('enter') 					{ $self->list_container( enter => 1); }
		when('list_items') 				{ $self->list_items; }

		when('mainpage') 				{ $self->mainpage; }

		when('add') 					{ $self->edit( add => 1); }
		when('add_dir') 				{ $self->edit( add => 1, dir => 1); }
		when('edit') 					{ $self->edit; }
		when('info') 					{ $self->info; }
		when('save') 					{ $self->save; }
		when('save_continue‎')			{ $self->save( continue => 1); }
		when('delete') 					{ $self->delete; }
		when('restore') 				{ $self->save( restore => 1); }

		when('menu_button') 			{
			$self->def_menu_button(
				key 		=> $self->app->program->{menu_btn_key},
				controller	=> $self->app->program->{key_razdel},
			);
		}

		when('copy') 					{ $self->item_copy; }

		when('tree') 					{ $self->tree; }
		when('tree_block') 				{ $self->tree_block; }
		when('tree_reload') 			{ $self->tree_block; }

		when('lists_select') 			{ $self->lists_select; }

		when('sel_treeblock') 			{ $self->field_select_dir; }

		when('quick_view') 				{ $self->quick_view; }

		when('filter_take') 			{ $self->filter_take( render => 1); }
		when('filter') 					{ $self->filter_form; }
		when('filter_save') 			{ $self->filter_save; }
		when('filter_clear') 			{ $self->filter_clear();  $self->list_container(); }

		when('set_qedit') 				{ $self->set_qedit; }
		when('set_qedit_i') 			{ $self->set_qedit(info => 1); }
		when('save_qedit') 				{ $self->save_qedit; }
		when('save_qedit_i') 			{ $self->save_qedit; }

		when('delete_file') 			{ $self->field_delete_file( lfield => 'docfile'); }
		when('delete_pict') 			{ $self->field_delete_pict; }
		when('field_upload_swf') 		{ $self->field_upload_swf; }
		when('file_upload_tmp') 		{ $self->render( text => $self->file_upload_tmp ); }

		# Загрузка архива
		when('zipimport')	 			{ $self->zipimport; }
		when('zipimport_save')	 		{ $self->zipimport_save; }
		when('zipimport_save_pict')	 	{ $self->zipimport_save_pict; }

		when('print') 					{ $self->print_choose; }
		when('print_anketa') 			{
			$self->print_anketa(
				title 	=> "Раздел «".$self->stash->{name_razdel}."»",
			);
		}

		default							{ $self->render( text => "действие не определенно"); }

	}
}

sub item_copy{
	my $self = shift;

	unless(
			$self->getArraySQL(
				from 	=> $self->stash->{list_table},
				where	=> "`ID`='".$self->stash->{index}."'",
				stash	=> 'anketa'
			)
		){
		$self->admin_msg_errors("Перед созданием копии необходимо сохранить текущий объект");

		return $self->edit;
	}
	my $index = delete $self->stash->{'index'};

	my $anketa = delete $self->stash->{anketa};
	foreach ( qw(ID rdate edate alias active viewtext viewimg) ){
		delete $anketa->{$_};
	}

	$self->send_params({});
	foreach my $f (keys %$anketa){
		my $lkeyType = $self->lkey(name => $f, controller => $self->stash->{'controller'}, setting => 'type');

		if($f eq 'name'){

			$self->send_params->{$f} = $anketa->{$f}.' копия';
			$self->send_params->{'alias'} = $self->transliteration( $self->send_params->{$f} );

		}
		elsif($lkeyType eq 'pict'){

			my $lkeyFolder = $self->lkey(name => $f, controller => $self->stash->{'controller'}, setting => 'folder');
			my $folder = $self->static_path.$lkeyFolder;

			# пропускаем если вдруг нет файла
			next unless -f $folder.$anketa->{$f};

			my $filetmp = $self->file_copy_tmp($folder.$anketa->{$f});

			$self->send_params->{$f} = $self->file_save_pict(
				filename 	=> $filetmp,
				lfield		=> $f,
				fields		=> {pict => $f},
			);

		}
		elsif($lkeyType ne 'table' && $lkeyType ne 'file' && $lkeyType ne 'filename'){

			$self->send_params->{$f} = $anketa->{$f};
		}
	}

	$self->stash->{group} = 1;

	if( $self->save_info( table => $self->stash->{list_table}) ){
		my $copiedIndex = $self->stash->{'index'};

		foreach my $f (keys %$anketa){
			next if($f eq 's' or $f eq 'd');

			my $lkeyType = $self->lkey(name => $f, controller => $self->stash->{'controller'}, setting => 'type');

			if($lkeyType eq 'table'){
				my $dopTable = $self->lkey(name => $f, controller => $self->stash->{'controller'}, setting => 'table');
				my $svf_field = $self->lkey(name => $f, controller => $self->stash->{'controller'}, setting => 'table_svf');

				for my $dopItems ($self->dbi->query("SELECT * FROM `$dopTable` WHERE `$svf_field`='$index'")->hashes){
					delete $dopItems->{ID};
					$dopItems->{ $svf_field } = $copiedIndex;

					foreach my $dopF (keys %$dopItems){
						my $dlkeyType = $self->lkey(name => $dopF, controller => $self->stash->{'controller'}, setting => 'type');
						next if ($dlkeyType ne 'pict');

						my $lkeyFolder = $self->lkey(name => $dopF, controller => $self->stash->{'controller'}, tbl => $dopTable, setting => 'folder');
						my $folder = $self->static_path.$lkeyFolder;

						# пропускаем если вдруг нет файла
						next unless -f $folder.$dopItems->{$dopF};

						my $filetmp = $self->file_copy_tmp($folder.$dopItems->{$dopF});

						$dopItems->{ $dopF } = $self->file_save_pict(
							filename 	=> $filetmp,
							lfield		=> $dopF,
							table 		=> $dopTable,
							fields		=> {pict => $dopF},
						);
					}

					$self->dbi->insert_hash($dopTable, $dopItems);
				}
			}

		}

		$self->admin_msg_success("Объект успешно скопирован");
		return $self->edit;
	}

	$self->admin_msg_errors("Ошибка создании копии");
	return $self->edit;
}

sub zipimport{
	my $self = shift;

	$self->param_default('lfield' => 'pict');

	my @keys = qw(zip);
	push @keys, $self->stash->{dir_field};

	$self->param_default('list_table' => 'dtbl_catalog_items_images' );
	$self->param_default('id_item' => $self->send_params->{id_item} );

	$self->define_anket_form(template => 'anketa_zipimport', access => 'w', render_html => 1, keys => \@keys);
}

sub zipimport_save{
	my $self = shift;

	my $files = $self->file_extract_zip( path => $self->file_tmpdir.$self->send_params->{zip} );

	my $html = $self->render( files => $files, template => 'Admin/Plugins/File/zipimport_img_node', partial => 1);

	$self->render( json => {html => $html, count => scalar(@$files)});
}

sub zipimport_save_pict{
	my $self = shift;

	my $lfield = $self->send_params->{lfield};

	if($self->file_save_pict(
		filename 	=> $self->send_params->{filename},
		lfield		=> $lfield,
	)){
		my $vals = {
			name	=> $self->send_params->{filename},
			rating	=> 99,
			id_item =>
		};

		$self->save_info(table => $self->stash->{list_table}, field_values => $vals );
	};

	my $item = $self->dbi->query("SELECT `pict` FROM `".$self->stash->{list_table}."` WHERE `ID`='".$self->stash->{index}."'")->hash;

	my $folder = $self->lfield_folder( lfield => $lfield ) || $item->{folder};
	$self->render( json => {filename	=> $item->{pict}, src => $folder.$item->{pict} });
}


sub print_choose{
	my $self = shift;

	if($self->stash->{group} == 2){

		my @items = ();
		if($self->stash->{lfield} eq 'html'){
			push @items, {
				type		=> 'eval',
				value		=> "openNewWin(800,600,'".$self->stash->{controller_url}."','do=print_anketa&index=".$self->stash->{index}."&lfield=".$self->stash->{lfield}."', 'print_html');"
			};
		} elsif($self->stash->{lfield} eq 'pdf'){
			push @items, {
				type		=> 'eval',
				value		=> "loadfile('".$self->stash->{controller_url}."do=print_anketa&index=".$self->stash->{index}."&lfield=".$self->stash->{lfield}."');"
			};
		}

		$self->render( json => {
				content	=> "документ формируется...",
				items	=> [
						{
							type		=> 'eval',
							value		=> "closeMessage(3);"
						},
						@items
						],
		});
	} else {
		eval("require PDF::FromHTML;");
		if ($@) {
			$self->stash->{pdf_flag} = 0;
		} else {
			$self->stash->{pdf_flag} = 1;
		}

		$self->render(	template	=> '/Admin/print_block');
	}

}

sub print_anketa{
	my $self = shift;
	my %params = (
		table 	=> $self->stash->{list_table} || '',
		id 		=> $self->stash->{index} || 0,
		title 	=> '',
		@_
	);

	my $table = delete $params{'table'};
	my $id = delete $params{'id'};
	my $title = delete $params{'title'};

	return unless $self->sysuser->access->{table}->{$table}->{r};

	if($self->getArraySQL(	from 	=> 	$table,
							where	=>	"`ID`='$id'",
							stash	=>  "print"
							)){

		my $values = $self->stash->{'print'};
		my $filename = 	sprintf("%s.pdf", $values->{alias} ? $values->{alias} : 'page');
		$values->{text} = $values->{url_for} ? "Данный раздел формируется динамически" : $values->{text};

		my $HTML = <<HEAD;
			<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"	"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
			<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ru" lang="ru">
			<head>
    		<link href="/css/style.css" rel="stylesheet" type="text/css" media="all" />
    		<STYLE TYPE="text/css" MEDIA=screen>
			<!--
  			BODY  { background: white; }
  			#anketa td { padding: 5px; }
			-->
			</STYLE>
			</head>
			<body>
			<table cellspacing="0" id="anketa" cellpadding="0" align="center" border="1">
HEAD
		$HTML .= "
			<tr>
				<th colspan='2'>$title</th>
			</tr>
		" if $self->stash->{name_razdel};

		my $i = 1;
		my $lkeys = $self->lkey;
		foreach my $key (sort {$$lkeys{$a}{settings}{rating} <=> $$lkeys{$b}{settings}{rating}} grep { $_ == $_ } keys %$lkeys) {
			next unless defined $values->{ $key };
			next if( (!$self->sysuser->sys && !$self->sysuser->access->{lkey}->{$key}->{r}) or ($key eq 'folder'));

			my $lkey = $self->lkey(name => $key);
			my $value = $values->{ $key };
			my $type = $lkey->{settings}->{type};

			if($type eq 'pict'){
				my $mini = $lkey->{settings}->{mini};
				my $folder = $values->{folder} || $self->stash->{folder} || "";
				if($mini){
					my @first_mini = split(',', $mini);
					$first_mini[0] =~ s{~[\w]+$}{};
					$folder .= $first_mini[0].'_';
				}

				$value = "<img src=".$folder.$values->{ $key }." />";

			} elsif($type eq 'chb'){
				$value = $value ?  $lkey->{settings}->{yes} :  $lkey->{settings}->{'no'};

			} elsif($type =~ /list/){
				$value = $self->VALUES( name => $key, value => $value );

			} elsif($type eq 'date' ){
				$value = 'не указана' if ($value eq '0000-00-00');

			} elsif($type eq 'datetime' or $type eq 'time' ){
				$value = 'не указана' if ($value eq '0000-00-00 00:00:00');
			}
			$HTML .=
			"<tr>
				<td bgcolor='".($i&1? '#eeeeee':'')."'>".($lkey ? $lkey->{name} : $key)."</td>
				<td bgcolor='".($i&1? '#eeeeee':'')."'>".$value."</td>
			</tr>";
			$i++;
		}

		$HTML .= "</table></body></html>";

		eval("require PDF::FromHTML;");
		if (($self->stash->{lfield} eq 'html') or $@ ){
			return $self->render( text => $HTML)

		} else {

		}
	}
	$self->render( text => "У Вас нет доступа к данной записи");
}

sub block_null{
	my $self = shift;

	my $body = $self->render(	template	=> 'Admin/block_null', partial => 1);

	$self->render( json => {
			content	=> $body,
			items	=> $self->init_modul,
	});
}

sub def_access_where{
	my $self = shift;
	my %params = (
		base		=> '',
		show_empty	=> 1,
		@_,
	);

	my $fields = {
		groups_list	=> $self->sysuser->userinfo->{id_group_user},
		users_list	=> $self->sysuser->userinfo->{ID},
	};

	my @access = ();
	foreach my $f (keys %$fields){
		my $k = !$params{base} ? "`$f`" : "`$params{base}`.`$f`";

		my $field_access;
		if (!$self->sysuser->sys) {
			foreach my $gr( split("=", $fields->{$f})){
				$field_access = $field_access ? "${field_access} OR ($k='$gr' OR ($k LIKE '$gr=%' OR $k LIKE '%=$gr=%' OR $k LIKE '%=$gr'))" : "($k='$gr' OR ($k LIKE '$gr=%' OR $k LIKE '%=$gr=%' OR $k LIKE '%=$gr'))";
			}
		} else {
			$field_access = "$k LIKE '%'";
		}
		push @access, $field_access if $field_access;
	}

	if($params{show_empty} and !$self->sysuser->sys){
		my $tmp;
		foreach my $f (keys %$fields){
			my $k = !$params{base} ? "`$f`" : "`$params{base}`.`$f`";
			$tmp = $tmp ? " $tmp OR ($k='') " : " ($k='') ";
		}
		push @access, $tmp;
	}
	return $self->stash->{access_where} = " AND (".join(' OR ', @access).")";
}

sub def_program{
	my $self = shift;
    my $name = shift;

	if (my $program = $self->dbi->query(
		"SELECT *
		FROM `sys_program`
		WHERE `key_razdel`='$name'")->hash) {
		my $set = {};
		foreach my $p (split(/\n/, $program->{settings})){
			$p =~ s/[\r\n]+//;
			my ($k, $v) = split(/=/, $p, 2);
			next unless $k;
			$set->{$k} = $v;
			if ($k =~ /^groupname/) {
				my @groupname = split(/\|/, $v);
				$set->{$k} = \@groupname;
			}
		}

		my $table = $self->stash->{list_table};
		$program->{groupname} = $table && $set->{'groupname_'.$table} ? $set->{'groupname_'.$table} : $set->{'groupname'};

		$self->stash->{group} ||= 1;
		$program->{settings} = $set;
		$self->app->program($program);
		$self->stash->{controller_url} = $self->url_for('admin_routes_to_body', controller => $name );

		# Установка прав для модуля
		$self->render_admin_msg_errors("Доступ к модулю &laquo$$program{name}&raquo запрещен") unless $self->sysuser->access->{modul}->{$$program{ID}};

		$self->app->sysuser->getAccess(modul => $name);

		$self->stash->{controller_name} = $program->{name};
		#$self->stash->{controller} = $name;

		#$self->app->buttons({});
		#$self->app->lkeys({});

		# установка доп таблицы
		return 1;
	} else {
		$self->render( text => '<h3>У Вас нет прав доступа к данному разделу!</h3>');
		return;
	}
}

sub save_history{
	my $self = shift;
	my %params = @_;

	return unless my $id_user = $self->sysuser->userinfo->{ID};;

	my $replaceme = $self->stash->{replaceme};
	my $script_link = $self->stash->{script_link};

	$params{name} = "<img width='21' height='21' src='".$self->app->program->{pict}."' align='absmiddle'>$params{name}";

	my $link = "<a href='#' onClick=\"openPage('center', '$replaceme', '$script_link?do=info&index=".$self->stash->{index}.$self->stash->{param_default}."', 'Документ', 'Документ')\">$params{name}</a>";
	my $sql = "REPLACE INTO `sys_history` (`id_user`, `link`, `replaceme`, `rdate`) VALUES (?, ?, ?, NOW())";
	my $sth = $self->dbh->do($sql, undef, $id_user, $link, $replaceme);
}

sub delete_info {
	my $self = shift;
	my %params = @_;

	my $table = $params{from} || $params{table};
	$params{index} = $self->stash->{index};

	die "Функция delete_info. Отсутствует параметр from" unless $table;

	if ($params{where} && ($params{where} =~ m/^([\d]+)/)) {
		$params{index} = $1;
		$params{where} = "WHERE `ID`='$params{index}'";

	} elsif ($params{where}) {
		$params{where} = "WHERE $params{where}";
	}

	if ($params{index} && $self -> getHashSQL(from => "sys_related", where => "`tbl_main` = '$params{from}'", stash => "related", sys => 1)) {
		my $items = $self->stash->{related};
		foreach my $item (@$items){
			my $where = "`".$item->{field}."`='$params{index}'";

			if($item->{mult}){
				my $f = $item->{field};
				$where = "`$f`='$params{index}' OR (`$f` LIKE '$params{index}=%' OR `$f` LIKE '%=$params{index}' OR `$f` LIKE '%=$params{index}=%')";
			}
			if (!$item->{delete} && $self->getArraySQL(	select 	=> "`ID`",
									 					from   	=> $item->{tbl_dep},
									 					where  	=> $where,
									 					stash   => "r",
									 					sys 	=> 1)){

				$self->admin_msg_errors("С записью связана запись $$item{ID} из таблицы $$item{tbl_dep}. Удаление запрещено.");
				return;
			} elsif($item->{delete}){
				$self->dbh->do("DELETE FROM `$$item{tbl_dep}` WHERE $where");
			}
		}
	}

	my $sql = "DELETE FROM $params{from} $params{where}";

	if (!$self->sysuser->access->{table}->{$table}->{d} and !$self->sysuser->sys) {
		$self->admin_msg_errors("Доступ к таблице &laquo$table&raquo для пользователя &laquo".$self->sysuser->userinfo->{name}."&raquo на удаление запрещен");
		$self->app->log->error("Доступ к таблице $table для пользователя ".$self->sysuser->userinfo->{name}." на удаление запрещен");
		return;
	}

	# удаление сложных полей
	$self->getArraySQL( from => $table, where => $params{index}, stash => 'delete_info');
	my $delValues = delete $self->stash->{delete_info};

	foreach my $k (keys %$delValues ) {
		next unless my $v = $delValues->{$k};

		my $lkey = $self->lkey(name => $k);
		my $lkey_settings = $lkey->{settings};
		my $type = $lkey_settings->{type};

		if($type eq 'pict'){
			$self->file_delete_pict(index => $params{index}, lfield => $k, pict => $v);
		}
		elsif($type eq 'file'){
			eval{
				unlink $self->static_path.$lkey->{settings}->{folder}.$v;
			};
			warn $@ if $@;
		}
	}

	my $sth = $self->dbh->prepare($sql);
	my $res = $sth->execute();

	unless($self->stash->{win_name}){
		$self->stash->{win_name} = "Удаление объекта #$params{index}";
		$self->stash->{win_name} .= " «".$self->stash->{anketa}->{name}."»" if $self->stash->{anketa}->{name};
	}

	if ($sth->err()) {
		$self -> {error} = $sth -> errstr();
		$self->admin_msg_errors("delArraySQL - ".$sth -> errstr());
		return;
	}
	return $res;
}


sub check_unique_field{
	my $self = shift;
	my %params = (
		lfield	=> "alias",
		field	=> '',
		value	=> '',
		table	=> '',
		index	=> '',
		@_
	);
	$params{field} ||= $params{lfield};
	my $field_name = $self->lkey( name => $params{field} )->{name};
	my $where = "";
	if($params{index}){
		$where = " AND `ID`!='$params{index}'";
	}

	my $sql = qq|SELECT `ID` FROM `$params{table}` WHERE `$params{field}`=? $where LIMIT 0,1|;
	my $sth = $self->app->dbh->prepare($sql);
	if($sth->execute($params{value}) ne '0E0'){
		my $current = 0;
		if($params{value} =~ /(\d)+$/){
			$current = $1;
			$params{value} =~ s/(\d)+$//;
		}

		my $sch = $current;
		while(1){
			$sch++;
			my $test_name = $params{value};
			$test_name .= $sch;
			if($sth->execute($test_name) eq '0E0'){
				$params{value} = $test_name;
				last;
			}
		}

		#$self->admin_msg_errors("$field_name «$params{lfield}» не уникален");
		#return;
	}
	return $params{value};
	#return 1;
}

sub save_info{
	my $self = shift;
	my %params = (
		send_params	=> 1,
		@_
	);

	my $table = delete $params{table};
	my $field_values = delete $params{field_values} || {};
	my $where	= delete $params{where} || '';

	foreach (keys %$field_values){
		unless($self->dbi->exists_keys(from => $table, lkey => $_)){
			delete $field_values->{$_};
		}
	}

	my $send_params = $self->send_params;
	if($params{send_params}){
		foreach (keys %$send_params){
			if($self->dbi->exists_keys(from => $table, lkey => $_)){
				$field_values->{$_} ||= $send_params->{$_};
			}
		}
	}

	if(exists $field_values->{alias} && !$field_values->{alias} && $field_values->{name}){
		$field_values->{alias} = $self->transliteration( $field_values->{name} );
	}

	foreach my $f (qw(alias)){
		if($field_values->{$f}){
			$field_values->{$f} = $self->check_unique_field( field => $f, value => $field_values->{$f}, table => $table, index => $self->stash->{index});

		}
	}


	if(!$self->stash->{index}){

		$self->stash->{index} = $self->insert_hash($table, $field_values, %params);
	} else {
		$where ||= "`ID`='".$self->stash->{index}."'";
		$self->update_hash($table, $field_values, $where, %params);
	}

	if($params{send_params} && $self->stash->{index}){
		# сохраняем сложные поля
		foreach my $k (keys %$send_params){
			next unless my $v = $send_params->{$k};

			my $lkey = $self->lkey(name => $k);
			my $lkey_settings = $lkey->{settings};
			my $type = $lkey_settings->{type};

			# сохраняем картинки
			if($type eq 'pict'){
				$self->file_save_pict(
					filename 	=> $v,
					lfield		=> $k,
					table 		=> $table,
					watermark 	=> $lkey_settings->{watermark},
					retina 		=> $lkey_settings->{retina},
				);
			}
			elsif($type eq 'file'){
				my (undef, $file_name_saved, $fileType) = $self->file_save_from_tmp( filename => $v, lfield => $k );

				my $folder = $lkey_settings->{folder};

				my $fv = {$k => $file_name_saved};
				if(defined $send_params->{size}){
					my $size = -s $self->static_path.$folder.$file_name_saved || 0;
					$fv->{size} = $size;
				}
				if(defined $send_params->{file_type}){
					$fv->{file_type} = $fileType;
				}

				$self->save_info(
					send_params 	=> 0,
					table 			=> $table,
					field_values 	=> $fv
				);
			}
		}
	}

	return $self->stash->{'index'};
}

sub insert_hash {
	my $self = shift;
	my ($table, $field_values, %params) = @_;

	if (!$params{sys} and !$self->sysuser->access->{table}->{$table}->{w} and !$self->sysuser->sys) {
		$self->admin_msg_errors("Доступ к таблице &laquo$table&raquo для пользователя &laquo".$self->sysuser->userinfo->{name}."&raquo на запись запрещен");
		$self->app->log->error("Доступ к таблице $table для пользователя ".$self->sysuser->userinfo->{name}." на запись запрещен");
		return;
	}

	if($self->app->dbi->exists_keys(from => $table, lkey => 'operator')){
		$field_values->{operator} = $self->sysuser->userinfo->{login};
	}

	foreach (keys %$field_values){
		my $lkey = $self->lkey( name => $_ );
		if(!$params{sys} and !$self->sysuser->access->{lkey}->{$_}->{w} and !$lkey->{settings}->{sys} and $_ ne "ID" and !$self->sysuser->sys){
			delete $field_values->{$_};
			$self->admin_msg_errors('Доступ к полю &laquo'.$lkey->{name}.'&raquo для записи запрещен');
		}
	}

	$self->stash->{flag_add} = 1;
	$self->stash->{_admin_part} = 1;

	my $old_index = $self->stash->{index};
	my $new_index = $self->dbi->insert_hash($table, $field_values);

	if($self->dbi->{error}){
		if($self->dbi->{error} =~ /Duplicate entry/){
			$self->dbi->{error} = "Запись с такими параметрами уже существует";
		}
		$self->admin_msg_errors($self->dbi->{error});
	}

	$new_index = $old_index || 0 if $params{no_index};

	$self->stash->{'index'} = $new_index;

	return $self->stash->{index};
}

sub update_hash {
	my $self = shift;
	my ($table, $field_values, $where, %params) = @_;

	if (!$self->sysuser->access->{table}->{$table}->{w} and !$self->sysuser->sys) {
		$self->admin_msg_errors("Доступ к таблице &laquo$table&raquo для пользователя &laquo".$self->sysuser->userinfo->{name}."&raquo на чтение запрещен");
		$self->app->log->error("Доступ к таблице $table для пользователя &laquo".$self->sysuser->userinfo->{name}."&raquo на чтение запрещен");
		return;
	}

	if($self->dbi->exists_keys(from => $table, lkey => 'operator')){
		$field_values->{operator} = $self->sysuser->userinfo->{login};
	}

	foreach (keys %$field_values){
		my $lkey = $self->lkey( name => $_ );
		if(!$params{sys} and !$self->sysuser->access->{lkey}->{$_}->{r} and !$lkey->{settings}->{sys} and $_ ne "ID" and !$self->sysuser->sys){
			delete $field_values->{$_};
			$self->admin_msg_errors("Доступ к полю &laquo".$lkey->{name}."&raquo для чтения запрещен");
		}
	}

	$self->stash->{_admin_part} = 1;

	return 1 unless keys %$field_values;

	my $status = $self->dbi->update_hash($table, $field_values, $where);
	if($self->dbi->{error}){
		if($self->dbi->{error} =~ /Duplicate entry/){
			$self->dbi->{error} = "Запись с такими параметрами уже существует";
		}
		$self->admin_msg_errors($self->dbi->{error});
	}
	return $status;
}

sub read_json{
	my $self = shift;
	my $file = shift;

	my $app =  $self->app;
	my $path = $app->home->rel_file($file);

	if ( open( my $FILE, "<", $path ) ) {
		$app->log->debug(qq/Reading lkeys file '$path'/);

		local $/ = undef;
		my $json = <$FILE>;
		close($FILE);

		require Mojo::JSON::Any;
		die Mojo::JSON::Any->new->decode($json);
		my $conf = eval { Mojo::JSON::Any->new->decode($json); };
		unless(ref $conf){
			$app->log->error("Couldn't parse JSON in config file '$path'\n");
			return {};
		}
		return $conf;
	}
	else {
		$app->log->error(qq/Error reading lkeys file '$path': $!./);
		return {};
	}
}

sub getArraySQL{ # Получение массива значений из базы MySQL
	my $self   = shift;
	my %params = (
		select	=> "*",
		sys		=> 0,
		where	=> " `ID`>0 ",
		from	=> '',
		@_,
	);

	if (!$params{from}) {die "Функция getArraySQL. Отсутствует параметр FROM";}

	if ($params{where} && ($params{where} =~ m/^([\d]+)/)) {
		$params{where} = "WHERE `ID`=$1 ";
	} elsif ($params{where}) {
		$params{where} = "WHERE $params{where}";
	} else {
		return;
	}

	my $fchars = substr($params{from}, 0, 4);
	$params{sys} = 1 if ($fchars eq 'sys_');

	my $sql = "SELECT $params{select} FROM $params{from} $params{where} LIMIT 0,1";

	if (!$self->sysuser->access->{table}->{$params{from}}->{r} and !$params{sys} and !$self->sysuser->sys) {
		$self->admin_msg_errors("Доступ к таблице &laquo$params{from}&raquo запрещен");
		return;
	}

	if(my $row = $self->dbi->query($sql)->hash){
		my $result = {};
		foreach (keys %$row) {
			if ($params{sys} ||
				($self->sysuser->access->{lkey}->{$_}->{r} || $self->lkey( name => $_ )->{settings}->{sys}) ||
				$_ eq "ID" ||
				$self->sysuser->sys) { # Проверка на разрешение доступа к ключу
				$result->{$_} = $row->{$_};
			}
		}
		if($params{stash}){
			$self->stash->{ $params{stash} } = $result;

		} elsif( defined $params{stash}){
			$self->stash->{$_} = $result->{$_} foreach (keys %$result)
		}

		return $result;
	}
	return;
}

sub getHashSQL{
	 # Получение массива значений из базы SQL
	my $self = shift();
	my %params = (
		select	=> "*",
		sys		=> 0,
		where	=> "",
		keys	=> "ID",
		@_,
	);


	if (!$params{from})   {die "Функция getHashSQL. Отсутствует параметр FROM";}

	$params{where} = " WHERE $params{where}" if $params{where};

	my $sql = "SELECT $params{select} FROM $params{from} $params{where}";

	die $sql if $params{test};

	my $fchars = substr($params{from}, 0, 4);
	$params{sys} = 1 if ($fchars eq 'sys_');

	my ($tbl) = split(/ /, $params{from});

	if (!$self->sysuser->access->{table}->{$tbl}->{r} and !$params{sys} and !$self->sysuser->sys) {
		$self->admin_msg_errors("Доступ к таблице &laquo$params{from}&raquo запрещен");
		return;
	}

	#warn $sql;
	if(my $rows = $self->app->dbi->query($sql)->hashes){

		my @result = ();
		foreach my $row (@$rows){
			my $allowFields = {};
			foreach (keys %$row) {
				if (	$params{sys} ||
						($self->sysuser->access->{lkey}->{$_}->{r} || $self->lkeys->{$_}->{settings}->{sys}) ||
						$_ eq "ID" ||
						$self->sysuser->sys
					) { # Проверка на разрешение доступа к ключу

					$allowFields->{$_} = $row->{$_};
				}
			}
			push @result, $allowFields;
		}

		$self->stash->{ $params{stash} } = \@result if $params{stash};
		return wantarray ? @result : \@result;
	}
	return;
}

sub def_context_menu{
	my $self = shift;
	my %params = @_;

	my $lkey = delete $params{lkey};
	my $buttons = $self->button;

	my $context_menu = "";
	delete $self->stash->{text};
	$self->stash->{context_menu} = "";
	my $stash = $self->stash;

	my $access_buttons = $self->sysuser->access->{button} || {};
	my $user_sys = $self->sysuser->sys;

	foreach my $key (sort {$$buttons{$a}{settings}{rating} <=> $$buttons{$b}{settings}{rating}} keys %$buttons) {
		# копировани объектов доступно только для уже сохранненой карточки
		next if($key eq 'copy' && !$self->stash->{index});

		my $button = $$buttons{$key};

		next if (!$$button{settings}{$lkey} or (!$access_buttons->{$key}->{r} and !$user_sys));

		$button->def_params_button($stash);
		$button->def_script_button($stash);

		$context_menu .= $self->render( template => 'Admin/anchor_html', button => $button, partial => 1);
	}

	return $self->stash->{context_menu} = $context_menu;
}

sub def_menu_button{
	my $self = shift();
	my %params = (
		controller	=> 'global',
		@_
	);
	my $key_menu = $params{key_menu} || $params{key} || "menu_button";
	$self->get_keys(controller => $params{controller}, validator => 0) if ($key_menu eq 'menu_button');

	my $buttons = $self->app->buttons->{ $params{controller} };

	my $result = {
		items	=> []
	};
	my @buttons = ();
	push @buttons, { type => 'menubardelall', menubarkey => 'button'};
	push @buttons, { type => 'menubarset', menubarkey => 'button'};

	my $access_buttons = $self->sysuser->access->{button} || {};
	my $user_sys = $self->sysuser->sys;

	$user_sys = 1 if ($key_menu eq 'menu_button'); # Если главная страница то кнопки показываем

	foreach my $key (sort { ($$buttons{$a}{settings}{rating}||0 ) <=> ($$buttons{$b}{settings}{rating}||0 ) } keys %$buttons) {
		my $button = $$buttons{$key};

		next if (!$$button{settings}{$key_menu} or (!$access_buttons->{$key}->{r} and !$user_sys));

		$button->def_params_button();
		$button->def_script_button();

		push @buttons, $button->button_item_json;
	}
	push @buttons, { type => 'menubarinit', menubarkey => 'button'};


	$result->{items} = \@buttons;
	$self->render(json => $result);
}


1;

