package GG::Import::Commerceml;

use Mojo::Base 'GG::Controller';

use utf8;
use File::Copy;
use XML::Simple;
use Encode;
use File::Basename qw(fileparse);

my $SyncFieldNameSite    = 'synccode';
my $SyncFieldNameXml     = 'Ид';
my $SyncFieldNameXmlList = 'ИдЗначения';
my $InsertOperator       = 'import'
  ; # оператор под кем обновляется / добавляется запись

# Tables
my $Table__items     = 'data_catalog_items';
my $Table__items_dop = 'dtbl_catalog_items_images';
my $Table__categorys = 'data_catalog_categorys';
my $ImgDir           = '/sync/img/';
my $Pict_lkey        = 'pict';


my $Props = {
  'Категория' => {
    lkey     => 'id_category',
    db_table => 'data_catalog_categorys',
    type     => 'custom'
  },
	'Сезон' => {
    lkey     => 'sezon',
    db_table => 'lst_catalog_seazon',
    type     => 'd'
  },
	'Цвет' => {
    lkey     => 'id_color',
    db_table => 'lst_catalog_colors',
    type     => 'd'
  },
	'Сезон' => {
    lkey     => 'sezon',
    db_table => 'lst_catalog_seazon',
    type     => 'd'
  },
  #'Цвет' =>
  #  {lkey => 'id_color', db_table => 'lst_catalog_colors', type => 'd'},
};

my $tmp__categorys        = {};
my $tmp__categorys_parent = {};
my $tmp__props            = {};

sub init {
  my $self   = shift;
  my %params = @_;

  foreach (keys %params) {
    $self->stash->{'commerceml.import'}->{$_} = $params{$_};
  }

  $self->stash->{'controller'} = $self->import_var('controller', 'catalog');

  $ENV{'DOCUMENT_ROOT'} = '/home/p177566/www/krosha-opt.ru';

  return 1;
}

sub import_var {
  my $self          = shift;
  my $var_name      = shift;
  my $default_value = shift;

  return $self->stash->{'commerceml.import'}->{$var_name};
}

sub catalog_offers_path {
  my $self = shift;
  $self->import_var('catalog_offers_path');
}

sub catalog_items_path {
  my $self = shift;
  $self->import_var('catalog_items_path');
}


sub load_categorys {
  my $self            = shift;
  my $categorys       = shift;
  my $parent_synccode = shift || '';

  # Загружаем текущие категории
  for my $r (
    $self->dbi->query(
      "SELECT ID,synccode FROM $Table__categorys WHERE synccode IS NOT NULL"
    )->hashes
    ) {
    $tmp__categorys->{$r->{synccode}}        = $r->{ID};
    $tmp__categorys_parent->{$r->{synccode}} = $r->{parent_category_id};
  }

  foreach my $cat (@{$categorys->{'Группа'}}) {
    next unless $cat->{'Ид'};
    next unless $cat->{'Ид'}->[0];

    my $data = {};
    $data->{'synccode'}           = $cat->{'Ид'}->[0];
    $data->{'name'}               = $cat->{'Наименование'}->[0];
    #$data->{'parent_category_id'} = 0;

    if ($parent_synccode) {
      if (
        my $parent_cat = $self->dbi->query(
          "SELECT ID FROM $Table__categorys WHERE synccode='$parent_synccode' LIMIT 1"
        )->hash
        ) {
        $data->{'parent_category_id'} = $parent_cat->{'ID'};
      }
    }
    warn $data->{'name'};

    my $cur_last_id = $self->dbi->dbh->{'mysql_insertid'};

    $self->dbi->dbh->do(
      qq/
			INSERT INTO $Table__categorys (name, synccode, operator, created_at)
				VALUES ('$$data{name}','$$data{synccode}','$InsertOperator', NOW() )
				ON DUPLICATE KEY UPDATE name=VALUES(name), operator=VALUES(operator), updated_at=NOW();
		/
    );

    if ( $self->dbi->dbh->{'mysql_insertid'}
      && $self->dbi->dbh->{'mysql_insertid'} != $cur_last_id) {
      $tmp__categorys->{$data->{'synccode'}}
        = $self->dbi->dbh->{'mysql_insertid'};
      $tmp__categorys_parent->{$data->{'synccode'}} = $parent_synccode;
    }

    if ($cat->{'Группы'}->[0]) {
      $self->load_categorys($cat->{'Группы'}->[0], $data->{'synccode'});
    }
  }
}

# загружаем справочники
sub load_props {
  my $self      = shift;
  my $propertys = shift;

  foreach my $prop (@{$propertys->{'Свойство'}}) {
    next unless $prop->{'ТипЗначений'};
    next
      unless $prop->{'ТипЗначений'}->[0] eq 'Справочник';

    my $list = $prop->{'Наименование'}->[0];
    next unless $Props->{$list};

    my $list_table = $Props->{$list}->{'db_table'};

    my $values = $prop->{'ВариантыЗначений'}->[0]
      ->{'Справочник'};
    foreach my $v (@$values) {
      next unless my $name     = $v->{'Значение'}->[0];
      next unless my $synccode = $v->{'ИдЗначения'}->[0];

      my $sql = qq/
				INSERT INTO $list_table (name, synccode, operator, created_at)
				VALUES ('$name','$synccode','$InsertOperator', NOW() )
				ON DUPLICATE KEY UPDATE name=VALUES(name), operator=VALUES(operator), updated_at=NOW();
			/;
      if (
        $self->dbi->exists_keys(
          lkey  => 'alias',
          table => $Props->{$list}->{'db_table'}
        )
        ) {
        my $alias = $self->transliteration($name);

        $sql = qq/
					INSERT INTO $list_table (name, synccode, alias, operator, created_at)
					VALUES ('$name','$synccode', '$alias', '$InsertOperator', NOW() )
					ON DUPLICATE KEY UPDATE name=VALUES(name), operator=VALUES(operator), updated_at=NOW();
				/;
      }

      $self->dbi->dbh->do($sql);

      my $prop_id = 0;
      if (
        my $prop = $self->dbi->query(
          "SELECT ID FROM $list_table WHERE synccode='$synccode' LIMIT 1")
        ->hash
        ) {
        $prop_id = $prop->{'ID'};
      }

      $tmp__props->{$synccode} = {
        lkey     => $Props->{$list}->{'lkey'},
        db_table => $Props->{$list}->{'db_table'},
        id       => $prop_id,

        #value 		=> $name,
      };
    }
  }
}

sub load_items {
  my $self  = shift;
  my $items = shift;

#dtbl_catalog_items_synccode
#my $sth_check_articul_exist = $self->dbi->dbh->prepare("SELECT ID FROM $Table__items WHERE articul=?");
  #$self->dbi->dbh->do("TRUNCATE TABLE dtbl_catalog_items_synccode");

#my $categories = $self->dbi->query("SELECT ID,parent_category_id FROM data_catalog_categorys WHERE parent_category_id > 0")->map;
#


  my $sync_img_dir = $self->static_path . $self->import_var('source_img_dir');
  my $dest_dir     = $self->lkey(
    name       => $self->import_var('pict_lkey'),
    setting    => 'folder',
    controller => 'catalog'
  );
  my $dest_dir_dop = $self->lkey(
    name       => $self->import_var('pict_lkey'),
    tbl        => $Table__items_dop,
    setting    => 'folder',
    controller => 'catalog'
  );

  foreach my $item (@{$items->{'Товар'}}) {
    next unless $item->{'Ид'};

    my $data = {
      synccode => $item->{'Ид'}->[0],
      name     => $item->{'Наименование'}->[0] || '',
      active   => 1,
      pict_waiting_update => 0,
      operator            => $InsertOperator,
    };

		if(my $status = $item->{'Статус'}){
			if($status eq 'Удален'){
				my $item = $self->dbi->query("select id from $Table__items where synccode='".$data->{synccode}."'")->hash;
				if($item && $item->{id}){
					$self->dbi->dbh->do("delete from $Table__items where id='".$data->{id}."'");
					$self->dbi->dbh->do("delete from $Table__items_dop where id_item='".$data->{id}."'");
				}
				next;
			}
		}

    $data->{'articul'} = _get_xml_value( $item->{'Артикул'} );
    $data->{'text'}    = _get_xml_value( $item->{'Описание'} );

    $data->{'alias'}
      = $self->transliteration($data->{'articul'} . '_' . $data->{'name'});

    my $cat_synccode = $item->{'Группы'}->[0]->{'Ид'}->[0];

    my $itemprops = $item->{'ЗначенияСвойств'}->[0]
      ->{'ЗначенияСвойства'};

    foreach my $ip (@$itemprops) {
      my $prop_id    = $ip->{'Ид'}->[0];
      my $prop_value = $ip->{'Значение'}->[0];

      warn $prop_id;

      next unless my $p = $tmp__props->{$prop_value};
      next unless $p->{'lkey'};

      $data->{$p->{'lkey'}}
        = $data->{$p->{'lkey'}}
        ? $data->{$p->{'lkey'}} . ',' . $p->{'id'}
        : $p->{'id'};
    }

    #Картинки
    if ($item->{'Картинка'} && scalar($item->{'Картинка'})) {
      my $picts = [];

      foreach my $img (@{$item->{'Картинка'}}) {
        push @$picts, $img;
      }

      $data->{'pict_imported'} = join(',', @$picts);

# если размер первой фотки не изменился то пропускаем обновление
      if (scalar(@$picts)) {

        #$data->{pict_updated} = 0;

        foreach my $p (@$picts) {
          my $folder = $p eq $picts->[0] ? $dest_dir : $dest_dir_dop;
          my ($filename, undef, undef) = fileparse($p);

          if (!-e $sync_img_dir . $p) {

            #$data->{pict_waiting_update} = 1;
            next;
          }
          elsif (!-e $self->static_path . $folder . $filename) {
            $data->{pict_waiting_update} = 1;
            next;
          }
          else {
            my $pict_sync_size = -s $sync_img_dir . $p;
            my $pict_size      = -s $self->static_path . $folder . $filename;

            if ($pict_sync_size != $pict_size) {
              $data->{pict_waiting_update} = 1;
              next;
            }
          }
        }

      }

    }

    #$data->{'top_category_id'} = $categories->{ $data->{'category_id'} } || 0;

    my $item_id = $self->stash->{'index'} = $self->dbi->upsert($Table__items, $data);

		$self->dbi->dbh->do("delete from dtbl_item_sizes where item_id='$item_id'");
		my @item_sizes = ();
		if ($data->{growth}) {
			my @sizes = split(",", $data->{growth});

			foreach (@sizes) {
				my @size = split("-", $_);
				if (scalar @size < 2) {
					$size[1] = $size[0];
				}
				push @item_sizes, [@size];
			}

			if ($item_id && scalar @item_sizes > 0) {
				my @sizes = ();

				foreach my $size (@item_sizes) {
					push @sizes, sprintf('(%1$d, %2$d, %3$d)', $item_id, int(@{$size}[0]), int(@{$size}[1]) ) if scalar @{$size} == 2;
				}

				$self->dbi->query("INSERT INTO `dtbl_item_sizes` (`item_id`, `growth_from`, `growth_to`) VALUES ".join(",", @sizes));
			}
		}

		###


    delete $self->stash->{'index'};
  }

  $self->dbi->dbh->do(
    "UPDATE $Table__items SET pict='', pict_waiting_update=0 WHERE pict_imported='' or pict_imported is NULL");

}

sub _get_xml_value {
	my $xml = shift;

	if($xml && $xml->[0] && !ref $xml->[0]){
		return $xml->[0];
	}
	return '';
}

sub load_catalog {
  my $self = shift;

	#die $self->static_path . $self->catalog_items_path;
  return unless -e $self->static_path . $self->catalog_items_path;

  copy(
    $self->static_path() . $self->catalog_items_path,
    $self->static_path() . $self->catalog_items_path . '__proccess',
    8 * 1024
  );
  unlink $self->static_path() . $self->catalog_items_path;

  my $dbh = $self->dbi->dbh;

  $self->get_keys(type => ['lkey'], controller => 'catalog');

  my $ref
    = XMLin($self->static_path() . $self->catalog_items_path . '__proccess',
    ForceArray => 1);

	#die $self->dumper($ref->{'Каталог'}->[0]->{'Товары'});


  my $propertys
    = $ref->{'Классификатор'}->[0]->{'Свойства'}->[0];

#$self->load_categorys( $ref->{'Классификатор'}->[0]->{'Группы'}->[0] );
  $self->load_props(
    $ref->{'Классификатор'}->[0]->{'Свойства'}->[0]);
  $self->load_items($ref->{'Каталог'}->[0]->{'Товары'}->[0]);

  #$self->_set_top_categories();

  if ($self->import_var('catalog_items_backup_path')) {
    copy(
      $self->static_path() . $self->catalog_items_path . '__proccess',
      $self->static_path() . $self->import_var('catalog_items_backup_path'),
      8 * 1024
    );
  }
  unlink($self->static_path() . $self->catalog_items_path . '__proccess');

  #$self->_set_item_sizes();
}

# sub _set_top_categories {
#   my $self = shift;
#
#   my $categories
#     = $self->dbi->query(
#     "SELECT ID,parent_category_id FROM data_catalog_categorys WHERE parent_category_id > 0"
#     )->map;
#
#   my $sth = $self->dbh->prepare(
#     "UPDATE data_catalog_items SET top_category_id=? WHERE ID=?");
#
#   for my $item (
#     $self->dbi->query(
#       "SELECT ID,category_id FROM data_catalog_items WHERE category_id>0")
#     ->hashes
#     ) {
#     $sth->execute($categories->{$item->{category_id}} || 0, $item->{ID});
#   }
#   $sth->finish();
# }

sub load_images {
  my $self = shift;

  return
    unless my $items
    = $self->dbi->query(
    "SELECT ID,pict_imported FROM $Table__items WHERE pict_waiting_update=1 LIMIT 10")
    ->hashes;

  my $lkey         = 'pict';
  my $sync_img_dir = $self->static_path . $self->import_var('source_img_dir');

  $self->get_keys(type => ['lkey'], controller => 'catalog');

  my $sth_delete_dtbl = $self->dbi->dbh->prepare(
    "DELETE FROM $Table__items_dop WHERE id_item=?");

	#my $folder =
  foreach my $item (@$items) {
    $sth_delete_dtbl->execute($item->{ID});

    my $img_count = 1;
    foreach my $img (split(',', $item->{pict_imported})) {
      next unless -e $sync_img_dir . $img;

      #my ($filename, undef, undef) = fileparse($img);

      if ($img_count == 1) {
        $self->stash->{'index'} = $item->{'ID'};
        if (
          my $mini = $self->lkey(
            name       => $lkey,
            setting    => 'mini',
            controller => 'catalog'
          )
          ) {
          my $filetmp = $self->file_copy_tmp($sync_img_dir . $img);
          eval {
            $self->file_save_pict(
              filename => $filetmp,
              lfield   => $lkey,
              origin   => 1,
              table    => $Table__items,
              fields   => {pict => 'pict'},
              replace  => 1,
            );
          };
          warn $@ if $@;
        }
      }
      else {
        my $folder = $self->static_path
          . $self->lkey(
          name       => $lkey,
          setting    => 'mini',
          controller => 'catalog',
          tbl        => $Table__items_dop,
          setting    => 'folder'
          );
        warn "dopimg: " . $folder;
        my $dopId = $self->dbi->insert_hash(
          $Table__items_dop,
          {
            id_item    => $item->{'ID'},
            operator   => $InsertOperator,
            name       => $self->transliteration($img),
            created_at => $self->setLocalTime(1),
          },
          'REPLACE'
        );

        $self->stash->{'index'} = $dopId;

        if (
          my $mini = $self->lkey(
            name       => $lkey,
            setting    => 'mini',
            controller => 'catalog',
            tbl        => $Table__items_dop
          )
          ) {
          my $filetmp = $self->file_copy_tmp($sync_img_dir . $img);
          eval {
            $self->file_save_pict(
              filename => $filetmp,
              lfield   => $lkey,
              origin   => 1,
              table    => $Table__items_dop,
              fields   => {pict => 'pict'},
              replace  => 1,
            );
          };
          warn $@ if $@;
        }
      }
      $img_count++;

      #last;
    }

    delete $self->stash->{'index'};
    $self->dbi->dbh->do("UPDATE $Table__items SET pict_waiting_update=0 WHERE ID=?",
      undef, $item->{'ID'});
  }
}

sub load_catalog_offers {
  my $self = shift;

  return unless -e $self->static_path . $self->catalog_offers_path;

  copy(
    $self->static_path() . $self->catalog_offers_path,
    $self->static_path() . $self->catalog_offers_path . '__proccess',
    8 * 1024
  );
  unlink $self->static_path() . $self->catalog_offers_path;

  $self->dbi_connect();
  my $dbh = $self->dbi->dbh;

  my $readin = "";
  open(IN, "<",
    $self->static_path() . $self->catalog_offers_path . '__proccess');
  while (<IN>) {
    $readin = $readin . $_;
  }
  close IN;

  #$readin = encode("UTF-8", $readin);

  my $ref = XMLin($readin, ForceArray => 1);

  my $offers = $ref->{'ПакетПредложений'}->[0]
    ->{'Предложения'}->[0];

  #die $self->dumper($offers);

  #die $self->dumper($offers);
  foreach my $offer (@{$offers->{'Предложение'}}) {
    next unless my $dtbl_synccode = $offer->{'Ид'}->[0];

    my $price = $offer->{'Цены'}->[0]->{'Цена'}->[0]
      ->{'ЦенаЗаЕдиницу'}->[0];
    my $quantity = 0;
    if ( $offer->{'Количество'}
      && $offer->{'Количество'}->[0]) {
      $quantity = $offer->{'Количество'}->[0];
    }

    my $is_available = $quantity ? 1 : 0;
    $self->dbi->update_hash($Table__items,
      {
				quantity => $quantity,
				price 	=> $price,
        is_available => $is_available,
			},
      "synccode='$dtbl_synccode'");

  }

  if ($self->import_var('catalog_offers_backup_path')) {
    copy(
      $self->static_path() . $self->catalog_offers_path . '__proccess',
      $self->static_path() . $self->import_var('catalog_offers_backup_path'),
      8 * 1024
    );
  }
  unlink($self->static_path() . $self->catalog_offers_path . '__proccess');

  #$self->_set_item_sizes();

  #$self->_set_item_prices();
}

# sub _set_item_prices {
#   my $self = shift;
#
#   my $sth = $self->dbi->dbh->prepare(
#     "UPDATE data_catalog_items SET price=? WHERE ID=?");
#
#   for my $r (
#     $self->dbi->query(
#       qq/SELECT ID,price_1c, price_discount FROM data_catalog_items WHERE 1/)
#     ->hashes
#     ) {
#     my $price = $r->{price_discount}
#       && $r->{price_discount} ne '0.00' ? $r->{price_discount} : $r->{price_1c};
#     $sth->execute($price, $r->{ID});
#
#   }
#
#   $sth->finish();
#
# }


1;

=encoding utf8

=head1 NAME

Commerce ML import

=head1 SYNOPSIS

=head1 DESCRIPTION

supported version 2.07
