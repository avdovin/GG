package GG::Admin::Plugins::TableList;

use utf8;

use Mojo::Base 'Mojolicious::Plugin';

our $VERSION = '1';

sub register {
  my ($self, $app, $opts) = @_;

  $opts ||= {};

  $app->log->debug("register GG::Admin::Plugins::TableList");

  $app->helper(
    define_table_list => sub {
      my $self   = shift;
      my %params = @_;

      $params{lkey}  ||= $self->stash->{replaceme};
      $params{where} ||= '';

      my $table = $params{table};
      my $lkey  = $params{lkey};

      $self->def_tablelist_param(key => "page", lkey => $lkey, default => 1);
      $self->def_tablelist_param(key => "pcol", lkey => $lkey, default => 25);
      $self->def_tablelist_param(
        key     => "sfield",
        lkey    => $lkey,
        default => 'ID'
      );
      $self->def_tablelist_param(key => "asc", lkey => $lkey, default => 'asc');
      $self->def_tablelist_param(
        key     => "qsearch",
        lkey    => $lkey . '_filter',
        default => ''
      );

      $self->stash->{table_from} = $table;

      $self->def_listfield_buttons(table => $table);
      $self->def_listfield_groups_buttons(table => $table);

      $self->filter_take(lkey => $lkey);
      $self->def_listfield(table => $table, lkey => $lkey);

      my $where_filtered = $self->set_filter(lkey => $lkey, table => $table);

      my $items = [];

      if ($self->sysuser->access->{table}->{$table}->{r} || $self->sysuser->sys)
      {
        $self->stash->{total} = $self->dbi->getCountCol(from => $table,
          where => "1 $params{where}");
        $self->stash->{total_with_filter} = $self->dbi->getCountCol(
          from  => $self->stash->{table_from},
          where => "1 $params{where} $where_filtered"
        );

  # Кол-во колонок + 2 служебные + кол-во кнопок
        $self->stash->{total_col_list}
          += 2 + scalar(@{$self->stash->{listfield_buttons}});
        $self->stash->{total_col_list}--
          unless $self->app->program->{settings}->{qview};

        $self->def_text_interval(
          total_vals   => $self->stash->{total_with_filter},
          cur_page     => $self->stash->{page},
          col_per_page => $self->stash->{pcol}
        );

        if ($self->stash->{total_page} < $self->stash->{page}) {
          $self->send_params->{page} = 1;
          $self->def_tablelist_param(
            key     => "page",
            lkey    => $lkey,
            default => 1
          );
          $self->def_text_interval(
            total_vals   => $self->stash->{total_with_filter},
            cur_page     => $self->stash->{page},
            col_per_page => $self->stash->{pcol}
          );
        }

        unless ($params{container}) {
          $params{npage} = $self->stash->{pcol} * ($self->stash->{page} - 1);

          my $where_limit = " LIMIT " . $self->stash->{pcol};
          $where_limit .= " OFFSET $params{npage}" if $params{npage};

          my $listfield = $self->stash->{listfield} ||= [];

          $items = $self->getHashSQL(
            select => join(",", @{$listfield}),
            from   => $self->stash->{table_from},
            where => "1 $params{where} $where_filtered ORDER BY `$table`.`"
              . $self->stash->{sfield} . "` "
              . $self->stash->{asc}
              . " $where_limit",
            sys => 1,
          );
        }
      }

      if ($params{container}) {

        if (  !$self->sysuser->access->{table}->{$table}->{r}
          and !$self->sysuser->sys) {
          $self->admin_msg_errors(
            "Доступ к разделу запрещен");
          $self->stash->{listfield_header} = [];
        }

        my $body = $self->render_to_string(
          template => 'admin/table_list/tablelist_container');

        $self->res->headers->content_type('application/json');
        return $self->render(
          json => {
            content => $body,
            items   => $self->get_init_items(init => 'init_modul'),
          }
        );
      }

      my $Data = {lkeys => [], settings => {}, data => [], buttons_key => [],};

      # показываем qView
      $Data->{settings}->{qview} = 1
        if $self->app->program->{settings}->{'qview'};

      # показываем ID записи в списке
      $Data->{settings}->{table_indexes} = 1
        if $self->app->program->{settings}->{'table_indexes'};

      #my $lkeys = $self->lkey;

      foreach my $key (@{$self->stash->{listfield_header}}) {
        my $lkey = $self->lkey(name => $key);
        push @{$$Data{lkeys}},
          {
          lkey  => $key,
          type  => $lkey->{settings}->{type},
          qedit => $lkey->{settings}->{qedit}
          };
      }

      foreach my $key (@{$self->stash->{listfield_buttons}}) {
        my $button = $self->button(name => $key);
        push @{$$Data{buttons_key}},
          {lkey => $key, confirm => $button->{settings}->{confirm} || ''};
      }

      my $mini_prefix = {};
      my $folders     = {};
      my $data_items  = [];

      foreach my $item (@$items) {
        my $id = $item->{ID};

        foreach my $v (keys %$item) {
          my $lkey = $self->lkey(name => $v);
          my $type = $lkey->{settings}->{type} || next;

          if ($type eq 'chb') {
            $item->{$v}
              = $item->{$v}
              ? $lkey->{settings}->{yes}
              : $lkey->{settings}->{no};

          }
          elsif ($type eq 'date') {
            delete $item->{$v} if (!$item->{$v} or $item->{$v} eq '0000-00-00');

          }
          elsif ($type =~ /list/) {
            $item->{$v} = $self->VALUES(
              name        => $v,
              type        => 'list',
              value       => $item->{$v},
              value_split => "=",
              )

          }
          elsif ($type eq 'pict') {
            if (!$item->{$v}) {
              $item->{$v} = '/admin/img/no_img.png';
            }
            else {
              unless ($folders->{$v}) {
                my $folder
                  = $lkey->{settings}->{folder} || $self->stash->{folder};
                $folder .= $lkey->{settings}->{table_list_folder}
                  if $lkey->{settings}->{table_list_folder};
                if ( $lkey->{settings}->{mini}
                  && !$mini_prefix->{$v}
                  && !$lkey->{settings}->{table_list_folder}) {
                  my @first_mini = split(',', $lkey->{settings}->{mini});
                  $first_mini[0] =~ s{~[\w]+$}{};
                  $folder .= $mini_prefix->{$v} = $first_mini[0] . '_';
                }

                $folders->{$v} = $folder;
              }
              $item->{$v}
                = $lkey->{settings}->{remote}
                ? $item->{$v}
                : $folders->{$v} . $item->{$v};

            }

          }
          elsif ($type eq 'file') {

            #next unless my $filename = $item->{$v};

#my $ext = ($filename =~ m/([^.]+)$/)[0];
#$item->{$v} = $self->image('/admin/img/icons/file/'.$ext.'.png', alt => $filename, width => 16, height => 16).' '.$filename;

          }
          elsif ($type eq 'site') {
            $item->{$v} = "<a href='$$item{$v}' target='_blank'>$$item{$v}</a>";

            # размер файла
          }
          elsif ($type eq 'filesize') {
            $item->{$v} = $self->file_nice_size($$item{$v});
          }
        }
        push @$data_items, $item;
      }
      $Data->{data} = $data_items;

      $self->render(json => $Data);
    }
  );

  $app->helper(
    defcol => sub {
      my $self   = shift;
      my %params = @_;

      my %types = (
        table    => 1,
        text     => 1,
        html     => 1,
        password => 1,
        code     => 1,
        file     => 1,
        filename => 1
      );
      my @anketa_keys = ();

      my $controller = $self->param('key_program');
      my $list_table = $self->param('list_table');

      return unless $self->def_program($controller);


      $self->get_keys(type => ['lkey'], controller => $controller);

      $self->stash->{controller} = $self->stash->{replaceme} = $controller;
      $self->stash->{replaceme} .= "_" . $list_table if $list_table;

      $self->stash->{group}++;

      if ($self->param('clear')) {
        $self->app->sysuser->save_user_settings(
          $self->stash->{replaceme} . "_defcol" => "");
        return $self->render(
          json => {content => 'OK', items => $self->init_tablelist_reload});
      }

      if ($self->stash->{group} == 2) {
        my $lkeys        = $self->lkey(controller => $controller);
        my $lkeys_access = $self->sysuser->access->{lkey};
        my $user_sys     = $self->sysuser->sys;

        my $defcol = '';
        if ($self->sysuser->settings->{$self->stash->{replaceme} . "_defcol"}) {
          $defcol
            = $self->sysuser->settings->{$self->stash->{replaceme} . "_defcol"};
        }
        else {
          no strict "refs";

          foreach my $k (
            sort {
              $$lkeys{$a}{settings}{rating} <=> $$lkeys{$b}{settings}{rating}
                or $a cmp $b
            } keys %$lkeys
            ) {
            if ( $self->dbi->exists_keys(table => $list_table, lkey => $k)
              && ($lkeys_access->{$k}->{r} || $user_sys)
              && !$$lkeys{$k}{settings}{sys}
              && !exists $types{$$lkeys{$k}{settings}{type}}
              && $$lkeys{$k}{settings}{table_list}) {
              my $size = $$lkeys{$k}{settings}{table_list_width} || 100;
              $defcol .= $defcol ? ",$k~$size" : "$k~$size";
            }
          }
        }

        foreach my $item (split(/,/, $defcol)) {
          my ($lkey, undef) = split("~", $item);
          $self->stash->{'check:' . $lkey} = 1;
        }

        no strict "refs";

        foreach my $k (
          sort {
                 $$lkeys{$a}{settings}{rating} <=> $$lkeys{$b}{settings}{rating}
              or $a cmp $b
          } keys %$lkeys
          ) {

          if ( $self->dbi->exists_keys(table => $list_table, lkey => $k)
            && ($lkeys_access->{$k}->{r} || $user_sys)
            && !$$lkeys{$k}{settings}{sys}
            && !exists $types{$$lkeys{$k}{settings}{type}}) {
            push @anketa_keys, $k;
          }

        }

        use strict "refs";

      }
      elsif ($self->stash->{group} == 3) {
        my $lkeys        = $self->lkey(controller => $controller);
        my $lkeys_access = $self->sysuser->access->{lkey};
        my $user_sys     = $self->sysuser->sys;

        if ($self->sysuser->settings->{$self->stash->{replaceme} . "_defcol"}) {
          my $defcol
            = $self->sysuser->settings->{$self->stash->{replaceme} . "_defcol"};

          foreach my $item (split(/,/, $defcol)) {
            my ($lkey, $size) = split("~", $item);
            $self->stash->{'check:' . $lkey} = $size || 100;
          }
        }


        my $list_fields = $self->stash->{listfields};
        foreach my $k (split(/,/, $list_fields)) {
          if ( $self->dbi->exists_keys(table => $list_table, lkey => $k)
            && ($lkeys_access->{$k}->{r} || $user_sys)
            && !$$lkeys{$k}{settings}{sys}
            && !exists $types{$$lkeys{$k}{settings}{type}}) {
            push @anketa_keys, $k;
          }
        }

      }
      elsif ($self->stash->{group} == 4) {

        my $list_fields = $self->stash->{listfields};
        my $result      = '';
        foreach my $item (split(/,/, $list_fields)) {
          my ($lkey, $size) = split("~", $item);
          $size = 100 if ($size !~ /\d+/);
          $result .= $result ? ",$lkey~$size" : "$lkey~$size";
        }
        $self->stash->{listfields} = $result;

        $self->app->sysuser->save_user_settings(
          $self->stash->{replaceme} . "_defcol" => $self->stash->{listfields});

        return $self->render(
          json => {content => 'OK', items => $self->init_tablelist_reload});
      }

      $self->stash->{listfield} = \@anketa_keys;


      if ($self->stash->{flag_win}) {
        $self->render(
          json => {
            content =>
              $self->render_to_string(template => 'admin/table_list/defcol'),
            items => $self->get_init_items(),
          }
        );
      }
      else {
        $self->render(template => 'admin/table_list/defcol');
      }

    }
  );

  $app->helper(
    filter_form => sub {
      my $self   = shift;
      my %params = @_;

      $self->define_anket_form(%params, access => 'f', render_html => 1);
    }
  );

  $app->helper(
    filter_save => sub {
      my $self   = shift;
      my %params = @_;

      my $table = $params{table} || $self->stash->{list_table};
      die
        "Функция TableList::filter_save. Не определена таблица, по которой строить фильтры"
        unless $table;
      my $lkey  = $self->stash->{replaceme} . '_filter';
      my $lkeys = $self->lkey;

      my %user_set = ();
      no strict "refs";

      foreach my $k (
        sort {
               $$lkeys{$a}{settings}{rating} <=> $$lkeys{$b}{settings}{rating}
            or $a cmp $b
        } keys %$lkeys
        ) {
        if ( $self->dbi->exists_keys(from => $table, lkey => $k)
          && $lkeys->{$k}->{settings}->{filter}) {
          if (!$self->stash->{$k}) {
            $user_set{$lkey . '_' . $k} = '';
          }
          else {
            if ( $lkeys->{$k}->{settings}->{type} eq 'date'
              || $lkeys->{$k}->{settings}->{type} eq 'datetime'
              || $lkeys->{$k}->{settings}->{type} eq 'd') {
              $user_set{$lkey . '_' . $k} = $self->stash->{$k};
              $user_set{$lkey . '_' . $k . 'pref'}
                = $self->param($k . 'pref') || '=';

            }
            elsif ($lkeys->{$k}->{settings}->{type} eq 'time') {
              my ($date) = split(/ /, $self->stash->{$k});
              $user_set{$lkey . '_' . $k} = $date;
              $user_set{$lkey . '_' . $k . 'pref'}
                = $self->param($k . 'pref') || '=';

            }
            else {
              $user_set{$lkey . '_' . $k} = $self->send_params->{$k};
            }
          }
        }
      }

      use strict "refs";

      $self->sysuser->save_ses_settings(%user_set);

      $self->render(
        json => {content => "OK!", items => $self->init_save_filter,});
    }
  );

  $app->helper(
    filter_clear => sub {
      my $self   = shift;
      my %params = @_;

      my $table = $params{table} || $self->stash->{list_table};
      die
        "Функция TableList::filter_save. Не определена таблица, по которой строить фильтры"
        unless $table;
      my $lkey   = $self->stash->{replaceme} . '_filter';
      my $lfield = $self->stash->{lfield};
      my $lkeys  = $self->lkey;

      no strict "refs";

      foreach my $k (
        sort {
               $$lkeys{$a}{settings}{rating} <=> $$lkeys{$b}{settings}{rating}
            or $a cmp $b
        } keys %$lkeys
        ) {
        if ( $self->dbi->exists_keys(from => $table, lkey => $k)
          && $lkeys->{$k}->{settings}->{filter}) {
          if (!$lfield or ($lfield and $lfield eq $k)) {
            delete $self->sysuser->settings->{$lkey . '_' . $k};
            delete $self->sysuser->settings->{$lkey . '_' . $k . 'pref'}
              if $self->sysuser->settings->{$lkey . '_filter_' . $k . 'pref'};
          }
        }
      }


      use strict "refs";
      $self->sysuser->save_ses_settings();

    }
  );

  $app->helper(
    def_listfield_buttons => sub {
      my $self   = shift;
      my %params = @_;

      my $default_buttons = [qw(delete edit)];
      $default_buttons = $self->stash->{listfield_buttons}
        if $self->stash->{listfield_buttons};

      # проверка прав ...
      my $user_sys = $self->sysuser->sys;
      foreach (0 .. $#{$default_buttons}) {
        if (  $default_buttons->[$_] eq 'edit'
          and !$self->sysuser->access->{table}->{$params{table}}->{w}
          and !$user_sys) {
          delete $default_buttons->[$_];

        }
        elsif ($default_buttons->[$_] eq 'delete'
          and !$self->sysuser->access->{table}->{$params{table}}->{d}
          and !$user_sys) {
          delete $default_buttons->[$_];
        }
#
      }

      $self->stash->{listfield_buttons} = $default_buttons;
    }
  );

  $app->helper(
    def_listfield_groups_buttons => sub {
      my $self   = shift;
      my %params = @_;

      my $default_groups_buttons = {
        delete => "удалить",
        hide   => "скрыть",
        show   => "показать"
      };
      $default_groups_buttons = $self->stash->{listfield_groups_buttons}
        if $self->stash->{listfield_groups_buttons};

      # проверка прав ...
      my $user_sys = $self->sysuser->sys;
      foreach (keys %$default_groups_buttons) {
        if (  $_ eq 'delete'
          and !$self->sysuser->access->{table}->{$params{table}}->{d}
          and !$user_sys) {
          delete $default_groups_buttons->{$_};
        }
      }

      $self->stash->{listfield_groups_buttons} = $default_groups_buttons;
    }
  );

  $app->helper(
    filter_take => sub {
      my $self   = shift;
      my %params = @_;

      my %filter_take = (
        0 => "не учитывать фильтры",
        1 => "учитывать фильтры"
      );
      $params{lkey} = $self->stash->{replaceme} || $self->stash->{controller};

      my $value
        = $self->sysuser->settings->{$params{lkey} . '_filter_take'} || 0;

      if ($params{render}) {
        $value = $value ? 0 : 1;
        $self->sysuser->save_ses_settings(
          $params{lkey} . '_filter_take' => $value);
      }

      $self->stash->{filter_take_text} = $filter_take{$value};

      delete $self->stash->{text};
      $self->render(text => $self->stash->{filter_take_text})
        if $params{render};
    }
  );

  $app->helper(
    set_filter => sub {
      my $self   = shift;
      my %params = @_;

      my $setting_key = $params{lkey} . '_filter';
      my $lkeys       = $self->lkey(controller => $params{'controller'});

      my $filter_string    = "";
      my $filter_string_qs = "";
      my @current_filter   = ();

      my $user_settings = $self->sysuser->settings;

      # задан быстрый поиск
      if ($user_settings->{$setting_key . '_qsearch'}) {
        my @filter;
        my %filter;
        foreach my $key (@{$self->stash->{listfield_header}}) {
          my $keyf = "$params{table}.`$key`";

          my $v    = $user_settings->{$setting_key . "_qsearch"};
          my $type = $lkeys->{$key}->{settings}->{type};
          if ( ($type eq "s")
            or ($type eq "site")
            or ($type eq "email")
            or ($type eq "d")
            or ($type eq "slat")
            or ($type eq "text")
            or ($type eq "html")) {
            push(@filter, "$keyf LIKE '%$v%'");

          }
          elsif ($v =~ m/^[\d]+$/) {
            push(@filter, "$keyf = $v");

          }
          elsif ($type eq "tlist") {

            my $list_field_as_id = $lkeys->{$key}->{settings}->{list_field_as_id} || 'ID';
            my $list_field_as_name = $lkeys->{$key}->{settings}->{list_field_as_name} || 'name';

            push(@filter,
                  "`"
                . $self->stash->{tables}->{$lkeys->{$key}->{settings}->{list}}
                . "`.`$list_field_as_name` LIKE '%$v%'")
              unless
              exists $filter{$lkeys->{$key}->{settings}->{list} . ".name"};

            $filter{$lkeys->{$key}->{settings}->{list} . ".name"} = 1;

          }

          $filter_string_qs = join(" OR ", @filter);
        }
        if ($filter_string_qs) {
          $filter_string_qs = " AND ($filter_string_qs)";
        }

      }

      if (
        !$user_settings->{$setting_key . '_qsearch'}
        || (  $user_settings->{$setting_key . '_qsearch'}
          and $user_settings->{$setting_key . '_take'})
        ) {

        foreach my $key (%$lkeys) {
          my $lkey = $self->lkey(name => $key, controller => $params{'controller'});
          my $keyf = "`$params{table}`.`$key`";

          if ($user_settings->{$setting_key . "_" . $key}
            and ($self->dbi->exists_keys(from => $params{table}, lkey => $key)))
          {
            my $v = $user_settings->{$setting_key . "_" . $key};

            if ( ($lkey->{settings}->{type} eq "s")
              or ($lkey->{settings}->{type} eq "site")
              or ($lkey->{settings}->{type} eq "text")
              or ($lkey->{settings}->{type} eq "html")) {
              $filter_string .= " AND ($keyf LIKE '%$v%' OR $keyf='$v')";

            }
            elsif (
              (
                   $lkey->{settings}->{type} eq 'list'
                or $lkey->{settings}->{type} eq 'tlist'
              )
              and ($lkey->{settings}->{list_type} eq 'checkbox'
                or $lkey->{settings}->{mult})
              ) {
              $filter_string
                .= " AND ($keyf='$v' OR $keyf LIKE '$v=%' OR $keyf LIKE '%=$v=%' OR $keyf LIKE '%=$v')";

    #				} elsif (($v =~ m/^[\d]+$/) and ($$self{lkeys}{$key}{type} ne "chb")) {
    #					$filter_string .= " AND $keyf = $v";

            }
            elsif ($lkey->{settings}->{type} eq "chb" and $v =~ m/[\d]/) {
              if   ($v == -1) { $filter_string .= " AND $keyf = 0"; }
              else            { $filter_string .= " AND $keyf = 1"; }

            }
            elsif (($lkey->{settings}->{type} eq "date")
              or ($lkey->{settings}->{type} eq "datetime")
              or ($lkey->{settings}->{type} eq "time")) {

              # if datetime convert to date
              $v = substr($v, 0, 10) if (length($v) > 10);
              next if ($v eq '0000-00-00');

              my ($f_year, $f_month, $f_day) = split('-', $v);

# если не заданы каой то параметр то фильтруем по остальным
              if ($f_month eq '00' && $f_day eq '00') {
                $filter_string .= " AND YEAR($keyf)='$f_year'";
              }
              elsif ($f_day eq '00') {
                $filter_string
                  .= " AND YEAR($keyf)='$f_year' AND MONTH($keyf)='$f_month'";
              }
              else {
                $filter_string
                  .= " AND DATE($keyf) "
                  . $self->sysuser->settings->{$setting_key . "_"
                    . $key . "pref"}
                  . " '$v'";
              }

            }
            elsif ($lkey->{settings}->{type} eq "d") {
              $filter_string
                .= " AND $keyf "
                . $self->sysuser->settings->{$setting_key . "_" . $key . "pref"}
                . " $v";

            }
            else {
              $filter_string .= " AND $keyf='$v'";
            }

            push @current_filter, $key;
          }
        }

      }

      $self->stash('current_filter', \@current_filter);

      return $filter_string . $filter_string_qs;
    }
  );

  $app->helper(
    def_tablelist_param => sub {
      my $self = shift;
      my (%params) = @_;

      my $send_param
        = $self->send_params->{$params{key}};    #$self->req->params->to_hash;

      my $key = $params{lkey} . '_'
        . $params{key};    # $self->stash->{replaceme}.'_'.$params{key};
      my $value = $params{default};

      if (!defined $send_param and $self->sysuser->settings->{$key}) {
        $value = $self->sysuser->settings->{$key};
      }
      elsif (defined $send_param) {
        $value = $send_param;
        $self->sysuser->save_ses_settings($key => $value);
      }

      $self->stash->{$params{key}} = $value;
    }
  );

  $app->helper(
    def_listfield => sub {
      my $self   = shift;
      my %params = @_;

      $params{lkey} = $self->stash->{replaceme} || $self->stash->{controller};

      my @table_list_keys        = ("`$params{table}`.`ID`");
      my @table_list_keys_header = ();
      push @table_list_keys_header, 'ID'
        if $self->app->program->{settings}->{'table_indexes'};

      my $sch = 1;
      my %tables;
      $tables{$params{table}} = 1;

      my $lkeys = $self->lkey;

      my @tmp;
      if (!$self->app->sysuser->settings->{$params{lkey} . "_defcol"}) {
        foreach my $k (
          sort {
            ($$lkeys{$a}{settings}{table_list} || 0)
              <=> ($$lkeys{$b}{settings}{table_list} || 0)
              or $a cmp $b
          } keys %$lkeys
          ) {

          my $lkey = $self->lkey(name => $k);
          if (
                $lkey->{settings}->{table_list}
            and $self->dbi->exists_keys(from => $params{table}, lkey => $k)
            and ($self->sysuser->access->{lkey}->{$k}->{r}
              || $self->app->sysuser->sys)
            ) {
            push(@table_list_keys,        "`$params{table}`.`$k`");
            push(@table_list_keys_header, $k);

            if ($lkey->{settings}->{type} eq "pict") {
              if (
                $self->dbi->exists_keys(
                  table => $params{table},
                  lkey  => "folder"
                )
                ) {
                push(@table_list_keys, "`$params{table}`.`folder`");
              }
              if (
                $self->dbi->exists_keys(
                  table => $params{table},
                  lkey  => "type_file"
                )
                ) {
                push(@table_list_keys, "`$params{table}`.`type_file`");
              }
              if (
                $self->dbi->exists_keys(
                  table => $params{table},
                  lkey  => "width"
                )
                ) {
                push(@table_list_keys, "`$params{table}`.`width`");
              }
              if (
                $self->dbi->exists_keys(
                  table => $params{table},
                  lkey  => "height"
                )
                ) {
                push(@table_list_keys, "`$params{table}`.`height`");
              }
            }
            if ($lkey->{settings}->{type} eq "tlist") {
              my $list_field_as_id = $lkey->{settings}->{list_field_as_id} || 'ID';
              my $list_field_as_name = $lkey->{settings}->{list_field_as_name} || 'name';

              my $list = $lkey->{settings}->{list};
              $self->stash->{table_from}
                .= " LEFT JOIN `$list` AS `tb"
                . $sch
                . "` ON `$params{table}`.`$k` = tb"
                . $sch . ".`$list_field_as_id`";
              push(@table_list_keys,
                "tb" . $sch . ".`$list_field_as_name` AS `" . $k . "_name`");
              $tables{$list} = "tb" . $sch;
              $sch++;
            }

          }
        }
      }
      else {
        my $defcol = $self->app->sysuser->settings->{$params{lkey} . "_defcol"};
        foreach my $item (split(/,/, $defcol)) {
          my ($k, $size) = split("~", $item);
          my $lkey = $self->lkey(name => $k);

          if (
            ($self->dbi->exists_keys(table => $params{table}, lkey => $k))
            and ($self->sysuser->access->{lkey}->{$k}->{r}
              || $self->app->sysuser->sys)
            ) {
            $lkey->{settings}->{table_list_width} = $size || 100;
            push(@table_list_keys,        "`$params{table}`.`$k`");
            push(@table_list_keys_header, $k);

            if ($lkey->{settings}->{type} eq "pict") {
              if (
                $self->dbi->exists_keys(
                  table => $params{table},
                  lkey  => "folder"
                )
                ) {
                push(@table_list_keys, "`$params{table}`.`folder`");
              }
              if (
                $self->dbi->exists_keys(
                  table => $params{table},
                  lkey  => "type_file"
                )
                ) {
                push(@table_list_keys, "`$params{table}`.`type_file`");
              }
            }
            if ($lkey->{settings}->{type} eq "tlist") {
              my $list = $lkey->{settings}->{list};
              $self->stash->{table_from}
                .= " LEFT JOIN `$list` AS `tb"
                . $sch
                . "` ON `$params{table}`.`$k` = tb"
                . $sch . ".`ID`";
              push(@table_list_keys,
                "tb" . $sch . ".`name` AS `" . $k . "_name`");
              $tables{$list} = "tb" . $sch;
              $sch++;
            }
          }
        }
      }

      # 2 поле растягиваем на всю ширину
      if ($table_list_keys_header[1]) {
        delete $self->lkeys->{$table_list_keys_header[1]}->{settings}
          ->{table_list_width};
      }

      $self->stash->{tables} = \%tables;
      $self->stash->{total_col_list} += $#table_list_keys;
      $self->stash->{listfield}        = \@table_list_keys;
      $self->stash->{listfield_header} = \@table_list_keys_header;
    }
  );

  $app->helper(
    quick_view => sub {
      my $self   = shift;
      my %params = @_;

      my $list_table = $params{table} || $self->send_params->{list_table};
      my $index = $self->send_params->{index};

      $self->stash->{item} = {};
      if ($list_table && $index) {

        if (my $item
          = $self->getArraySQL(from => $list_table, where => "`ID`='$index'")) {
          foreach (keys %$item) {
            my $lkey = $self->lkey(name => $_);
            delete $item->{$_} unless $lkey->{settings}->{qview};
          }

          $self->stash->{item} = $item;
        }
      }

      $self->render(template => 'admin/table_list/quick_view');
    }
  );

  $app->helper(
    save_qedit => sub {
      my $self = shift;
      my $table = $self->param('list_table') || $self->stash->{list_table};

      my ($index, $sfield)
        = split(/__/, $self->send_params->{textEditElementId});
      $index =~ s{\D+}{}gi;

      require URI::Escape::JavaScript;
      my $value = URI::Escape::JavaScript::js_unescape(
        $self->send_params->{textEditValue});

      if ($sfield eq 'alias') {
        $value = $self->transliteration($value);
        $value = $self->check_unique_field(
          field => $sfield,
          value => $value,
          table => $table,
          index => $index
        );
      }
      else {
        my $valid_params = $self->validate({$sfield => $value});
        $value = $valid_params->{$sfield};
      }

      if ($self->update_hash($table, {$sfield => $value}, "`ID`='$index'")) {
        $self->save_logs(
          name =>
            "Сохранение записи в таблице объектов (ключей) $table",
          comment =>
            "Сохранена запись в таблице объектов [$index]. Таблица $table"
        );
        return $self->render(text => 'OK');
      }

      $self->render(
        text => "Ошибка при обновлении записи");
    }
  );

  $app->helper(
    set_qedit => sub {
      my $self   = shift;
      my %params = @_;

      $params{info} = $params{info} ? "_i" : "";
      my $replaceme   = $self->stash->{replaceme};
      my $controller  = $self->stash->{controller};
      my $script_link = $self->stash->{controller_url};

      if (!$self->sysuser->settings->{$controller . '_qedit_off'}) {
        $self->sysuser->save_ses_settings($controller . '_qedit_off' => 1);

        $self->render(
          json => {
            content => 'Включить QEdit',
            items   => [
              {
                type  => 'eval',
                value => "ld_content('$replaceme', '$script_link?do="
                  . ($params{info} ? 'info' : 'list_container')
                  . "&'+ document.getElementById('${replaceme}_QS').innerHTML.replace(/&amp;/g, '&') );",
              },
            ]
          }
        );
      }
      else {
        $self->sysuser->save_ses_settings($controller . '_qedit_off' => 0);

        $self->render(
          json => {
            content => 'Выключить QEdit',
            items   => [
              {
                type  => 'eval',
                value => "ld_content('$replaceme', '$script_link?do="
                  . ($params{info} ? 'info' : 'list_container')
                  . "&'+ document.getElementById('${replaceme}_QS').innerHTML.replace(/&amp;/g, '&') );",
              },
            ]
          }
        );
      }

    }
  );

  $app->helper(
    delete_list_items => sub {
      my $self   = shift;
      my %params = (table => $self->stash->{list_table}, has_pict => 0, @_,);
      my $table  = delete $params{table};
      my $list_items = $self->stash->{listindex} || return;
      foreach my $id (split(/,/, $list_items)) {
        next unless $id;


        if ($self->getArraySQL(from => $table, where => $id, stash => 'anketa'))
        {

          if ($self->delete_info(from => $table, where => $id)) {
            $self->stash->{tree_reload} = 1;

            $self->save_logs(
              name => 'Удаление записи из таблицы '
                . $params{table},
              comment => "Удалена запись из таблицы ["
                . $id
                . "]. Таблица "
                . $params{table}
            );
          }

          delete $self->stash->{anketa};
        }
      }
    }
  );

  $app->helper(
    show_list_items => sub {
      my $self   = shift;
      my %params = (
        table  => $self->stash->{list_table},
        lfield => 'active',
        value  => 0,
        @_,
      );

      return $self->hide_list_items(%params, value => 1);
    }
  );

  $app->helper(
    hide_list_items => sub {
      my $self   = shift;
      my %params = (
        table  => $self->stash->{list_table},
        lfield => 'active',
        value  => 0,
        @_,
      );
      my $table      = delete $params{table};
      my $list_items = $self->stash->{listindex} || return;
      my $field      = delete $params{'lfield'};

      my @IDs = ();
      foreach (split(/,/, $list_items)) {
        push @IDs, $_ if $_;
      }
      $self->dbi->update_hash(
        $table,
        {$field => $params{value}},
        "`ID` IN (" . join(',', @IDs) . ") "
      ) if (scalar(@IDs) > 0);
    }
  );
}

1;
