package GG::Content::Search;

use utf8;

use base 'GG::Controller';

sub catalog_category_menu {
  my $self = shift;

  my $search = $self->param('search');


  return $self->render_partial(
    categorys => \@categorys,
    template  => 'catalog/category_menu'
  );
}

1;
