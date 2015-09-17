package GG::Content::Catalog;

use utf8;

use Mojo::Base 'GG::Content::Controller';

sub brands {
  my $self = shift;

  my $items
    = $self->dbi->query(
    "SELECT * FROM `data_catalog_brands` WHERE `active`=1 ORDER BY rating,name")
    ->hashes;

  $self->render(items => $items, template => 'Catalog/brands');
}

sub order_checkout {
  my $self = shift;

  my $basket = $self->userdata->{basket} || {};

  my $json = {errors => {}, success => '',};

  my $comment = $self->check_string(value => $self->param('comment') || '');


  my $errors = {};

  my $send_params = $self->req->params->to_hash;

  unless (keys %$basket) {
    $errors->{'misc'} = 'Корзина пуста';
  }

  my $orderComment = $self->check_string(value => $self->param('comment'));

  my $fields = {
    name => {
      label      => 'Имя',
      required   => 1,
      error_text => 'Укажите Ваше Имя, Фамилию',
    },
    addressindex => {
      label      => 'Индекс',
      required   => 1,
      error_text => 'Укажите индекс',
    },
    city => {
      label      => 'Город',
      required   => 1,
      error_text => 'Укажите город',
    },
    street => {
      label      => 'Улица',
      required   => 1,
      error_text => 'Укажите улицу',
    },
    house => {
      label      => 'Дом',
      required   => 1,
      error_text => 'Укажите дом',
    },
    korpus => {
      label      => 'Корпус',
      required   => 0,
      error_text => 'Укажите корпус',
    },
    apartment => {
      label      => 'Квартира',
      required   => 1,
      error_text => 'Укажите квартиру',
    },
    email => {
      label      => 'Электронная почта',
      required   => 1,
      error_text => 'Укажите почту',
    },
    phone => {
      label      => 'Телефон',
      required   => 1,
      error_text => 'Укажите телефон',
    },
  };

  foreach my $f (keys %$fields) {
    if ($send_params->{$f}) {
      $self->stash->{$f} = $send_params->{$f};

    }
    elsif ($fields->{$f}->{required}) {
      $errors->{$f} = '';    #$fields->{ $f }->{error_text};

    }
  }

  if (keys %$errors) {
    $json->{errors} = $errors;
    $json->{errors}->{'misc'}
      = 'ВЫ НЕ ЗАПОЛНИЛИ ОБЯЗАТЕЛЬНЫЕ ПОЛЯ';
    return $self->render(json => $json);
  }

  my $items = $self->dbi->query("
				SELECT data_catalog_items.*, lst_catalog_colors.name AS color_name
				FROM `data_catalog_items`
        LEFT JOIN lst_catalog_colors
          ON data_catalog_items.color_id=lst_catalog_colors.ID
				WHERE data_catalog_items.ID IN ("
      . join(',', keys %$basket)
      . ") AND data_catalog_items.active=1 ")->hashes
    || [];

  if (!$items or ref($items) ne 'ARRAY') {
    $json->{errors}->{misc} = 'Не выбраны товары';
    return $self->render(json => $json);
  }


  my $totalPrice = 0;

  foreach my $i (0 .. scalar(@$items) - 1) {
    if ($basket->{$items->[$i]->{ID}}) {

      my $item_id = $items->[$i]->{ID};
      my $count   = $basket->{$item_id}->{count};
      $items->[$i]->{sum}      = $items->[$i]->{price} * $count;
      $items->[$i]->{count}    = $count;
      $items->[$i]->{size}     = $basket->{$item_id}->{size};
      $items->[$i]->{footsize} = $basket->{$item_id}->{footsize};
      $items->[$i]->{color}    = $items->[$i]->{color};

      #$items->[$i]->{comment} = "$size=".$count;

      $totalPrice += $items->[$i]->{sum};
    }
  }

  unless ($totalPrice) {
    $json->{errors}->{misc} = 'Остуствует сумма заказа';
    return $self->render(json => $json);
  }

  $self->stash->{'sum'} = $totalPrice;

  if (
    my $order_id = $self->dbi->insert_hash(
      'data_catalog_orders',
      {
        name         => $self->stash->{name}         || '',
        email        => $self->stash->{email}        || '',
        phone        => $self->stash->{phone}        || '',
        city         => $self->stash->{city}         || '',
        address      => $self->stash->{address}      || '',
        city         => $self->stash->{city}         || '',
        house        => $self->stash->{house}        || '',
        korpus       => $self->stash->{korpus}       || '',
        street       => $self->stash->{street}       || '',
        addressindex => $self->stash->{addressindex} || '',
        apartment    => $self->stash->{apartment}    || '',
        ordercomment => $orderComment                || '',
        totalprice   => $totalPrice,
        orderstatus  => 0,
      }
    )
    )
  {
    $json->{order_id} = $order_id;
    $json->{price}    = $totalPrice;
    $json->{goods}    = [];

    $self->stash->{id_order} = $order_id;

    foreach my $i (0 .. scalar(@$items) - 1) {
      $self->dbi->insert_hash(
        'dtbl_orders',
        {
          id_order => $order_id,
          id_item  => $items->[$i]->{ID},
          articul  => $items->[$i]->{articul},
          pict     => $items->[$i]->{pict},

          #price		=> $basket_items->{ $i->{ID} }->{price},
          price    => $items->[$i]->{price},
          sum      => $items->[$i]->{sum},
          articul  => $items->[$i]->{articul},
          color    => $items->[$i]->{color},
          size     => $items->[$i]->{size},
          footsize => $items->[$i]->{footsize},
          name     => $items->[$i]->{name}
        }
      );

      push @{$json->{goods}},
        {
        id_item => $items->[$i]->{ID},
        name    => $items->[$i]->{name},
        price   => $items->[$i]->{price},
        count   => $items->[$i]->{count},
        };
    }

    # Clear basket session
    #$self->userdata->{'basket'} = {};
    #$self->save_userdata;


    $json->{success} = 1;

#		$json->{success} = $self->render(
#			template 	=> "Catalog/_checkout_success_msg",
#			partial		=> 1
#		);

    my $mailBody = $self->render_mail(
      items        => $items,
      totalPrice   => $totalPrice,
      orderComment => $orderComment,
      template     => "Catalog/_checkout",
    );

# $self->mail(
# 	to      => $self->get_var(name => 'email_admin', controller => 'global', raw => 1),
# 	subject => 'Сделан заказ на сайте '.$self->site_name,
# 	data    => $mailBody,
# );

# $self->mail(
# 	to      => $self->stash->{email},
# 	subject => 'Вы сделали заказ на сайте '.$self->site_name,
# 	data    => $mailBody,
# );

    $json->{order} = {id => $order_id,};

    return $self->render(json => $json);

  }


  $json->{errors}->{misc}
    = 'Системная ошибка, повторите попытку позже';
  return $self->render(json => $json);
}

sub basket_flush {
  my $self = shift;

  $self->userdata->{'basket'} = {};
  $self->save_userdata;

  $self->redirect_to('catalog_basket');
}

sub basket {
  my $self = shift;

  $self->meta_title('Корзина');

  my $basket = $self->userdata->{'basket'};

  my $items = $self->dbi->query("
				SELECT data_catalog_items.*, lst_catalog_colors.name AS color_name
				FROM `data_catalog_items`
        LEFT JOIN lst_catalog_colors
          ON data_catalog_items.color_id=lst_catalog_colors.ID
				WHERE data_catalog_items.ID IN ("
      . join(',', keys %$basket)
      . ") AND data_catalog_items.active='1'")->hashes
    || [];


  $self->render(
    basket   => $basket,
    items    => $items,
    template => "Catalog/basket"
  );
}

sub update_basket_items {
  my $self = shift;
  my %params = (delFlag => $self->param('delFlag') ? 1 : 0, @_);

  my $json = {error => '',};

  #return $self->render_not_found unless $self->is_auth;

  use JSON;

  my $itemid = $self->param('itemid');
  my $basket = $self->userdata->{'basket'} || {};

  my $items = JSON->new->decode($self->param('items')) || [];

  my $delFlag = delete $params{delFlag};
  warn $delFlag;
  foreach my $item (@$items) {
    warn $delFlag;
    if ($delFlag) {
      delete $self->userdata->{basket}->{$item->{id}};
    }
    else {
      next unless $item->{id};

      if ($self->userdata->{basket}->{$item->{id}}) {

        # update
        $self->userdata->{basket}->{$item->{id}}->{'count'} = $item->{count}
          if $item->{count};
        $self->userdata->{basket}->{$item->{id}}->{'size'} = $item->{count}
          if $item->{size};
        $self->userdata->{basket}->{$item->{id}}->{'footsize'} = $item->{count}
          if $item->{footsize};
      }
      else {
        $self->userdata->{basket}->{$item->{id}} = {
          count    => $item->{'count'},
          size     => $item->{'size'},
          footsize => $item->{'footsize'},
        };
      }
    }
  }
  warn $self->dumper($self->userdata->{basket});
  ($self->stash->{'cataloc_calc_price'}, $self->stash->{'cataloc_calc_count'})
    = ($json->{price}, $json->{count}) = $self->catalog_calc_resultprice;

  $json->{price_formated}
    = sprintf("%s %s", $self->numberformat($json->{price}), 'руб.');
  $json->{count_formated} = sprintf(
    "%s %s",
    $self->numberformat($json->{count}),
    $self->pluralize(
      $json->{count}, [qw(товар товары товаров)]
    )
  );

#($json->{price_formated}, $json->{count_formated}) = ($self->numberformat($json->{price}), $self->numberformat($json->{count}));
# $json->{basket_header} = $self->render(
# 	template	=> 'Catalog/_basket_header',
# 	partial 	=> 1
# );

  $self->save_userdata;

  delete $self->stash->{layout};
  $self->render(json => $json);
}

sub iteminfo {
  my $self = shift;

  my $itemAlias = $self->stash->{item_alias};

  return $self->render_not_found unless my $item = $self->dbi->query(
    qq/
    SELECT data_catalog_items.*, lst_catalog_colors.name AS color_name, data_catalog_brands.name AS brand_name, data_catalog_brands.pict_logo AS brand_pict
    FROM data_catalog_items
    LEFT JOIN
    lst_catalog_colors
      ON data_catalog_items.color_id=lst_catalog_colors.ID
    LEFT JOIN
      data_catalog_brands
        ON data_catalog_items.brand_id=data_catalog_brands.ID
    WHERE data_catalog_items.alias='$itemAlias' AND data_catalog_items.active='1'
  /
  )->hash;

  my $itemImages
    = $self->dbi->query(
    "SELECT * FROM `dtbl_catalog_items_images` WHERE `id_item`='$$item{ID}' ORDER BY `rating`"
    )->hashes;

  my $recommendItems = [];
  if ($item->{recommend}) {
    $item->{recommend} =~ s{=}{,}gi;

    $recommendItems = $self->dbi->query(
      qq/
      SELECT data_catalog_items.*,  data_catalog_brands.name AS brand_name
      FROM `data_catalog_items`
      LEFT JOIN
      data_catalog_brands
      ON  data_catalog_items.brand_id=data_catalog_brands.ID
      WHERE data_catalog_items.ID IN ($$item{recommend}) AND data_catalog_items.active='1'
      /
      )->hashes
      || [];
  }

#my $colors = $self->dbi->query("SELECT * FROM `lst_catalog_colors` WHERE 1 ORDER BY `name`")->hashes;

  if ($self->stash->{'popup'}) {
    delete $self->stash->{layout};

    my $out = $self->render_to_string(
      popup       => 1,
      item        => $item,
      category    => {},
      subcategory => {},
      basket      => $self->userdata->{basket},

      #colors 		=> $colors,
      itemImages     => $itemImages,
      recommendItems => $recommendItems,
      template       => 'Catalog/_iteminfo_inner',
    );

    return $self->render(text => $out);
  }

  my $category = {};
  if ($item->{category_id}) {
    $category
      = $self->dbi->query(
      "SELECT ID,name,alias FROM `data_catalog_categorys` WHERE ID=$$item{category_id} "
      )->hash;
  }
  my $subcategory = {};
  if ($item->{subcategory_id}) {
    $subcategory
      = $self->dbi->query(
      "SELECT ID,name,alias FROM `data_catalog_categorys` WHERE ID=$$item{subcategory_id} "
      )->hash;
  }

  $self->meta_title($item->{title} || $item->{name});
  $self->meta_keywords($item->{keywords});
  $self->meta_description($item->{description});

  return $self->render(
    popup  => 0,
    item   => $item,
    basket => $self->userdata->{basket},

    #colors 		=> $colors,
    category       => $category,
    subcategory    => $subcategory,
    itemImages     => $itemImages,
    recommendItems => $recommendItems,
    template       => 'Catalog/iteminfo',
  );
}

sub list {
  my $self = shift;

  my $category_alias = $self->stash->{category_alias};
  my ($category, $subcategory) = ({}, {});

  if ($category_alias) {
    return $self->render_not_found
      unless $category
      = $self->dbi->query(
      "SELECT * FROM `data_catalog_categorys` WHERE `alias`='$category_alias' AND `active`='1' LIMIT 0,1 "
      )->hash;

    $self->meta_title($category->{title} || $category->{name});

    if (my $subcategory_alias = $self->stash->{subcategory_alias}) {
      return $self->render_not_found
        unless $subcategory
        = $self->dbi->query(
        "SELECT * FROM `data_catalog_categorys` WHERE `alias`='$subcategory_alias' AND `active`='1' LIMIT 0,1 "
        )->hash;

      $self->meta_title($subcategory->{title} || $subcategory->{name});
      $self->meta_keywords($subcategory->{keywords});
      $self->meta_description($subcategory->{description});

    }
    else {
      $self->meta_keywords($category->{keywords});
      $self->meta_description($category->{description});
    }
  }


  $self->render(
    category    => $category,
    subcategory => $subcategory,
    template    => 'Catalog/list'
  );
}

sub list_items {
  my $self   = shift;
  my %params = (
    limit => $self->get_var(
      name       => 'catalog_items_limit',
      controller => 'catalog',
      raw        => 1
    ),
    page => $self->param('page') || 1,
    @_
  );

  my $where = $self->_build_where();

  $self->stash->{page} = $params{page};

  if ($params{limit}) {
    my $count
      = $self->dbi->getCountCol(from => 'data_catalog_items', where => $where);
    $self->def_text_interval(
      total_vals   => $count,
      cur_page     => $params{page},
      col_per_page => $params{limit}
    );
    $params{npage} = $params{limit} * ($params{page} - 1);
    $where .= " LIMIT $params{limit} OFFSET $params{npage} ";

    $self->stash('count', $count);
  }

  my $items = $self->dbi->query(
    qq/
		SELECT data_catalog_items.*, data_catalog_brands.name AS brand_name
		FROM `data_catalog_items`
    LEFT JOIN
    data_catalog_brands
    ON data_catalog_items.brand_id=data_catalog_brands.ID
		WHERE $where
	/
  )->hashes;

  if ($params{items}) {

#my @carusel_items = ();
#push @carusel_items, { url => '/image/catalog/items/list_'.$_->{pict},  slug => $_->{slug}, title => $_->{title} || $_->{name},  id => $_->{ID}} foreach @$items;

    my ($item_prev, $item_next);
    my $item_index = $self->param('index');
    if ($item_index) {

      foreach my $i (0 .. scalar(@$items) - 1) {
        if ($items->[$i]->{id} == $item_index) {
          if ($items->[$i + 1]) {
            $item_next = $items->[$i + 1]->{id};
          }
          if ($items->[$i - 1] && $i > 0) {
            $item_prev = $items->[$i - 1]->{id};
          }
        }

      }
    }

    delete $self->stash->{layout};
    return $self->render(
      items    => $items,
      template => 'Catalog/_iteminfo_list_items',
      )

#		return $self->render( json =>  {
#			'items' 	=> \@carusel_items,
#			'next' 		=> $item_next,
#			'prev' 		=> $item_prev,
#		});
  }

  my $out = $self->render_to_string(
    items    => $items,
    template => 'Catalog/_list_items',
  );

  my $html_nav = $self->page_navigator();

  my $total_string = sprintf(
    "%s %s",
    $self->numberformat($self->stash->{'count'}),
    $self->pluralize(
      $self->stash->{'count'},
      [qw(товар товара товаров)]
    )
  );

  $self->render(
    json => {
      total        => $self->stash->{'count'},
      total_string => $total_string,
      nav          => $html_nav,
      html         => $out,
    }
  );
}

sub _build_where {
  my $self = shift;

  my $where = " data_catalog_items.active='1' ";

  my $sendParams = $self->req->params->to_hash;

  my $vals = {};


  if ($sendParams->{category_id}) {
    $where .= " AND data_catalog_items.category_id='"
      . $sendParams->{category_id} . "' ";
  }
  if ($sendParams->{subcategory_id}) {
    $where .= " AND data_catalog_items.subcategory_id='"
      . $sendParams->{subcategory_id} . "' ";
  }

  if (my $gender = $sendParams->{gender}) {
    my $gender_arr = [];
    foreach (split(',', $gender)) {
      next if $_ !~ /\d+/;
      push @$gender_arr, $_;
    }
    $where
      .= " AND data_catalog_items.gender IN (" . join(',', @$gender_arr) . ") "
      if scalar @$gender_arr;
  }
  if (my $brand_id = $sendParams->{'brand'}) {
    $brand_id = $self->dbi->dbh->quote($brand_id);
    $where .= " AND data_catalog_items.brand_id=$brand_id ";
  }

  if (my $is_new = $sendParams->{'is_new'}) {
    $is_new = $self->dbi->dbh->quote($is_new);
    $where .= " AND data_catalog_items.is_new=$is_new ";
  }

  if (my $is_sale = $sendParams->{'is_sale'}) {
    $is_sale = $self->dbi->dbh->quote($is_sale);
    $where .= " AND data_catalog_items.is_sale=$is_sale ";
  }

  if (my $brand_id = $sendParams->{'brand'}) {
    $brand_id = $self->dbi->dbh->quote($brand_id);
    $where .= " AND data_catalog_items.brand_id=$brand_id ";
  }
  if (my $sizes = $sendParams->{'sizes'}) {
    my $sizes_arr = [];
    foreach (split(',', $sizes)) {
      push @$sizes_arr, $self->dbi->dbh->quote($_);
    }
    $where
      .= " AND data_catalog_items.ID IN (SELECT item_id FROM dtbl_catalog_item_sizes WHERE size IN ("
      . join(',', @$sizes_arr) . ") ) "
      if scalar @$sizes_arr;
  }
  if (my $colors = $sendParams->{'colors'}) {
    my $color_arr = [];
    foreach (split(',', $colors)) {
      next if $_ !~ /\d+/;
      push @$color_arr, $_;
    }
    $where
      .= " AND data_catalog_items.color_id IN ("
      . join(',', @$color_arr) . ") "
      if scalar @$color_arr;
  }

  my $order_direction = $sendParams->{'order_direction'} || 'asc';
  $where .= " ORDER BY data_catalog_items.price $order_direction ";

  return $where;
}


1;
