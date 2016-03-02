package GG::Admin::Plugins::Fields;

use utf8;

use Mojo::Base 'Mojolicious::Plugin';

our $VERSION = '1';


sub register {
  my ($self, $app, $opts) = @_;

  $opts ||= {};

  $app->log->debug("register GG::Admin::Plugins::Fields");

  $app->helper(
    field_map     => sub {
      my $self = shift;
      my %params = (
        value     => '',
        @_
      );

      my $lkey = $params{lkey};

      my %link_settings = (
        size    => '400x200',
        zoom    => 10,
        layout  => 'map',
        center  => '59.9531,30.2454',
        markstyle => 'pm2bll',
        %{ $lkey->{settings} },
      );

      # обрежем центр если не указано другое
      if ( !$lkey->{settings}->{center} and $params{value} ){
        $link_settings{center} = $params{value};
      }



      $link_settings{size} =~ s/x/,/;
      $link_settings{markstyle} = ','.$link_settings{markstyle};

      my $constructed_link  = 'https://static-maps.yandex.ru/1.x/?';
      $constructed_link    .= 'll='       . $link_settings{center};
      $constructed_link    .= '&size='    . $link_settings{size};
      $constructed_link    .= '&z='       . $link_settings{zoom};
      $constructed_link    .= '&l='       . $link_settings{layout};
      $constructed_link    .= '&pt=';

      return
        $self->image(
            $constructed_link.$params{value}.( $params{value} ? $link_settings{markstyle} : '' ) =>
              (
                id          => $self->stash->{replaceme}. '_' .$params{key}. '_img',
                style       => 'display:' . ( $params{value} ? 'block;' : 'none;'),
                'data-url'    => $constructed_link,
                'data-markstyle' => $link_settings{markstyle},
              )
            )


  });

  $app->helper(
    field_url_for => sub {
      my $self   = shift;
      my %params = @_;

      my $value = delete $params{value} || 0;

      # Check if application has routes
      my $app = $self->app;
      return unless $app->can('routes');

      # Walk and draw
      my $routes = [];

      _walk($self, $_, 0, $routes) for @{$app->routes->children};

      return _draw($self, $routes, $value);

      sub _draw {
        my ($self, $routes, $value) = @_;

        my $options = '';
        foreach my $node (@$routes) {
          next
            if (!$node->[1]->pattern->defaults->{admin_name}
            or !$node->[1]->has_custom_name);
          my $route_admin_name
            = $node->[1]->pattern->defaults->{admin_name};    #$node->[1]->name;
          my $route_layout = $node->[1]->pattern->defaults->{layout};
          my $route_name   = $node->[1]->name;
          my $route_alias  = $node->[1]->pattern->defaults->{alias} || '';

          $options
            .= "<option data-layout='$route_layout' data-alias='$route_alias' value='$route_name' "
            . ($value eq $route_name ? " selected='true' " : "")
            . ">$route_admin_name</option>";
        }
        return $options;
      }

      # "I surrender, and volunteer for treason!"
      sub _walk {
        my ($self, $node, $depth, $routes) = @_;

        # Pattern
        my $prefix = '';
        if (my $i = $depth * 2) { $prefix .= '-' x $i }

        #my $route_url = $node->pattern->pattern || '/';
        my $route_url = $node->pattern->unparsed || '/';

        # Пропускаем админские роуты
        return if ($route_url =~ /^\/admin[\s\S]*/);

        push @$routes, [$prefix . ($route_url), $node];

        $depth++;
        _walk($self, $_, $depth, $routes) for @{$node->children};
        $depth--;
      }
    }
  );

  $app->helper(
    field_select_dir => sub {
      my $self   = shift;
      my %params = (
        parent_field => $self->stash->{dir_field},
        parent_id    => $self->stash->{index},
        lfield       => $self->send_params->{lfield},
        items        => 0,
        index        => 0,
        @_
      );
      my $table = $params{from}
        || $self->lkey(name => $params{lfield})->{settings}->{list};
      my $parent_field = delete $params{parent_field} || $params{lfield};
      my $parent_id = delete $params{parent_id};

      my $dir
        = $self->dbi->exists_keys(from => $table, lkey => 'dir')
        ? " `dir`='1' AND "
        : "";
      my $order
        = $self->dbi->exists_keys(from => $table, lkey => 'rating')
        ? 'rating'
        : 'ID';

      my $dop_where = '';
      $dop_where .= " AND `ID`!='$params{index}'"
        if ($params{'index'} && $self->stash->{list_table} eq $table);

      my $items = $self->getHashSQL(
        select => "`ID`,`name`" . ($dir ? ",`dir`" : ""),
        from => $table,
        where =>
          " $dir `$parent_field`='$parent_id' $dop_where ORDER BY `$order`",
      ) || [];

      foreach my $i (0 .. $#{$items}) {
        $items->[$i]->{flag_plus}     = 0;
        $items->[$i]->{param_default} = '';

        if ($dir && $items->[$i]->{dir}) {
          $items->[$i]->{flag_plus} = 1;

        }
        elsif (!$dir) {
          if (
            $self->dbi->getCountCol(
              from  => $table,
              where => "`$parent_field`='" . $items->[$i]->{ID} . "'"
            )
            )
          {
            $items->[$i]->{flag_plus} = 1;
          }
          else {
            $items->[$i]->{icon} = 'doc';
          }

        }
        else {
          $items->[$i]->{icon} = 'doc';
        }
      }

      $self->param_default(lfield => $params{lfield});

      return $items if $params{items};

      my $html = $self->render_to_string(
        lfield   => $params{lfield},
        items    => $items,
        template => 'admin/anket_form/tree_elements_select',
      );

      $self->render(
        json => {
          content => $html,
          items   => [
            {
              type  => 'eval',
              value => "treeObj['"
                . $self->stash->{replaceme}
                . $params{lfield}
                . "'].initTree();",

            }
          ],
        }
      );
    }
  );

  $app->helper(
    field_upload_swf => sub {
      my $self = shift;
      my %params
        = (lfield => $self->stash->{lfield}, index => $self->stash->{index},
        @_);

      my $html
        = $self->render(%params, template => 'admin/anket_form/pict_uploader');

    }
  );

  $app->helper(
    field_delete_pict => sub {
      my $self   = shift;
      my %params = (
        table => $self->stash->{dop_table} || $self->stash->{list_table},
        folder => '',                               #$self->stash->{folder},
        fields => [$self->send_params->{lfield}],
        lfield => $self->stash->{lfield},
        index  => $self->stash->{index},
        @_
      );

      $params{folder}
        ||= $self->lkey(name => $params{lfield}, setting => 'folder');

      my $folder       = delete $params{folder};
      my $fields       = delete $params{fields};
      my $index        = delete $params{index};
      my $lfield       = delete $params{lfield};
      my $clear_fields = {};
      $clear_fields->{$_} = '' foreach (@$fields);
      $clear_fields->{$lfield} = '';

      if (
        my $item = $self->getArraySQL(
          from  => $params{table},
          where => "`ID`='$index'",
          sys   => 1
        )
        )
      {

        $self->file_delete_pict(%params, pict => $item->{$lfield});

        if (
          $self->save_info(
            table        => $params{table},
            field_values => $clear_fields
          )
          )
        {
          my $lkey = $self->lkey(name => $lfield);

          $self->save_logs(
            name       => "Удалена картинка [$index] «$$lkey{name}»",
            comment    => $params{table},
            event      => 'delete',
            parameters => $clear_fields,
          );
        }
      }

      my $content = $self->render_to_string(
        key      => $lfield,
        lkey     => $self->lkey(name => $lfield),
        template => '/admin/anket_form/reload/field_pict_reload',
      );
      $self->render(
        json => {content => $content, items => $self->get_init_items(),});
    }
  );

  $app->helper(
    field_delete_file => sub {
      my $self   = shift;
      my %params = (
        table => $self->stash->{dop_table} || $self->stash->{list_table},
        folder => '',                       #$self->stash->{folder},
        fields => [],
        lfield => $self->stash->{lfield},
        index  => $self->stash->{index},
        @_
      );

      $params{folder}
        ||= $self->lkey(name => $params{lfield}, setting => 'folder');

      my $folder       = delete $params{folder};
      my $fields       = delete $params{fields};
      my $lfield       = delete $params{lfield};
      my $index        = delete $params{index};
      my $clear_fields = {};

      if (scalar @$fields) {
        $clear_fields->{$_} = '' foreach (@$fields);
      }
      else {
        $clear_fields->{$lfield}                = '';
        $clear_fields->{$lfield . "_folder"}    = '';
        $clear_fields->{$lfield . "_size"}      = '';
        $clear_fields->{$lfield . "_file_type"} = '';
      }

      if (my $item
        = $self->getArraySQL(from => $params{table}, where => "`ID`='$index'"))
      {

        my $document_root = $ENV{DOCUMENT_ROOT};
        unlink($document_root . $folder . $item->{$lfield}) if $item->{$lfield};

        if (
          $self->save_info(
            table        => $params{table},
            field_values => $clear_fields,
            add_to_log   => 0
          )
          )
        {
          my $lkey = $self->lkey(name => $lfield);

          $self->save_logs(
            name       => "Удален файл [$index] «$$lkey{name}»",
            comment    => $params{table},
            event      => 'delete',
            parameters => $clear_fields,
          );
        }
      }

      my $content = $self->render_to_string(
        key      => $lfield,
        lkey     => $self->lkey(name => $lfield),
        template => '/admin/anket_form/reload/field_file_reload'
      );
      $self->render(
        json => {content => $content, items => $self->get_init_items(),});
    }
  );

  $app->helper(
    field_dop_table_reload => sub {
      my $self = shift;

      my $controller = $self->param('replaceme');
      $controller = $1 if $controller =~ /^([^_]+)/;
      $controller =~ s{\d+$}{}gi;

      return unless $self->def_program($controller);


      $self->stash->{list_table} = $self->param('replaceme');
      $self->stash->{list_table} =~ s{^$controller}{};
      $self->stash->{list_table} =~ s{^_|[\d]+}{}gi;

      $self->get_keys(type => ['lkey'], controller => $controller);

      $self->stash->{controller} = $controller;

      $self->stash->{group} = $self->lkey(
        name       => $self->stash->{lfield},
        setting    => 'group',
        controller => $controller
      ) || 1;

      $self->stash->{not_init}         = 1;
      $self->stash->{dop_table_reload} = 1;
      $self->stash->{key}              = $self->stash->{lfield};
      $self->stash->{lkey} = $self->lkey(
        name => $self->stash->{lfield},
        controller => $controller
      );
      $self->stash->{class} = '';

      $self->restore_doptable;

      $self->def_tablelist_param(
        key     => "pcol_doptable",
        lkey    => $self->stash->{key},
        default => 25
      );
      $self->def_tablelist_param(
        key     => "page_doptable",
        lkey    => $self->stash->{key},
        default => 1
      );

      $self->define_anket_form(
        access       => $self->stash->{access_flag},
        template_dir => '/admin/anket_form/',
        template     => 'field_table'
      );
    }
  );

  $app->helper(
    lists_select_search => sub {
      my $self = shift;

      my $controller
        = $self->param('controller') || $self->param('key_program');
      my $lfield = $self->param('lfield');
      $lfield =~ s{^fromselect}{};

      $self->get_keys(type => ['lkey'], controller => $controller);

      my $stash = $self->stash;
      my $replaceme = $self->param('replaceme') || '';

      if (my $rules = $self->param('rules')) {
        my $list_table = $self->lkey(
          name       => $lfield,
          setting    => 'list',
          controller => $controller
        );

        my $menu
          = "lstobj[out].options[lstobj[out].options.length] = new Option('----', '');\n";


        #my $from   = $list_table;
        my (@rules, $field_rules_f1, $field_rules_f2);

        return $self->render(text => $list_table) unless $list_table;

        $rules =~ s/&brvbar;/\|/g;
        (@rules) = split(/\|/, $rules);

        #$rules = $rules[0];

        my ($from, $field_rules) = split(/\./, $rules[0]);
        ($field_rules_f1, $field_rules_f2) = split(/=/, $field_rules);

        my $lkey_field_rules_f1 = $self->lkey(
          name       => $field_rules_f1,
          controller => $controller
        );

        my $lkey_field_rules_f2 = $self->lkey(
          name       => $field_rules_f2,
          controller => $controller
        );

        my $list_f1_as_id = $lkey_field_rules_f1->{settings}->{list_field_as_id} || 'ID';
        my $list_f1_as_name = $lkey_field_rules_f1->{settings}->{list_field_as_name} || 'name';

        my $where  = " 1 ";
        my $select = " $list_f1_as_id as `ID`, $list_f1_as_name as `name`";

        if ($field_rules_f2 eq "index") {
          my $rules_where = $lkey_field_rules_f1->{settings}->{rules_where};
          $where .= " ".$rules_where if $rules_where;

          $where .= " and `$field_rules_f1`='"
            . $stash->{$field_rules_f2} . "' ";

        }
        else {

          my $list_f2_as_id = $lkey_field_rules_f2->{settings}->{list_field_as_id} || 'ID';
          my $list_f2_as_name = $lkey_field_rules_f2->{settings}->{list_field_as_name} || 'name';
          my $list_f2_list = $lkey_field_rules_f2->{settings}->{list};

          $select = "`$list_f2_list`.`$list_f2_as_id` AS ID,"
            . "`$list_f2_list`.`$list_f2_as_name` AS name";
          $where
            = "`$from`.`ID`='"
            . $self->stash->{$field_rules_f2}
            . "' GROUP BY `$field_rules_f2`";
          $from = "`$from` INNER JOIN "
            . $list_f2_list
            . " ON `$from`.`$field_rules_f2`=`"
            . $list_f2_list . "`.`$list_f2_as_id`";
        }


        my $flag_sel = 0;

        if (my $items
          = $self->dbi->query("SELECT $select FROM `$from` WHERE $where")
          ->hashes)
        {
          $menu
            .= "document.getElementById('ok_${replaceme}' + out).innerHTML = \"<span style='background-color:lightgreen;width:45px;padding:3px'>найдено: "
            . scalar(@$items)
            . "</span>\";\n";
          foreach my $item (@$items) {
            my $name = _def_name_list_select($item->{name});

#$flag_sel = 1 if ($self->stash->{ $field_rules_f2 } && $self->stash->{ $field_rules_f2 } == $item->{ID});

            $menu
              .= "lstobj[out].options[lstobj[out].options.length] = new Option('$name', '$$item{ID}');\n"
              if $name;
          }

   # Если найдена 1 запись делаем ее выбранной
          unless ($flag_sel) {
            if (scalar(@$items) == 1) {
              $flag_sel = 1;
              $self->stash->{$lfield} = $items->[0]->{ID};
            }
          }
        }
        else {
          $menu
            .= "document.getElementById('ok_${replaceme}' + out).innerHTML = \"<span style='background-color:red;color:yellow;width:45px;padding:3px'>ничего не найдено...</span>\";\n";
        }

        if ($flag_sel) {
          $menu
            .= "for (j = 0; j < lstobj[out].options.length; j++) { if (lstobj[out].options[j].value == "
            . $self->stash->{$lfield}
            . ") lstobj[out].options[j].selected = true; }\n";
        }

#       if ($#rules >= 0) {
#         foreach (@rules) {
#           $menu .= "getListOther(out, '$_', '$controller');\n";
#         }
#       }

        $self->render(text => $menu)


      }
      elsif (my $keystring = $self->param('keystring')) {


        my $selected_vals = $self->send_params->{$lfield};
        $selected_vals =~ s{=}{,}gi;

        my $list_out = ""
          ; # "lstobj[out].options[lstobj[out].options.length] = new Option('----', '');\n";
        my $sch = 0;

        my $lkey = $self->lkey(name => $lfield, controller => $controller);

        if ($lkey) {
          my $list_as_id = $lkey->{settings}->{list_field_as_id} || 'ID';
          my $list_as_name = $lkey->{settings}->{list_field_as_name} || 'name';
          my $list_table = $lkey->{settings}->{list};
          my $list_where = $lkey->{settings}->{where};

          my $where = " 1 ";
          $where .= $list_where . " " if $list_where;

          $where .= " AND `$list_as_id` NOT IN ($selected_vals) "
            if ($selected_vals
            && ($self->param('multi') or $self->param('mult')))
            ;    # Исключаем ИД если мультисписок
          $where
            .= " AND `$list_as_name` LIKE '%$keystring%' ORDER BY `$list_as_name` LIMIT 0,50";

          for my $item (
            $self->dbi->query("SELECT $list_as_id as `ID`,$list_as_name as `name` FROM `$list_table` WHERE $where")
            ->hashes)
          {
            my $name = _def_name_list_select($item->{name});
            $list_out
              .= "lstobj[out].options[lstobj[out].options.length] = new Option('$name', '$$item{ID}');\n"
              if $name;
            $sch++;
          }

        }
        $list_out
          .= "document.getElementById('ok_' + out).innerHTML = \"<span style='background-color:lightgreen;width:45px;padding:3px'>найдено: "
          . $sch
          . "</span>\";\n";

        $self->render(text => $list_out);
      }


      sub _def_name_list_select {
        my $name = shift;

        $name =~ s/&laquo;/"/;
        $name =~ s/&raquo;/"/;
        $name =~ s/["']+//g;

        return $name;
      }


    }
  );
}

1;
