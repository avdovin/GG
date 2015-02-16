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
			'news_item'					=> {
							'table'			=> 'texts_news_ru',
							'placeholders'	=> { 'alias' => 'list_item_alias'},
							'where'			=> " `viewtext`='1' ",
							'priority'		=> '0.5',
							'changefreq'	=> 'monthly',
			},
			'catalog_iteminfo'					=> {
							'table'			=> 'data_catalog_items',
							'placeholders'	=> { 'alias' => 'item_alias'},
							'where'			=> " `active`='1' ",
							'priority'		=> '0.5',
							'changefreq'	=> 'monthly',
			},
			'images_gallery' 			=> {
							'table'			=> 'images_gallery',
							'placeholders'	=> { 'alias' => 'gallery_alias'},
							'where'			=> " `viewimg`='1' AND `dir`=1 ",
							'priority'		=> '0.5',
							'changefreq'	=> 'monthly',
			},
			'catalog_list_by_category'			=> {
							'table'			=> 'data_catalog_categorys',
							'where'			=> " `active`='1' ",
							'priority'		=> '0.5',
							'changefreq'	=> 'monthly',
							'cb' 				=> sub {
									my ($self,$route,$category) = @_;

									return $self->url_for($route, category_alias => $category->{alias}) unless $category->{id_parent_category};

									my $parent_alias = $self->dbi->query("SELECT `alias` FROM `data_catalog_categorys` WHERE `ID`='$$category{id_parent_category}'")->list;

									return $self->url_for('catalog_list_by_sub_category', category_alias => $category->{alias}, subcategory_alias => $parent_alias);
							}
			},
		};

		my $host = $self->host;
		my $nodes;
		foreach my $route (keys %$CONFIG){
			my $routeConfig = $CONFIG->{ $route };

			my $placeholders = $routeConfig->{placeholders};
			my $fields_str = join(",", keys %$placeholders);
			$fields_str .= ','.$fields_str if $fields_str;

			for my $row ( $self->app->dbi->query("SELECT * FROM `$$routeConfig{table}` WHERE ".$routeConfig->{where} )->hashes ){
				my $url_vals = {};
				$row->{updated_at} = $row->{created_at} if (!$row->{updated_at} or $row->{updated_at} eq '0000-00-00 00:00:00');

				foreach (keys %$placeholders){
					$url_vals->{ $placeholders->{$_} } = $row->{$_};
				}

				my $url = '';

				if ($routeConfig->{cb}){
					$url = 'http://'.$host.$routeConfig->{cb}->($self,$route,$row);
				}else{
					if($row->{link}){
						$url = $row->{link} =~ /^http/ ? $row->{link} : 'http://'.$host.$row->{link};
					}
					elsif($row->{url_for}){
						$url = 'http://'.$host.$self->menu_item($row);
					}
					else {
						$url = 'http://'.$host.$self->url_for($route, %$url_vals);
					}

				}

				my $priority = $routeConfig->{priority} || '0.5';
				my $changefreq = $routeConfig->{changefreq} || 'monthly';

				$nodes .= $self->render_to_string(
					node 		=> $row,
					url 		=> $url,
					priority 	=> $priority,
					changefreq 	=> $changefreq,
					template 	=> 'Sitemap/node',

					format 		=> 'xml',
				);

			}
		}

		$self->render( nodes => $nodes, template => 'Sitemap/sitemap', format => 'xml');
	});

}


1;