package GG::Admin::Styles;

use utf8;

use Mojo::Base 'GG::Admin::AdminController';
use Time::localtime;
use File::stat;
use open ':encoding(utf8)';


sub _init{
	my $self = shift;
	
	$self->def_program('styles');
	
	$self->get_keys( type => ['lkey', 'button'], controller => $self->app->program->{key_razdel});
	
	my $config = {
		controller_name	=> $self->app->program->{name},
	};
	
	$self->stash->{css_dir} ||= '/css/';

	$self->stash($_, $config->{$_}) foreach (keys %$config);
		
	$self->stash->{index} ||= $self->send_params->{index};
	unless($self->send_params->{replaceme}){
		$self->send_params->{replaceme} = $self->stash->{controller};
		$self->send_params->{replaceme} .= '_'.$self->stash->{list_table} if $self->stash->{list_table};
	}
	 
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
		when('mainpage') 				{ $self->mainpage; }
		when('list_items') 				{ $self->list_items; }
		
		when('menu_button') 			{ 
			$self->def_menu_button( 
				key 		=> $self->app->program->{menu_btn_key},
				controller	=> $self->app->program->{key_razdel},
			); 
		}
		
		when('filter_take') 			{ $self->filter_take( render => 1); }
		when('quick_view') 				{ $self->quick_view; }
		
		when('add') 					{ $self->edit( add => 1); }
		when('edit') 					{ $self->edit; }
		when('save') 					{ $self->save; }
		when('delete') 					{ $self->delete; }
		when('restore') 				{ $self->save( restore => 1); }
		
		default							{ $self->render_text("действие не определенно"); }
	}	
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
	
	
	my $path =  $ENV{DOCUMENT_ROOT}."css/".$self->stash->{dir};
	
	
	my $code = $self->stash->{code};
	chomp($code);
	
	#Добавляем дату и имя оператора в файл
	my $info_line = "/* ".sprintf("Last Modified %s by %s", $self->setLocalTime(1),$self->sysuser->userinfo->{login} )." */ \n";	
	if($code =~ /^\/\* Last Modified [\s\S]+\n/){
		my @code = split("\n", $code);
		shift @code;
		$code = $info_line.join("\n", @code);
	} else {
		$code = $info_line.$code;
	}

	my $ok = $self->file_save_data( data => $code, path => $path);
	
	if($ok){
		$self->admin_msg_success('Файл успешно сохранен ...');
	} 
	
	return $self->edit;

}

sub edit{
	my $self = shift;
	my %params = @_;
	
	#$self->def_context_menu( lkey => 'edit_info');
	my $dir =  $self->stash->{dir} || '';

	die "Ошибка открытия файла, не указана папка" unless $dir;
	
	my $anketa = {};
	
	my $rel_dir = $ENV{DOCUMENT_ROOT}."css/$dir";

	#my $rel_dir = $self->app->home->rel_dir("../css/$dir");


	$anketa->{code} = $self->file_read_data(path => $rel_dir);

	# Время изменения файла
	my ($tm_m, $tm_c);
	eval{
		$tm_m = localtime( stat($rel_dir)->mtime );
	};
	$anketa->{modifytime} = "Неизвестно";
	if(!$@){
		$anketa->{modifytime} = sprintf("%02d.%02d.%04d %02d:%02d:%02d", $tm_m->mday, $tm_m->mon+1, $tm_m->year+1900, $tm_m->hour, $tm_m->min, $tm_m->sec);
	}
	
	$anketa->{name} = ($dir =~ m/([^\/]+)$/)[0];
	$anketa->{dir} = $dir;
	
	$self->stash->{anketa} = $anketa;
	
	$self->stash->{page_name} = "Редактирование стилей «$dir»";
	
	$self->lkeys->{code}->{settings}->{dirview} = 1;
	
	$self->param_default(dir => $dir );
	$self->param_default(replaceme => "styles_$dir" );
	
	$self->define_anket_form( access => 'w', noget => 1, keys => [qw(name dir modifytime code)]);		
}

sub list_container{
	my $self = shift;
	my %params = @_;
	
	$self->delete_list_items if $self->stash->{delete};
	
	$self->stash->{enter} = 1 if ($params{enter});

	$self->def_context_menu( lkey => 'table_list');

	$self->stash->{win_name} = "Таблица объектов: ".$self->app->send_params->{list_table};
	
	$self->stash->{listfield_groups_buttons} = {delete => "удалить"};
	
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
	my $dir = $self->stash->{dir} || '';

	my $rel_dir = $ENV{DOCUMENT_ROOT}."css/$dir"; 
	my $controller_url = $self->stash->{controller_url};

	$self->stash->{win_name} = $dir;
	$self->stash->{anketa}->{name} = $dir; 
	
	for my $file ($self->_get_files($dir)){
		my $is_folder = -d $rel_dir.'/'.$file ? 1 : 0;
		my $dir_file = $dir.'/'.$file;
		
		my $script = $is_folder ? 
					"openPage('center','styles_dir','$controller_url?do=mainpage&dir=$dir_file','Папка: $dir','$dir')" :
					"openPage('center','styles_$dir_file','$controller_url?do=edit&dir=$dir_file','Файл: $dir_file','$dir_file')";
  
		my %button_conf = (
   			"params" 		=> "config_table,first_flag",
       		"action" 		=> "mainpage",
       		"controller" 	=> "Styles",
       		"name"			=> $file,
       		"tabtitle"		=> $file,
       		"imageicon" 	=> $is_folder ? "/admin/img/icons/program/folder.png" : "/admin/img/icons/menu/icon_styles.png",
       		"classdiv"		=> "div_icons-big-text",
       		"classimg"		=> "image_icons",
       		"classhref"		=> "href_icons",
       		"title" 		=> $file,
       		"type_link" 	=> "openpage",
       		"script"		=> $script
   		);
			
		$body .= $self->render( partial => 1, template => 'Admin/icon', button => \%button_conf);			
	}

	my $content = $self->render( partial => 1, template => 'Admin/page_admin_main', body => $body);
	
	my $win_name = $self->cut( string => $dir, size => 15 );
	$self->stash->{win_name} = $win_name;
	
	my $items = [];

	if($dir){
		$items = [
				{
					type		=> 'settitle',
					id			=> "styles_dir",
					title		=> $win_name
				},
				{
					type		=> 'settabtitle',
					id			=> "styles_dir",
					title		=> $win_name
				},
				{
					type		=> 'showcontent',
					id			=> "styles_dir",
				},		
		];		
		
	} else {
		$self->stash->{enter} = 1;
		$items = $self->get_init_items( init => 'init_modul');
	}
#					
	
	my $result = {
		content	=> $content,
		items	=> $items,
	};
	
	$self->render( json => $result);
}

sub _get_files {
	my $self = shift;
	my $dir = shift;
	
	my $rel_dir = $self->app->static->paths->[0]."css/$dir";

	opendir(LAYOUT, $rel_dir) or die "Ошибка при чтение стилей $!";
	my @templates = grep(!/\.\.?$/, readdir LAYOUT);
	closedir(LAYOUT);
	
	
	my %dirs = ();
	my %files = ();
	foreach  (@templates){
		if(-d $rel_dir.'/'.$_){
			$dirs{$_} = 1;
		} else {
			$files{$_} = 1;
		}
	}
	
	my @dirs = sort keys %dirs;
	my @files = sort keys %files;
	my (@sort_templates) = (@dirs, @files); 
	
	return @sort_templates;
} # end of &get_CSSfiles


1;
