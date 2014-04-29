package GG::Content::Catalog;

use utf8;

use Mojo::Base 'GG::Content::Controller';

sub order_checkout{
	my $self = shift;

	my $basket = $self->userdata->{basket} || {};

	my $json = {
		errors	=> {},
		success	=> '',
	};

	my $comment = $self->check_string( value => $self->param('comment') || '' );

#	my %fields = (
#		name		=> 'Имя',
#		phone		=> 'Телефон',
#		city		=> 'Город',
#		email		=> 'Электронная почта ',
#	);
#
	my $errors = {};
#
#	foreach (keys %fields){
#		if($self->param($_)){
#			$self->app->user->{$_} = $self->param($_);
#		} else {
#			$errors->{ $_ } = 'Не заполенно обязательное поле - '.$fields{$_};
#		}
#	}

	my $send_params = $self->req->params->to_hash;

	unless(keys %$basket){
		$errors->{'misc'} = 'Корзина пуста';
	}

	my $orderComment = $self->check_string( value => $self->param('comment') );

	my $fields = {
		name 		=> {
			label 			=> 'Имя',
			required 		=> 1,
			error_text 		=> 'Укажите Ваше Имя, Фамилию',
		},
		phone 		=> {
			label 			=> 'Контактный телефон',
			required 		=> 1,
			error_text 		=> 'Укажите контактный номер телефона',
		},
		email 		=> {
			label 			=> 'Электронная почта',
			required 		=> 1,
			error_text 		=> 'Укажите электронную почту',
		},
		city 		=> {
			label 			=> 'Город',
			required 		=> 1,
			error_text 		=> 'Укажите Ваш город',
		}
	};


	foreach my $f (keys %$fields){
		if( $send_params->{$f} ){
			$self->stash->{ $f } = $send_params->{$f}

		}
		elsif($fields->{ $f }->{required}){
			$errors->{$f} = $fields->{ $f }->{error_text};

		}
	}

	my $paymentOnline = $self->param('payment') ? 1 : 0;

	if(keys %$errors){
		$json->{errors} = $errors;
		return $self->render( json => $json );
	}

	my $items = $self->dbi->query("
				SELECT *
				FROM `data_catalog_items`
				WHERE `ID` IN (".join(',', keys %$basket).") AND `active`='1'")->hashes || [];

	if(!$items or ref($items) ne 'ARRAY'){
		$json->{errors}->{misc} = 'Не выбраны товары';
		return $self->render( json => $json );
	}


	my $totalPrice = 0;

	foreach my $i (0..scalar(@$items)-1){
		if ($basket->{$items->[$i]->{ID}}) {

			my $count = $basket->{ $items->[$i]->{ID} }->{count};

			$items->[$i]->{sum}   = $items->[$i]->{price} * $count;
			$items->[$i]->{count} = $count;
			$items->[$i]->{color} = $basket->{ $items->[$i]->{ID} }->{color};

			#$items->[$i]->{comment} = "$size=".$count;

			$totalPrice += $items->[$i]->{sum};
		}
	}

	unless($totalPrice){
		$json->{errors}->{misc} = 'Остуствует сумма заказа';
		return $self->render( json => $json );
	}

	$self->stash->{'sum'} = $totalPrice;

	if (my $order_id = $self->dbi->insert_hash('data_catalog_orders', {
			name 		=> $self->stash->{name} || '',
			email 		=> $self->stash->{email} || '',
			phone 		=> $self->stash->{phone} || '',
			city 		=> $self->stash->{city} || '',
			comment 	=> $orderComment || '',
			totalprice 		=> $totalPrice,
			})
		){
		$json->{order_id} = $order_id;
		$json->{price} = $totalPrice;
		$json->{goods} = [];

		$self->stash->{id_order} = $order_id;

		foreach my $i ( 0..scalar(@$items)-1 ){
			$self->dbi->insert_hash('dtbl_orders', {
				id_order	=> $order_id,
				id_item		=> $items->[$i]->{ID},
				pict		=> $items->[$i]->{pict},
				#price		=> $basket_items->{ $i->{ID} }->{price},
				price 		=> $items->[$i]->{price},
				totalprice	=> $items->[$i]->{sum}, #$basket_items->{ $i->{ID} }->{price} * $basket_items->{ $i->{ID} }->{count},
				articul		=> $items->[$i]->{articul},
				color		=> $items->[$i]->{color},
				name		=> $items->[$i]->{name}
			});

			push @{ $json->{goods} }, {
				id_item 	=> $items->[$i]->{ID},
				name 		=> $items->[$i]->{name},
				price 		=> $items->[$i]->{price},
				count 	 	=> $items->[$i]->{count},
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
			items 			=> $items,
			orderComment 	=> $orderComment,
			template		=> "Catalog/_checkout",
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

		$json->{order} = {
			id 		=> $order_id,
		};

		return $self->render( json => $json );

	}


	$json->{errors}->{misc} = 'Системная ошибка, повторите попытку позже';
	return $self->render( json => $json );
}

sub basket_flush{
	my $self = shift;

	$self->userdata->{'basket'} = {};
	$self->save_userdata;

	$self->redirect_to('catalog_basket');
}

sub basket{
	my $self = shift;

	$self->meta_title( 'Корзина' );

	my $basket = $self->userdata->{'basket'};

	my $items = $self->dbi->query("
				SELECT *
				FROM `data_catalog_items`
				WHERE `ID` IN (".join(',', keys %$basket).") AND `active`='1'")->hashes || [];


	$self->render(	basket 		=> $basket,
					items		=> $items,
					template	=> "Catalog/basket" );
}

sub update_basket_items{
	my $self = shift;
	my %params = (
		delFlag => ($self->param('delFlag') && $self->param('delFlag') eq 'true') ? 1 : 0,
		@_
	);

	my $json = {
		error	=> '',
	};

	#return $self->render_not_found unless $self->is_auth;

	use Mojo::JSON;

	my $itemid = $self->param('itemid');
	my $basket = $self->userdata->{'basket'} || {};

	my $items = Mojo::JSON->new->decode( $self->param('items') ) || [];

	my $delFlag = delete $params{delFlag};

	foreach my $item (@$items){
		if($delFlag){
			delete $self->userdata->{basket}->{ $item->{id} };
		} else {
			next if (!$item->{color} or !$item->{id});

			$self->userdata->{basket}->{ $item->{id} } = {
				count 	=> $item->{count},
				color 	=> $item->{color},
			};
		}
	}
	#die $self->dumper( $items );

	($self->stash->{'cataloc_calc_price'}, $self->stash->{'cataloc_calc_count'}) = ($json->{price}, $json->{count}) = $self->catalog_calc_resultprice;

	($json->{price_formated}, $json->{count_formated}) = ($self->numberformat($json->{price}), $self->numberformat($json->{count}));
	# $json->{basket_header} = $self->render(
	# 	template	=> 'Catalog/_basket_header',
	# 	partial 	=> 1
	# );

	$self->save_userdata;

	delete $self->stash->{layout};
	$self->render( json => $json );
}

sub iteminfo{
	my $self = shift;

	my $itemAlias = $self->stash->{item_alias};
	return $self->render_not_found unless my $item = $self->dbi->query("SELECT * FROM `data_catalog_items` WHERE `alias`='$itemAlias' AND `active`='1' ")->hash;

	my $itemImages = $self->dbi->query("SELECT * FROM `dtbl_catalog_items_images` WHERE `id_item`='$$item{ID}' ORDER BY `rating`")->hashes;

	my $recommendItems = [];
	if($item->{recommend}){
		$item->{recommend} =~ s{=}{,}gi;
		$recommendItems = $self->dbi->query("SELECT * FROM `data_catalog_items` WHERE `ID` IN (".$item->{recommend}.") AND `active`='1' ")->hashes || [];
	}

	my $colors = $self->dbi->query("SELECT * FROM `lst_catalog_colors` WHERE 1 ORDER BY `rating`")->hashes;

	if ($self->stash->{'popup'}){
		delete $self->stash->{layout};

		my $out = $self->render(
			popup 		=> 1,
			item 		=> $item,
			basket 		=> $self->userdata->{basket},
			colors 		=> $colors,
			itemImages 	=> $itemImages,
			recommendItems => $recommendItems,
			template	=> 'Catalog/_iteminfo_inner',

			partial 	=> 1
		);

		return $self->render( text => $out)
	}

	$self->meta_title( $item->{title} || $item->{name} );
	$self->meta_keywords( $item->{keywords} );
	$self->meta_description( $item->{description} );

	return $self->render(
		popup 		=> 0,
		item 		=> $item,
		basket		=> $self->userdata->{basket},
		colors 		=> $colors,
		itemImages 	=> $itemImages,
		recommendItems => $recommendItems,
		template	=> 'Catalog/iteminfo',
	)
}

sub list{
	my $self = shift;

	my $category_alias = $self->stash->{category_alias};

	my ($category, $subcategory) = ({}, {});

	if($category_alias){
		return $self->render_not_found
			unless $category = $self->dbi->query("SELECT * FROM `data_catalog_categorys` WHERE `alias`='$category_alias' AND `active`='1' LIMIT 0,1 ")->hash;

		$self->meta_title( $category->{title} || $category->{name} );

		if(my $subcategory_alias = $self->stash->{subcategory_alias}){
			return $self->render_not_found
				unless $subcategory = $self->dbi->query("SELECT * FROM `data_catalog_categorys` WHERE `alias`='$subcategory_alias' AND `active`='1' LIMIT 0,1 ")->hash;

			$self->meta_title( $subcategory->{title} || $subcategory->{name} );
			$self->meta_keywords( $subcategory->{keywords} );
			$self->meta_description( $subcategory->{description} );

		}
		else {
			$self->meta_keywords( $category->{keywords} );
			$self->meta_description( $category->{description} );
		}
	}


	$self->render(
		category	=> $category,
		subcategory	=> $subcategory,
		template	=> 'Catalog/list'
	);
}

sub list_items {
	my $self = shift;
	my %params = (
		limit 	=> 0,# $self->get_var(name => 'catalog_items_limit', controller => 'catalog', raw => 1),
		page 	=> $self->param('page') || 1,
		@_
	);

	my $where = $self->_build_where();

	$self->stash->{page} = $params{page};

	if($params{limit}){
		my $count = $self->dbi->getCountCol(from => 'data_catalog_items', where => $where);
		$self->def_text_interval( total_vals => $count, cur_page => $params{page}, col_per_page => $params{limit} );
		$params{npage} = $params{limit} * ($params{page} - 1);
		$where .= " LIMIT $params{npage},$params{limit} ";

		$self->stash('count', $count);
	}

	my $items = $self->dbi->query(qq/
		SELECT *
		FROM `data_catalog_items`
		WHERE $where
	/)->hashes;

	if($params{items}){

		#my @carusel_items = ();
		#push @carusel_items, { url => '/image/catalog/items/list_'.$_->{pict},  slug => $_->{slug}, title => $_->{title} || $_->{name},  id => $_->{ID}} foreach @$items;

		my ($item_prev, $item_next);
		my $item_index = $self->param('index');
		if($item_index){

		foreach my $i (0..scalar(@$items)-1){
			if($items->[$i]->{id} == $item_index){
				if($items->[$i+1]){
					$item_next = $items->[$i+1]->{id};
				}
				if($items->[$i-1] && $i>0){
					$item_prev = $items->[$i-1]->{id};
				}
			}

			}
		}

		delete $self->stash->{layout};
		return $self->render(
			items		=> $items,
			template	=> 'Catalog/_iteminfo_list_items',
		)
#		return $self->render( json =>  {
#			'items' 	=> \@carusel_items,
#			'next' 		=> $item_next,
#			'prev' 		=> $item_prev,
#		});
	}

	my $out = $self->render(
		items 		=> $items,
		template	=> 'Catalog/_list_items',
		partial		=> 1,
	);

	$self->render(
		text	=> $out
	);
}

sub _build_where{
	my $self = shift;

	my $where = " `active`='1' ";

	my $sendParams = $self->req->params->to_hash;

	my $vals = {};


	if($sendParams->{category_id}){
		$where .= " AND `category_id`='".$sendParams->{category_id}."' ";
	}
	if($sendParams->{sort_field}){
		my $sortDir = $sendParams->{sort_direction};
		$sortDir = 'asc' if($sortDir ne 'asc' && $sortDir ne 'desc');
		$where .= " ORDER BY `".$sendParams->{sort_field}."` $sortDir ";

	}

	#die $where;
	return $where;
}


1;
