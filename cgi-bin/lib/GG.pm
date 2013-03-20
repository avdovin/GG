package GG;

# Author: Vdovin Aleksey

use Mojo::Base 'Mojolicious';

use utf8;

# This method will run once at server start
sub startup{
	my $self = shift;

#	Pluggins
#----------------------------------------------------------------------------------------------------------
	
	# Register plugins namespace
	$self->plugins->namespaces( [ 'GG::Plugins', 'Mojolicious::Plugin' ] );
	$self->plugin( charset => { charset => 'UTF-8' } );
	$self->plugin( PoweredBy => (name => 'GG 9.2'));
	
	
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
	$self->plugin('util_helpers');


	# ADMIN ROUTES
	$self->plugin('admin');
	
	# self
	$self->plugin('menu');
	$self->plugin('banners');
	$self->plugin('content');
	#$self->plugin('feedback');
	#$self->plugin('captcha') ;
	
	$self->plugin('feedback');
	#$self->plugin('crm');
	
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
	
	my %routes_args = (
		handler	=> 'ep',
		controller_class	=> 'GG::Controller',
		layout	=> 'default',
	#	lang	=> 'ru',
	);

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
		
        #$self->app->sessions_check( $self->session('cck') );
        #$self->session( cck => $self->app->user->{cck});
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
    
    $routes->any('/')->to("Texts#text_main_item", alias => 'main', %routes_args )->name('main');

	$routes->any('/news/list')->to( "Texts#texts_list", alias => 'news', key_razdel => "news", admin_name => 'Новости' )->name('news_list');
	$routes->any('/news/:group_alias/list')->to( "Texts#texts_list", alias => 'news', key_razdel => "news" )->name('news_list_by_group');
	$routes->any('/news/:group_alias/:list_item_alias')->to( "Texts#text_list_item", alias => 'news', key_razdel => "news" )->name('news_item_by_group');
	$routes->any('/news/:list_item_alias')->to( "Texts#text_list_item", alias => 'news', key_razdel => "news" )->name('news_item');
	
	$routes->any('/faq')->to("Faq#list", alias => "faq", admin_name => 'FAQ' )->name('faq');
		
	$routes->any("/:alias")->to("Texts#text_main_item" )->name('text');
	
	#$routeViaAlias->any('/subscribe/cronsend')->to("Subscribe#cron_send" );
	#$routeViaAlias->any('/subscribe/add_ajax')->to("Subscribe#add_ajax" );
	#$routeViaAlias->any('/subscribe/unsubscribe')->to("Subscribe#unsubscribe" );
}
1;
