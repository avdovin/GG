package GG::Admin::Vars;

use utf8;

use Mojo::Base 'GG::Admin::AdminController';

sub _init {
  my $self = shift;

  $self->def_program('vars');

  $self->get_keys(
    type       => ['lkey', 'button'],
    controller => $self->app->program->{key_razdel}
  );

  my $config = {
    controller_name => $self->app->program->{name},

    #controller		=> 'keys',
  };

  $self->stash->{list_table} = 'sys_vars';

  $self->stash($_, $config->{$_}) foreach (keys %$config);

  $self->stash->{index} ||= $self->send_params->{index};
  unless ($self->send_params->{replaceme}) {
    $self->send_params->{replaceme} = $self->stash->{controller};
    $self->send_params->{replaceme} .= '_' . $self->stash->{list_table}
      if $self->stash->{list_table};
  }

  #$self->send_params->{replaceme} .= $self->stash->{index} || '';

  foreach (qw(list_table replaceme)) {
    $self->param_default($_ => $self->send_params->{$_})
      if $self->send_params->{$_};
  }

  $self->stash->{replaceme} = $self->send_params->{replaceme};
  $self->stash->{lkey}      = $self->stash->{controller};
  $self->stash->{lkey} .= '_' . $self->send_params->{list_table}
    if $self->send_params->{list_table};
  $self->stash->{script_link}
    = '/admin/' . $self->stash->{controller} . '/body';
}

sub body {
  my $self = shift;

  $self->_init;

  my $do = $self->param('do');

  $self->def_access_where(base => $self->stash->{list_table}, show_empty => 0);

  given ($do) {

    when ('list_container') { $self->list_container; }

    default {
      $self->default_actions($do);
    }
  }
}

sub tree {
  my $self = shift;

  my $controller = $self->stash->{controller};
  my $table      = $self->stash->{list_table};

  $self->stash->{param_default} .= "&first_flag=1";

  $self->param_default('replaceme' => '');

  my $folders
    = $self->getHashSQL(from => 'sys_program', where => "`ID`>0", sys => 1)
    || [];

  foreach my $i (0 .. $#$folders) {
    $folders->[$i]->{replaceme} = $table . $folders->[$i]->{ID};
  }

  my $items = $self->getHashSQL(
    select => "`ID`,`name`,`envkey`",
    from   => 'sys_vars',
    where  => "`id_program`='0' " . $self->stash->{access_where}
  ) || [];

  foreach my $i (0 .. $#$items) {
    $items->[$i]->{icon}      = 'vars';
    $items->[$i]->{replaceme} = $table . $items->[$i]->{ID};
    $items->[$i]->{name}
      = "<b>" . $items->[$i]->{envkey} . "</b> (" . $items->[$i]->{name} . ")";
    $items->[$i]->{param_default} = "&replaceme=" . $items->[$i]->{replaceme};
  }

  $self->render(
    folders  => $folders,
    items    => $items,
    template => 'Admin/tree_block'
  );
}

sub tree_block {
  my $self = shift;

  my $items      = [];
  my $index      = $self->stash->{index};
  my $controller = $self->stash->{controller};
  my $table      = $self->stash->{list_table};

  $self->param_default('replaceme' => '');

  $items = $self->getHashSQL(
    select => "`ID`,`name`",
    from   => $table,
    where  => "`id_program`='$index' ",
    sys    => 1
  ) || [];

  foreach my $i (0 .. $#$items) {
    $items->[$i]->{icon}      = 'vars';
    $items->[$i]->{replaceme} = $controller . '_' . $table . $items->[$i]->{ID};
    $items->[$i]->{param_default} = "&replaceme=" . $items->[$i]->{replaceme};
  }

  $self->render(
    json => {
      content => $self->render_to_string(
        items    => $items,
        template => 'Admin/tree_elements'
      ),
      items => [
        {
          type  => 'eval',
          value => "treeObj['" . $self->stash->{controller} . "'].initTree();"
        },
      ]
    }
  );

}

sub _restore_envKey {
  my $self = shift;

  unless ($self->stash->{_restore_envKey}) {
    $self->stash->{_restore_envKey}
      = $self->lkey(name => 'envvalue')->{settings};
  }


  $self->lkey(name => 'envvalue')->{settings}
    = $self->stash->{_restore_envKey} || {};
}

sub save {
  my $self   = shift;
  my %params = @_;

  $self->stash->{index} = 0 if $params{restore};

  my $envval
    = $self->stash->{index}
    ? $self->dbi->query(
    "SELECT * FROM `sys_vars` WHERE `ID`='" . $self->stash->{index} . "'")
    ->hash
    : {};
  my $types = $self->stash->{types} || $envval->{types} || 's';
  $self->stash->{settings} ||= $envval->{settings};

  my $value = $self->param('envvalue');

  $self->_restore_envKey;
  if (my $userSettings = $self->stash->{settings}) {
    my $userSettings_parsed = $self->parse_keys_settings($userSettings);

    $self->lkey(name => 'envvalue')->{settings}
      = $self->merge_keys_settings($self->lkey(name => 'envvalue')->{settings},
      $userSettings_parsed, {type => $types});
  }


  if ($types) {
    given ($types) {
      when ('s') { $value = $self->check_string(value => $value); }
      when ('slat') { $value = $self->check_lat(value => $value); }
      when ('d') { $value = $self->check_decimal(value => $value); }
      when ('chb') { $value = $self->check_checkbox(value => $value); }
      when ('list') {
        $self->def_list(name => 'envvalue', controller => 'vars');
        $value
          = $self->check_list(%{$self->lkey(name => 'envvalue')->{settings}},
          value => $value);
      }
      when ('list_radio') {
        $self->lkey(name => 'envvalue')->{settings}->{type} = 'list';

        #$self->lkeys->{envvalue}->{settings}->{type} = 'list';
        $self->def_list(name => 'envvalue', controller => 'vars');
        $value = $self->check_list(
          %{$self->lkey(name => 'envvalue')->{settings}},
          type  => 'list',
          value => $value
        );
      }
      when ('list_chb') {
        $self->lkey(name => 'envvalue')->{settings}->{type} = 'list';

        #$self->lkeys->{envvalue}->{settings}->{type} = 'list';
        $self->def_list(name => 'envvalue', controller => 'vars');
        $value = $self->check_list(
          %{$self->lkey(name => 'envvalue')->{settings}},
          type  => 'list',
          value => $value
        );
      }
      when ('email') { $value = $self->check_email(value => $value); }
      when ('code') { }
      when ('text') { $value = $self->check_string(value => $value); }
      when ('html') { $value = $self->check_html(value => $value); }
      when ('pict') {
        $value = $value ? $self->check_string(value => $value) : undef;
      }
      when ('file') {
        $value = $value ? $self->check_string(value => $value) : undef;
      }

      default {
        $value = '';
        $types = 's';
        $self->admin_msg_errors(
          "Тип переменной «$types» не определен");
      }
    }
  }

  $self->send_params->{envvalue} = $value if defined $value;

  if ($self->save_info(table => $self->stash->{list_table})) {
    $self->loadVars(1);

    if ($params{restore}) {
      $self->stash->{tree_reload} = 1;
      $self->save_logs(
        name => 'Восстановление записи в таблице '
          . $self->stash->{list_table},
        comment => "Восстановлена запись в таблице ["
          . $self->stash->{index}
          . "]. Таблица "
          . $self->stash->{list_table} . ". "
          . $self->msg_no_wrap
      );
      return $self->info;
    }

    if ($params{continue}) {
      $self->admin_msg_success("Данные сохранены");
      return $self->edit;
    }
    elsif ($self->stash->{group} >= $#{$self->app->program->{groupname}} + 1) {
      return $self->info;
    }

    $self->stash->{group}++;
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

  $self->getArraySQL(
    from  => $self->stash->{list_table},
    where => $self->stash->{index},
    stash => 'anketa'
  );

  my $types = $self->stash->{anketa}->{types} || 's';

  $self->lkey(name => 'envvalue')->{settings}->{notnull} //= 1;

  my $dop_settings
    = $self->parse_keys_settings($self->stash->{anketa}->{settings});
  $self->lkey(name => 'envvalue')->{settings}
    = $self->merge_keys_settings($self->lkey(name => 'envvalue')->{settings},
    $dop_settings, {type => $types});

  given ($types) {
    when ('list_chb') {
      $self->lkey(name => 'envvalue')->{settings}->{type} = 'list';
      $self->def_list(name => 'envvalue', controller => 'vars');
      $self->lkey(name => 'envvalue')->{settings}->{list_type} = 'checkbox';
      $self->lkey(name => 'envvalue')->{settings}->{template_w}
        = 'field_list_read';
    }
    when ('list_radio') {
      $self->lkey(name => 'envvalue')->{settings}->{type} = 'list';
      $self->def_list(name => 'envvalue', controller => 'vars');
      $self->lkey(name => 'envvalue')->{settings}->{list_type} = 'radio';
      $self->lkey(name => 'envvalue')->{settings}->{template_w}
        = 'field_list_read';
    }
  }

  $self->define_anket_form(noget => 1, access => 'r', table => $table);
}

sub edit {
  my $self   = shift;
  my %params = @_;

  $self->def_context_menu(lkey => 'edit_info');

  $self->getArraySQL(
    from  => $self->stash->{list_table},
    where => $self->stash->{index},
    stash => 'anketa'
  );

  my $types = $self->stash->{anketa}->{types} || 's';

  $self->lkey(name => 'envvalue')->{settings}->{notnull} //= 1;

  $self->_restore_envKey;

  my $dop_settings
    = $self->parse_keys_settings($self->stash->{anketa}->{settings});

#use Data::Dumper;
#die Dumper $self->merge_keys_settings($self->lkey(name => 'envvalue')->{settings}, $dop_settings, { type => $types});

#$self->lkey(name => 'envvalue')->{settings} = $self->merge_keys_settings($self->lkey(name => 'envvalue')->{settings}, $dop_settings, { type => $types});

  #use Data::Dumper;
  #die Dumper $self->lkey;

  given ($types) {
    when ('s') {
      $self->lkey(name => 'envvalue')->{settings}->{template_w} = 'field_input';
    }
    when ('slat') {
      $self->lkey(name => 'envvalue')->{settings}->{template_w} = 'field_input';
    }
    when ('chb') {
      $self->lkey(name => 'envvalue')->{settings}->{template_w}
        = 'field_checkbox';
    }
    when ('list') {
      $self->def_list(name => 'envvalue', controller => 'vars');
      $self->lkey(name => 'envvalue')->{settings}->{list_type}  = 'select';
      $self->lkey(name => 'envvalue')->{settings}->{template_w} = 'field_list';
    }
    when ('list_chb') {
      $self->lkey(name => 'envvalue')->{settings}->{type} = 'list';
      $self->def_list(name => 'envvalue', controller => 'vars');
      $self->lkey(name => 'envvalue')->{settings}->{list_type}  = 'checkbox';
      $self->lkey(name => 'envvalue')->{settings}->{template_w} = 'field_list';
    }
    when ('list_radio') {
      $self->lkey(name => 'envvalue')->{settings}->{type} = 'list';
      $self->def_list(name => 'envvalue', controller => 'vars');
      $self->lkey(name => 'envvalue')->{settings}->{list_type}  = 'radio';
      $self->lkey(name => 'envvalue')->{settings}->{template_w} = 'field_list';
    }
    when ('email') {
      $self->lkey(name => 'envvalue')->{settings}->{template_w} = 'field_input';
      $self->lkey(name => 'envvalue')->{settings}->{multiple}   = 1;
    }
    when ('code') {
      $self->lkey(name => 'envvalue')->{settings}->{template_w} = 'field_text';
    }
    when ('text') {
      $self->lkey(name => 'envvalue')->{settings}->{template_w} = 'field_text';
    }
    when ('html') {
      $self->lkey(name => 'envvalue')->{settings}->{cktoolbar}  = 'Basic';
      $self->lkey(name => 'envvalue')->{settings}->{template_w} = 'field_html';
    }
    when ('d') {
      $self->lkey(name => 'envvalue')->{settings}->{template_w}
        = 'field_rating';
    }
    when ('pict') {
      $self->lkey(name => 'envvalue')->{settings}->{template_w} = 'field_pict';
    }
    when ('file') {
      $self->lkey(name => 'envvalue')->{settings}->{template_w} = 'field_file';
    }
    default {
      $self->lkey(name => 'envvalue')->{settings}
        = $self->merge_keys_settings(
        $self->lkey(name => 'envvalue')->{settings},
        {type => 's'});

#$value = '';
#$self->msg_errors("Тип переменной «$types» не определен");
    }
  }
  $self->lkey(name => 'envvalue')->{settings}
    = $self->merge_keys_settings($self->lkey(name => 'envvalue')->{settings},
    $dop_settings, {type => $types});

  $self->define_anket_form(noget => 1, access => 'w');
}


sub list_container {
  my $self   = shift;
  my %params = @_;

  $self->delete_list_items if $self->stash->{delete};

  $self->stash->{enter} = 1 if ($params{enter});

  $self->def_context_menu(lkey => 'table_list');

  $self->stash->{win_name} = "Список правил";

  $self->stash->{listfield_groups_buttons} = {delete => "удалить"};

  return $self->list_items(%params, container => 1);
}

sub list_items {
  my $self   = shift;
  my %params = @_;

  my $list_table = $self->stash->{list_table};
  $self->render_not_found unless $list_table;

  $params{table} = $list_table;

  $self->sysuser->access->{table}->{'sys_vars'} = {r => 1, w => 1, d => 0,};

  $self->define_table_list(%params, where => $self->stash->{access_where});
}

1;
