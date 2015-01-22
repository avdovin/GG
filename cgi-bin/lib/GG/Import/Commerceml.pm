package GG::Import::Commerceml;

use utf8;

use Mojo::Base 'GG::Controller';

#use Modern::Perl;
use File::Copy;
use XML::Simple;
use Encode;

my $SyncFieldNameSite = 'synccode';
my $SyncFieldNameXml = 'Ид';
my $SyncFieldNameXmlList = 'ИдЗначения';
my $InsertOperator = 'import'; 						# оператор под кем обновляется / добавляется запись

# Tables
my $Table__items = 'data_catalog_items';
my $Table__categorys = 'data_catalog_categorys';

# my $Props = {
# 	'Состав' 		=> 'lst_catalog_materials',
# 	'Размеры' 	=> 'lst_catalog_sizes',
# 	'Категория'	=> 'data_catalog_categorys',
# 	'Цвет'			=> 'lst_catalog_colors',
# 	'Бренд'			=> 'data_catalog_brands',
# 	'Страна изготовитель'			=> 'lst_catalog_countryproduction',
# };

my $ImgDir = '/sync/img/';

my $Props = {
	'Состав' 		=> {
			lkey			=> 'material_id',
			db_table 	=> 'lst_catalog_materials',
			type 			=> 'd'
	},
	'Размер' 		=> {
			lkey			=> 'sizes',
			db_table 	=> 'lst_catalog_sizes',
			type 			=> 'custom'
	},
	'Категория' => {
			lkey		=> 'category_id',
			db_table 	=> 'data_catalog_categorys',
			type 		=> 'custom'
	},
	'Цвет' 		=> {
			lkey		=> 'color_id',
			db_table 	=> 'lst_catalog_colors',
			type 		=> 'd'
	},
	'Бренд' 		=> {
			lkey		=> 'brand_id',
			db_table 	=> 'data_catalog_brands',
			type 		=> 'd'
	},
	'Страна изготовитель'	=> {
			lkey		=> '',
			db_table 	=> 'lst_catalog_countryproduction',
			type 		=> 'd'
	},
	'Пол'	=> {
			lkey			=> 'gender_id',
			db_table 	=> 'lst_catalog_gender',
			type 			=> 'd'
	},
};

my $tmp__categorys = {};
my $tmp__categorys_parent = {};
my $tmp__props = {};

sub init{
	my $self = shift;
	my %params = @_;

	foreach (keys %params){
		$self->stash->{'_import'}->{$_} = $params{$_};
	}

	$self->stash->{'controller'} = 'catalog';
	$self->app->static->paths(['/var/www/vhosts/fabstore.ru/httpdocs/']);

	return 1;
}

sub load_categorys{
	my $self = shift;
	my $categorys = shift;
	my $parent_synccode = shift || '';

	# Загружаем текущие категории
	for my $r ($self->dbi->query("SELECT ID,synccode,parent_category_id FROM $Table__categorys WHERE synccode IS NOT NULL")->hashes){
		$tmp__categorys->{ $r->{synccode} } = $r->{ID};
		$tmp__categorys_parent->{ $r->{synccode} } = $r->{parent_category_id}
	}

	foreach my $cat (@{$categorys->{'Группа'}}){
		next unless $cat->{'Ид'};
		next unless $cat->{'Ид'}->[0];

		my $data = {};
		$data->{'synccode'} = $cat->{'Ид'}->[0];
		$data->{'name'} = $cat->{'Наименование'}->[0];
		$data->{'parent_category_id'} = 0;

		if($parent_synccode){
			if(my $parent_cat = $self->dbi->query("SELECT ID FROM $Table__categorys WHERE synccode='$parent_synccode' LIMIT 1")->hash){
				$data->{'parent_category_id'} = $parent_cat->{'ID'};
			}
		}
		warn $data->{'name'};

		my $cur_last_id = $self->dbi->dbh->{'mysql_insertid'};

		$self->dbi->dbh->do(qq/
			INSERT INTO $Table__categorys (name, synccode, operator, parent_category_id, created_at)
				VALUES ('$$data{name}','$$data{synccode}','$InsertOperator', '$$data{parent_category_id}', NOW() )
				ON DUPLICATE KEY UPDATE name=VALUES(name), operator=VALUES(operator), parent_category_id=VALUES(parent_category_id), updated_at=NOW();
		/);

		if($self->dbi->dbh->{'mysql_insertid'} && $self->dbi->dbh->{'mysql_insertid'} != $cur_last_id){
			$tmp__categorys->{ $data->{'synccode'} } = $self->dbi->dbh->{'mysql_insertid'};
			$tmp__categorys_parent->{ $data->{'synccode'} } = $parent_synccode;
		}

		if($cat->{'Группы'}->[0]){
			$self->load_categorys( $cat->{'Группы'}->[0], $data->{'synccode'});
		}
	}
}

# загружаем справочники
sub load_props{
	my $self = shift;
	my $propertys = shift;

	foreach my $prop (@{$propertys->{'Свойство'}}){
		next unless $prop->{'ТипЗначений'};
		next unless $prop->{'ТипЗначений'}->[0] eq 'Справочник';

		my $list = $prop->{'Наименование'}->[0];
		next unless $Props->{ $list };
		my $list_table =  $Props->{ $list }->{'db_table'};

		my $values = $prop->{'ВариантыЗначений'}->[0]->{'Справочник'};
		foreach my $v (@$values){
			next unless my $name = $v->{'Значение'}->[0];
			next unless my $synccode = $v->{'ИдЗначения'}->[0];

			my $sql = qq/
				INSERT INTO $list_table (name, synccode, operator, created_at)
				VALUES ('$name','$synccode','$InsertOperator', NOW() )
				ON DUPLICATE KEY UPDATE name=VALUES(name), operator=VALUES(operator), updated_at=NOW();
			/;
			if($self->dbi->exists_keys(lkey => 'alias', table => $Props->{ $list }->{'db_table'})){
				my $alias = $self->transliteration( $name );

				$sql = qq/
					INSERT INTO $list_table (name, synccode, alias, operator, created_at)
					VALUES ('$name','$synccode', '$alias', '$InsertOperator', NOW() )
					ON DUPLICATE KEY UPDATE name=VALUES(name), operator=VALUES(operator), updated_at=NOW();
				/;
			}

			$self->dbi->dbh->do($sql);

			my $prop_id = 0;
			if( my $prop = $self->dbi->query("SELECT ID FROM $list_table WHERE synccode='$synccode' LIMIT 1")->hash){
				$prop_id = $prop->{'ID'};
			}

			$tmp__props->{ $synccode } = {
				lkey 			=> $Props->{ $list }->{'lkey'},
				db_table 	=> $Props->{ $list }->{'db_table'},
				id 				=> $prop_id,
				#value 		=> $name,
			};
		}
	}
}

sub load_items{
	my $self = shift;
	my $items = shift;

	#dtbl_catalog_items_synccode
	#my $sth_check_articul_exist = $self->dbi->dbh->prepare("SELECT ID FROM $Table__items WHERE articul=?");
	$self->dbi->dbh->do("TRUNCATE TABLE dtbl_catalog_items_synccode");

	foreach my $item (@{$items->{'Товар'}}){
		next unless $item->{'Ид'};

		my $data = {
			synccode 			=> $item->{'Ид'}->[0],
			name 					=> $item->{'Наименование'}->[0],
			active 				=> 1,
			pict_updated 	=> 0,
			operator 			=> $InsertOperator,
		};

		$data->{'alias'} = $self->transliteration( $data->{'name'} );

		$data->{'articul'} = $item->{'Артикул'}->[0];
		$data->{'text'} = $item->{'Описание'}->[0];

		my $cat_synccode = $item->{'Группы'}->[0]->{'Ид'}->[0];

		# ищем ИД категории у БД
		#next unless my $cat_id = $tmp__categorys->{$cat_synccode};
		# if( my $parent_synccode = $tmp__categorys_parent->{ $cat_synccode } ){
		# 	#$data->{'category_id'} = $tmp__categorys->{ $parent_synccode } ;
		# 	#$data->{'subcategory_id'} = $tmp__categorys->{ $cat_synccode } ;
		# 	$data->{'category_id'} = $tmp__categorys->{ $cat_synccode } ;
		# }
		# else {
		# 	$data->{'category_id'} = $tmp__categorys->{ $parent_synccode } ;
		# }

		my $itemprops = $item->{'ЗначенияСвойств'}->[0]->{'ЗначенияСвойства'};

		foreach my $ip (@$itemprops){
			my $prop_id = $ip->{'Ид'}->[0];
			my $prop_value = $ip->{'Значение'}->[0];

			warn $prop_id;

			next unless my $p = $tmp__props->{ $prop_value };
			warn "found: $prop_id";

			$data->{ $p->{'lkey'} } = $data->{ $p->{'lkey'} } ? $data->{ $p->{'lkey'} }.','.$p->{'id'} : $p->{'id'};
		}


		#Картинки
		if($item->{'Картинка'} && scalar($item->{'Картинка'})){
			my $picts = [];

			foreach my $img (@{$item->{'Картинка'}}){
				push @$picts, $img;
			}

			$data->{'pict_imported'} = join(',', @$picts);
		}

		$self->stash->{'index'} = $self->dbi->upsert($Table__items, $data);

		delete $self->stash->{'index'};


		$self->dbi->insert_hash('dtbl_catalog_items_synccode',{
			synccode 	=> $data->{'synccode'},
			articul 	=> $data->{'articul'},
			size_id		=> $data->{'sizes'},
		});
	}

	$self->dbi->dbh->do("UPDATE $Table__items SET pict='', pict_updated=1 WHERE pict_imported=''");

}

sub load_catalog{
	my $self = shift;

	return unless -e $self->static_path.$self->path_catalog_items;

	copy($self->static_path().$self->path_catalog_items, $self->static_path().$self->path_catalog_items.'__proccess' , 8*1024);
	unlink $self->static_path().$self->path_catalog_items;

	my $dbh = $self->dbi->dbh;

	$self->get_keys( type => ['lkey'], controller => 'catalog');

# print 1;
# 	my $readin="";
# 	open (IN,"<", $self->static_path().$self->path_catalog_items.'__proccess');
# 	while (<IN>){
#   	$readin = $readin . $_;
# 	}
# 	close IN;

# 	$readin = encode("UTF-8", $readin);

	my $ref = XMLin( $self->static_path().$self->path_catalog_items.'__proccess' , ForceArray => 1);

	my $propertys = $ref->{'Классификатор'}->[0]->{'Свойства'}->[0];

	#$self->load_categorys( $ref->{'Классификатор'}->[0]->{'Группы'}->[0] );
	$self->load_props( $ref->{'Классификатор'}->[0]->{'Свойства'}->[0] );
	$self->load_items( $ref->{'Каталог'}->[0]->{'Товары'}->[0] );

	if($self->stash->{'_import'}->{'path_catalog_items_backup'}){
		copy($self->static_path().$self->path_catalog_items.'__proccess', $self->static_path().$self->stash->{'_import'}->{'path_catalog_items_backup'}, 8*1024);
	}
	unlink($self->static_path().$self->path_catalog_items.'__proccess');

	#$self->_set_item_sizes();
}

sub load_images{
	my $self = shift;

	return unless my $items = $self->dbi->query("SELECT ID,pict_imported FROM $Table__items WHERE pict_updated=0 LIMIT 10")->hashes;

	my $lkey = 'pict';
	my $sync_img_dir = $self->static_path.$ImgDir;

	$self->get_keys( type => ['lkey'], controller => 'catalog');

	my $sth_delete_dtbl = $self->dbi->dbh->prepare("DELETE FROM dtbl_catalog_items_images WHERE id_item=?");

	foreach my $item (@$items){
		$sth_delete_dtbl->execute($item->{ID});

		my $img_count = 1;
		foreach my $img ( split(',', $item->{pict_imported}) ){
			next unless -e $sync_img_dir.$img;

			if($img_count == 1){
				$self->stash->{'index'} = $item->{'ID'};
				if(my $mini = $self->lkey(name => $lkey, setting => 'mini', controller => 'catalog' ) ){
					my $filetmp = $self->file_copy_tmp( $sync_img_dir.$img );
					$self->file_save_pict(
						filename 	=> $filetmp,
						lfield		=> $lkey,
						table 		=> $Table__items,
						fields		=> {pict => $img},
						replace		=> 1,
					);
				}
			}
			else {
				my $folder = $self->static_path.$self->lkey(name => $lkey, setting => 'mini', controller => 'catalog', tbl => 'dtbl_catalog_items_images', setting => 'folder' );
				warn "dopimg: ".$folder;
				my $dopId = $self->dbi->insert_hash('dtbl_catalog_items_images', {
					id_item		=> $item->{'ID'},
					operator 	=> $InsertOperator,
					name 			=> $self->transliteration($img),
					created_at => $self->setLocalTime(1),
				}, 'REPLACE');

				$self->stash->{'index'} = $dopId;

				if(my $mini = $self->lkey(name => $lkey, setting => 'mini', controller => 'catalog', tbl => 'dtbl_catalog_items_images' ) ){
					my $filetmp = $self->file_copy_tmp( $sync_img_dir.$img );
					$self->file_save_pict(
						filename 	=> $filetmp,
						lfield		=> $lkey,
						table 		=> 'dtbl_catalog_items_images',
						fields		=> {pict => $img},
						replace		=> 1,
					);
				}
			}
			$img_count++;
			#last;
		}

		delete $self->stash->{'index'};
		$self->dbi->dbh->do("UPDATE $Table__items SET pict_updated=1 WHERE ID=?", undef, $item->{'ID'});
	}
}

sub load_catalog_offers{
	my $self = shift;

	return unless -e $self->static_path.$self->path_catalog_offers;

	copy($self->static_path().$self->path_catalog_offers, $self->static_path().$self->path_catalog_offers.'__proccess' , 8*1024);
	unlink $self->static_path().$self->path_catalog_offers;

	$self->dbi_connect();
	my $dbh = $self->dbi->dbh;

	my $readin="";
	open (IN,"<", $self->static_path().$self->path_catalog_offers.'__proccess');
	while (<IN>){
  	$readin = $readin . $_;
	}
	close IN;

	#$readin = encode("UTF-8", $readin);

	my $ref = XMLin(  $readin , ForceArray => 1);

	my $offers = $ref->{'ПакетПредложений'}->[0]->{'Предложения'}->[0];
	#die $self->dumper($offers);

	foreach my $offer (@{ $offers->{'Предложение'} } ){
		next unless my $dtbl_synccode = $offer->{'Ид'}->[0];

		my $price = $offer->{'Цены'}->[0]->{'Цена'}->[0]->{'ЦенаЗаЕдиницу'}->[0];
		my $quantity = $offer->{'Количество'}->[0] || 0;


		$self->dbi->update_hash('dtbl_catalog_items_synccode', {
			quantity => $quantity,
		}, "synccode='$dtbl_synccode'");

		$self->dbi->update($Table__items, {
			price 		=> $price,
			#quantity 	=> $quantity,
			#active		=> $quantity > 0 ? 1 : 0,
		}, "synccode='$dtbl_synccode'");
	}

	if($self->stash->{'_import'}->{'path_catalog_offers_backup'}){
		copy($self->static_path().$self->path_catalog_offers.'__proccess', $self->static_path().$self->stash->{'_import'}->{'path_catalog_offers_backup'}, 8*1024);
	}
	unlink($self->static_path().$self->path_catalog_offers.'__proccess');

	$self->_set_item_sizes();
}



sub path_catalog_offers{
	return shift->stash->{'_import'}->{'path_catalog_offers'};
}

sub path_catalog_items{
	return shift->stash->{'_import'}->{'path_catalog_items'};
}


sub _set_item_sizes{
	my $self = shift;

	warn "_set_item_sizes: begin";


	my $synccodes = {};
	for my $r  ($self->dbi->query(qq/
		SELECT data_catalog_items.synccode,dtbl_catalog_items_synccode.synccode AS dtbl_synccode,dtbl_catalog_items_synccode.quantity,lst_catalog_sizes.name AS size_name
		FROM dtbl_catalog_items_synccode
		LEFT JOIN data_catalog_items
		ON data_catalog_items.articul=dtbl_catalog_items_synccode.articul
		LEFT JOIN lst_catalog_sizes
		ON dtbl_catalog_items_synccode.size_id=lst_catalog_sizes.ID
		/
		)->hashes){
		if( $r->{'synccode'} ){
			$synccodes->{ $r->{'synccode'} } ||= {};
			$synccodes->{ $r->{'synccode'} }->{ $r->{'size_name'} } = $r->{'quantity'};
		}
		elsif($r->{'dtbl_synccode'} && !$synccodes->{ $r->{'dtbl_synccode'} } ){
			$synccodes->{ $r->{'dtbl_synccode'} } ||= {};
			$synccodes->{ $r->{'dtbl_synccode'} }->{ $r->{'size_name'} } = $r->{'quantity'};
		}
		#push @{ $synccodes->{ $r->{'synccode'} }  }, {size_name => $r->{'size_name'},  qnt => $r->{'quantity'}}
	}


	my $sth_update_size = $self->dbi->dbh->prepare("UPDATE data_catalog_items SET sizes=? WHERE synccode=?");
	foreach my $synccode (keys %$synccodes){
		my $sizes = [];
		my $s = [];
		foreach my $s (sort keys %{$synccodes->{$synccode}} ){
			push @$sizes, "$s=".$synccodes->{$synccode}->{$s};
		}
		$sth_update_size->execute(join(',', @$sizes), $synccode);
	}
	$sth_update_size->finish();


	warn "_set_item_sizes: TRUNCATE dtbl";

	$self->dbi->dbh->do("TRUNCATE TABLE `dtbl_catalog_item_sizes`");

	return unless my $items = $self->dbi->query("SELECT ID, sizes FROM data_catalog_items WHERE sizes!='' ")->hashes;

	my $sizes_hash = $self->dbi->query("SELECT ID,name FROM lst_catalog_sizes WHERE 1")->map_hashes('ID');

	my $sth_replace_dtbl_size = $self->dbi->dbh->prepare("REPLACE INTO dtbl_catalog_item_sizes(item_id, size, qnt) VALUES (?, ?, ?)");
	foreach my $item (@$items){
		my $sizes = $item->{'sizes'};
	  my @sizes = ();
	  foreach my $size (split(',', $sizes)){
	    my ($k, $v) = split('=', $size);
	    $v =~ s{\D}{}gi;
	    $v =~ s{^\s+|\s+$}{}gi;
	    $k =~ s{^\s+|\s+$}{}gi;
    	next unless $v;

    	$sth_replace_dtbl_size->execute($$item{ID}, $k, $v);

	    # next unless $size;
	    # next unless my $v = $sizes_hash->{$size};
	    # next unless $v = $v->{name};

	    # my $qnt = $synccodes

	    # $self->dbi->dbh->do("REPLACE INTO dtbl_catalog_item_sizes(item_id, size, qnt) VALUES ('$$item{ID}', '$v', '0')");
	  }
	}
	warn "_set_item_sizes: finish";

	$sth_replace_dtbl_size->finish();
  $self->dbi->query("OPTIMIZE TABLE `dtbl_catalog_item_sizes`");
}

# sub document_root{
# 	return $ENV{'DOCUMENT_ROOT'}
# }

1;