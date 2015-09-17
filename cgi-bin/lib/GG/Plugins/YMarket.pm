package GG::Plugins::YMarket;

use utf8;

use Mojo::Base 'Mojolicious::Plugin';

sub register {
  my ($self, $app, $conf) = @_;


  $app->routes->get("ymarket")->to(
    cb => sub {
      my $self = shift;

      my $CONFIG = {
        'name'    => 'Obey Russia',    #название магазина
        'company' => 'Obey Russia',    # название компании
        'url'         => "http://" . $self->host,    #сайт
        'cms'         => 'GG CMS',                   #cms
        'cms_version' => '9',                        # версия cms
        'agency'      => 'ООО "Айфрог"'
        , # организация, которая обслуживает сайт
        'email' => 'ifrogseo@gmail.com'
        ,    # email обслуживающей организации
        'cpa' => '0'
        , # участие в программе "покупка на маркете"
        'currencies' =>
          { # соответствие валют, короткий код => отношение к рублю, подробнее http://help.yandex.ru/partnermarket/currencies.xml
          'RUR' => {'rate' => '1',}
          },
        'replaces' =>
          { # замена внутренних значений на значения маркета, ex:
          'available' => 'is_avalible'
          ,    # в базе is_avalible - в маркете available
          'picture' => 'pict',
          },
        'group_replaces' =>
          { # замена внутренних групп на группы маркета, описания должны лежать здесь http://help.yandex.ru/partnermarket/docs/market_categories.xls
          'default' =>
            '/Дом и дача/Строительство и ремонт/Материалы/Облицовочные и отделочные/Обои'
          , # дефолтные значения которые не подпадают под категории
          },
        'adult' => 0,    # товары для взрослых
        'country_of_origin' => 'Финляндия'
        ,    # страна производитель по умолчанию
        'vendor' =>
          'Sandudd',    # производитель по умолчанию
        'description' =>
          'Экологичные флизелиновые обои скандинавского дизайна без винила. Складская программа – финские обои в наличии на складе в Петербурге. Доставка по СПб от 1 до 5 дней с момента оплаты. Универсальный дизайн: от винтажной классики до современного минимализма! Финские обои длиной 11,2 м: 4 полосы с 1 рулона. Бесплатно привозим образцы обоев на дом!'
        ,               # описание
        'market_flag' => ''
        , # флаг в базе выгружать в маркет или нет
        'market_flag_categories' =>
          '',    # флаг в базе для категорий
        'where' =>
          ' AND `active`=1 ',    # дополнительное условие
        'where_categories' => ' AND `active`=1'
        , # дополнительное условие для категорий
        'manufacturer_warranty' =>
          'true',   #гарантия производителя, true || false;
        'pickup' => 'true',    # самовывоз, true || false;
        'store'  => 'true'
        , # взозможность забрать товар из магазина, true || false;
        'delivery' => 'true',    # доставка, true || false;
        'price'    => sub {
          my $item = shift;
          return $item->{price};
        },
      };

      my $host             = "http://" . $self->host || $CONFIG->{url};
      my $now              = $self->setLocalTime(1);
      my $where_categories = "1";
      if ($CONFIG->{market_flag_categories}) {
        $where_categories .= " AND `$$CONFIG{market_flag_categories}`=1 ";
      }
      if ($CONFIG->{where_categories}) {
        $where_categories .= $CONFIG->{where_categories};
      }
      my $categories
        = $self->dbi->query(
        "SELECT * FROM `data_catalog_categories` WHERE $where_categories")
        ->hashes || [];

      my @categories_ids = ();
      push @categories_ids, $_->{ID} foreach (@$categories);
      my $where = '1';
      if ($CONFIG->{market_flag}) {
        $where .= " AND `$$CONFIG{market_flag}`=1 ";
      }
      if ($CONFIG->{where}) {
        $where .= $CONFIG->{where};
      }

# if (scalar (@categories_ids)){
# 	$categories = $self->dbi->query("SELECT * FROM `data_catalog_groups` WHERE `id_group` IN (".join(',',@categories_ids).")  OR `ID` IN (".join(',',@categories_ids).")")->hashes;
# 	@categories_ids = ();
# 	push @categories_ids, $_->{ID} foreach (@$categories);
# 	$where .= " AND `id_group` IN (".join(',',@categories_ids).") " if scalar @categories_ids;
# }

      my $items
        = $self->dbi->query("SELECT * FROM `data_catalog_items` WHERE $where")
        ->hashes;
      my $release_items = [];
      foreach my $item (@$items) {
        $item->{url} = $host
          . $self->url_for('catalog_iteminfo', item_alias => $item->{alias});
        $item->{categoryId} = $item->{subcategory_id};
        $item->{market_category}
          = $CONFIG->{group_replaces}->{$item->{id_group}}
          || $CONFIG->{group_replaces}->{'default'};
        $item->{picture} = $host . "/image/catalog/items/$$item{pict}";
        $item->{vendor} = $item->{brand} || $CONFIG->{vendor} || '';

        #$item->{vendorCode} = $item->{articul} || '';
        #$item->{description} = strXhtmlValid($item->{text});
        $item->{description}           = $CONFIG->{description};
        $item->{pickup}                = $item->{pickup} || $CONFIG->{pickup};
        $item->{delivery}              = $CONFIG->{delivery};
        $item->{price}                 = $CONFIG->{price}->($item);
        $item->{store}                 = $item->{store} || $CONFIG->{store};
        $item->{manufacturer_warranty} = $CONFIG->{manufacturer_warranty}
          ; # гарантия производителя хз что с ней делать
        $item->{country_of_origin} = $CONFIG->{country_of_origin};
        $item->{cpa}               = $CONFIG->{cpa};

        push @$release_items, $item;

      }
      $self->res->headers->content_type('text/xml;charset=utf-8');
      $self->render(
        config     => $CONFIG,
        currencies => $CONFIG->{currencies},
        items      => $release_items,
        now        => $now,
        categories => $categories,
        template   => 'Plugins/YMarket/ymarket',
        format     => 'yml',
      );

    }
  )->name('ymarket');

}

sub strXhtmlValid ($) {
  $_[0] =~ s/&(?!amp;)/&amp;/g;
  $_[0] =~ s/</&lt;/g;
  $_[0] =~ s/>/&gt;/g;
  $_[0] =~ s/"/&quot;/g;
  $_[0] =~ s/'/&apos;/g;
  return $_[0];
}

1;
