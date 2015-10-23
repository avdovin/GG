package GG;

use Mojo::Base 'Mojolicious';

#use 5.20.2;
#use experimental 'signatures';

use utf8;
our $VERSION = '9.3.2.1';

# This method will run once at server start
sub startup {
  my $self = shift;

  # Init config & plugins and other ...
  $self->plugins->namespaces(['GG::Plugins', 'Mojolicious::Plugin']);
  push @{$self->commands->namespaces()}, 'GG::Command';
  $self->plugin('init');


  # Routes
  my $r = $self->routes;
  $r->namespaces(['GG::Content']);

  # значения по умолчанию
  $self->defaults(layout => 'default');
  $self->defaults(controller_class => 'GG::Controller');
  $self->defaults(handler => 'ep');

  # check site availability
  $r->any("/ping")->to(cb => sub {
    return shift->render(text => 'pong');
  });

  my $routes = $r->under()->to(
    seo => $self->config->{'seo'},
    cb  => sub {
      my $self = shift;

      return 1;
    }
  );

  my $routesCatalog = $routes->under('/catalog')->to(
    alias  => 'catalog',
    layout => 'default',
    cb     => sub {

      $self->stash->{catalog} = 1;
      $self->stash->{alias}   = 'catalog';

      #$self->res->headers->header('Pragma' => 'no-cache');
      #$self->res->headers->header('Cache-Control' => 'no-cache');

      return 1;
    }
  );

  my $routesCatalogAjax = $routesCatalog->under('/ajax')->to(
    layout => '',
    cb     => sub {

      return 1;
  });
  $routesCatalogAjax->route("/order/checkout")->to("Catalog#order_checkout");
  $routesCatalogAjax->any('/list_items')->to('Catalog#list_items');
  $routesCatalogAjax->any('/update_basket_items')
    ->to('Catalog#update_basket_items');

  $routesCatalog->any('/iteminfo/:item_alias/body')
    ->to('Catalog#iteminfo', popup => 1)->name('catalog_iteminfo_body');
  $routesCatalog->any('/iteminfo/:item_alias')->to('Catalog#iteminfo')
    ->name('catalog_iteminfo');

  $routesCatalog->any('/basket/flush')->to('Catalog#basket_flush')
    ->name('catalog_basket_flush');
  $routesCatalog->any('/basket')->to('Catalog#basket')->name('catalog_basket');

  $routesCatalog->any('/:category_alias/:subcategory_alias',
    category_alias => $self->alias_re,
    subcategory_alias => $self->alias_re)
    ->to('Catalog#list')
    ->name('catalog_list_by_sub_category');
  $routesCatalog->any('/:category_alias')
    ->to('Catalog#list')
    ->name('catalog_list_by_category');
  $routesCatalog->any('/')
    ->to('Catalog#list', admin_name => 'Продукция')
    ->name('catalog_list');

  $routes->any('/')->to("Texts#text_main_item", alias => 'main')
    ->name('main');

  $routes->any('/news/list')->to(
      "Texts#texts_list",
      alias      => 'news',
      key_razdel => "news",
      admin_name => 'Новости'
  )->name('news_list');

  $routes->any('/news/:list_item_alias', list_item_alias => $self->alias_re)
    ->to("Texts#text_list_item", alias => 'news', key_razdel => "news")
    ->name('news_item');

  $routes->any("/images")->to(
      "Images#images_list",
      key_razdel => 'gallery',
      alias      => 'gallery',
      admin_name => 'Фотогалерея'
  )->name('gallery_dir_list');

  $routes->any("/images/:dir_alias", dir_alias => $self->alias_re)
    ->to("Images#images_list", key_razdel => 'gallery', alias => 'gallery')
    ->name('gallery_items_list');

  $routes->get('/faq')->to("Faq#list", alias => "faq", admin_name => 'FAQ')
    ->name('faq');
  $routes->post('/faq')->to("Faq#list", alias => "faq", submit => 1)
    ->name('faq_submit');

  $routes->any("/:alias", alias => $self->alias_re )
    ->to("Texts#text_main_item", redirect_to_url_for => 1)
    ->name('text');

  # subscribe
  $routes->any('/ajax/subscribe/add')->to("Subscribe#add_ajax");
  $routes->any('/subscribe/unsubscribe')->to("Subscribe#unsubscribe");
}
1;
