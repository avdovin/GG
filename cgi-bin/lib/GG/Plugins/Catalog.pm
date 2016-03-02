package GG::Plugins::Catalog;

use Mojo::Base 'Mojolicious::Plugin';

use utf8;

sub register {
  my ($self, $app, $opts) = @_;

  $app->helper(
    catalog_has_in_basket => sub {
      my $self   = shift;
      my $itemId = shift;

      return $self->userdata->{basket}->{$itemId} || 0;
    }
  );

  $app->helper(
    catalog_calc_resultprice => sub {
      my $self = shift;

      my $basket = $self->userdata->{basket} || {};

      my ($price, $count) = (0, 0);
      if (keys %$basket) {
        for my $row (
          $self->dbi->query("
				SELECT `ID`, `price`
				FROM `data_catalog_items`
				WHERE `ID` IN (" . join(',', keys %$basket) . ") AND `active`='1'")->hashes
          )
        {

          my $basketItem = $basket->{$row->{ID}};

          unless ($basketItem->{count}) {
            delete $basket->{$row->{ID}};
            $self->save_userdata;
            next;
          }
          $price += $basketItem->{'count'} * $row->{price};
          $count++;
        }
      }

      return ($price, $count);
    }
  );

  $app->helper(
    catalog__filters => sub {
      my $self = shift;

      my $categorys
        = $self->dbi->query(
        "SELECT ID,name,alias,parent_category_id FROM `data_catalog_categorys` WHERE 1 ORDER BY `rating`, `name`"
        )->hashes;
      my $brands
        = $self->dbi->query(
        "SELECT ID,name FROM `data_catalog_brands` WHERE 1 ORDER BY `rating`, `name`"
        )->hashes;
      my $sizes
        = $self->dbi->query(
        "SELECT size FROM `dtbl_catalog_item_sizes` WHERE 1 ORDER BY `size`")
        ->flat;
      my $colors = $self->dbi->query(
        "SELECT * FROM `lst_catalog_colors` WHERE 1 ORDER BY `name`")->hashes;

      return $self->render_to_string(
        categorys => $categorys,
        brands    => $brands,
        sizes     => $sizes,
        colors    => $colors,
        template  => 'catalog/_filters'
      );
    }
  );

  $app->helper(
    catalog__item_avl_sizes => sub {
      my $self = shift;

      my $categorys
        = $self->dbi->query(
        "SELECT ID,name,alias,parent_category_id FROM `data_catalog_categorys` WHERE 1 ORDER BY `rating`, `name`"
        )->hashes;
      my $brands
        = $self->dbi->query(
        "SELECT ID,name FROM `data_catalog_brands` WHERE 1 ORDER BY `rating`, `name`"
        )->hashes;
      my $sizes
        = $self->dbi->query(
        "SELECT size FROM `dtbl_catalog_item_sizes` WHERE 1 ORDER BY `size`")
        ->flat;
      my $colors = $self->dbi->query(
        "SELECT * FROM `lst_catalog_colors` WHERE 1 ORDER BY `name`")->hashes;

      return $self->render_to_string(
        categorys => $categorys,
        brands    => $brands,
        sizes     => $sizes,
        colors    => $colors,
        template  => 'catalog/_filters'
      );
    }
  );

  $app->helper(
    catalog__filters_top_brands => sub {
      my $self = shift;

      my $brands
        = $self->dbi->query(
        "SELECT ID,name,pict FROM `data_catalog_brands` WHERE 1 ORDER BY `rating`, `name`"
        )->hashes;
      return $self->render_to_string(
        brands   => $brands,
        template => 'catalog/_filters_top_brands'
      );
    }
  );

  $app->helper(
    catalog__brands_mainpage => sub {
      my $self = shift;

      my $brands
        = $self->dbi->query(
        "SELECT ID,name,pict_logo,pict_logo_hover FROM `data_catalog_brands` WHERE 1 ORDER BY `rating`, `name`"
        )->hashes;

      return $self->render_to_string(
        brands   => $brands,
        template => 'catalog/_brands_mainpage'
      );
    }
  );
}

1;
