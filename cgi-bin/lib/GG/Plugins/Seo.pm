package GG::Plugins::Seo;

use utf8;

use Mojo::Base 'Mojolicious::Plugin';

our $VERSION = '0.03';

my $DataTable = 'data_seo';

sub register {
	my ($self, $app, $conf) = @_;

	$app->hook( before_render => sub{
		my $self = shift;
		if ($self->stash->{seo}){
			$self->seo_custom_tags;
		}
	});

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
		my %args  = @_;

		return $self->render_to_string(
			template 	=> '_footer',
			%args
		);
	});

	$app->helper( render_headers => sub {
		my $self	= shift;
		my %args  = @_;

		my $metaTags = $self->stash->{'_meta_tags'};

		if($self->stash->{seo}){# && $self->seo_custom_tags ){

			# заданы кастомные теги
		} else {

			if(!scalar @{ $metaTags->{title} } && $self->stash->{alias}){
				my $textMetaTags = $self->app->dbi->query("SELECT `title`,`keywords`,`description` FROM `texts_main_".$self->lang."` WHERE `alias`='".$self->stash->{alias}."' LIMIT 0,1 ")->hash;

				$self->meta_title( $textMetaTags->{title} );
				$self->meta_keywords( $textMetaTags->{keywords} );
				$self->meta_description( $textMetaTags->{description} );

			}
		}

		return $self->render_to_string(
			template 	=> '_headers',
			%args
		);
	});

	$app->helper( seo_custom_tags => sub {
		my $self   = shift;
		my $reqUrl = $self->req->url->path;

		($reqUrl, undef) = split(/\?/, $reqUrl);

		# Собираем все где есть *
		my $seo_meta = {};
		my $found = 0;
		for my $node  ($self->dbi->query(qq{SELECT *, `name` AS `title` FROM `$DataTable` WHERE `url` REGEXP "[*]$\" })->hashes){
			$node->{name} =~ s{\*$}{}gi;

			if($reqUrl =~ /$$node{name}.*/gi){
				$seo_meta = $node;
				$found = 1;
				last;
			}
		}

		unless($found){
			if(my $node = $self->dbi->query("SELECT *, `name` AS `title` FROM `$DataTable` WHERE `url` LIKE '%".$reqUrl."' LIMIT 0,1")->hash){
				$seo_meta = $node;
				$found = 1;
			}
		}

		if($found){
			# если заданы кастомные теги то показываем только их (все остальное удаляем)
			foreach (qw(title keywords description)){
				$self->stash->{'_meta_tags'}->{ $_ } = [$seo_meta->{$_}];
			}
			# сео тексты
			$self->stash->{'gg.seo.title'} = $seo_meta->{seo_title} || '';
			$self->stash->{'gg.seo.text'} = $seo_meta->{seo_text} || '';
			return 1;
		}
		return;
	});
}

1;