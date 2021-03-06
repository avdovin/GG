package GG::Plugins::Keys;

use Mojo::Base 'Mojolicious::Plugin';

use utf8;

use experimental 'smartmatch';
use List::Util 'first';

our $VERSION = '0.06';

sub register {
  my ($self, $app, $args) = @_;

  $args ||= {};

  $app->plugin('validator');

  unless (ref($app)->can('buttons')) {
    ref($app)->attr('buttons');
    $app->buttons({});
  }
  unless (ref($app)->can('lkeys')) {
    ref($app)->attr('lkeys');
    $app->lkeys({});
  }

  $app->helper(
    buttons => sub {
      return shift->app->buttons;
    }
  );

  $app->helper(
    lkeys => sub {
      return shift->app->lkeys;
    }
  );

  $app->helper(

    # name - имя переменной
    # split - разделитель для списка
    # values - масив значений переменной

    VALUES => sub {
      my $self = shift;
      my $params = ref $_[0] ? $_[0] : {@_};

      return unless $$params{'name'};

      my $name  = $$params{'name'};
      my $type  = $$params{'type'};
      my $param = $$params{'param'} || 'name';
      my $controller
        = lc(delete $$params{'controller'} || $self->stash->{controller});


      return
        unless my $lkey = $self->lkey(name => $name, controller => $controller);

      $type ||= $lkey->{settings}->{type} || return '';

      my $values //= $$params{'value'};
      $values    //= $$params{'values'};
      $values    //= [];

      my $values_split
        = $$params{'value_split'} || $$params{'values_split'} || "=";

      if (ref($values) ne 'ARRAY') {
        $_       = $values;
        $values  = [];
        @$values = split($values_split, $_);
      }

      my $lkey_settings = $lkey->{settings};

      if ($type eq 'user') {
        my $result
          = $$params{param}
          ? $self->app->sysuser->settings->{$name}
          : $self->app->sysuser->userinfo->{$name};
        $result = 'checked' if $$params{chbox};
        return $result;

      }
      elsif ($type eq 'env') {

        return $self->req->env->{$name} || '';

      }
      elsif ($type =~ /list/) {
        $self->def_list(name => $name, controller => $controller);

        my $attr = {
          split => $lkey_settings->{'values_join_delimiter_tablelist'}
            || $lkey_settings->{'values_join_delimiter'}
            || '<br />',
          name => 'name',
          %{$params},
        };

        if (my $listRef = $lkey->{list}) {
          my @vals = ();
          foreach (@$values) {
            push @vals, $listRef->{$_} if $listRef->{$_};
          }

    # 0 Значение значение выбрано по умолчанию
          if (!scalar @vals && $lkey->{list}->{0}) {
            push @vals, $lkey->{list}->{0};
          }

          return join($$attr{split}, @vals);
        }
        return;

      }
      elsif ($type eq 'chb') {
        return $values->[0]
          && $values->[0] == 1 ? $lkey_settings->{yes} : $lkey_settings->{no};

      }
      else {
        return join(' ', @$values);
      }

      return "VALUES type '$type' for name '$name' not supported ";
    }
  );

  $app->helper(
    LIST => sub {
      my $self = shift;
      my $params = ref $_[0] ? $_[0] : {@_};

      return if !$self->app->lkeys;

      my $name = delete $$params{'name'};
      my $type = delete $$params{'type'};
      my $controller
        = lc(delete $$params{'controller'} || $self->stash->{controller});

      my $values //= $$params{'value'};
      $values    //= $$params{'values'};
      $values    //= [];

      return
        unless my $lkey = $self->lkey(name => $name, controller => $controller);

      my $values_split = delete $$params{value_split} || "=";
      my $setting      = $lkey->{settings};
      my $replaceme    = $self->stash->{replaceme} || '';

      if (ref($values) ne 'ARRAY') {
        $_       = $values;
        $values  = [];
        @$values = split($values_split, $_);
      }

      $type ||= $lkey->{settings}->{list_type} || 'select';

      my $required
        = $$params{required} || $setting->{required} ? " required " : "";
      my $list_delimetr
        = $$params{delimetr} || $setting->{list_delimetr} || '<br />';
      my $list_style = $$params{style} || $setting->{list_style} || '';
      my $list_class = $$params{class} || $setting->{list_class} || '';

      $self->def_list(name => $name, controller => $controller);

      my $list        = $lkey->{list}        || {};
      my $list_labels = $lkey->{list_labels} || [];


      my $backup = {};
      if ($$params{onlyindex}) {
        $backup->{$_} = $list->{$_} foreach (keys %{$list});
        if ($$params{onlyindex} == -1) {
          delete $list->{$_} foreach (@$values);
        }
        elsif ($$params{onlyindex} == 1) {
          foreach my $k (keys %{$list}) {
            delete $list->{$k} unless (grep(/^$k$/, @$values));
          }
        }
      }
      push @$values, 0 if (!scalar(@$values) and !$lkey->{settings}->{notnull});

      my $code = "";

      if ($type eq 'select') {

        $code
          .= "<select name='$name' $list_style $list_class id='$name' $required>"
          unless $params->{option};

        foreach my $k (@$list_labels) {
          next unless $list->{$k};

          my $selected
            = (defined first { $k eq $_ } @$values)
            ? " selected='selected' "
            : "";

          $code
            .= "<option value='"
            . ($k || '')
            . "' $selected>"
            . $list->{$k}
            . "</option>";
        }

        $code .= "</select>" unless $params->{option};

      }
      elsif ($type eq 'checkbox') {

        foreach my $k (@$list_labels) {
          next unless $list->{$k};

          my $selected
            = (defined first { $k eq $_ } @$values)
            ? " checked='checked' "
            : "";
          $code
            .= "<label style=\"float:none;cursor:pointer;\"><input value='$k' name='$name' id='${replaceme}${name}_$k' $list_style type='checkbox' $list_class $required class='checkbox' $selected>"
            . $list->{$k}
            . "</label>";
          $code .= $list_delimetr;
        }

      }
      elsif ($type eq 'radio') {
        foreach my $k (@$list_labels) {
          next unless $list->{$k};
          my $selected
            = (defined first { $k eq $_ } @$values)
            ? " checked='checked' "
            : "";
          $code
            .= "<input value='$k' name='$name' $list_style type='radio' id='${replaceme}${name}_$k' $list_class $required $selected><label for='${replaceme}${name}_$k' "
            . ($replaceme ? 'style=\'float:none;cursor:pointer;\'' : '') . "'>"
            . $list->{$k}
            . " </label>";
          $code .= $list_delimetr;
        }

      }
      else {
        return "LIST type '$type' for name '$name' not supported ";
      }

      $lkey->{list} = $backup if $$params{onlyindex};
      return $code;
    }
  );

  $app->helper(
    def_list => sub {
      my $self = shift;
      my $args = ref $_[0] ? $_[0] : {@_};

      return
        unless my $lkey
        = $self->lkey(name => $args->{name}, controller => $args->{controller});
      return if $lkey->{list};


      my $list = $lkey->{settings}->{list} || '';
      my $type = $lkey->{settings}->{type} || 's';
      my $list_vals = {};
      if ($type eq 'list') {

        if (my $listOut = $lkey->{settings}->{list_out}) {
          $list = $self->lkey(
            name       => $args->{name},
            controller => $args->{controller}
            )->{settings}->{list}
            = $self->lkey(name => $listOut)->{settings}->{list};
        }

        foreach my $l (split(/~/, $list)) {
          my ($key, $value) = split(/\|/, $l);
          $list_vals->{$key} = $value;
        }

      }
      elsif ($type eq 'tlist') {
        my $where = $lkey->{settings}->{where} || '';
        $where = $self->render_to_string(inline => $where) if $where;

        my $list_field_as_id = $lkey->{settings}->{list_field_as_id} || 'ID';
        my $list_field_as_name = $lkey->{settings}->{list_field_as_name} || 'name';

        eval {
          $list_vals = $self->app->dbi->query(
            qq/
            SELECT $list_field_as_id as `ID`,$list_field_as_name as `name`
            FROM `$list`
            WHERE 1 $where
          /
          )->map;
        };

        $app->log->error("Error read lkey list '$$args{name}': $@") && return
          if $@;
      }

      $lkey->{list} = $list_vals;

      $self->_def_list_labels($lkey);
    }
  );

  $app->helper(
    _def_list_labels => sub {
      my $self = shift;
      my $lkey = shift;

      my $list_vals = $lkey->{list} || {};
      my $sort = $lkey->{settings}->{list_sort} || 0;

      if (!$sort && $lkey->{settings}->{type} eq 'list') {
        $sort = 'asc_d';
      }

      my $labels = [];

      # Сортировка по значению
      if ($sort eq 'asc_d') {
        push @$labels, $_ foreach sort { $a <=> $b } keys %$list_vals;
      }
      elsif ($sort eq 'asc_s') {
        push @$labels, $_ foreach sort { $a cmp $b } keys %$list_vals;
      }
      elsif ($sort eq 'desc_d') {
        push @$labels, $_ foreach sort { $b cmp $a } keys %$list_vals;
      }
      elsif ($sort eq 'desc_s') {
        push @$labels, $_ foreach sort { $b cmp $a } keys %$list_vals;
      }
      else {
        push @$labels, $_
          foreach sort { $list_vals->{$a} cmp $list_vals->{$b} }
          keys %$list_vals;
      }

      if (
        !$list_vals->{0}
        and (defined $lkey->{settings}->{notnull}
          && $lkey->{settings}->{notnull} == 0)
        || not defined $lkey->{settings}->{notnull}
        )
      {
        my $null_value = $lkey->{settings}->{nullvalue} || "------";
        unshift @$labels, 0;
        $lkey->{list}->{'0'} = $null_value;
      }

      $lkey->{list_labels} = $labels;
    }
  );

  $app->helper(
    get_keys => sub {
      my $self   = shift;
      my %params = (
        validator   => 1,
        controller  => '',
        key_program => '',
        no_global   => 0,
        type        => [],
        @_
      );

      $params{controller} ||= $params{key_program};

      my $type       = delete $params{type};
      my $keys_table = 'keys_' . $params{controller};

      my $app = $self->app;


      if (!$params{no_global}
        && $self->app->lkeys->{'_cached_global_' . $params{controller}}
        && $self->app->lkeys->{'_cached_' . $params{controller}})
      {
        $self->validate(controller => $params{controller})
          if $params{validator};
        return 1;

      }
      elsif ($params{no_global}
        && $self->app->lkeys->{'_cached_' . $params{controller}})
      {

        $self->validate(controller => $params{controller})
          if $params{validator};
        return 1;
      }

      unless ($params{no_global}) {
        if (my $rows
          = $app->dbi->query("SELECT * FROM `keys_global` WHERE 1")->hashes)
        {
          _parseLkeys(
            app        => $app,
            controller => $params{controller},
            lkeys      => $rows,
          );
          _parseLkeys(app => $app, controller => 'global', lkeys => $rows,);
        }

        $self->app->lkeys->{'_cached_global_' . $params{controller}} = 1;
      }

      if ($keys_table) {
        if (my $rows
          = $app->dbi->query("SELECT * FROM `$keys_table` WHERE 1")->hashes)
        {
          _parseLkeys(
            app        => $app,
            controller => $params{controller},
            lkeys      => $rows,
          );
        }
        $self->app->lkeys->{'_cached_' . $params{controller}} = 1;
      }

      $self->validate(controller => $params{controller}) if $params{validator};
    }
  );

  $app->helper(
    parse_keys_settings => sub {
      my $self            = shift;
      my $settings_result = {};

      foreach my $settings (@_) {

        map {
          my ($k, $v) = split("=", $_, 2);
          $k =~ s/\s*//g;
          $settings_result->{$k} = $v;
        } split("\n", $settings);
      }
      return $settings_result;

    }
  );

  $app->helper(
    button => sub {
      my $self      = shift;
      my $args    = ref $_[0] ? $_[0] : {@_};

      my $buttonName = $args->{name};
      my $controller = $args->{controller} || $self->stash->{controller} || return '';

      my $buttons = $self->app->buttons;

      return $self->app->buttons->{$controller} unless $buttonName;

      if($self->app->buttons->{$controller}->{$buttonName}){

        if(my $list_table = $args->{'tbl'} || $self->stash->{list_table}){

          my $button = ($buttons->{$controller}->{_tbl}->{$list_table} &&
                $buttons->{$controller}->{_tbl}->{$list_table}->{$buttonName}) ?
                $buttons->{$controller}->{_tbl}->{$list_table}->{$buttonName} :
                $buttons->{$controller}->{$buttonName};


          if($args->{setting}){
            if($button->{ $args->{setting} } ){
              return $button->{ $args->{setting} } ;

            } elsif($button->{settings}->{ $args->{setting} } ){
              return $button->{settings}->{ $args->{setting} }
            }
            return '';
          }

          return $button

        } else {
          if($args->{setting}){

            if($buttons->{$controller}->{$buttonName}->{$args->{setting}}){
              return $buttons->{$controller}->{$buttonName}->{$args->{setting}};

            } elsif($buttons->{$controller}->{$buttonName}->{settings}->{ $args->{setting} }){
              return $buttons->{$controller}->{$buttonName}->{settings}->{ $args->{setting} }
            }
            return '';

          } else {

            return $buttons->{$controller}->{$buttonName};
          }
        }
      }
    }
  );

  $app->helper(
    lkey_folder => sub {
      my $self   = shift;
      my %params = @_;

      return '' unless my $lkey = delete $params{'lkey'};
      my $controller
        = delete $params{'controller'} || $self->stash->{'controller'};
      $controller = lc($controller);
      unless ($self->app->lkeys->{$controller}) {
        $self->get_keys(type => ['lkey'], controller => $controller);
      }

      return $self->lkey(
        name       => $lkey,
        setting    => 'folder',
        controller => $controller,
        %params
      );
    }
  );

  $app->helper(
    lkey_path => sub {
      my $self   = shift;
      my %params = @_;

      return '' unless my $lkey  = $params{'lkey'};
      return '' unless my $value = delete $params{'value'};

      my $folder = $self->lkey_folder(%params);

      $params{size}
        ? return $folder . $params{size} . '_' . $value
        : return $folder . $value;

    }
  );

  $app->helper(
    lkey => sub {
      my $self = shift;
      my $args = ref $_[0] ? $_[0] : {@_};

      my $lkeyName = $args->{name};
      my $controller
        = $args->{controller} || $self->stash->{controller} || return '';

      my $lkeys = $self->app->lkeys;

      if (delete $args->{'tmp'}) {
        return $self->app->lkeys->{'global'}->{'tmp'} = Lkey->new(
          {
            name => $lkeyName       || 'временный ключ',
            lkey => $args->{'lkey'} || 'tmp',
            object   => 'lkey',
            tbl      => '',
            settings => $args->{settings},
            type     => $args->{type} || $args->{settings}->{type} || 's',
            group    => 1,
            access   => {r => 1, w => 0, d => 0,}
          }, $self->app
        );

      }

      return $self->app->lkeys->{$controller} unless $lkeyName;

      if ($self->app->lkeys->{$controller}->{$lkeyName}) {

        if (my $list_table = $args->{'tbl'} || $self->stash->{list_table}) {

          my $lkey
            = (  $lkeys->{$controller}->{_tbl}->{$list_table}
              && $lkeys->{$controller}->{_tbl}->{$list_table}->{$lkeyName})
            ? $lkeys->{$controller}->{_tbl}->{$list_table}->{$lkeyName}
            : $lkeys->{$controller}->{$lkeyName};


          if ($args->{setting}) {
            if ($lkey->{$args->{setting}}) {
              return $lkey->{$args->{setting}};

            }
            elsif ($lkey->{settings}->{$args->{setting}}) {
              return $lkey->{settings}->{$args->{setting}};
            }
            return '';
          }

          return $lkey

        }
        else {
          if ($args->{setting}) {

            if ($lkeys->{$controller}->{$lkeyName}->{$args->{setting}}) {
              return $lkeys->{$controller}->{$lkeyName}->{$args->{setting}};

            }
            elsif (
              $lkeys->{$controller}->{$lkeyName}->{settings}->{$args->{setting}}
              )
            {
              return $lkeys->{$controller}->{$lkeyName}->{settings}
                ->{$args->{setting}};
            }
            return '';

          }
          else {
            return $lkeys->{$controller}->{$lkeyName};
          }
        }
      }
      return $args->{setting} ? "" : {};

    }
  );


 # проверяем есть ли значение у позиции ( 1=3=5 )
  $app->helper(
    has_in_multilist => sub {
      my $self = shift;
      return unless my $itemValues = shift;
      return unless my $checkValue = shift;

      my @itemValues = split('=', $itemValues);
      return 1 if ($checkValue ~~ @itemValues);
      return;
    }
  );

  $app->helper(
    merge_keys_settings => sub {
      my $self            = shift;
      my $settings_result = {};

      foreach my $settings (@_) {
        $settings_result->{$_} = $settings->{$_} foreach (keys %$settings);
      }
      return $settings_result;

    }
  );

  $app->helper(
    reload_tlist => sub {
      my $self = shift;
      our $table = shift;
      my $lkeys = $self->app->lkeys;

      foreach my $controller ( keys %$lkeys ){
        my $controller_lkeys = $lkeys->{ $controller };

        if( $controller_lkeys and ref $controller_lkeys ){
          if( $controller_lkeys->{_tbl} and ref $controller_lkeys->{_tbl} ){
            foreach my $tbl ( keys %{ $controller_lkeys->{_tbl} } ){
              _check_reload( $controller_lkeys->{_tbl}->{$tbl} );
            }
          }
          _check_reload( $controller_lkeys );
        }
      }

      sub _check_reload {
        my $lkeys = shift;
        foreach my $key ( keys %$lkeys ){
          next if $key eq '_tbl';
          my $lkey = $lkeys->{ $key };
          next unless ref $lkey;
          if( $lkey->{type} eq 'tlist' and $lkey->{settings}->{list} eq $table ){
            $lkey->reload();
          }
        }
      }
    }
  )
}

sub _parseLkeys{
  my %params  = @_;

  my $app = delete $params{app};
  my $controller = delete $params{controller};
  my $lkeys   = delete $params{lkeys};

  unless($app->buttons->{$controller}){
    $app->buttons->{$controller} = {};
    $app->buttons->{$controller}->{_tbl} = {};
  }
  unless($app->lkeys->{$controller}){
    $app->lkeys->{$controller} = {};
    $app->lkeys->{$controller}->{_tbl} = {};
  }

  foreach my $dbKey (@$lkeys){

    my $lkey = _parseLkeySettings($dbKey);

    my $object = $lkey->{object} eq 'lkey' ? Lkey->new( $lkey, $app ) : Button->new( $lkey );

    $object->access->{r} = 1;
    my $storage = $lkey->{object} eq 'lkey' ? $app->lkeys : $app->buttons;

    if($lkey->{tbl}){
      $storage->{$controller}->{_tbl}->{$lkey->{tbl}}->{$lkey->{lkey}} = $object;
      $storage->{$controller}->{$lkey->{lkey}} ||= $object;
    } else {
      $storage->{$controller}->{$lkey->{lkey}} = $object;
    }

  }
}

sub _parseLkeySettings {
  my $dbKey = shift;

  my $settings = $dbKey->{settings};
  $settings =~ s/\r//g;

  my @settings_strings = split("\n", $settings);
  my $settings_hash = {rating => 99, type => 's',};

  map {
    my ($k, $v) = split("=", $_, 2);
    $k =~ s/\s*//g;
    $settings_hash->{$k} = $v;
  } @settings_strings;

  return {
    name     => $dbKey->{name},
    lkey     => $dbKey->{lkey},
    object   => $dbKey->{object},
    tbl      => $dbKey->{tbl},
    settings => $settings_hash,
    type     => $settings_hash->{type} || 's',
    group    => $settings_hash->{group} || 1,
  };
}

1;

package Lkey;

use utf8;
use Mojo::Base -base;

__PACKAGE__->attr(access => sub { shift->{access} });

sub new {
  my $class = shift;
  my $args = shift || {};

  my $self = {
    tbl      => undef,
    lkey     => undef,
    name     => undef,
    type     => "s",
    filter   => 0,
    group    => 1,
    object   => "lkey",
    settings => {type => 's',},
    access   => {d => 0, r => 0, w => 0},
    %{$args}
  };

  if( $self->{type} eq 'tlist' ){
    $self->{app} = shift;
  }

  bless($self, $class);
  return $self;
}

sub reload{
  my $self = shift;
  return if $self->{type} ne 'tlist';
  delete $self->{list};

  $self->{app}->def_list;
}

1;

package Button;

use utf8;
use Mojo::Base -base;

__PACKAGE__->attr(access => sub { shift->{access} });

sub new {
  my $class = shift;
  my $args = shift || {};

  my $self = {
    lkey      => undef,
    name      => undef,
    image     => undef,
    program   => undef,
    action    => undef,
    object    => "button",
    settings  => {},
    code      => undef,
    imageicon => '',
    access    => {d => 0, r => 0, w => 0},
    stash     => {},
    %{$args}
  };
  bless($self, $class);
  return $self;
}


sub button_item_json {
  my $self = shift;
  my $vals = {
    type       => 'additembutton',
    menubarkey => 'button',
    id       => $$self{ID},     #sprintf("%03d%03d", rand('999'), rand('999') ),
    itemtext => $$self{name},
    itemicon   => $$self{settings}->{imageiconmenu},
    helptext   => $$self{settings}->{title},
    jsfunction => $$self{settings}->{script}
  };
  return $vals;
}

sub def_icons {    # Определение кнопки типа "Icons"
  my $self = shift();


  $$self{settings}->{imageicon} ||= "/admin/img/icons/menu/icon_no.gif";

  $self->def_params_button();
  $self->def_script_button();
}

sub def_params_button {    # определение параметров
  my $self  = shift;
  my $stash = shift;

  my %params = @_;

  my (@params);

  my $settings = $$self{settings};

  if ($settings->{params}) {
    foreach my $p (split(/,/, $settings->{params})) {
      next unless $p;
      next unless my $v = $stash->{$p};

      $v = $stash->{controller} . '_' . $stash->{list_table} . '0'
        if ($settings->{id}
        && $settings->{id} eq 'newentry'
        && $p eq 'replaceme');

      push(@params, "$p=$v");
    }
  }

  $settings->{controller} ||= $stash->{controller};
  $self->{params_string} = $settings->{params_string}
    = join("&", @params) || '';

  $settings->{action} ||= $settings->{'do'} || 'undef';
  $settings->{controller} ||= '';

  $settings->{program}
    = '/admin/' . $settings->{controller} . '/body?do=' . $settings->{action};

  $$self{settings} = $settings;
}

sub def_script_button
{    # определение скрипта выполнения
  my $self  = shift();
  my $stash = shift;

  my %params = @_;
  no warnings;

  my $settings = $$self{settings};
  if (!$settings->{type_link}) {
    $settings->{script} = "doNothing()";
  }
  else {

    if ($settings->{type_link} eq "openurl") {
      $settings->{script}
        = "open_url('$$settings{program}?$$settings{params_string}')";

    }
    elsif ($settings->{type_link} eq "openlink") {
      $settings->{script}
        = "openNewWin($$settings{width}, $$settings{height}, '$$settings{program}', '$$self{params_string}', '$$settings{ID}')";

    }
    elsif ($settings->{type_link} eq "modullink") {
      $settings->{script}
        = "displayMessage('$$settings{program}&$$self{params_string}', $$settings{width}, $$settings{height}, $$settings{level})";

    }
    elsif ($settings->{type_link} eq "loadcontent") {
      my $replaceme = $settings->{replaceme} || $stash->{replaceme} || '';

      $settings->{program} ||= $stash->{script_link};

      if ($settings->{confirm}) {
        if ($settings->{loading_msg}) {
          $settings->{script}
            = "if (confirm('$$settings{confirm}')) ld_content('$replaceme','$$settings{program}&$$self{params_string}', '', 1)";
        }
        else {
          $settings->{script}
            = "if (confirm('$$settings{confirm}')) ld_content('$replaceme','$$settings{program}&$$self{params_string}')";
        }
      }
      else {
        if ($settings->{loading_msg}) {
          $settings->{script}
            = "ld_content('$replaceme','$$settings{program}&$$self{params_string}', '', 1)";
        }
        else {
          $settings->{script}
            = "ld_content('$replaceme','$$settings{program}&$$self{params_string}')";
        }

      }

    }
    elsif ($settings->{type_link} eq "javascript") {
      $settings->{script} = $$self{settings}{function};

    }
    elsif ($settings->{type_link} eq "openpage") {
      $settings->{position} ||= "center";
      $settings->{id}       ||= $$self{replaceme};
      $$self{title}         ||= $$self{settings}{id};
      $$self{tabtitle}      ||= $$self{settings}{id};

      my $link = $$settings{program};
      $link .= "&" . $$settings{params_string} if $$settings{params_string};

      if ($settings->{confirm}) {
        $settings->{script}
          = "if (confirm('$$settings{confirm}')) openPage('$$settings{position}','$$settings{id}','$link','$$settings{title}','$$settings{tabtitle}')";

      }
      elsif ($settings->{id} eq 'newentry') {
        $settings->{tabtitle} = 'Новая запись';
        my $replaceme = $stash->{controller} . '_' . $stash->{list_table} . '0';
        $settings->{script}
          = "openPage('$$settings{position}','$replaceme','$link','$$settings{title}','$$settings{tabtitle}')";
      }
      else {
        $settings->{script}
          = "openPage('$$settings{position}','$$settings{id}','$link','$$settings{title}','$$settings{tabtitle}')";
      }
    }
  }
  use warnings;
  $$self{settings} = $settings;
}


1;
