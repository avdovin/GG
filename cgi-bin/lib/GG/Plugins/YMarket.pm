package GG::Plugins::YMarket;

use utf8;

use Mojo::Base 'Mojolicious::Plugin';

sub register {
	my ($self, $app, $conf) = @_;
	
	
	$app->routes->route("ymarket")->to( cb => sub{
		my $self   = shift;
		
		my $CONFIG = {
			'name' => 'Рога и копыта', #название магазина
			'company' => 'ООО Рога и копыта', # название компании
			'url'	=> $self->req->url->base->host, #сайт
			'cms' => 'GoodGear CMS', #cms
			'cms_version' => '9', # версия cms
			'agency' => 'ООО "Айфрог"',# организация, которая обслуживает сайт
			'email' => 'ifrogseo@gmail.com',# email обслуживающей организации
			'cpa'	=> '0', # участие в программе "покупка на маркете"
			'currencies' => { # соответствие валют, короткий код => отношение к рублю, подробнее http://help.yandex.ru/partnermarket/currencies.xml
				'RUR' => {
					'rate' => '1',
				}
			},
			'replaces' => { # замена внутренних значений на значения маркета, ex:
				'available' => 'is_avalible', # в базе is_avalible - в маркете available
				'picture' => 'pict',
			},
			'group_replaces' => { # замена внутренних групп на группы маркета, описания должны лежать здесь http://help.yandex.ru/partnermarket/docs/market_categories.xls
				'1' => '/Оборудование/Рекламные сувениры',
				'2' => '/Оборудование/Охрана и сигнализация',
				'3' => '/Оборудование/Охрана и сигнализация/Сейфы',
				'default' => '/Оборудование', # дефолтные значения которые не подпадают под категории
			},
			'adult' => 0, # товары для взрослых 
			'country_of_origin' => 'США', # страна производитель по умолчанию
			'market_flag' => 'market', # флаг в базе выгружать в маркет или нет
			'where' => ' AND `active`=1 ', # дополнительное условие
			'pickup' => 'true', # самовывоз, true || false;
			'store' => 'true', # взозможность забрать товар из магазина, true || false;
			'delivery' => 'true', # доставка, true || false;
		};
		my $host = "http://".$self->host || $CONFIG->{url};
		my $now = $self->dbi->query("SELECT NOW()")->list;
		my $categories = $self->dbi->query("SELECT * FROM `data_catalog_categorys`")->hashes || [];
		my $where = '1';
		if ($CONFIG->{market_flag}){
			$where .= " AND `$$CONFIG{market_flag}`=1 ";
		};
		if ($CONFIG->{where}){
			$where .= $CONFIG->{where};
		};
		my $items = $self->dbi->query("SELECT * FROM `data_catalog_items` WHERE $where")->hashes;
		my @release_items = ();
		foreach my $item (@$items){
			$item->{url} = $host.$self->url_for('catalog_iteminfo',item_id => $item->{ID});
			$item->{categoryId} = $item->{category_id};
			$item->{market_category} = $CONFIG->{group_replaces}->{$item->{id_group}} || $CONFIG->{group_replaces}->{'default'};
			$item->{picture} = $host."/image/catalog/items/$$item{pict}";
			$item->{vendor} = $brands->{$item->{id_brand}}{name};
			$item->{vendorCode} = $item->{articul} || '';
			$item->{description} = strXhtmlValid($item->{text});
			$item->{pickup} = $item->{pickup} || $CONFIG->{pickup};
			$item->{delivery} = $item->{delivery} || $CONFIG->{delivery};
			$item->{store} = $item->{store} || $CONFIG->{store};
			$item->{manufacturer_warranty} = 'false'; # гарантия производителя хз что с ней делать
			$item->{country_of_origin} = $CONFIG->{country_of_origin};
			$item->{cpa} = $CONFIG->{cpa};		

			# my $params = $self->dbi->query("SELECT * FROM `dtbl_catalog_dimensions` WHERE `id_item`=$$item{ID} ORDER BY `rating`")->hashes;

			# $item->{params} = {};
			# foreach(@$params){
			# 	$item->{params}->{$_->{name}} = $_->{value};
			# }
			push @release_items, $item;

		}

		$self->render( 
			config => $CONFIG, 
			currencies => $CONFIG->{currencies}, 
			items => \@release_items,
			now => $now,
			categories => $categories,
			template => 'Plugins/YMarket/ymarket', 
			format => 'yml',
		);	
		
	})->name('ymarket');
		
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
