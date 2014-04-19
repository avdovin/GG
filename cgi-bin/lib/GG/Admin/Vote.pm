package GG::Admin::Vote;

use utf8;

use Mojo::Base 'GG::Admin::AdminController';

sub _init{
	my $self = shift;

	$self->def_program('vote');

	$self->get_keys( type => ['lkey', 'button'], controller => $self->app->program->{key_razdel});

	my $config = {
		controller_name	=> $self->app->program->{name},
		#controller		=> 'keys',
	};

	$self->stash->{list_table} ||= 'data_vote';

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

	if($self->stash->{list_table} =~ /data_vote_([\s\S]+)/){
		$self->app->program->{groupname} = $self->app->program->{settings}->{'groupname_'.$1} if($1 && $self->app->program->{settings}->{'groupname_'.$1});
	}
}

sub body{
	my $self = shift;

	$self->_init;

	my $do = $self->param('do');

	given ($do){

		when('list_container') 			{ $self->list_container; }

		default							{
			$self->default_actions($do);
		}
	}
}

sub lists_select{
	my $self = shift;

	my $lfield = $self->param('lfield');
	$lfield =~ s{^fromselect}{};
	my $keystring = $self->param('keystring');

	my $selected_vals = $self->param($lfield);
	$selected_vals =~ s{=}{,}gi;

	$selected_vals = join(',', map {"'$_'"} split(',', $selected_vals) );

	my $sch = 0;
	my $list_out = "";

	if($lfield eq 'groups'){
		my $baseCode = $self->get_var('catalog_basecode');

		my  $where .= " `code`='$baseCode' ";
			$where .= " AND `name` LIKE '%$keystring%' " if ($keystring ne 'all');
			$where .= " AND `name` NOT IN ($selected_vals)" if $selected_vals;

		for my $item ($self->dbi->query("SELECT `value`,`name`,`valuename` FROM `lst_catalog_dimensions` WHERE $where ORDER BY `name`")->hashes){
			my $name  = _quote($item->{valuename} || $item->{value});
			my $value = _quote($item->{value});

			$list_out .= "lstobj[out].options[lstobj[out].options.length] = new Option($name, $value);\n" if $name;
			$sch++;
		}

	} else {
		my  $where .= " 1 ";
			$where .= " AND `name` LIKE '%$keystring%' " if ($keystring ne 'all');
			$where .= " AND `name` NOT IN ($selected_vals)" if $selected_vals;

		for my $item ($self->dbi->query("SELECT distinct(code), `code` FROM `lst_catalog_dimensions` WHERE $where ORDER BY `code` ")->hashes){
			my $name  = _quote($item->{code});
			my $value = _quote($item->{code});

			$list_out .= "lstobj[out].options[lstobj[out].options.length] = new Option($name, $value);\n" if $name;
			$sch++;
		}

	}


	$list_out .= "document.getElementById('ok_' + out).innerHTML = \"<span style='background-color:lightgreen;width:45px;padding:3px'>найдено: ".$sch."</span>\";\n";
	$self->render_text($list_out);


}

sub _quote {
	my $string = shift;
	$string =~ s/(["\\])/\\$1/g;
	return qq{"$string"};
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

	if( $self->save_info( table => $self->stash->{list_table}) ){

		if($params{restore}){
			$self->stash->{tree_reload} = 1;
			$self->save_logs( 	name 	=> 'Восстановление записи в таблице '.$self->stash->{list_table},
								comment	=> "Восстановлена запись в таблице [".$self->stash->{index}."]. Таблица ".$self->stash->{list_table}.". ".$self->msg_no_wrap);
			return $self->info;
		}


		if(!$self->stash->{dop_table} && $self->stash->{group} >= $#{$self->app->program->{groupname}} + 1){
			return $self->info;
		}

		$self->stash->{group}++;
	}
	my $json->{content} = $self->has_errors ? "ERROR" : "OK";
	$json->{items} = $self->init_dop_tablelist_reload();

	if($self->stash->{dop_table}){
		$self->restore_doptable;
		return $self->render(
				json	=> $json,
		);
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

	#$self->app->lkeys->{$lfield}->{settings}->{table_groupname}

	if($self->stash->{index}){
		$self->getArraySQL(	from 	=> $self->stash->{list_table},
							where	=> "`ID`='".$self->stash->{index}."'",
							stash	=> 'anketa');

		#$self->_defDimensionsList if ($self->stash->{list_table} eq 'data_catalog_categorys');
	}

	$self->define_anket_form( access => 'r', table => $table, noget => 1);
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


	}

	$self->define_anket_form( access => 'w', noget => 1);
}

sub list_container{
	my $self = shift;
	my %params = @_;

	$self->delete_list_items if $self->stash->{delete};

	$self->stash->{enter} = 1 if ($params{enter});

	$self->def_context_menu( lkey => 'table_list');

	$self->stash->{win_name} = "Список опросов";

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

1;
