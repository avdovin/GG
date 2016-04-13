package GG::Model::Main;

use Mojo::Base 'GG::Model';

sub table{
  "texts_main_ru";
}

sub get_by_alias{
  my $self = shift;
  my $alias = shift;

  return $self->select( where => { alias => $alias, viewtext => 1 }, limit => 1 );
}
1;
