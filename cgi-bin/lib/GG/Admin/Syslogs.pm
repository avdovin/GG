package GG::Admin::Syslogs;

use utf8;

use Mojo::Base 'GG::Admin::AdminController';

sub _init{
	my $self = shift;

	$self->def_program('syslogs');

	$self->get_keys( type => ['lkey', 'button'], controller => $self->app->program->{key_razdel});

	my $config = {
		controller_name	=> $self->app->program->{name},
	};

	$self->stash->{list_table} = 'sys_datalogs';

	$self->stash($_, $config->{$_}) foreach (keys %$config);

	$self->stash->{index} ||= $self->send_params->{'index'};
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

		default							{
			$self->default_actions($do);
		}
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

	$self->render( folders => $folders, template => 'Admin/tree_block');
}

sub tree_block{
	my $self = shift;

	my $items = [];
	my $index = $self->stash->{index};
	my $controller = $self->stash->{controller};
	my $table = $self->stash->{list_table};

	$self->param_default('replaceme' => '');

	$items = $self->getHashSQL(	select	=> "`ID`,`name`",
								from 	=> $table,
								where 	=> "`id_group_user`='$index' ".$self->stash->{access_where},
								sys		=> 1) || [];

	foreach my $i (0..$#$items){
		$items->[$i]->{icon} = 'user';
		$items->[$i]->{replaceme} = $controller.'_'.$table.$items->[$i]->{ID};
		$items->[$i]->{param_default} = "&replaceme=".$items->[$i]->{replaceme};
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

	$self->stash->{index} = 0 if $params{restore};



	if(my $ok = $self->save_info( table => $self->stash->{list_table})){
		# Добавляем текущего пользователя в список
		my $index = $self->stash->{index};

		$self->send_params({});

		my @users_list = split('=', $self->send_params->{users_list});
		push @users_list, $index unless(grep(/^$index$/, @users_list) );
		$self->send_params->{users_list} = join('=', sort @users_list);

		$self->save_info( table => $self->stash->{list_table});

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

	#unless($self->stash->{index}){
	#	$self->stash->{anketa}->{groups_list} = $self->app->sysuser->userinfo->{groups_list};
	#}

	$self->define_anket_form( access => 'w');
}

sub list_container{
	my $self = shift;
	my %params = @_;

	$self->delete_list_items if $self->stash->{delete};

	$self->stash->{enter} = 1 if ($params{enter});

	$self->def_context_menu( lkey => 'table_list');

	$self->stash->{win_name} = "Список правил";

	$self->stash->{listfield_groups_buttons} = {};

	return $self->list_items(%params, container => 1)
}

sub list_items{
	my $self = shift;
	my %params = @_;

	my $list_table = $self->stash->{list_table};
	$self->render_not_found unless $list_table;

	$params{table} = $list_table;
	$params{where} = $self->stash->{access_where};

	$self->stash->{listfield_buttons} =  [];

	$self->define_table_list(%params);
}

1;
