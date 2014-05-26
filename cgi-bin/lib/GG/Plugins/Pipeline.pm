package Mojolicious::Plugin::Pipeline;
use Mojo::Base 'Mojolicious::Plugin';

use Mojo::Asset::Memory;
use Mojo::Home;
use Mojo::Loader;
use Mojo::Util 'md5_sum';

my @staticDirs = qw(js css);

my @excludeDirs = qw(js/vfe);

sub register {
	my ($self, $app) = @_;

	# Register "filter" helper
	my %filters;
	$app->helper(
		filter => sub {
			my ($self, $name, $cb) = @_;
			$filters{$name} = $cb;
		}
	);

	# Register "asset" helper
	my %assets;
	$app->helper(
		asset => sub {
			my ($self, $name, $sources) = (shift, shift, shift);

			# Generate "link" or "script" tag
			unless ($sources) {
				my $checksum = $assets{$name}{checksum};
				$name =~ /^(.+)\.(\w+)$/;
				return $self->stylesheet("/$1.$checksum.$2") if $2 eq 'css';
				return $self->javascript("/$1.$checksum.$2");
			}

			# Concatenate
			my $asset = '';
			for my $source (@$sources) {

				# Glob support
				#$source = quotemeta $source;
				#$source =~ s/\\\*/[^\/]+/;

				$asset .= $self->app->static->file($source)->slurp;
			}

			# Filter
			for my $filter (@_) { $asset = $filters{$filter}->($asset) }

			# Store source with current checksum
			$assets{$name} = {source => $asset, checksum => md5_sum($asset)};
		}
	);

	# Asset dispatcher
	$app->hook(
		before_dispatch => sub {
			my $self = shift;

			# Match asset path with checksum
			return
				unless $self->req->url->path =~ /^\/?(.+)\.([[:xdigit:]]+)\.(\w+)$/;
			return unless my $asset = $assets{"$1.$3"};

			# Serve asset
			$self->app->log->debug(qq/Serving asset "$1.$3" with checksum "$2"./);
			$self->app->static->serve_asset($self,
				Mojo::Asset::Memory->new->add_chunk($asset->{source}));
			$self->tap(sub { shift->stash('mojo.static' => 1) })->rendered;
		}
	);
}

1;

=head1 NAME
use Mojolicious::Lite;

plugin 'Pipeline';
plugin 'Pipeline::CSSCompressor';

app->asset('app.js' => ['one.js', 'js/two.js']);
app->asset('app.css' => ['stylesheets/*.css'] => 'css_compressor');

get '/' => 'index';


=cut