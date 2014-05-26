package GG;

use Mojo::Base 'Mojolicious';

use utf8;

our $VERSION  = '9.3.1.1';

# This method will run once at server start
sub startup{
	my $self = shift;

	# Add new MIME type
	$self->types->type(xls => 'application/vnd.ms-excel');
	# Add secret
	$self->secrets(['It is a good day to die ...']);


#	Pluggins
#----------------------------------------------------------------------------------------------------------

	# Register plugins namespace
	$self->plugins->namespaces( [ 'GG::Plugins', 'Mojolicious::Plugin' ] );
	$self->plugin( charset => { charset => 'UTF-8' } );


	# Load config
	my $config = $self->plugin('Config', {	file      => 'config', 	default   => {} });

	$self->plugin('init');
	$self->plugin('util_helpers');
	# DBI OO api
	$self->plugin('dbi', $config );


	# Load plugins from config
	foreach (@{$config->{plugins}}){
		$self->plugin($_);
	}

	# языковые версии сайта
	# $self->plugin('I18N' =>  {
	# 	support_url_langs 	=> [qw(ru en)],
	# 	default 			=> 'ru',
	# 	namespace 			=> 'GG::I18N',
	# 	no_header_detect 	=> 1
	# });
# / Pluggins ----------------------------------------------------------------------------------------------


	# Routes
	my $r = $self->routes;
	$r->namespaces(['GG::Content']);

	eval{
		$self->plugin(mail => {
			from     => 'no-reply@domain.com',
			encoding => 'base64',
			how      => 'sendmail',
			howargs  => [ '/usr/sbin/sendmail -t' ],
			type	 => 'text/html;charset=utf-8',
		});
	};

	# значения по умолчанию для маршрутов
	my %routes_args = (
		handler				=> 'ep',				# Тип шаблонозитора и соответсвенно файлов шаблона
		controller_class	=> 'GG::Controller',	# Папка с модулями
		layout				=> 'default',			# Скелет (layout) страниц
	);

	$self->static->paths([$config->{static_path}]);
	$self->plugin('vfe') if $config->{'vfe_enabled'};
	$ENV{MOJO_MAX_MESSAGE_SIZE} = $config->{upload_maxchanksize};

	$self->hook(before_dispatch => sub {
		my $self = shift;

		$self->stash->{lang} = $config->{lang_default};

		if(my $mode = $self->get_var( name => 'mode', controller => 'global', raw => 1 )){
			$self->app->mode( $ENV{MOJO_MODE} = $mode );
			$self->app->log->level($mode eq 'development' ? 'debug' : 'error');
		}

		# --- SEO 301 redirect to none www domain ---------
		my $url = $self->req->url->clone;
		my $host = $url->base->host || '';

		if($host =~ /^www\./){
			$host =~ s{^www\.}{};

			$url->base->host($host);
			my $res = $self->res;
			$res->code(301);
			$res->headers->location($url->to_abs);
			$res->headers->content_length(0);
			$self->rendered;
			return;
		}

		# remove url trailing slash - /about/ => /about
		if( $self->req->url->path->trailing_slash ){
			next if $self->req->url->path->contains('/admin');

			my $path = $self->req->url->path->to_string;
			$path =~ s{\/$}{}gi;

			$self->res->code(301);
			return $self->redirect_to($path);
		}

		$self->req->url->base( Mojo::URL->new(q{/}) );

		#if( my $cck = $self->app->sessions_check( cck => $self->session('cck') || '', user_id => $self->cookie('user_id') || 0 ) ){
		#	$self->session( cck => $cck );
		#}
	});

	$self->hook(after_render => sub {
		my ($self, $output, $format) = @_;

		if($config->{minify_html} && $self->app->mode eq 'production'){
			eval("use HTML::Packer");
			my $packer = HTML::Packer->init();
			$$output = $packer->minify( $output, {
				remove_comments 	=> 1
			});
		}
	});

	$self->hook(before_render => sub {
		my ($self, $args) = @_;

		return unless my $template = $args->{template};

		$self->js_controller() if ($template eq '_footer');
	});


	my $routes = $r->bridge()->to(%routes_args, cb => sub {
		my $self = shift;

		$self->stash->{lang} ||= 'ru';
		return 1;
	});

	$routes->post("callback")->to( cb => sub {
		shift->callbackSend;
	});


	my $routesCatalog = $routes->bridge('/catalog')->to(alias => 'catalog',layout => 'default', cb => sub {

		$self->stash->{catalog} = 1;
		$self->stash->{alias} = 'catalog';
		return 1;
	});

	my $routesCatalogAjax = $routesCatalog->bridge('/ajax')->to(layout => '', cb => sub {

		return 1;
	});
	$routesCatalogAjax->route("/order/checkout")->to("Catalog#order_checkout");
	$routesCatalogAjax->any('/list_items')->to('Catalog#list_items');
	$routesCatalogAjax->any('/update_basket_items')->to('Catalog#update_basket_items');

	$routesCatalog->any('/iteminfo/:item_alias/body')->to('Catalog#iteminfo', popup => 1)->name('catalog_iteminfo_body');
	$routesCatalog->any('/iteminfo/:item_alias')->to('Catalog#iteminfo')->name('catalog_iteminfo');

	$routesCatalog->any('/basket/flush')->to('Catalog#basket_flush')->name('catalog_basket_flush');
	$routesCatalog->any('/basket')->to('Catalog#basket')->name('catalog_basket');

	$routesCatalog->any('/:category_alias/:subcategory_alias')->to('Catalog#list')->name('catalog_list_by_sub_category');
	$routesCatalog->any('/:category_alias')->to('Catalog#list')->name('catalog_list_by_category');
	$routesCatalog->any('/')->to('Catalog#list', admin_name => 'Продукция')->name('catalog_list');

	$routes->any('/')->to("Texts#text_main_item", alias => 'main', %routes_args )->name('main');

	$routes->any('/news/list')->to( "Texts#texts_list", alias => 'news', key_razdel => "news", admin_name => 'Новости' )->name('news_list');
	$routes->any('/news/:list_item_alias')->to( "Texts#text_list_item", alias => 'news', key_razdel => "news" )->name('news_item');

	$routes->any("/images")->to("Images#images_list", key_razdel => 'gallery', alias => 'gallery', admin_name => 'Фотогалерея')->name('gallery_dir_list');
	$routes->any("/images/:dir_alias")->to("Images#images_list", key_razdel => 'gallery', alias => 'gallery')->name('gallery_items_list');

	$routes->any('/faq')->to("Faq#list", alias => "faq", admin_name => 'FAQ' )->name('faq');

	$routes->any("/:alias")->to("Texts#text_main_item", redirect_to_url_for => 1 )->name('text');

	# subscribe
	$routes->any('/ajax/subscribe/add')->to("Subscribe#add_ajax" );
	$routes->any('/subscribe/unsubscribe')->to("Subscribe#unsubscribe" );


	# check site availability
	$r->any("/ping")->to(cb => sub{
		return shift->render(text => 'pong');
	});
}
1;
