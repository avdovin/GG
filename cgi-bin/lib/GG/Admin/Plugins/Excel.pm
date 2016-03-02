package GG::Admin::Plugins::Excel;

use utf8;

use Mojo::Base 'Mojolicious::Plugin';

our $VERSION = '1';

use Carp 'croak';
use Spreadsheet::WriteExcel;

sub register {
  my ($self, $app, $opts) = @_;

  $opts ||= {};

  $app->log->debug("register GG::Admin::Plugins::Excel");

  $app->helper(
    export_config => sub {
      my $self   = shift;
      my %params = (@_);

      my $controller = $self->param('key_program');
      my $table      = $self->param('list_table');

      return unless $self->def_program($controller);
      $self->get_keys(type => ['lkey'], controller => $controller);

      $self->stash->{replaceme} = $controller;
      $self->stash->{replaceme} .= "_" . $table if $table;

      my @anketa_keys = ();

      #$self->stash->{group}++;

      my %types = (
        table    => 1,
        text     => 1,
        html     => 1,
        password => 1,
        code     => 1,
        file     => 1,
        filename => 1,
        pict     => 1
      );

      my $group = $self->send_params->{group} ||= 1;


      my $access   = $self->sysuser->access->{lkey};
      my $sys_user = $self->sysuser->sys;
      my $lkeys    = $self->lkey(controller => $controller);

      no strict "refs";
      no warnings;

      if ($group == 1) {
        foreach my $k (
          sort {
            $$lkeys{$a}{settings}{rating} <=> $$lkeys{$b}{settings}{rating}
          } keys %$lkeys
          )
        {
          if ( $self->dbi->exists_keys(from => $table, lkey => $k)
            && ($access->{$k}->{r} || $sys_user)
            && !$lkeys->{$k}->{settings}->{sys}
            && !$types{$lkeys->{$k}->{settings}->{type}})
          {
            push @anketa_keys, $k;
          }

        }

      }
      elsif ($group == 2) {
        my $listfields = $self->stash->{listfields};
        foreach my $k (split(/,/, $listfields)) {
          if ( $self->dbi->exists_keys(from => $table, lkey => $k)
            && $access->{$k}->{r}
            || $sys_user
            && !$lkeys->{$k}->{settings}->{sys}
            && !$types{$lkeys->{$k}->{settings}->{type}})
          {
            push @anketa_keys, $k;
          }
        }
        $self->stash->{listfield_header} = \@anketa_keys;

      }
      else {
        return $self->file_download(
          abs_path => $self->file_tmpdir . $self->param('filename'),
          format   => 'xls'
        );
      }

      use strict "refs";
      use warnings;

      $self->stash->{listfields} = \@anketa_keys;
      if ($group == 2) {

        #my $filename = $self -> exportExcel(%params);
        #$self -> out_html( html => $filename );
        $self->export_excel_get_items();

      }
      elsif ($group == 1) {
        $self->render(template => 'admin/Plugins/Excel/export_config_window');
      }
      return 0;
    }
  );


  $app->helper(
    export_excel_get_items => sub {
      my $self   = shift;
      my %params = (@_);

      $self->stash->{pcol} ||= 100000;
      $self->stash->{page} ||= 0;


      my $table = $self->stash->{list_table};
      $self->stash->{table_from} = $table;

      my $listfields = $self->send_params->{listfields};
      my $listfieild_headers;
      foreach my $k (split(/,/, $listfields)) {
        $listfieild_headers .= $listfieild_headers ? ",$k~100" : "$k~100";
      }
      $self->app->sysuser->settings->{$self->stash->{replaceme} . "_defcol"}
        = $listfieild_headers;

      $self->def_listfield(table => $table, lkey => $self->stash->{replaceme});
      $self->filter_take(lkey => $self->stash->{replaceme});

      my $where_filtered
        = $self->set_filter(lkey => $self->stash->{replaceme}, table => $table);

      my $items = [];
      if ($self->sysuser->access->{table}->{$table}->{r} || $self->sysuser->sys)
      {
        my $listfields = $self->stash->{listfields};
        my $listfield = $self->stash->{listfields} ||= [];
        $items = $self->getHashSQL(
          select => join(",", map {"`$table`.`$_`"} @{$listfield}),
          from  => $self->stash->{table_from},
          where => "1 $params{where} $where_filtered ORDER BY `$table`.`ID` "
            . $self->stash->{asc}
            . " LIMIT "
            . $self->stash->{page} . ","
            . $self->stash->{pcol} . " ",
          sys => 1
        ) || [];
      }
      $self->export_excel_build(items => $items);

#			$params{filename} ||= int(rand(100000000)).".xls";
#			$params{folder}	  = $ENV{'DOCUMENT_ROOT'}.$$self{envv}{tempory_dir}{envvalue};
#
#			$self -> export_do(%params);
#			$self -> {filename} = $params{filename};
#
#			return $params{return} || $self -> defBlock(shablon => "eexport_win_close", from => "shablon_reload");
    }
  );

  $app->helper(
    export_excel_build => sub {
      my $self = shift;
      my %params
        = (items => [], filename => '', folder => '', sheetname => '', @_);

      my $controller = $self->param('key_program');
      my $filename = $params{filename} || $self->transliteration(
        sprintf(
          "%s_%04d_%02d_%02d.xls",
          $self->stash->{controller_name}, (localtime)[5] + 1900,
          (localtime)[4] + 1, (localtime)[3]
        )
      );
      my $dir       = $self->file_tmpdir;
      my $items     = delete $params{items};
      my $sheetname = $params{sheetname} || $self->stash->{controller_name};
      my $listfield_headers = $self->stash->{listfields};
      my $eexcel_key
        = $self->param('eexcel_key')
        ? 1
        : 0;    # ключ поля заменить на описание
      my $lkeys = $self->lkey(controller => $controller);

      $self->stash->{_rowcount} = 0;
      $self->stash->{_colcount} = 0;

      unlink($dir . $filename);
      my $oBook = Spreadsheet::WriteExcel->new($dir . $filename) or die $!;

      #require Encode;
      my $oWs = $oBook->add_worksheet($sheetname);

      $oWs->set_column(0, 0, 30);
      my $length
        = $eexcel_key
        ? scalar(@{$listfield_headers}) - 1
        : scalar(@{$listfield_headers});
      for (my $ct = 0; $ct < $length; $ct++) { $oWs->set_column($ct, $ct, 30); }

      #  	Add and define a format
      my $formats = _eAddFormats($oBook);

      # записываем ключи в первую строку
      foreach my $key (@{$listfield_headers}) {
        next if ($eexcel_key && $key eq 'ID');
        $self->export_excel_build_write_cell(
          $oWs,
          (
            string => $eexcel_key ? $lkeys->{$key}->{name} : $key,
            rowN   => 0,
            colN   => 1,
            format => $formats->{'title'}
          )
        );
      }
      $self->export_excel_build_write_cell($oWs,
        (string => '', rowN => 1, colN => -1, format => $formats->{'title'}));

      foreach my $item (@$items) {

        my $format
          = $self->stash->{_rowcount} & 1
          ? $formats->{'blank'}
          : $formats->{'blank_xRow'};
        foreach my $key (@{$listfield_headers}) {
          next if ($eexcel_key && $key eq 'ID');

          my $value = $item->{$key};
          my $type  = $lkeys->{$key}->{settings}->{type};

          if ($type eq 'chb') {
            $value
              = $value
              ? $lkeys->{settings}->{yes}
              : $lkeys->{$key}->{settings}->{'no'};
          }
          elsif ($type =~ /list/) {
            $value = $self->VALUES(
              name       => $key,
              value      => $value,
              controller => $controller
            );
          }

          $value ||= "----------";
          $value =~ s{^\s+|\s+$}{}gi;

          if (length $value > 15) {
            my $newvalue = "";
            my $i        = 1;
            foreach my $simbol (split("", $value)) {
              $newvalue .= $simbol;
              if ($i >= 10 && $simbol eq " ") {
                $newvalue .= "\n";
                $i == 1;
              }
            }
            $value = $newvalue;
          }

          $self->export_excel_build_write_cell($oWs,
            (string => $value, rowN => 0, colN => 1, format => $format));

        }
        $self->export_excel_build_write_cell($oWs,
          (string => '', rowN => 1, colN => -1, format => $format));
      }

      my $url
        = $self->url_for('admin_routes', controller => 'main', action => 'body')
        . "?do=excel&group=3&filename=$filename&key_program="
        . $self->param('key_program')
        . "&list_table="
        . $self->param('list_table');
      $self->render(
        json => {
          content => "OK",
          items   => [
            {type => 'eval', value => "closeMessage(4);"},
            {type => 'eval', value => "open_url('$url');"}
          ]
        }
      );
    }
  );

  $app->helper(
    export_excel_build_write_cell => sub {
      my $self   = shift;
      my $oWs    = shift;
      my %params = (string => '', rowN => '', colN => '', format => '', @_);

      my $string = delete $params{string};
      $string =~ s/&nbsp;/ /g;
      $string =~ s/^=/'=/;

      $oWs->write(
        $self->stash->{_rowcount},
        $self->stash->{_colcount},
        $string, $params{format}
      );

      $self->stash->{_rowcount}++
        if ($params{rowN} == 1)
        ;    # двигаемся к следующим ячейкам
      $self->stash->{_colcount}++ if ($params{colN} == 1);
      $self->stash->{_colcount} = 0
        if ($params{colN} < 0);    # возвращаемся вначало
    }
  );
}

sub _eAddFormats {
  my $oBook = shift;
  $oBook->set_custom_color(10, '#CCE4D0');
  $oBook->set_custom_color(11, '#EDC263');
  $oBook->set_custom_color(12, '#E90004');

  my $formats = {};

  $formats->{'blank'}
    = $oBook->add_format(color => 'black', num_format => '@', text_wrap => 1);
  $formats->{'blank_xRow'} = $oBook->add_format(
    bg_color   => 10,
    color      => 'black',
    num_format => '@',
    text_wrap  => 1
  );
  $formats->{'title'} = $oBook->add_format(
    bold     => 1,
    size     => 10,
    bg_color => 'silver',
    color    => 'black'
  );
  $formats->{'na'} = $oBook->add_format(color => 'black');
  $formats->{'floor'} = $oBook->add_format();

  #$formats->{'floor'} -> set_num_format('0.00');
  return $formats;

}    # end of &eAddFormats

1;
