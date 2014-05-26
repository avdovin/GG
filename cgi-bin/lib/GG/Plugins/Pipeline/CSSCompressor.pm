package Mojolicious::Plugin::Pipeline::CSSCompressor;
use Mojo::Base 'Mojolicious::Plugin';

use CSS::Compressor 'css_compress';

sub register {
  my ($self, $app) = @_;

  # Register "css_compressor" filter
  $app->filter(css_compressor => sub { css_compress shift });
}

1;