package GG::Admin::Plugins::InitJson;

use utf8;

use Mojo::Base 'Mojolicious::Plugin';

our $VERSION = '1';

sub register {
	my ( $self, $app, $opts ) = @_;

	$opts ||= {};

	$app->log->debug("register GG::Admin::Plugins::InitJson");

	$app->hook(
		before_dispatch => sub {
			my $self = shift;
			$self->stash->{_init_items} = [];
		}
	);

	$app->helper(
		init_items => sub {
			my $self = shift;
			if($_[0]){
				my $params	= ref $_[0] ? $_[0] : {@_};
				push @{ $self->stash->{_init_items} }, $params;
			} else {
				return shift->stash->{_init_items};
			}
		}
	);

	$app->helper(
		get_init_items => sub {
			my $self   = shift;
			my $params	= ref $_[0] ? $_[0] : {@_};

			my $items = [];
			if($params->{init} && !$self->stash->{not_init}){
				my $init = delete $params->{init};
				$items = $self->$init,
			}

			my $init_items = delete $self->stash->{_init_items} || [];
			push @$items, $_ foreach (@$init_items);

			return $items;

		}
	);

	$app->helper(
		init_main => sub {
			my $self   = shift;

			my $items = [
			{
				type		=> 'addcontent',
				position	=> 'east',
				id			=> 'hot_link',
				contenturl	=> '/admin/main/body?do=hot_link',
				pantitle	=> 'Недавние документы',
				tabtitle	=> 'Недавно'
			},
			{
				type		=> 'deletecontent',
				id			=> 'westContent'
			},
			{
				type		=> 'deletecontent',
				id			=> 'eastContent'
			},
			{
				type		=> 'showcontent',
				id			=> 'user_info'
			},
			{
				type		=> 'showpane',
				position	=> 'east'
			},
			{
				type		=> 'showpane',
				position	=> 'west'
			},
			{
				type		=> 'collapsepane',
				position	=> 'west',
				status		=> $self->sysuser->settings->{leftwin_hidden} ? 1 : 0,
			},
			{
				type		=> 'collapsepane',
				position	=> 'east',
				status		=> $self->sysuser->settings->{rightwin_hidden} ? 1 : 0,
			},
			{
				type		=> 'topmenu',
				display		=> 'block'
			},
			{
				type		=> 'loadjson',
				divid		=> 'menuButton',
				url			=> '/admin/main/menu_button'
			},
			{
				type		=> 'eval',
				value		=> 'load_topMenu();',
			},
			{
				type		=> 'showcontent',
				id			=> 'center'
			},
			{
				type		=> 'eval',
				value		=> "load_script('/admin/ckeditor/ckeditor.js');"
			},
			#{
			#	type		=> 'eval',
			#	value		=> "load_css('/admin/js/SpinBoxJs/Scripts/SpinBoxJs.css');",
			#},

			#'/admin/js/jquery/ui/jquery-ui.min.js',

			{
				type		=> 'eval',
				value		=> "load_css('/admin/css/tooltip.css');",

			},
			{
				type		=> 'eval',
				value		=> "load_script('/admin/js/jquery/jtip.js');",

			},
			{
				type		=> 'eval',
				value		=> qq|load_scripts({
										loading_key	: 'init_main',
										scripts		: [
											'/admin/js/tablelist.js',
											'/admin/js/form.js',
											'/admin/js/select_dir.js',
											'/admin/js/urlify.js',
											'/admin/js/drag-drop-folder-tree.js',
											'/admin/js/jquery/jquery.liteuploader.min.js'
										],
										success		: function(){}
									})
									|
			},

			{
				type		=> 'addcontent',
				position	=> 'west',
				id			=> 'user_info',
				contenturl	=> '/admin/main/body?do=user_block',
				pantitle	=> 'Информация о пользователе',
				tabtitle	=> 'Инфо'
			},
			];

			if(!$self->sysuser->settings->{leftwin_hidden}){
				push @$items, {
					type		=> 'expandPane',
					position	=> 'west',
					status		=> 1,
				};
			} else {
				push @$items, {
					type		=> 'collapsepane',
					position	=> 'west',
					status		=> 1,
				};
			}

			if(!$self->sysuser->settings->{rightwin_hidden}){
				push @$items, {
					type		=> 'expandPane',
					position	=> 'east',
					status		=> 1,
				};
			} else {
				push @$items, {
					type		=> 'collapsepane',
					position	=> 'east',
					status		=> 1,
				};
			}

			push @$items, {
					type		=> 'settabtitle',
					id			=> 'center',
					title		=> 'Главная'
			};

			return $items;
		}
	);

	$app->helper(
		init_modul => sub {
			my $self   = shift;
			my %params = @_;

			my $stash = $self->stash;
			$params{$_} ||= $stash->{$_} foreach keys %$stash;

			my $items = [
				{
					type		=> 'eval',
					value		=> "load_data('$params{replaceme}', '/admin/$params{controller}/body?do=list_items&$params{param_default}&table_flag=1&page=$$stash{page}')",

				},
#				{
#					type		=> 'showcontent',
#					id			=> 'center',
#				},
				{
					type		=> 'settitle',
					id			=> $params{replaceme},
					title		=> $params{win_name}
				},
				{
					type		=> 'settabtitle',
					id			=> $params{replaceme},
					title		=> $params{win_name}
				},
				{
					type		=> 'eval',
					value		=> "load_script('/admin/js/mselectboxes.js');",

				},
				# {
				# 	type		=> 'eval',
				# 	value		=> "load_css('/admin/css/calendar.css');",
				# },
				{
					type		=> 'settabtitle',
					id			=> 'center',
					title		=> $stash->{'controller_name'}.' » '.($self->stash->{ win_name } || 'Список')
				},
			];

			if($self->app->program->{settings}->{tree} and !$self->sysuser->settings->{leftwin_hidden}){

				push @$items, {
					type		=> 'expandPane',
					position	=> 'west',
					status		=> 1,
				};

				push @$items, {
					type		=> 'addcontent',
					position	=> 'west',
					id			=> $params{controller}.'_tree',
					contenturl	=> $stash->{script_link}.'?do=tree',
					pantitle	=> $stash->{controller_name},
					tabtitle	=> $stash->{controller_name}
				};
				push @$items, {
					type		=> 'showcontent',
					id			=> $params{controller}.'_tree',
				};

			} else {
				my $status = $self->sysuser->settings->{leftwin_hidden} || 0;
				$status = 1 unless $self->app->program->{settings}->{tree};

				push @$items, {
					type		=> 'collapsepane',
					position	=> 'west',
					status		=> $status,
				};
			}

			if($stash->{tree_reload} && !$self->sysuser->settings->{leftwin_hidden}){
				push @$items, {
					type		=> 'eval',
					value		=> "ld_content('pane_tree_".$stash->{controller}."','/admin/".$stash->{controller}."/body?do=tree', 1, 1);",
				};
			}


			if(!$self->sysuser->settings->{rightwin_hidden}){
				push @$items, {
					type		=> 'expandPane',
					position	=> 'east',
					status		=> 1,
				};
			} else {
				push @$items, {
					type		=> 'collapsepane',
					position	=> 'east',
					status		=> 1,
				};
			}

#			push @$items, {
#				type		=> 'collapsepane',
#				position	=> 'east',
#				status		=> $self->sysuser->settings->{rightwin_hidden} ? 1 : 0,
#			};
			if($stash->{enter}){
				push @$items, {
					type		=> 'loadjson',
					divid		=> 'menuButton',
					url			=> $stash->{script_link}.'?do=menu_button'
				};
			}

			# показываем первую вкладку
			unless($stash->{'showcontent_center_disabled'}){
				push @$items, {
					type		=> 'showcontent',
					id			=> 'center',
				};
			}
			return $items;
		}
	);

	$app->helper(
		init_anketa_edit => sub {
			my $self   = shift;
			my %params = @_;

			no warnings;

			my $stash = $self->stash;
			#$params{$_} ||= $stash->{$_} foreach keys %$stash;

			my $items = [];

			#if($stash->{anketa_ok} eq 'ok'){
			#}

			if($stash->{controller} eq 'templates'){
#				push @$items, {
#					type		=> 'eval',
#					value		=> "load_script('/admin/js/edit_area/edit_area_loader.js');",
#				};
#				push @$items, {
#					type		=> 'eval',
#					value		=> "load_script('/admin/js/edit_area-dop.js');",
#				};
			}
			if($stash->{multiselect_flag}){
				push @$items, {
					type		=> 'eval',
					value		=> "document.getElementById('link".$stash->{multiselect_flag}."').onclick = function() { if (document.getElementById('helpmultilist".$stash->{multiselect_flag}."').style.display=='none') { document.getElementById('link".$stash->{multiselect_flag}."').innerHTML='выключить подсказку по клику'; } else { document.getElementById('link".$stash->{multiselect_flag}."').innerHTML='включить подсказку по клику'; } swich_visible('helpmultilist".$stash->{multiselect_flag}."'); }",
				},
			}

			if($stash->{group} == 1){
				push @$items, {
					type		=> 'eval',
					value		=> "ld_content('hot_link', '/admin/main/body?do=hot_link', '', 1);",
				};
			}


			$items = [
				@$items,
				{
					type		=> 'eval',
					value		=> "eSubmit".$stash->{replaceme}."= function () {
								document.getElementById(id_block_submit['".$stash->{replaceme}."']).disabled = false;
								document.getElementById('dop' + id_block_submit['".$stash->{replaceme}."']).disabled = false;

								document.getElementById('continue_' + id_block_submit['".$stash->{replaceme}."']).disabled = false;
								document.getElementById('continue_dop' + id_block_submit['".$stash->{replaceme}."']).disabled = false;
							}",
				},
				{
					type		=> 'eval',
					value		=> "dSubmit".$stash->{replaceme}." = function () {
								document.getElementById(id_block_submit['".$stash->{replaceme}."']).disabled = true;
								document.getElementById('dop' + id_block_submit['".$stash->{replaceme}."']).disabled = true;

								document.getElementById('continue_' + id_block_submit['".$stash->{replaceme}."']).disabled = true;
								document.getElementById('continue_dop' + id_block_submit['".$stash->{replaceme}."']).disabled = true;
							}",

				},
				{
					type		=> 'eval',
					value		=> "id_block_submit['".$stash->{replaceme}."']='submit_".$stash->{replaceme}."';",
				},
				{
					type		=> 'eval',
					value		=> "formValObj['".$stash->{replaceme}."']=new DHTMLSuite.formValidator({ formRef:'form_".$stash->{replaceme}."',keyValidation:true,callbackOnFormValid:'eSubmit".$stash->{replaceme}."',callbackOnFormInvalid:'dSubmit".$stash->{replaceme}."',indicateWithBars:true });",
				},
				{
					type		=> 'eval',
					value		=> "formObj['".$stash->{replaceme}."']=new DHTMLSuite.form({ formRef:'form_".$stash->{replaceme}."',action:'$stash->{controller_url}',responseEl:'formResponse".$stash->{replaceme}."'});",
				},
				{
					type		=> 'eval',
					value		=> "link_list='".$stash->{request_list}."';",
				},
				{
					type		=> 'eval',
					value		=> "if(link_list.length > 0){requestList = link_list;}",
				},
			];

			if($stash->{_html_editor}){
				push @$items, {
					type		=> 'eval',
					value		=> "editor_init('form_".$stash->{replaceme}."');",
				};
			}

			if($stash->{multilist_init}){
				push @$items, {
					type		=> 'eval',
					value		=> "multilist_init('form_".$stash->{replaceme}."');",
				};
			}

			# Для поля с деревом структуры
			if($stash->{flag_select_dir}){
				push @$items, {
					type		=> 'eval',
					value		=> qq|load_scripts({
										loading_key	: 'select_dir',
										scripts		: ['/admin/js/select_dir.js'],
										success		: function(){ init_select_dir('$$stash{flag_select_dir}'); }
									})
									|
				};
			}

			push @$items, {
				type		=> 'eval',
				value		=> "editFormInit('form_".$stash->{replaceme}."');",
			};

			# if new entry title = subtitle = Новая запись
			if($stash->{replaceme} eq 'newentry' && !$stash->{index}){
				$stash->{win_name} = $stash->{anketa}->{name} = 'Новая запись';
			}

			$items = [
				@$items,
				{
					type		=> 'settitle',
					id			=> $stash->{replaceme},
					title		=> $self->cut( string => $stash->{win_name}, size => 50),
				},
				{
					type		=> 'settabtitle',
					id			=> $stash->{replaceme},
					title		=> $self->cut( string => $stash->{anketa}->{name} ? $stash->{anketa}->{name} : $stash->{controller_name}.$stash->{index}, size => 15 ),
				},
			];


			if($stash->{tree_reload} && !$self->sysuser->settings->{leftwin_hidden}){
				push @$items, {
					type		=> 'eval',
					value		=> "ld_content('pane_tree_".$stash->{controller}."','/admin/".$stash->{controller}."/body?do=tree', 1, 1);",
				};
			}

			return $items;
		}
	);

	$app->helper(
		init_anketa_info => sub {
			my $self = shift;

			my $stash = $self->stash;
			my $items = [];

			if($self->send_params->{'do'} eq 'save' or $self->send_params->{'do'} eq 'restore'){
				if($stash->{controller} ne 'keys'){
					push @$items, {
						type		=> 'eval',
						value		=> "ld_content('table".$stash->{controller}."', '/admin/".$stash->{controller}."/body?do=list&table_flag=1', '', 1);",
					};
				}
				if($stash->{tree_reload} && !$self->sysuser->settings->{leftwin_hidden}){
					push @$items, {
						type		=> 'eval',
						value		=> "ld_content('pane_tree_".$stash->{controller}."', '/admin/".$stash->{controller}."/body?do=tree', 1, 1);",
					};
				}
			}

			push @$items, {
				type		=> 'eval',
				value		=> "ld_content('hot_link', '/admin/main/body?do=hot_link', '', 1);",
			};

			push @$items, {
				type		=> 'eval',
				value		=> "setTimeout(\"inittabs('".$stash->{replaceme}."', Array(".$stash->{group_name_list}."), Array())\", 100);",
			};
			# push @$items, {
			# 	type		=> 'eval',
			# 	value		=> "setTimeout(\"init_tableWidget();\", 1000);",
			# };

			push @$items, {
				type		=> 'settitle',
				id			=> $stash->{replaceme},
				title		=> $self->cut( string => $stash->{win_name}, size => 50)
			};
			push @$items, {
				type		=> 'settabtitle',
				id			=> $stash->{replaceme},
				title		=> $self->cut( string => $stash->{anketa}->{name} ? $stash->{anketa}->{name} : $stash->{controller_name}.$stash->{index}, size => 15 ),
			};

			if(!$self->sysuser->settings->{$stash->{controller}.'_qedit_off'} ){
				push @$items, {
					type		=> 'eval',
					value		=> "setTimeout(\"init_qedit_info('".$stash->{replaceme}."')\", 500);",
				};
			}

			return $items;
		}
	);

	$app->helper(
		init_anketa_delete => sub {
			my $self = shift;

			my $stash = $self->stash;
			my $items = [];

			if($stash->{tree_reload} && !$self->sysuser->settings->{leftwin_hidden}){
				push @$items, {
						type		=> 'eval',
						value		=> "ld_content('pane_tree_".$stash->{controller}."', '/admin/".$stash->{controller}."/body?do=tree', 1, 1);",
				};
			}

			return $items;
		}
	);


	$app->helper(
		init_save_filter => sub {
			my $self = shift;

			my $stash = $self->stash;
			my $items = [];

			push @$items, {
					type		=> 'eval',
					value		=> "ld_content('".$stash->{replaceme}."', '".$stash->{controller_url}."?do=list_container".$stash->{param_default}."', '', 1)",
			};
			push @$items, {
					type		=> 'eval',
					value		=> "closeMessage(3);",
			};

			return $items;
		}
	);

	$app->helper(
		init_tablelist_reload => sub {
			my $self = shift;

			my $stash = $self->stash;

			my $items = [];

			push @$items, {
					type		=> 'eval',
					value		=> "ld_content('".$stash->{replaceme}."', '".$stash->{controller_url}."?do=list_container".$stash->{param_default}."', '', 1)",
			};
			push @$items, {
					type		=> 'eval',
					value		=> "closeMessage(4);",
			};

			return $items;
		}
	);

	# Сохранение модального окна типа win
	$app->helper(
		init_win_save => sub {
			my $self = shift;

			my $stash = $self->stash;
			return $self->init_tablelist_reload() unless $self->stash->{flag_win};

			my $items = [];

			if($self->has_errors){

				my $msg = $self->dbh->quote($self->admin_msg_errors);
				push @$items, {
						type		=> 'eval',
						value		=> "jQuery('#replaceme_win".$self->stash->{replaceme}." h3:first').html($msg); ",
				};

			} else {
				my $index = $stash->{index_old} || $stash->{index};
				push @$items, {
						type		=> 'eval',
						value		=> "addOption('$$stash{lfield}', '$$stash{name}', '$index');",
				};
				push @$items, {
						type		=> 'eval',
						value		=> "closeMessage(4);",
				};
			}

			return $items;
		}
	);

	$app->helper(
		init_dop_tablelist_reload => sub {
			my $self = shift;

			my $stash = $self->stash;
			return $self->init_win_save() if $self->stash->{flag_win};

			my $main_url = $self->url_for('admin_routes', controller => 'main', action => 'body');
			my $items = [];

			if($self->has_errors){

				push @$items, {
						type		=> 'eval',
						value		=> "ld_content('replaceme_doptable_".$stash->{replaceme}.$stash->{lfield}.$stash->{index}."', '".$main_url."?do=load_table&replaceme=".$stash->{replaceme}."&access_flag=".$stash->{access_flag}."&index=".$stash->{index}."&lfield=".$stash->{lfield}."');",
				};
				push @$items, {
						type		=> 'eval',
						value		=> "closeMessage(4);",
				};
				push @$items, {
						type		=> 'eval',
						value		=> "setTimeout('init_tableWidget()', 1500);",
				};

			} else {
				push @$items, {
						type		=> 'eval',
						value		=> "ld_content('replaceme_doptable_".$stash->{replaceme}.$stash->{lfield}.$stash->{index}."', '".$main_url."?do=load_table&replaceme=".$stash->{replaceme}."&access_flag=".$stash->{access_flag}."&index=".$stash->{index}."&lfield=".$stash->{lfield}."');",
				};
				push @$items, {
						type		=> 'eval',
						value		=> "closeMessage(4);",
				};
				push @$items, {
						type		=> 'eval',
						value		=> "setTimeout('init_tableWidget()', 1500);",
				};
			}

			return $items;
		}
	);


	$app->helper(
		init_null_block => sub {
			my $self = shift;

			my $stash = $self->stash;
			my $items = [];

			push @$items, {
					type		=> 'settitle',
					id			=> $stash->{replaceme},
					title		=> $stash->{page_name}
			};
			push @$items, {
					type		=> 'settabtitle',
					id			=> $stash->{replaceme},
					title		=> $stash->{name} || $stash->{page_name} ||  $stash->{controller_name}.$stash->{index}
			};

			return $items;
		}
	);
}

1;