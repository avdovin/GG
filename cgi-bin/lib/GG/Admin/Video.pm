package GG::Admin::Video;

use utf8;

use Mojo::Base 'GG::Admin::AdminController';

sub _init{
	my $self = shift;

	$self->def_program('video');

	$self->get_keys( type => ['lkey', 'button'], controller => $self->app->program->{key_razdel});

	my $config = {
		controller_name	=> $self->app->program->{name},
		#controller		=> 'keys',
	};

	$self->stash->{list_table} ||= 'data_video';

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

	$self->stash->{dir_field} = 'id_video';

	if($self->stash->{list_table} =~ /data_catalog_([\s\S]+)/){
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


sub save{
	my $self = shift;
	my %params = @_;

	my $table = $self->stash->{list_table};

	$self->backup_doptable;

	$self->send_params->{youtubelink} =~ s/(?:http|https|)(?::\/\/|)(?:www.|)(?:youtu\.be\/|youtube\.com(?:\/embed\/|\/v\/|\/watch\?v=|\/ytscreeningroom\?v=|\/feeds\/api\/videos\/|\/user\S*[^\w\-\s]|\S*[^\w\-\s]))([\w\-]{11})[a-z0-9;:@?&%=+\/\$_.-]*/$1/i;
	$self->send_params->{vimeolink} =~ s/(?:http|https|)(?::\/\/|)(?:player\.|)?vimeo\.com(?:\/video)?\/(\d+)/$1/i;

	$self->stash->{index} = 0 if $params{restore};

	if( $self->save_info( table => $self->stash->{list_table}) ){

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


		if($params{continue}){
			$self->admin_msg_success("Данные сохранены");
			return $self->edit;
		}
		elsif(!$self->stash->{dop_table} && $self->stash->{group} >= $#{$self->app->program->{groupname}} + 1){
			return $self->info;
		}

		$self->stash->{group}++;
	}

	if($self->stash->{dop_table}){
		$self->restore_doptable;
		return $self->render_json({
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
	}

	$self->define_anket_form( access => 'r', table => $table, noget => 1);
}

sub edit{
	my $self = shift;
	my %params = @_;

	$self->def_context_menu( lkey => 'edit_info');

	# Создание папки
	if($params{dir}){
		$self->stash->{page_name} = "Создание новой папки";
		$self->param_default('dir' => $self->stash->{anketa}->{dir} = 1 );
	}

	if($self->stash->{dop_table}){
		$self->backup_doptable();
	}

	if($self->stash->{index}){
		$self->getArraySQL(	from 	=> $self->stash->{list_table},
							where	=> "`ID`='".$self->stash->{index}."'",
							stash	=> 'anketa');

	}

	if(!$self->stash->{anketa}->{dir} && $self->stash->{group} > 1){
		return $self->info;
	}

	$self->define_anket_form( access => 'w', noget => 1);
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

	$self->define_table_list(%params);
}

1;
