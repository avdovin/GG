package GG::Admin::Vars;

use utf8;

use Mojo::Base 'GG::Admin::AdminController';

sub _init{
	my $self = shift;
	
	$self->def_program('vars');
	
	$self->get_keys( type => ['lkey', 'button'], controller => $self->app->program->{key_razdel});
	
	my $config = {
		controller_name	=> $self->app->program->{name},
		#controller		=> 'keys',
	};
	
	$self->stash->{list_table} = 'sys_vars';
	
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
	
	$self->def_access_where( base => $self->stash->{list_table}, show_empty => 0);

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
		
		default							{ $self->render( text => "действие не определенно"); }
	}
}

sub tree{
	my $self = shift;
	
	my $controller = $self->stash->{controller};
	my $table = $self->stash->{list_table};
	
	$self->stash->{param_default} .= "&first_flag=1";
	
	$self->param_default('replaceme' => '');
	
	my $folders = $self->getHashSQL(	from 	=> 'sys_program', 
										where 	=> "`ID`>0",
										sys		=> 1) || [];

	foreach my $i (0..$#$folders){
		$folders->[$i]->{replaceme} = $table.$folders->[$i]->{ID};
	}

	my $items = $self->getHashSQL(	select	=> "`ID`,`name`,`envkey`",
									from 	=> 'sys_vars', 
									where 	=> "`id_program`='0' ".$self->stash->{access_where}) || [];
	
	foreach my $i (0..$#$items){
		$items->[$i]->{icon}		= 'vars';
		$items->[$i]->{replaceme} = $table.$items->[$i]->{ID};
		$items->[$i]->{name} = "<b>".$items->[$i]->{envkey}."</b> (".$items->[$i]->{name}.")";
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
	
	$items = $self->getHashSQL(	select	=> "`ID`,`name`",
								from 	=> $table, 
								where 	=> "`id_program`='$index' ",
								sys		=> 1) || [];
		
	foreach my $i (0..$#$items){
		$items->[$i]->{icon} = 'vars';
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

sub _restore_envKey{
	my $self = shift;
	
	unless($self->stash->{_restore_envKey}){
		$self->stash->{_restore_envKey} = $self->lkey(name => 'envvalue')->{settings};
	}
	
	
	$self->lkey(name => 'envvalue')->{settings} = $self->stash->{_restore_envKey} || {};
}

sub save{
	my $self = shift;
	my %params = @_;
	
	$self->stash->{index} = 0 if $params{restore};
	
	my $types = $self->stash->{types};
	my $value = $self->param('envvalue');

	$self->_restore_envKey;
	if(my $userSettings = $self->stash->{settings}){
		my $userSettings_parsed = $self->parse_keys_settings($userSettings);

		$self->lkey(name => 'envvalue')->{settings} = $self->merge_keys_settings($self->lkey(name => 'envvalue')->{settings}, $userSettings_parsed, { type => $types});
	}
	

		
	if($types){
		given ($types){
			when('s') 				{ $value = $self->check_string( value => $value); 			}	
			when('slat') 			{ $value = $self->check_lat( value => $value); 				}
			when('d') 				{ $value = $self->check_decimal( value => $value); 			}
			when('chb') 			{ $value = $self->check_checkbox( value => $value); 		}
			when('list') 			{
				$self->def_list( name => 'envvalue', controller => 'vars');  
				$value = $self->check_list(%{$self->lkey(name => 'envvalue')->{settings}}, value => $value);
			}
			when('list_radio')		{
				$self->lkey(name => 'envvalue')->{settings}->{type} = 'list';
				#$self->lkeys->{envvalue}->{settings}->{type} = 'list'; 
				$self->def_list( name => 'envvalue', controller => 'vars'); 
				$value = $self->check_list(%{$self->lkey(name => 'envvalue')->{settings}}, type => 'list', value => $value); 			
			}
			when('list_chb') 		{
				$self->lkey(name => 'envvalue')->{settings}->{type} = 'list';
				
				#$self->lkeys->{envvalue}->{settings}->{type} = 'list'; 
				$self->def_list( name => 'envvalue', controller => 'vars'); 
				$value = $self->check_list(%{$self->lkey(name => 'envvalue')->{settings}}, type => 'list', value => $value);
			}
			when('email') 			{ $value = $self->check_email( value => $value); 			}
			when('code') 			{ }
			when('text') 			{ $value = $self->check_string( value => $value); 			}
			when('html') 			{ $value = $self->check_html( value => $value); 			}
			
			default					{
				$value = '';
				$types = 's';
				$self->admin_msg_errors("Тип переменной «$types» не определен");
			}
		}
	}

	$self->send_params->{envvalue} = $value;
	
	my $ok = $self->save_info( table => $self->stash->{list_table});
	
	if($ok){
		
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
	
	$self->getArraySQL( from => $self->stash->{list_table}, where => $self->stash->{index}, stash => 'anketa');
	
	my $types = $self->stash->{anketa}->{types} || 's';
	
	$self->lkey(name => 'envvalue')->{settings}->{notnull} //= 1;

	my $dop_settings = $self->parse_keys_settings($self->stash->{anketa}->{settings});
	$self->lkey(name => 'envvalue')->{settings} = $self->merge_keys_settings($self->lkey(name => 'envvalue')->{settings}, $dop_settings, { type => $types});

	given ($types){
			when('list_chb'){
				$self->lkey(name => 'envvalue')->{settings}->{type} = 'list';
				$self->def_list( name => 'envvalue', controller => 'vars');
				$self->lkey(name => 'envvalue')->{settings}->{list_type} = 'checkbox';
				$self->lkey(name => 'envvalue')->{settings}->{template_w} = 'field_list_read';
			}		
			when('list_radio'){
				$self->lkey(name => 'envvalue')->{settings}->{type} = 'list';
				$self->def_list( name => 'envvalue', controller => 'vars');
				$self->lkey(name => 'envvalue')->{settings}->{list_type} = 'radio';
				$self->lkey(name => 'envvalue')->{settings}->{template_w} = 'field_list_read';
			}		
	}
	
	$self->define_anket_form(noget => 1, access => 'r', table => $table);	
}

sub edit{
	my $self = shift;
	my %params = @_;
	
	$self->def_context_menu( lkey => 'edit_info');
	
	$self->getArraySQL( from => $self->stash->{list_table}, where => $self->stash->{index}, stash => 'anketa');
	
	my $types = $self->stash->{anketa}->{types} || 's';
	
	$self->lkey(name => 'envvalue')->{settings}->{notnull} //= 1;
	
	$self->_restore_envKey;
	
	my $dop_settings = $self->parse_keys_settings($self->stash->{anketa}->{settings});
	#use Data::Dumper;
	#die Dumper $self->merge_keys_settings($self->lkey(name => 'envvalue')->{settings}, $dop_settings, { type => $types});
	
	$self->lkey(name => 'envvalue')->{settings} = $self->merge_keys_settings($self->lkey(name => 'envvalue')->{settings}, $dop_settings, { type => $types});
	
	#use Data::Dumper;
	#die Dumper $self->lkey;
	
	given ($types){
			when('s'){
				$self->lkey(name => 'envvalue')->{settings}->{template_w} = 'field_input';
			}	
			when('slat'){
				$self->lkey(name => 'envvalue')->{settings}->{template_w} = 'field_input';
			}	
			when('chb'){
				$self->lkey(name => 'envvalue')->{settings}->{template_w} = 'field_checkbox';
			}	
			when('list'){
				$self->def_list( name => 'envvalue', controller => 'vars');
				$self->lkey(name => 'envvalue')->{settings}->{list_type} = 'select';
				$self->lkey(name => 'envvalue')->{settings}->{template_w} = 'field_list';
			}				
			when('list_chb'){
				$self->lkey(name => 'envvalue')->{settings}->{type} = 'list';
				$self->def_list( name => 'envvalue', controller => 'vars');
				$self->lkey(name => 'envvalue')->{settings}->{list_type} = 'checkbox';
				$self->lkey(name => 'envvalue')->{settings}->{template_w} = 'field_list';
			}		
			when('list_radio'){
				$self->lkey(name => 'envvalue')->{settings}->{type} = 'list';
				$self->def_list( name => 'envvalue', controller => 'vars');
				$self->lkey(name => 'envvalue')->{settings}->{list_type} = 'radio';
				$self->lkey(name => 'envvalue')->{settings}->{template_w} = 'field_list';
			}		
			when('email'){
				$self->lkey(name => 'envvalue')->{settings}->{template_w} = 'field_input';
			}	
			when('code'){
				$self->lkey(name => 'envvalue')->{settings}->{template_w} = 'field_text';
			}	
			when('text'){
				$self->lkey(name => 'envvalue')->{settings}->{template_w} = 'field_text';
			}
			when('html'){
				$self->lkey(name => 'envvalue')->{settings}->{cktoolbar} = 'Basic';
				$self->lkey(name => 'envvalue')->{settings}->{template_w} = 'field_html';
			}
			when('d'){
				$self->lkey(name => 'envvalue')->{settings}->{template_w} = 'field_rating';
			}
			default					{
				$self->lkey(name => 'envvalue')->{settings} = $self->merge_keys_settings($self->lkey(name => 'envvalue')->{settings}, { type => 's'} );
				#$value = '';
				#$self->msg_errors("Тип переменной «$types» не определен");
			}
	}
			
	$self->define_anket_form(noget => 1, access => 'w');		
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

	$self->sysuser->access->{table}->{'sys_vars'} = {
		r	=> 1,
		w	=> 1,
		d	=> 0,
	};

	$self->define_table_list(%params, where => $self->stash->{access_where});
}

1;
