package GG::Admin::Main;

use utf8;

use Mojo::Base 'GG::Admin::AdminController';

sub body{
	my $self = shift;
	
	
	my $do = $self->param('do');

	given ($do){
		
		when('mainpage') 				{ $self->mainpage; }
		#when('nothing') 				{ $self->nothing; }
		when('user_block') 				{ $self->user_block; }
		when('menu_button') 			{ $self->menu_button; }
		when('menu_top') 				{ $self->menu_top; }
		when('settings_panel') 			{ $self->settings_panel; }
		when('clear_settings') 			{ $self->settings_panel( clear => 1); }

		when('chlang') 					{ 
			$self->sysuser->save_settings(lang => $self->param('lang'));
			$self->mainpage; 
		}
				
		when('upload_tmp_thumbview') 	{ $self->file_upload_tmp_thumbview; }
				
		# Поля с поиском по подстроке
		when('lists_select') 			{ $self->lists_select_search; }
		
		# Настройка колонок
		when('def_col') 				{ $self->defcol; }
		
		# Экспорт в Excel
		when('excel') 					{ 
			$self->app->plugin('excel');
			$self->export_config; 	
		}
		when('lists_select') 			{ $self->lists_select; }
		
		when('load_table') 				{ $self->field_dop_table_reload; }
		when('hot_link') 				{ $self->hot_link; }
		
		default							{ $self->render_text("действие не определенно"); }
	}
}

sub hot_link{
	my $self = shift;
	
	
	my $id_user = $self->app->sysuser->userinfo->{ID};
	my $items = $self->dbi->query(qq/
		SELECT `link` 
		FROM `sys_history`
		WHERE `id_user`='$id_user' ORDER BY `rdate` DESC LIMIT 0,20/)->hashes;

	$self->render( items => $items, template => 'Admin/Main/hot_link');	
}

sub settings_panel{
	my $self = shift;
	my %params = @_;
	
	foreach (qw(leftwin_hidden rightwin_hidden)){
		my $value = $self->param($_) || '';
		$value = 0 if $params{clear};
		$self->sysuser->save_settings($_ => $value);	
	}
	
	my $mode = $self->param('mode') ? 'development' : 'production';
	$self->setVar(key => 'mode', value => $mode);

	return $self->user_block;
}

sub mainpage{
	my $self = shift;

	$self->sysuser->save_settings(lang => "ru") if (!$self->sysuser->settings->{lang});
	
	$self->get_keys( type => ['lkey', 'button'], controller => 'global', no_global => 1);

	my $user_lang = $self->sysuser->settings->{lang};

	my (%main_menu);
	my $app = $self->app;
	
	# Получаем список всех доступных модулей
	for my $row  ($self->dbi->query("SELECT * FROM `sys_program` WHERE `$user_lang`='1'")->hashes){
		
		my $button = $app->button( name => $$row{key_razdel}, controller => 'global');
		
		unless($button){
			$self->app->log->error(__PACKAGE__." button $$row{key_razdel} NOT FOUND!");
			next;
		}
		
		
		$button->def_icons;
		
		my %button_conf = (
			lkey		=> $$row{key_razdel},
			classdiv	=> 'div_icons',
			title		=> $row->{name},
			classhref	=> 'href_icons',
			classimg	=> 'image_icons',
			imageicon	=> $$row{pict},
			name		=> $button->{name},
			script		=> $button->{settings}->{script}
		);

		if( $self->sysuser->sys or exists($self->sysuser->access->{modul}->{ $$row{ID} }) ){
			$main_menu{ $$row{prgroup} } .= $self->render_partial(template => 'Admin/icon', button => \%button_conf)
		}
	}
	
	$self->def_list( name => 'panel_razdel', controller => 'global');
	my $panelsList = $app->lkey(name => 'panel_razdel', controller => 'global', setting => 'list');
	
	my $body;
	foreach (sort keys %$panelsList){
		$body .= qq{<tr><td><br><h2>$$panelsList{$_}:</h2><br>$main_menu{$_}</td></tr>} if $main_menu{$_};
	}

	my $result = {
			content	=> $self->render_partial(	body		=> $body,
												template	=> 'Admin/block_admin_main'),
			items	=> $self->init_main,
	};

	$self->render_json($result);
}

sub user_block{
	my $self = shift;

	my $login = $self->sysuser->{userinfo}->{login};
	
	if($self->getArraySQL(
					select	=> "vdate",
					from	=> "sys_users",
					where	=> "`login` = '$login' and ((unix_timestamp(NOW()) - unix_timestamp(`vdate`) > 60*60*3) or (`vdate` = '0000-00-00 00:00:00'))",
					sys		=> 1,
		)){
		$self->dbi->query("UPDATE `sys_users` SET `vdate`=NOW() WHERE `login`='$login'");				
	}
		
	$self->render(	template	=> "Admin/Main/user_block");
}

sub menu_button{
	my $self 	= shift;
	
	$self->def_menu_button();
}

sub menu_top{
	my $self 	= shift;
	
	my $app = $self->app;
	
	my $moduls = {};
	my $items = [];
	
	$self->get_keys( type => ['button'], controller => 'global', no_global => 1, validator => 0);

	my $user_sys = $self->sysuser->sys;
	$self->app->sysuser->getAccess(modul => $b) unless $user_sys;
	
	my $buttons = $self->app->buttons->{'global'};
	my $access_buttons = $self->sysuser->access->{button} || {};
	my $user_lang = $self->sysuser->settings->{lang} || 'ru';
	my $is_msie = 0;
	if($ENV{'HTTP_USER_AGENT'} && ($ENV{'HTTP_USER_AGENT'} =~ /MSIE 8.0/ or $ENV{'HTTP_USER_AGENT'} =~ /MSIE 7.0/) ){
		$is_msie = 1;
	}

		
	for my $row  ($self->dbi->query("SELECT `ID`,`name`,`menu_btn_key`,`key_razdel` FROM `sys_program` WHERE `$user_lang`='1' AND `prgroup` IN (1, 2, 3) ORDER BY `prgroup`, `name`")->hashes){
		next if( !$self->sysuser->sys and !exists($self->sysuser->access->{modul}->{ $$row{ID} }) );
		
		unless ($moduls->{$row->{ID}}){
			$moduls->{$row->{ID}} = '1'.sprintf("%04d", $row->{ID} );
			
			#my $icon = $app->buttons->{ $$row{'key_razdel'} }->{'settings'}->{'imageiconmenu'} || '';
						
			push @$items, {
				type		=> 'eval',
				value		=> "menuTop.addItem(".$moduls->{$row->{ID}}.",'$$row{name}','','',false,'$$row{name}','');"
			};

			push @$items, {
				type		=> 'eval',
				value		=> "menuTop.setSubMenuWidth(".$moduls->{$row->{ID}}.",200);",
			};
			
			my $sch = 1;
			if(my $button_key = $$row{'key_razdel'}.'_topmenu'){
				foreach my $b (sort {$$buttons{$a}{settings}{rating} <=> $$buttons{$b}{settings}{rating}} keys %$buttons) {
					my $button = $$buttons{$b};
					
					next if ($b eq 'admin' or $b eq 'logout');
					next if (!$$button{settings}{$button_key} or (!$access_buttons->{$b}->{r} and !$user_sys));

					if( $button->{settings}->{'do'} && substr($button->{settings}->{'do'}, 0, 14) eq 'list_container'){
						$button->{settings}->{'do'} = 'enter'.substr($button->{settings}->{'do'}, 14)
					}
										
					$button->def_params_button();
					$button->def_script_button();
					
					my $icon = $button->{'settings'}->{'imageiconmenu'} || '';
					
					# Скрываем иконки т.к. IE 7/8 не поддерживают css background-size
					$icon = '' if $is_msie;
					
					if($b eq 'texts'){
						my $access_where = $self->def_access_where( base => 'lst_texts', show_empty => 0);
						
						$self->getHashSQL(	select	=> 	'*',
											from	=>	'lst_texts',
											where	=> 	"`".$self->sysuser->settings->{'lang'}."`='1' $access_where",
											sys		=> 1,
											stash	=> 	'texts');
						my $razdel = $self->stash->{texts} || [];
						my $settings = $button->{settings};
						
						$self->get_keys( type => ['button'], controller => $b, no_global => 1, validator => 0);
						my $buttonByController = $self->app->buttons->{$b};
						
						$self->app->sysuser->getAccess(modul => $b);

						foreach my $r (@$razdel){
							my $txtTable = 'texts_'.$r->{key_razdel}.'_'.$user_lang;
													
							if($user_sys or $self->sysuser->access->{table}->{$txtTable}->{w}){
								my $script = "ld_content('$$settings{replaceme}','$$settings{program}&$$button{params_string}&razdel=$$r{ID}')";
								push @$items, {
									type		=> 'eval',
									value		=> "menuTop.addItem(".$sch.$moduls->{$row->{ID}}.",\"$$r{name}\",\"$icon\",\"\",".$moduls->{$row->{ID}}.", \"$$r{name}\" ,\"$script\");"
								};			
			
								push @$items, {
									type		=> 'eval',
									value		=> "menuTop.setSubMenuWidth(".$sch.$moduls->{$row->{ID}}.",200);",
								};
								
								# Добавление записи в тестовый раздел
								
								if($buttonByController->{add_link} && ($user_sys or ($self->sysuser->access->{button}->{add_link} && $self->sysuser->access->{button}->{add_link}->{r} ) )){
									my $buttonAdd = $$buttonByController{'add_link'};
									$buttonAdd->def_params_button({
										controller => $b,
									});
									$buttonAdd->def_script_button();
									my $settingsAddBtn = $buttonAdd->{settings};
									my $scriptAdd = "ld_content('$$settings{replaceme}','$$settingsAddBtn{program}&$$button{params_string}&razdel=$$r{ID}&list_table=$txtTable')";

									push @$items, {
										type		=> 'eval',
										value		=> "menuTop.addItem(".$sch.$sch.$moduls->{$row->{ID}}.",'Добавить запись','/admin/img/icons/menu/icon_add.png','',".$sch.$moduls->{$row->{ID}}.",'',\"$scriptAdd\")",
									};								
								}
								$sch++;
							}
															
						}
					} else {
						push @$items, {
							type		=> 'eval',
							value		=> "menuTop.addItem(".$sch.$moduls->{$row->{ID}}.",\"$$button{name}\",\"$icon\",\"\",".$moduls->{$row->{ID}}.", \"$$button{name}\" ,\"$$button{settings}{script}\");"
						};			
	
						push @$items, {
							type		=> 'eval',
							value		=> "menuTop.setSubMenuWidth(".$sch.$moduls->{$row->{ID}}.",200);",
						};
						$sch++;						
					}
					
				}				
			}
						
		}
		
	}

	@$items =  (@$items, (
		{
			type		=> 'eval',
			value		=> "menuTop.init();"
		},
		{
			type		=> 'eval',
			value		=> "menuTopBar.addMenuItems(menuTop);"
		},	
		{
			type		=> 'eval',
			value		=> "menuTopBar.setTarget('innerDiv');"
		},	
		{
			type		=> 'eval',
			value		=> "menuTopBar.init();"
		},	
	) );
				
	$self->render_json({
		content	=> 'OK',
		items	=> $items,
	});
}

1;
