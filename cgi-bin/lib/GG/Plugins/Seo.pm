package GG::Plugins::Seo;

use utf8;

use Mojo::Base 'Mojolicious::Plugin';

our $VERSION = '0.02';

sub register {
	my ($self, $app, $conf) = @_;


	$app->hook( before_dispatch => sub {
		my ($self) = @_;

		$self->stash->{'_meta_tags'} = {
			title 		=> [],
			keywords  	=> [],
			description => [],
		};
	});

	$app->helper( meta_title => sub {
		my $self	= shift;

		my $title = $self->stash->{'_meta_tags'}->{title};

		if($_[0]){
			push @$title, $_ foreach @_;
			return;
		}

		unshift @$title, $self->site_name;
		return join(" » ", reverse @$title);
	});

	$app->helper( meta_keywords => sub {
		my $self	= shift;

		my $keywords = $self->stash->{'_meta_tags'}->{keywords};
		push @$keywords, $_[0] if $_[0];

		return join(", ", reverse @$keywords);
	});

	$app->helper( meta_description => sub {
		my $self	= shift;

		my $description = $self->stash->{'_meta_tags'}->{description};
		push @$description, $_[0] if $_[0];

		return join(", ", reverse @$description);
	});

	$app->helper( render_footer => sub {
		my $self	= shift;

		return $self->render_to_string(
			template 	=> '_footer',
		);
	});

	$app->helper( render_headers => sub {
		my $self	= shift;

		my $metaTags = $self->stash->{'_meta_tags'};

		if($self->stash->{seo_custom_tags} && $self->seo_custom_tags ){
			# заданы кастомные теги
		}
		else {

			if(!scalar @{ $metaTags->{title} } && $self->stash->{alias}){
				my $textMetaTags = $self->app->dbi->query("SELECT `title`,`keywords`,`description` FROM `texts_main_".$self->lang."` WHERE `alias`='".$self->stash->{alias}."' LIMIT 0,1 ")->hash;

				$self->meta_title( $textMetaTags->{title} );
				$self->meta_keywords( $textMetaTags->{keywords} );
				$self->meta_description( $textMetaTags->{description} );

			}
		}

		return $self->render_to_string(
			template 	=> '_headers',
		);
	});

	$app->helper( seo_custom_tags => sub {
		my $self   = shift;
		my $reqUrl = '/'.$self->req->url;

		($reqUrl, undef) = split(/\?/, $reqUrl);

		# Собираем все где есть *
		my $seoMeta = {};
		my $found = 0;
		for my $node  ($self->dbi->query('SELECT *, `name` AS `title` FROM `data_seo_meta` WHERE `url` REGEXP "[*]$" ')->hashes){
			$node->{name} =~ s{\*$}{}gi;

			if($reqUrl =~ /$$node{name}.*/gi){
				$seoMeta = $node;
				$found = 1;
				last;
			}
		}

		unless($found){
			if(my $node = $self->dbi->query("SELECT *, `name` AS `title` FROM `data_seo_meta` WHERE `url` LIKE '%".$reqUrl."' LIMIT 0,1")->hash){
				$seoMeta = $node;
				$found = 1;
			}
		}

		if($found){
			# если заданы кастомные теги то показываем только их (все остальное удаляем)
			foreach (qw(title keywords description)){
				$self->stash->{'_meta_tags'}->{ $_ } = [$seoMeta->{$_}];
			}
			return 1;
		}
		return;
	});
}

1;