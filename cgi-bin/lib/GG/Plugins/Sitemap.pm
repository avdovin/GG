package GG::Plugins::Sitemap;

use utf8;

use Mojo::Base 'Mojolicious::Plugin';



sub register {
	my ($self, $app, $conf) = @_;


	$app->routes->route("sitemap.xml")->to( cb => sub{
		my $self   = shift;

		my $CONFIG = {
			'text'					=> {
							'table'			=> 'texts_main_ru',
							'placeholders'	=> { 'alias' => 'alias', 'link' => 'link', 'url_for' => 'url_for'},
							'where'			=> " `viewtext`='1' ",
							'priority'		=> '0.5',
							'changefreq'	=> 'monthly',
			},
		};

		my $host = $self->host;
		my $nodes;
		foreach my $route (keys %$CONFIG){
			my $routeConfig = $CONFIG->{ $route };

			my $dopWhere = " `rdate` ";
			$dopWhere .= ",`edate`" if $self->dbi->exists_keys(from => $$routeConfig{table}, lkey => 'edate');

			my $placeholders = $routeConfig->{placeholders};
			my $fields_str = join(",", keys %$placeholders);
			$fields_str .= ','.$fields_str if $fields_str;

			for my $row ( $self->app->dbi->query("SELECT $dopWhere $fields_str FROM `$$routeConfig{table}` WHERE ".$routeConfig->{where} )->hashes ){
				my $url_vals = {};
				$row->{edate} = $row->{rdate} if (!$row->{edate} or $row->{edate} eq '0000-00-00 00:00:00');

				foreach (keys %$placeholders){
					$url_vals->{ $placeholders->{$_} } = $row->{$_};
				}

				my $url = '';
				if($row->{link}){
					$url = $row->{link};
				}
				elsif($row->{url_for}){
					$url = 'http://'.$host.$self->menu_item($row);
				}
				else {
					$url = 'http://'.$host.$self->url_for($route, %$url_vals);
				}

				my $priority = $routeConfig->{priority} || '0.5';
				my $changefreq = $routeConfig->{changefreq} || 'monthly';

				$nodes .= $self->render(
					node 		=> $row,
					url 		=> $url,
					priority 	=> $priority,
					changefreq 	=> $changefreq,
					template 	=> 'Plugins/Sitemap/node',
					format 		=> 'xml',

					partial 	=> 1,
				);

			}
		}

		$self->render( nodes => $nodes, template => 'Plugins/Sitemap/sitemap', format => 'xml');
	});
}

1;