package GG::Plugins::Sitemap;

use utf8;

use Mojo::Base 'Mojolicious::Plugin';



sub register {
	my ($self, $app, $conf) = @_;
	
	
	$app->routes->route("sitemap.xml")->to( cb => sub{
		my $self   = shift;
		
		my $CONFIG = {
			'texts_main_ru'	=> {
								'route'		=> 'text',
								'fields'	=> { 'alias' => 'alias', 'link' => 'link', 'url_for' => 'url_for'},
								'where'		=> "`viewtext`='1'",
								'priority'	=> '0.5',
								'changefreq'	=> 'monthly',
								}, 
			'data_catalog_items'	=> {
								'route'		=> 'catalog_iteminfo',
								'fields'	=> { 'ID' => 'item_id'},
								'where'		=> "`active`='1'",
								'priority'	=> '0.6',
								'changefreq'	=> 'weekly',
								},
			'data_catalog_looks'	=> {
								'route'		=> 'catalog_lookinfo',
								'fields'	=> { 'ID' => 'item_id'},
								'where'		=> "`active`='1'",
								'priority'	=> '0.6',
								'changefreq'	=> 'weekly',
								},			
			'data_catalog_groups'	=> {
								'route'		=> 'catalog_lookinfo',
								'fields'	=> { 'ID' => 'item_id'},
								'where'		=> "`active`='1'",
								'priority'	=> '0.6',
								'changefreq'	=> 'weekly',
								},	
		};
		
		my $host = $self->req->url->{base}->{host};
		my $nodes;
		foreach my $table (keys %$CONFIG){
			my $priority = $CONFIG->{$table}->{priority} || '0.5';
			my $changefreq = $CONFIG->{$table}->{changefreq} || 'monthly';
			my $fields = $CONFIG->{$table}->{fields};
			my $fields_str = join(",", keys %$fields);
			
			for my $node ( $self->app->dbi->query("SELECT $fields_str, `edate`,`rdate` FROM `$table` WHERE ".$CONFIG->{$table}->{where} )->hashes ){
				my $url_vals = {};
				$node->{edate} = $node->{rdate} if ($node->{edate} eq '0000-00-00 00:00:00');
				foreach (keys %{$CONFIG->{$table}->{fields}}){
					$url_vals->{$CONFIG->{$table}->{fields}->{$_}} = $node->{$_};
				}
				my $url;
				if($node->{url_for}){
					$url = 'http://'.$host.$self->menu_item($node);
				} else {
					$url = 'http://'.$host.$self->url_for($CONFIG->{$table}->{route}, %$url_vals);
				}

				$nodes .= $self->render_partial( node => $node, url => $url, priority => $priority, changefreq => $changefreq, template => 'Sitemap/node', format => 'xml');
			}
		}
		
		$self->render( nodes => $nodes, template => 'Sitemap/sitemap', format => 'xml');	
		
	})->name('sitemap');
		
}

1;
