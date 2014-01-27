package GG::Content::Catalog;

use utf8;

use Mojo::Base 'GG::Content::Controller';

sub catalog{
	my $self = shift;



}

sub catalog_filter_sizes{
    my $self = shift;

    my @sizes = $self->dbi->query(qq/
		SELECT distinct(size)
		FROM `dtbl_sizes`
		WHERE 1 ORDER BY `size`
	/)->hashes;

	$self->render_partial(		sizes		=> \@sizes,
   								template	=> "Catalog/filter_sizes" );
}

sub catalog_ajax_submitorder{
    my $self = shift;

	my $basket_items = $self->session('basket_items');


	my $vals = {
		error	=> '',
	};
	unless($self->is_auth){
		$vals->{error} = 'Для покупки товаров необходимо авторизоваться';
	}


	my $items = [];
	if(keys %$basket_items){
		my @ids = ();
		foreach (keys %$basket_items){
			push @ids, $_ if keys %{$basket_items->{$_}};
		}

		if(scalar(@ids)>0){
			$items = $self->dbi->query("
						SELECT *
						FROM `data_catalog_items`
						WHERE `ID` IN (".join(',', @ids).") AND `active`='1'")->hashes;
		}
	}

	my $orderComment = $self->validator( type => 's', value => $self->param('zazakcomment') );


	eval{
		my $totalprice = 0;
		foreach my $i ( @{$items} ){
			if($basket_items->{ $i->{ID} }){
				my $count = 0;
				my $price = 0;
				foreach (keys %{$basket_items->{ $i->{ID} }}){
					$count += $basket_items->{ $i->{ID} }->{$_};
				}

				$price += $i->{price_roz} * $count;
				$totalprice += $price;
				$basket_items->{ $i->{ID} }->{price} = $price;
			}
		}
		return unless $totalprice;

		if(my $order_id = $self->insert_hash('data_catalog_orders', {id_user => $self->app->user->{ID}, ordercomment => $orderComment, totalprice => $totalprice})){
			foreach my $i ( @{$items} ){

				my $sizes = $basket_items->{ $i->{ID} };
				my $comment = "";
				foreach (keys %$sizes){
					if($_ ne 'price'){
						$comment = $comment ? $comment." $_=$$sizes{$_}" : "$_=$$sizes{$_}";
					}
				}

				my $item_vals = {
					id_order	=> $order_id,
					id_item		=> $i->{ID},
					pict		=> $i->{pict},
					type_file	=> $i->{type_file},
					folder		=> $i->{folder},
					price		=> $basket_items->{ $i->{ID} }->{price},
					articul		=> $i->{articul},
					articul		=> $i->{articul},
					comment		=> $comment,
					name		=> $i->{name}
				};
				$self->insert_hash('dtbl_orders', $item_vals);
			}
		}
	};
	if($@){
		$vals->{error} = $@;
	} else {
		# Clear basket session
		$self->session('basket_items', {});
	}

	$vals->{html} = $self->render_partial( vals => $vals, template => 'Catalog/basket_order_popup_result');

	my $email_body = 	$self->render_partial(	template	=> "Catalog/submitorder_mail" );

	$self->mail(
    	to      => $self->app->user->{email},
    	subject => 'Вы сделали заказ на сайте '.$self->vars->{site_name}->value,
    	data    => $email_body,
  	);


  	$self->render_json( $vals );
}

sub catalog_basket{
    my $self = shift;

	$self->stash('header', {
		title		=> 	'Корзина',
	});

	my $basket_items = $self->session('basket_items');

	my $items = [];
	if(keys %$basket_items){
		my @ids = ();
		foreach (keys %$basket_items){
			push @ids, $_ if keys %{$basket_items->{$_}};
		}

		if(scalar(@ids)>0){
			$items = $self->dbi->query("
						SELECT *
						FROM `data_catalog_items`
						WHERE `ID` IN (".join(',', @ids).") AND `active`='1'")->hashes;
		}
	}
	$items ||= [];
	$self->catalog_basket_items;



  	$self->render(	basket_items 		=> $basket_items,
  					items				=> $items,
   					template			=> "Catalog/basket" );
}

sub catalog_category_menu{
    my $self = shift;

	my @categorys = $self->dbi->query(qq/
		SELECT *
		FROM `lst_catalog_category`
		WHERE 1 ORDER BY `rating`
	/)->hashes;


	$self->render_partial(		categorys	=> \@categorys,
   								template	=> "Catalog/category_menu" );

}

sub catalog_sizes_block{
	my $self = shift;
	my %params = @_;
	$params{template} ||= 'Catalog/iteminfo_sizes_block';

	my $sizes_str = $params{sizes};
	my @sizes = split(" ", $sizes_str);

	$self->render_partial(		%params,
								sizes		=> \@sizes,
   								);
}

sub catalog_basket_items{
	my $self = shift;

	$self->stash('basket_items', $self->session('basket_items'));
}

sub catalog_ajax_additem{
    my $self = shift;

    my $vals = {
    	error	=> '',
    };
    my $item_id = $self->param('item_id');
    my $delete_flag	= $self->param('delete');
    $item_id =~ s{\D+}{};


    my %items = ();

    if($self->param('params')){
		%items = split("[!,]",  $self->param('params') );
	}
	if($item_id && !$delete_flag){
		my $comment = $self->param('comment');
		$items{ $item_id } = $comment;
	}

	if($delete_flag){
		$item_id ? delete $self->session->{'basket_items'}->{$item_id} : $self->session('basket_items', {});
	} else {
		while(my($item_id, $comment) = each %items){
			next unless $item_id;

	    	my %sizes = split("[=~]", $comment);
	   		$self->session->{'basket_items'}->{$item_id} = \%sizes;
		}
	}


    ($vals->{resultprice}, $vals->{count})  = $self->catalog_calc_resultprice;

   	$self->render_json( $vals );
}

sub catalog_iteminfo{
    my $self = shift;
    my %params	= @_;

    my $item_id = $self->stash('item_id');

    my $FILTER = $self->session('filter');

    #my $where	= " AND `active`='1' ";

	my $order = $FILTER->{order_sql};

    my $item = $self->dbi->query(qq/
		SELECT *
		FROM `data_catalog_items`
		WHERE `ID`='$item_id' AND `active`='1' LIMIT 0,1/)->hash;

	# get all images for item
    my $images = $self->dbi->query(qq/
		SELECT *
		FROM `dtbl_images`
		WHERE `id_data_catalog`='$item_id' AND `pict`!='' ORDER BY `rating`/)->hashes;

	# get brand
    my $brand = $self->dbi->query(qq/
		SELECT *
		FROM `data_catalog_brands`
		WHERE `ID`='$$item{id_brand}'  LIMIT 0,1/)->hash;

	# get colors by articul
	my $colors = [];
   	$colors = $self->dbi->query(qq/
		SELECT t1.`ID`, t2.colorhex, t2.name
		FROM `data_catalog_items` AS t1 LEFT JOIN `lst_catalog_itemcolors` AS t2 ON  t1.color=t2.ID
		WHERE t1.articul='$$item{articul}' AND t1.active='1' AND t1.ID!='$item_id' ORDER BY `rating`/)->hashes if $$item{articul};


	$$FILTER{where} ||= " `id_category`='$$item{id_category}' ";
	# get all other items with current filter

    my $filtered_items = $self->dbi->query(qq/
		SELECT `ID`,`name`,`pict`
		FROM `data_catalog_items`
		WHERE $$FILTER{where} /)->hashes;

	$self->dbh->do("UPDATE `data_catalog_items` SET `view_count`=`view_count`+1 WHERE `ID`='$item_id'");


	my $where	= $self->_build_where( no_order_sql => 1, category => $$item{id_category});

	$item->{index_after} = $self->get_index_after(from => 'data_catalog_items', index => $item_id, ring => 0, where => " AND $where", order => $FILTER->{order_sql});
	$item->{index_befor} = $self->get_index_befor(from => 'data_catalog_items', index => $item_id, ring => 0, where => " AND $where", order => $FILTER->{order_sql});

	$self->stash('header', {
		title		=> 	$$item{title} || $$item{name},
		keywords	=>	$$item{keywords},
		description	=>	$$item{description},
	});

	$self->catalog_basket_items;
	$self->stash('itemprice', $self->catalog_sizes_block(sizes => $item->{sizes}) );

  	$self->render(	item 		=> $item,
  					images		=> $images,
  					brand		=> $brand,
  					colors		=> $colors,
  					filtered_items	=> $filtered_items,
   					template	=> "Catalog/iteminfo" );
}

sub catalog_ajax_items{
    my $self = shift;
    my %params	= @_;

    $params{items} = 1;

 	$self->catalog_list(%params);
}

sub catalog_ajax_filter_update{
    my $self = shift;
	my %params	= @_;

	my $where	= $self->_build_where;

 	my $count = $self->dbi->getCountCol(from => 'data_catalog_items', where => $where);
 	$count ||= 0;

 	$self->render_json( {items_count	=> $count} );

}

sub _build_where{
	my $self = shift;
	my %params	= @_;

	my $FILTER = $self->session('filter') || {};
	my 	$where	 = 	" `active`='1' ";

	my @fields = qw(brand category size_from size_to filter_type order);
	my @fields_send = qw(brand category size_from size_to filter_type order);
	if($self->param('onlycategory')){
		@fields_send = qw(category);
	}

	foreach (@fields){
		$FILTER->{$_} = $self->stash($_) if(defined $self->stash($_));
	}

	foreach (@fields_send){
		$FILTER->{$_} = $self->param($_) if(defined $self->param($_));
	}

	my 	$brand = $FILTER->{brand} || $params{brand};

		$where	.=	" AND `id_brand` IN ($brand)" if(defined $brand);
		#$FILTER->{brand} = $brand;

	my 	$category = "";


	$category = $FILTER->{category} if defined $FILTER->{category};
	$category = $params{category} if defined $params{category} and !defined $category;
		if(defined $category && $category eq '0'){

		} elsif($category){
			my @category = ();
			@category = split(",", $category);

			$where	.=	" AND `id_category` IN ($category)" unless( grep(/^0/, @category) );

		}  else {
			$where	.=	" AND `id_category` IN (0)";
		}

		#$FILTER->{category} = $category;

	my 	$filter_type = $FILTER->{filter_type};

	if($filter_type){
		#$FILTER->{filter_type} = $filter_type;

		if($filter_type == 2){
			$where	.= " AND `is_new`='1' ";

		} elsif($filter_type == 3){
			$where	.= " AND `is_rasprodaja`='1'";

		}
	}

	my ($size_from, $size_to) = ($FILTER->{size_from}, $FILTER->{size_to});

	#if($size_from && $size_to){
		my 	$sizes_where = "1 ";
			$sizes_where .= " AND `size`>='$size_from' " if $size_from;
			$sizes_where .= " AND `size`<='$size_to' " if $size_to;

		my @sizes = $self->dbi->query(qq/
			SELECT DISTINCT `id_catalog_item`
			FROM `dtbl_sizes`
			WHERE $sizes_where
		/)->flat;

		if(scalar(@sizes)>0){
			$where	.= " AND `ID` IN (".join(',', @sizes).")";
		} else {

			if($size_from && $size_to){
				$where	.= " AND `ID` IN (0)";
			}
		}
		#$FILTER->{size_from} = $size_from;
		#$FILTER->{size_to} = $size_to;

	#}


	#order
	my 	$order = $FILTER->{order};
	$order ||= 1;
	$FILTER->{order} = $order;

	my $order_sql = "rdate";
	if($order == 1){
		$order_sql	= "price_roz";

	} elsif($order == 2){
		$order_sql	= "view_count";

	} elsif($order == 3){
		$order_sql	= "rdate";
	}

	my $where_with_order .= $where." ORDER BY `$order_sql`";
	$FILTER->{order_sql} = $order_sql;

	$FILTER->{where} = $where_with_order;

	$self->stash( filter => $FILTER);

	$self->session( filter => $FILTER );
	return $params{no_order_sql} ? $where : $where_with_order;

}

sub catalog_brand_list{
	my $self = shift;
	my %params	= @_;

	my @brands = $self->dbi->query(qq/
			SELECT *
			FROM `data_catalog_brands`
			WHERE 1 ORDER BY `rating`,`name`
		/)->hashes;

	foreach my $i(0..$#brands){
		my $id_brand = $brands[$i]->{ID};
		$brands[$i]->{items_count} = $self->dbi->getCountCol(from => 'data_catalog_items', where => "`id_brand`='$id_brand' AND `sizes`!='' AND `active`='1'");
	}

	$self->render(	brands		=> \@brands,
					template	=> "Catalog/brand_list" );
}

sub catalog_list{
    my $self = shift;
	my %params	= @_;

	$params{page}		   ||= $self->param('page') || 1;
	$params{limit} 		    =  $self->app->vars->{'catalog_limit'}->value;
	$self->stash('page', $params{page});

	#$params{order}		   	= $self->param('order') || 'rating';

	my $category_id = $self->stash('category_id');
	#$category_id ||= '0';

	my $where	= $self->_build_where( category => $category_id);

	my $count = 0;
	if($params{limit}){
		$count = $self->dbi->getCountCol(from => 'data_catalog_items', where => $where);
		$self->def_text_interval( total_vals => $count, cur_page => $params{page}, col_per_page => $params{limit} );
		$params{npage} = $params{limit} * ($params{page} - 1);
		$where .= " LIMIT $params{npage},$params{limit} ";

		$self->stash('count', $count);
	}

	my @items = $self->dbi->query(qq/
		SELECT *
		FROM `data_catalog_items`
		WHERE $where
	/)->hashes;


	if($params{items}){
		my $html = $self->render_partial(	items		=> \@items,
											template	=> 'Catalog/list_items' );

		my @carusel_items = ();
		push @carusel_items, { url => '/image/catalog/mini_'.$_->{pict},  title => $_->{title} || $_->{name},  id => $_->{ID}} foreach @items;

		my ($item_prev, $item_next1);
		my $item_index = $self->param('index');
		if($item_index){

			foreach my $i (0..$#carusel_items){
				if($carusel_items[$i]->{id} == $item_index){
					$item_next = $carusel_items[$i+1]->{id} if($carusel_items[$i+1]);
				}
				$item_prev = $carusel_items[$i]->{id};
			}
		}

		$self->render_json( {html	=> $html, items_count => $count, items => \@carusel_items, 'next' => $item_next, prev => $item_prev } );

	} else {

		$self->metaHeader( title => 'Каталог. Список товаров' );

		$self->stash('category_hash', { name => 'Весь каталог'} );
		if($category_id){
			my $category = $self->dbi->query("SELECT * FROM `lst_catalog_category` WHERE `ID`='$category_id'")->hash;
			$category ||= {};
			$self->stash('category_hash', $category);
		}

	 	my @brands = $self->dbi->query(qq/
			SELECT distinct(data_catalog_brands.ID), data_catalog_brands.*
			FROM `data_catalog_brands` LEFT JOIN `data_catalog_items`
			ON `data_catalog_items`.`id_brand`=`data_catalog_brands`.`ID`
			WHERE `data_catalog_items`.`active`='1' ORDER BY `data_catalog_brands`.`rating`,`data_catalog_brands`.`name`
		/)->hashes;

		$self->render(
			items 		=> \@items,
			category	=> \@brands,
			template	=> "Catalog/list"
		);
	}
}


#
#sub catalog_sendorder{
#	my $self = shift;
#
#	my $items = $self->param('items');
#	my @items = split(",", $items);
#
#	unless(scalar(@items)>0){
#		$self->app->static->serve_404;
#		return;
#	}
#
#	my @categorys = $self->dbi->query(qq/
#		SELECT *
#		FROM `lst_catalog_category`
#		WHERE 1 ORDER BY `rating`
#	/)->hashes;
#
#	my 	$where 	= " `active`='1'";
#
#	my @tmp = ();
#	foreach (@categorys){
#		push @tmp, $_->{ID};
#	}
#		$where 	.= " AND `id_category` IN(".join(",", @tmp).")" if( scalar(@tmp)>0);
#		$where	.= " AND `ID` IN ($items)";
#
#	@items = $self->dbi->query(qq/
#		SELECT *
#		FROM `data_catalog`
#		WHERE $where ORDER BY `rating`,`ID`
#	/)->hashes;
#
#	foreach (0..$#items){
#		$items[$_]->{pricetext} ||= $items[$_]->{price}
#	}
#
#
#
#
#	$self->get_keys( type => ['lkey'], key_program => 'catalog');
#	my $params = $self->stash('params');
#	my %userdata = ();
#
#	my $error = 1;
#	foreach (qw(fname lname phone cardnumber)){
#		unless($params->{$_}){
#			$error = 1;
#			delete($userdata{ $_ });
#
#		} else{
#			$userdata{ $_ } = $params->{$_};
#		}
#	}
#
#	if($error){
#		$self->redirect_to("catalog_basket", userdata => \%userdata, submit => 1);
#	}
#
#	my $email_body = 	$self->render_partial(	items 		=> \@items,
#												userdata	=> \%userdata,
#   												template	=> "Catalog/sendorder_email_body" );
#	$self->mail(
#    	to      => $self->vars->{email_admin}->value,
#    	subject => 'Новый заказ с сайта',
#    	data    => $email_body,
#  	);
#
#
#	$self->redirect_to("text", alias => 'catalog_succes');
#}


1;
