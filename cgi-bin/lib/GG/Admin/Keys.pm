package GG::Admin::Keys;

use utf8;

use Mojo::Base 'GG::Admin::AdminController';

sub _init{
	my $self = shift;

	$self->def_program('keys');

	$self->get_keys( type => ['lkey', 'button'], controller => $self->app->program->{key_razdel});

	my $config = {
		controller_name	=> $self->app->program->{name},
		#controller		=> 'keys',
	};

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

		when('mainpage') 				{ $self->mainpage; }

		default							{
			$self->default_actions($do);
		}
	}
}

sub tree{
	my $self = shift;

	my $folders = [];
	my $controller = $self->stash->{controller};
	my $table = $self->stash->{list_table};
	foreach my $t ($self->dbi->getTablesSQL()) {
		if ($t =~ m/^keys_([\s\S]+)/) {
			push @$folders, {
				ID => $t,
				name => $t,
				param_default => '&list_table='.$t,
				click_type	=> 'list',
				replaceme	=> 'keys'.$t,
				tabname		=> $t,
			};
		}
	}

	$self->render( folders => $folders, template => 'Admin/tree_block');
}

sub tree_block{
	my $self = shift;

	$self->stash->{param_default} = '';
	my $items = $self->getHashSQL(	from 	=> $self->param('index'),
									where 	=> "`ID`>0");

	my $table = $self->stash->{list_table};
	foreach my $i (0..$#$items){
		$items->[$i]->{name} = "<b>".$items->[$i]->{lkey}."</b> ".$items->[$i]->{name};
		$items->[$i]->{key_element} = $table;
		$items->[$i]->{replaceme} = $table.$items->[$i]->{ID};
		$items->[$i]->{icon} = 'object';
		$items->[$i]->{click_type} = 'text';
		$items->[$i]->{param_default} = '&list_table='.$table.'&replaceme='.$self->stash->{controller}.$table.$items->[$i]->{ID};
	}


	$self->render( json => {
					content	=> $self->render_to_string( items => $items, template => 'Admin/tree_elements'),
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

	$self->stash->{index} = 0 if $params{restore};

	unless($self->stash->{index}){
		$self->send_params->{tbl} ||= '';
	}

	my $ok = $self->save_info( table => $self->stash->{list_table});

	if($ok){

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
	} else {
		$self->def_context_menu( lkey => 'print_info');
	}
	$self->define_anket_form( access => 'r', table => $table);
}

sub edit{
	my $self = shift;
	my %params = @_;

	$self->def_context_menu( lkey => 'edit_info');

	unless($self->stash->{index}){
		$self->stash->{anketa}->{object} = 'lkey';
    
    # default key setting
    $self->stash->{anketa}->{settings} = qq{
type=s
rating=99
group=1
qview=1
qedit=1
filter=1
table_list=0
table_list_width=0
fileview=1
required=0
    };
	}

	$self->define_anket_form( access => 'w');
}

sub list_container{
	my $self = shift;
	my %params = @_;

	$self->delete_list_items if $self->stash->{delete};

	$self->stash->{enter} = 1 if ($params{enter});

	$self->def_context_menu( lkey => 'table_list');

	# Получаем название справочника
	if(my $controller = $self->dbi->query("SELECT `name` FROM `sys_program` WHERE `keys_table`='".$self->app->send_params->{list_table}."' ")->hash){
		$self->stash->{win_name} = $controller->{name};
	} else {
		$self->stash->{win_name} = $self->app->send_params->{list_table};
	}

	$self->stash->{listfield_groups_buttons} = {delete => "удалить"};

	# блокируем переход на 1-ю вкладку
	$self->stash->{showcontent_center_disabled} = 1;

	return $self->list_items(%params, container => 1)
}

sub list_items{
	my $self = shift;
	my %params = @_;

	my $list_table = $self->app->send_params->{list_table};
	$self->render_not_found unless $list_table;

	$params{table} = $list_table;
	#$params{lkey} = $self->stash->{lkey};

	$self->define_table_list(%params);
}

sub mainpage{
	my $self = shift;

	my $body = "";
	foreach my $t ($self->dbi->getTablesSQL()) {
		if ($t =~ m/^keys_([\s\S]+)/) {
			my %button_conf = (
	   			"params" 		=> "config_table,first_flag",
	       		"action" 		=> "list",
	       		"controller" 	=> "Keys",
	       		"name"			=> $t,
	       		"tabtitle"		=> $t,
	       		"imageicon" => "/admin/img/icons/program/object.png",
	       		"classdiv"		=> "div_icons-big-text-overflow",
	       		"classimg"		=> "image_icons",
	       		"classhref"		=> "href_icons",
	       		"title" 		=> $t,
	       		"type_link" 	=> "openpage",
	       		#"script"		=> "openPage('center','keys${t}','/admin/keys/body?do=list_container&list_table=$t','Ключи: $t','$t')"
	       		"script"		=> "ld_content('replaceme','/admin/keys/body?do=list_container&list_table=$t')"
	   		);

			$body .= $self->render_to_string( template => 'Admin/icon', button => \%button_conf);
		}
	}
	my $content = $self->render_to_string( template => 'Admin/page_admin_main', body => $body);

	$self->stash->{enter} = 1;
	my $result = {
		content	=> $content,
		items	=> $self->get_init_items( init => 'init_modul'),
	};

	$self->render( json => $result);
}


1;
