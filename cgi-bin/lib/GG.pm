package GG;

use Mojo::Base 'Mojolicious';

use utf8;

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
	my $config = $self->plugin('Config',{
		file      => 'config',
		default   => {}
	});

	# DBI OO api
	$self->plugin('dbi', $config );

	# Sys vars
	$self->plugin('vars');

	# Lkeys
	$self->plugin('keys');
	$self->plugin('seo');
	$self->plugin('util_helpers');


	# ADMIN ROUTES
	$self->plugin('admin');

	# self
	$self->plugin('menu');
	$self->plugin('banners');
	$self->plugin('content');
	#$self->plugin('feedback');
	#$self->plugin('captcha') ;

	$self->plugin('file');
	$self->plugin('feedback');
	$self->plugin('image');

	# языковые версии сайта
	# $self->plugin('I18N' =>  {
	# 	support_url_langs 	=> [qw(ru en)],
	# 	default 			=> 'ru',
	# 	namespace 			=> 'GG::I18N',
	# 	no_header_detect 	=> 1
	# });
# / Pluggins ----------------------------------------------------------------------------------------------

	$self->static->paths(['../../httpdocs/']);

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
		seo_custom_tags 	=> 1,					# учитывать seo-meta теги (title, keywords, description) из таблицы data_seo_meta
		seo_title_sitename	=> 1,					# Показывать вначале тега title имя сайта
		jquery_history		=> 0,					# Загрузить jQuery плагин - history
		vfe_enabled			=> 0,					# Загружать vfe
	#	lang	=> 'ru',							# языковая версия сайта
	);

	$self->plugin('vfe') if $routes_args{'vfe_enabled'};

	$self->hook(before_dispatch => sub {
		my $self = shift;

		if(my $mode = $self->get_var( name => 'mode', controller => 'global', raw => 1 )){
			$ENV{MOJO_MODE} = $mode;
			$self->app->log->level($mode eq 'development' ? 'debug' : 'error');
		}

		$self->req->url->base( Mojo::URL->new(q{/}) );

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

		#if( my $cck = $self->app->sessions_check( cck => $self->session('cck') || '', user_id => $self->cookie('user_id') || 0 ) ){
		#	$self->session( cck => $cck );
		#}
	});

	$self->hook(after_dispatch => sub {
		my $tx = shift;

		# Was the response dynamic?
#	    return if $tx->res->headers->header('Expires');
#
#	    # If so, try to prevent caching
#	    $tx->res->headers->header(
#	        Expires => Mojo::Date->new(time-365*86400)
#	    );
#	    $tx->res->headers->header(
#	        "Cache-Control" => "no-cache, max-age=0, must-revalidate, no-store"
#	    );
	});

	my $routes = $r->bridge()->to(%routes_args, cb => sub {
		my $self = shift;

		$self->stash->{lang} ||= 'ru';
		return 1;
	});

	$routes->post("callback")->to( cb => sub {
		shift->callbackSend;
	});

	my $routesCatalog = $routes->bridge('/catalog')->to(layout => 'default', cb => sub {

		$self->stash->{catalog} = 1;
		return 1;
	});

	my $routesCatalogAjax = $routesCatalog->bridge('/ajax')->to(layout => '', cb => sub {

		return 1;
	});

	$routesCatalogAjax->any('/list_items')->to('Catalog#list_items', alias => 'catalog', admin_name => 'Каталог программ')->name('catalog_list_by_category');

	$routesCatalog->any('/:category_alias/:subcategory_alias')->to('Catalog#list', alias => 'catalog', admin_name => 'Каталог программ')->name('catalog_list_by_sub_category');
	$routesCatalog->any('/:category_alias')->to('Catalog#list', alias => 'catalog', admin_name => 'Каталог программ')->name('catalog_list_by_category');


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
