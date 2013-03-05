package GG::Admin::Access;

use utf8;

use Mojo::Base 'GG::Admin::AdminController';

sub _init{
	my $self = shift;
	
	$self->def_program('access');
	
	$self->get_keys( type => ['lkey', 'button'], controller => $self->app->program->{key_razdel});
	
	my $config = {
		controller_name	=> $self->app->program->{name},
		#controller		=> 'keys',
	};
	
	$self->stash->{list_table} = 'sys_access';

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
}

sub body{
	my $self = shift;
	
	$self->_init;
	
	my $do = $self->param('do');

	given ($do){
		
		when('list_container') 			{ $self->list_container; }
		when('enter') 					{ $self->list_container( enter => 1); }
		when('list_items') 				{ $self->list_items; }
		
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
		when('delete') 					{ $self->delete; }
		when('restore') 				{ $self->save( restore => 1); }
		
		when('tree') 					{ $self->tree; }
		when('tree_block') 				{ $self->tree_block; }
		when('tree_reload') 			{ $self->tree_block; }	
		
		default							{ $self->render_text("действие не определенно"); }
	}	
}

sub tree{
	my $self = shift;
	
	my $folders = $self->getHashSQL(	from 	=> 'lst_group_user', 
										where 	=> "`ID`>0") || [];
	
	$self->stash->{param_default} .= "&first_flag=1";
									
	my $controller = $self->stash->{controller};
	my $table = $self->stash->{list_table};
	
	foreach my $i (0..$#$folders){
		$folders->[$i]->{replaceme} = $table.$folders->[$i]->{ID};
	}

	$self->render(folders => $folders, template => 'Admin/tree_block');
}

sub tree_block{
	my $self = shift;
	
	my $items = [];
	my $index = $self->stash->{index};
	my $controller = $self->stash->{controller};
		
	if($self->stash->{first_flag}){
		$self->stash->{param_default} .= "&id_group_user=$index";
		
		$items = $self->getHashSQL(	select	=> "`ID`,`name`",
									from 	=> 'sys_program', 
									where 	=> "`ID`>0",
									sys		=> 1) || [];
		
		
		foreach my $i (0..$#$items){
			$items->[$i]->{noclick} = 1;
			$items->[$i]->{icon} = 'folder';
			$items->[$i]->{flag_plus} = $self->getArraySQL( select 	=> "`ID`", 
															from	=> 	'sys_access', 
															where 	=> "`modul`='".$items->[$i]->{ID}."' AND `id_group_user`='$index'") ? 1 : 0;
		}
		
		push @$items, {
			ID			=> 999999,
			noclick		=> 1,
			icon		=> 'folder',
			flag_plus	=> $self->getArraySQL( 	select 	=> "`ID`", 
												from	=> 	'sys_access', 
												where 	=> "`modul`='0' AND `id_group_user`='$index'") ? 1 : 0,
			name		=> 'Общие правила',
		};

	} else {
		$index = 0 if ($index == 999999);
		
		$items = $self->getHashSQL(	select	=> "`sys_access`.`ID`,`sys_access`.`objecttype` AS `name`,`objecttype`,`sys_program`.`name` AS `program_name`",
									from 	=> '`sys_access` LEFT JOIN `sys_program` ON `sys_access`.`modul`=`sys_program`.`ID`', 
									where 	=> "`sys_access`.`id_group_user`='".$self->stash->{id_group_user}."' AND `modul`='$index'",
									sys		=> 1
									) || [];

		my $table = $self->stash->{list_table};
		$self->param_default('replaceme' => '');
		
		$self->def_list( name => 'objecttype', controller => 'access') unless $self->lkey(name => 'objecttype')->{list};
		my $objecttypeKey = $self->lkey(name => 'objecttype', controller => 'access');
		
		foreach my $i (0..$#$items){
			$items->[$i]->{icon} = $items->[$i]->{objecttype};
			$items->[$i]->{replaceme} = $controller.'_'.$table.$items->[$i]->{ID};
			$items->[$i]->{name} = $objecttypeKey->{list}->{$items->[$i]->{name}};
			$items->[$i]->{param_default} = '&replaceme='.$items->[$i]->{replaceme};
		}		
		
	}
	
#	my $items = $self->getHashSQL(	from 	=> $self->param('index'), 
#									where 	=> "`ID`>0");
#	
#	my $table = $self->stash->{list_table};
#	foreach my $i (0..$#$items){
#		$items->[$i]->{name} = "<b>".$items->[$i]->{lkey}."</b> ".$items->[$i]->{name};
#		$items->[$i]->{key_element} = $table;
#		$items->[$i]->{icon} = $items->[$i]->{object};
#		$items->[$i]->{click_type} = 'text';
#		$items->[$i]->{param_default} = '&list_table='.$table.'&replaceme='.$self->stash->{controller}.'_'.$table.$items->[$i]->{ID};
#	}
	

	$self->render_json({
					content	=> $self->render_partial( items => $items, template => 'Admin/tree_elements'),
					items	=> [{
							type	=> 'eval',
							value	=> "treeObj['".$self->stash->{controller}."'].initTree();"
					},
					]
				});	
	
}

sub delete{
	my $self = shift;
	

	if ($self->getArraySQL( from => $self->stash->{list_table}, where => $self->stash->{index}, stash => 'anketa')) {
		
		if($self->delete_info( from => $self->stash->{list_table}, where => $self->stash->{index} )){
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

	
	if($self->param('objectname')){
		my $objectname = $self->param('objectname');
		$objectname = join("=", split(/,/, $objectname));
		$objectname =~ s/^=//;
		$self->send_params->{objectname} = $objectname;
	}
	
		
	$self->stash->{index} = 0 if $params{restore};
	
	if(  $self->save_info( table => $self->stash->{list_table}) ){
		my $hash = $self->dbi->query("SELECT * FROM `".$self->stash->{list_table}."` WHERE `ID`='".$self->stash->{index}."'")->hash;
		
		my $a;
		foreach my $k (sort keys %$hash){
			$a .= $hash->{$k} if(defined $hash->{$k} and $k ne 'cck' and $k ne "objectname" and $k ne 'rdate' and $k ne 'edate');
		}
		my $cck = $self->sysuser->def_cck_access($a);

		$self->update_hash($self->stash->{list_table}, {cck => $cck}, "`ID`='".$self->stash->{index}."'");
				
		if($params{restore}){
			$self->stash->{tree_reload} = 1;
			$self->save_logs( 	name 	=> 'Восстановление записи в таблице '.$self->stash->{list_table},
								comment	=> "Восстановлена запись в таблице [".$self->stash->{index}."]. Таблица ".$self->stash->{list_table}.". ".$self->msg_no_wrap);
			return $self->info;			
		}
		
		if ($self->stash->{objecttype} && ($self->stash->{objecttype} eq "modul" or $self->stash->{objecttype} eq "table") && $self->stash->{group} == 1){ 
			$self->stash->{group} = 3;
			return $self->edit;
		}
		
		if($self->stash->{group} >= $#{$self->app->program->{groupname}} + 1){
			$self->stash->{tree_reload} = 1;
			
			#TODO: Сбрасываем авторизацию для всех пользователей (чтобы обновились права)
			#$self->dbh->do("UPDATE `sys_users` SET `cck`='' WHERE `sys`='0'");
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
	} else {
		$self->def_context_menu( lkey => 'print_info');
	}
	$self->_def_objectname_list;
	
	$self->define_anket_form( access => 'r', table => $table);	
}

sub edit{
	my $self = shift;
	my %params = @_;
	
	$self->def_context_menu( lkey => 'edit_info');
	
	if ($self->stash->{group} == 3){
		$self->_def_objectname_list;
	} else {
		$self->getArraySQL(from => $self->stash->{list_table}, where => "`ID`='".$self->stash->{index}."'" , stash => 'anketa');
		$self->stash->{objecttype} = $self->stash->{anketa}->{objecttype};
	}

	if ($self->stash->{objecttype} && ($self->stash->{objecttype} eq "modul" or $self->stash->{objecttype} eq "table") && $self->stash->{group} == 2){ 
		$self->stash->{group} = 3;
		
		$self->_def_objectname_list;
	}
				
	$self->define_anket_form( access => 'w');		
}

sub list_container{
	my $self = shift;
	my %params = @_;
	
	$self->delete_list_items if $self->stash->{delete};
	
	$self->stash->{enter} = 1 if ($params{enter});
	
	$self->def_context_menu( lkey => 'table_list');

	$self->stash->{win_name} = "Список правил";
	
	$self->stash->{listfield_groups_buttons} = {delete => "удалить"};
	
	return $self->list_items(%params, container => 1)
}

sub list_items{
	my $self = shift;
	my %params = @_;
	
	my $list_table = $self->stash->{list_table};
	$self->render_not_found unless $list_table;
			
	$params{table} = $list_table;
	#$params{lkey} = $self->stash->{lkey};

	$self->define_table_list(%params);
}

sub _def_objectname_list {
	my $self = shift;
	my $vals = {};

	
	my $item = $self->getArraySQL(select => "`objecttype`,`modul`", from => 'sys_access', where => $self->stash->{index});
	$self->stash->{objecttype} = $item->{objecttype};
	
	if($item->{objecttype} eq 'table'){
		foreach ($self->dbi->getTablesSQL()) {
			my $fchars = substr($_, 0, 4);
			next if ($fchars eq 'keys' or $fchars eq 'sys_');
			$vals->{$_} = $_;# if (($_ !~ m/^keys_/) ); 
		}
	
	} elsif($item->{objecttype} eq 'modul'){
		if( my $pr = $self->getHashSQL(select => "`ID`,`name`", from => 'sys_program', where => "`ID`>0")){
			$vals->{$_->{ID}} = $_->{name} foreach (@$pr);
		}

	} elsif($item->{objecttype} eq 'lkey' or $item->{objecttype} eq 'button' or $item->{objecttype} eq 'menu'){
		my $keys_table = $self->getArraySQL(select => "`keys_table`", from => 'sys_program', where => $item->{modul});
		$keys_table ||= {};
		$keys_table->{keys_table} ||= 'keys_global';

		if( my $keys = $self->getHashSQL(select => "`ID`,`name`,`lkey`", from => $keys_table->{keys_table}, where => "`object`='$$item{objecttype}' AND `settings` NOT LIKE '%sys=1%'", sys => 1)){
			$vals->{$_->{lkey}} = $_->{name}.' ('.$_->{lkey}.')' foreach (@$keys);
		}
	}
	
	my $objectnameKey = $self->lkey( name => 'objectname', controller => 'access');
	$objectnameKey->{list} = $vals;
	$self->_def_list_labels($objectnameKey);
}


1;
