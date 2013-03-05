package GG::Plugins::Content;

use Mojo::Base 'Mojolicious::Plugin';

use utf8;

sub register {
	my ( $self, $app, $opts ) = @_;

	$opts ||= {};

	$app->log->debug("register GG::Plugin::Content");

	$app->helper(
		soffers_anons => sub {
			my $self   = shift;
			my %params = @_;
			
			my $items = $self->app->dbi->query("SELECT * FROM `texts_soffers_ru` WHERE `viewtext`='1' ORDER BY `tdate` DESC LIMIT 0,3")->hashes;

			return $self->render_partial( 
							items	=> $items, 
							template => 'Texts/soffers_main');			

		}
	);	
	
	$app->helper(
		news_anons => sub {
			my $self   = shift;
			my %params = @_;
			
			my $items = $self->app->dbi->query("SELECT * FROM `texts_news_ru` WHERE `viewtext`='1' ORDER BY `tdate` DESC LIMIT 0,2")->hashes;

			return $self->render_partial( 
							items	=> $items, 
							template => 'Texts/news_anons');			

		}
	);		

	$app->helper(
		faq_anons => sub {
			my $self   = shift;
			my %params = @_;
			
			my $items = $self->app->dbi->query("SELECT * FROM `data_faq` WHERE `active`='1' ORDER BY `rdate` DESC LIMIT 0,10")->hashes;

			return $self->render_partial( 
							items	=> $items, 
							template => 'Faq/main_anons');			

		}
	);
	
	$app->helper(
		tours_anons => sub {
			my $self   = shift;
			my %params = @_;
			
			my $items = $self->app->dbi->query("SELECT * FROM `data_catalog_tours` ORDER BY RAND() LIMIT 0,3")->hashes;
            
			return $self->render_partial( 
							items	=> $items, 
							template => 'Catalog/main_tours');			

		}
	);
	
}
1;