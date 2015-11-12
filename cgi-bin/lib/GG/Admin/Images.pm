package GG::Admin::Images;

use utf8;

use Mojo::Base 'GG::Admin::AdminController';

sub _init {
  my $self = shift;

  $self->def_program('images');

  $self->get_keys(type => ['lkey', 'button'], controller => $self->app->program->{key_razdel});

  my $config = {controller_name => $self->app->program->{name},};
  $self->stash->{img_razdel} = 'lst_images';

#my $access_where = $self->def_access_where( base => $self->stash->{img_razdel}, show_empty => 0);

  if ($self->param('list_table')) {
    my (undef, $kr) = split(/_/, $self->param('list_table'));
    $self->stash->{key_razdel} = $kr;
    $self->getArraySQL(
      select => '`ID` AS `razdel`,`name` AS `name_razdel`',
      from   => $self->stash->{img_razdel},
      where  => "`key_razdel`='$kr'",
      sys    => 1,
      stash  => '',
    );
  }

  unless ($self->sysuser->settings->{'images_razdel'}) {
    $self->getArraySQL(
      select => '`ID` AS `razdel`,`key_razdel`,`name` AS `name_razdel`',
      from   => $self->stash->{img_razdel},
      where  => "1",
      sys    => 1,
      stash  => ''
    );

    $self->sysuser->save_settings(images_razdel => $self->stash->{razdel});
  }

  $self->stash->{razdel} = $self->send_params->{razdel} || $self->sysuser->settings->{'images_razdel'};

  if (
    !$self->stash->{key_razdel}
    && (
      !$self->stash->{razdel}
      or !$self->getArraySQL(
        select => '`ID` AS `razdel`,`key_razdel`,`name` AS `name_razdel`',
        from   => $self->stash->{img_razdel},
        where  => "`ID`='" . $self->stash->{razdel} . "'",
        sys    => 1,
        stash  => ''
      )
    )
    )
  {

    unless (
      $self->getArraySQL(
        select => '`ID` AS `razdel`,`key_razdel`,`name` AS `name_razdel`',
        from   => $self->stash->{img_razdel},
        where  => "1",
        sys    => 1,
        stash  => ''
      )
      )
    {
      $self->admin_msg_errors("Доступных данных нет");
    }
  }

  unless ($self->send_params->{replaceme}) {
    $self->send_params->{replaceme} = $self->stash->{controller};
    $self->stash->{replaceme} = $self->send_params->{replaceme} .= '_' . $self->stash->{list_table}
      if $self->stash->{list_table};
  }

  if ($self->send_params->{razdel} and $self->param('do') ne 'chrazdel') {
    $self->changeRazdel;
  }

  $self->stash->{win_name} = $self->stash->{name_razdel};

  $self->stash->{list_table} = 'images_' . $self->stash->{key_razdel};

  $self->stash($_, $config->{$_}) foreach (keys %$config);

  $self->stash->{index} ||= $self->send_params->{index};
  $self->stash->{group} ||= $self->send_params->{group} || 1;


  foreach (qw(list_table replaceme)) {
    $self->param_default($_ => $self->send_params->{$_}) if $self->send_params->{$_};
  }

  $self->stash->{replaceme} = $self->send_params->{replaceme};
  $self->stash->{lkey}      = $self->stash->{controller};
  $self->stash->{lkey} .= '_' . $self->send_params->{list_table} if $self->send_params->{list_table};
  $self->stash->{script_link} = '/admin/' . $self->stash->{controller} . '/body';


  if ($self->dbi->exists_keys(table => $self->stash->{list_table}, lkey => 'image_' . $self->stash->{key_razdel})) {
    $self->stash->{dir_field} = 'image_' . $self->stash->{key_razdel};
  }
  else {
    $self->stash->{dir_field} = '';
  }

  #Groupname
  my $kr         = $self->stash->{key_razdel};
  my $list_table = $self->stash->{list_table};
  if ($list_table && $program->{settings}->{'groupname_' . $list_table}) {
    $self->app->program->{groupname} = $self->app->program->{settings}->{'groupname_' . $list_table};
  }
  elsif ($kr && $self->app->program->{settings}->{'groupname_' . $kr}) {
    $self->app->program->{groupname} = $self->app->program->{settings}->{'groupname_' . $kr};
  }

}

sub body {
  my $self = shift;

  $self->_init;

  my $do = $self->param('do');

  given ($do) {

    when ('list_container') { $self->list_container; }


    default {
      $self->default_actions($do);
    }
  }
}

sub changeRazdel {
  my $self = shift;

  $self->sysuser->save_ses_settings(images_razdel                         => $self->send_params->{razdel});
  $self->sysuser->save_ses_settings($self->stash->{replaceme} . '_sfield' => 'ID');

  #$self->sysuser->save_settings(images_razdel => $self->send_params->{razdel});
  #$self->sysuser->save_settings($self->stash->{replaceme}.'_sfield' => 'ID');
  $self->stash->{razdel} = $self->send_params->{razdel};
}

sub zipimport {
  my $self = shift;

  $self->param_default('lfield' => 'pict');

  my @keys = qw(zip);
  push @keys, $self->stash->{dir_field};

  $self->param_default('list_table' => $self->stash->{list_table});

  $self->define_anket_form(template => 'anketa_zipimport', access => 'w', render_html => 1, keys => \@keys);
}

sub zipimport_save {
  my $self = shift;

  my $files = $self->file_extract_zip(path => $self->file_tmpdir . $self->send_params->{zip});

  my $html = $self->render_to_string(files => $files, template => 'Admin/Plugins/File/zipimport_img_node');

  $self->render(json => {html => $html, count => scalar(@$files)});
}

sub zipimport_save_pict {
  my $self = shift;

  my $lfield = $self->send_params->{lfield};

  if ($self->file_save_pict(filename => $self->send_params->{filename}, lfield => $lfield,)) {
    my $item_name = $self->send_params->{filename};

    $item_name =~ s/\.[^.]+$//gi;

    my $vals = {name => $self->send_params->{filename}, viewimg => 1, rating => 99,};
    if ($self->dbi->exists_keys(from => $self->stash->{list_table}, lkey => "alias")) {
      $vals->{"alias"} = $self->check_unique_field(
        field => 'alias',
        value => $self->transliteration($item_name),
        table => $self->stash->{list_table}
      ) || '';
    }
    if ($self->dbi->exists_keys(from => $self->stash->{list_table}, lkey => "image_" . $self->stash->{key_razdel})) {
      $vals->{"image_" . $self->stash->{key_razdel}} = $self->send_params->{'image_' . $self->stash->{key_razdel}} || 0;
    }

    $self->save_info(table => $self->stash->{list_table}, field_values => $vals);
  }

  my $item
    = $self->dbi->query(
    "SELECT `pict`,`folder` FROM `" . $self->stash->{list_table} . "` WHERE `ID`='" . $self->stash->{index} . "'")
    ->hash;

  my $folder = $self->lfield_folder(lfield => $lfield) || $item->{folder};
  $self->render(json => {filename => $item->{pict}, src => $folder . $item->{pict}});
}


sub lists_select {
  my $self = shift;

  my $lfield = $self->param('lfield');
  $lfield =~ s{^fromselect}{};
  my $keystring = $self->param('keystring');

  my $selected_vals = $self->send_params->{$lfield};
  $selected_vals =~ s{=}{,}gi;

  my $sch      = 0;
  my $list_out = "";

  my $where = "`ID` > 0";
  $where .= " AND `name` LIKE '%$keystring%' ORDER BY `name`";

  my (@array_lang);
  foreach ($self->dbi->getTablesSQL()) {
    if ($_ =~ m/texts_main_([\w]+)/) { push(@array_lang, $1); }
  }

  # Смотрим в разделах:
  for my $item ($self->dbi->query("SELECT `ID`,`name`,`key_razdel` FROM `lst_texts` WHERE $where")->hashes) {
    my $name = &def_name_list_select("Раздел: ", $item->{name});
    my $index = "$$item{key_razdel}:0";
    $list_out .= "lstobj[out].options[lstobj[out].options.length] = new Option('$name', '$index');\n" if $name;

    $sch++;
  }

  foreach my $l (@array_lang) {
    for my $item ($self->dbi->query("SELECT `ID`,`name` FROM `texts_main_${l}` WHERE $where")->hashes) {
      my $name = &def_name_list_select("Страница ($l): ", $item->{name});

      my $index = "$l:main:$$item{ID}";
      $list_out .= "lstobj[out].options[lstobj[out].options.length] = new Option('$name', '$index');\n" if $name;

      $sch++;
    }
  }
  $list_out
    .= "document.getElementById('ok_' + out).innerHTML = \"<span style='background-color:lightgreen;width:45px;padding:3px'>найдено: "
    . $sch
    . "</span>\";\n";
  $self->render(text => $list_out);

  sub def_name_list_select {
    my ($title, $name) = @_;

    $name =~ s/&laquo;/"/;
    $name =~ s/&raquo;/"/;
    $name =~ s/["']+//g;

    return $title . $name;
  }

}

sub save {
  my $self   = shift;
  my %params = @_;

  my $table = $self->stash->{list_table};

  $self->backup_doptable;

  if ($self->save_info(%params, table => $table)) {

    if ($params{continue}) {
      $self->admin_msg_success("Данные сохранены");
      return $self->edit;
    }
    elsif ($self->stash->{group} >= $#{$self->app->program->{groupname}} + 1) {
      return $self->info;
    }
    $self->stash->{group}++;
  }

  if ($self->stash->{dop_table}) {
    $self->restore_doptable;
    return $self->render(json => {content => "OK", items => $self->init_dop_tablelist_reload(),});
  }
  return $self->edit;

}

sub info {
  my $self   = shift;
  my %params = @_;

  my $table = $self->stash->{list_table};

  if ($self->send_params->{flag_add}) {
    $self->def_context_menu(lkey => 'add_info');
  }
  else {
    $self->def_context_menu(lkey => 'print_info');
  }

  if ($self->stash->{index}) {
    $self->getArraySQL(
      from  => $self->stash->{list_table},
      where => "`ID`='" . $self->stash->{index} . "'",
      stash => 'anketa'
    );
  }

  $self->define_anket_form(access => 'r', table => $table, noget => 1);
}

sub edit {
  my $self   = shift;
  my %params = @_;

  $self->def_context_menu(lkey => 'edit_info');

  # Создание папки
  if ($params{dir}) {
    $self->stash->{page_name}
      = "Создание новой папки в разделе «" . $self->stash->{name_razdel} . "»";
    $self->param_default('dir' => $self->stash->{anketa}->{dir} = 1);
  }

  if ($self->stash->{dop_table}) {
    $self->backup_doptable();
  }

  if ($self->stash->{index}) {
    $self->getArraySQL(
      from  => $self->stash->{list_table},
      where => "`ID`='" . $self->stash->{index} . "'",
      stash => 'anketa'
    );

  }


  $self->define_anket_form(access => 'w', noget => 1);
}

sub list_container {
  my $self   = shift;
  my %params = @_;

  $self->changeRazdel if $self->param('razdel');

  $self->delete_list_items(has_pict => 1) if $self->stash->{delete};
  $self->hide_list_items(lfield => 'viewimg') if $self->param('hide');
  $self->show_list_items(lfield => 'viewimg') if $self->param('show');

  $self->stash->{enter} = 1 if ($params{enter});

  if ($self->dbi->exists_keys(table => $self->stash->{list_table}, lkey => "dir")) {
    $self->def_context_menu(lkey => 'table_list_dir');
  }
  else {
    $self->def_context_menu(lkey => 'table_list');
  }

  $self->stash->{listfield_groups_buttons}
    = {delete => "удалить", show => 'публиковать', hide => 'скрыть'};

  return $self->list_items(%params, container => 1);
}

sub list_items {
  my $self   = shift;
  my %params = @_;

  my $list_table = $self->stash->{list_table};
  $self->render_not_found unless $list_table;

  $self->stash->{listfield_buttons} = [qw(delete edit print)];

  $params{table} = $list_table;

  $self->define_table_list(%params);
}

sub tree {
  my $self = shift;

  my $controller = $self->stash->{controller};
  my $table      = $self->stash->{list_table};

  $self->stash->{param_default} .= "&first_flag=1";

  $self->param_default('replaceme' => '');

  my $folders
    = $self->getHashSQL(from => $self->stash->{img_razdel}, sys => 1, where => "1 " . $self->stash->{access_where},)
    || [];

  my @tmp = ();
  foreach (@$folders) {

    #$folders->[$i]->{replaceme} = $controller.$table;#$folders->[$i]->{ID};
    my $table = "images_" . $_->{key_razdel};

    push @tmp, {

      #ID            => $controller . $_->{ID},
      name          => $_->{name},
      param_default => "&list_table=" . $table . "&first_flag=1",
      replaceme     => 'replaceme',                                 # $controller.$table,
      tabname       => $table,
      click_type    => 'list',
      params        => {razdel => $_->{ID}},
      }
      if $self->sysuser->access->{table}->{$table}->{r};
  }

  $self->render(folders => \@tmp, items => [], template => 'Admin/tree_block');
}

sub tree_block {
  my $self = shift;

  my $items      = [];
  my $index      = $self->stash->{'index'} || 0;
  my $controller = $self->stash->{'controller'};
  my $table      = $self->stash->{'list_table'};

  $self->param_default('replaceme' => '');

  if ($self->sysuser->access->{table}->{$table}->{r}) {
    my $select = "`ID`,`name`,`type_file`";
    $select .= ", `dir` " if $self->dbi->exists_keys(table => $table, lkey => "dir");

    $items = $self->getHashSQL(
      select => $select,
      from   => $table,
      where  => ($self->stash->{dir_field} ? "`" . $self->stash->{dir_field} . "`='$index' " : " `ID`>0 ")
        . " ORDER BY `dir` DESC, `created_at` DESC ",
    ) || [];

    foreach my $i (0 .. $#$items) {
      my $item = $items->[$i];
      if ($item->{dir}) {

        $items->[$i]->{flag_plus}  = 1;
        $items->[$i]->{replaceme}  = $controller;
        $items->[$i]->{click_type} = 'list_filtered';
        $items->[$i]->{params} = {$self->stash->{dir_field} => $items->[$i]->{ID}, razdel => $self->stash->{razdel},};

      }
      elsif ($item->{type_file}) {
        $items->[$i]->{icon} = $items->[$i]->{type_file};
      }
      else {
        $items->[$i]->{icon} = 'image';
      }

      $items->[$i]->{key_element}   = $table;
      $items->[$i]->{tabname}       = $table . $item->{ID};
      $items->[$i]->{replaceme}     = $controller . '_' . $table . $items->[$i]->{ID};
      $items->[$i]->{param_default} = "&list_table=$table&replaceme=" . $items->[$i]->{replaceme};
    }
  }

  $self->render(
    json => {
      content => $self->render_to_string(items => $items, template => 'Admin/tree_elements'),
      items => [{type => 'eval', value => "treeObj['" . $self->stash->{controller} . "'].initTree();"},]
    }
  );

}

1;
