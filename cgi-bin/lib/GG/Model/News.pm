package GG::Model::News;

use Mojo::Base 'GG::Model';

sub table{
  "texts_news_ru";
}

sub get_list{
  my $self = shift;

  my %params = (
    limit   => 10,
    order   => " tdate ",
    @_,
  );

  my $where = {};

  map { $where->{$_}   = $params{where}->{$_} } keys %{ $params{where} } if $params{where};

  $where->{viewtext} ||= 1;

  return $self->select( %params );

}

sub get_last{
  my $self = shift;

  return $self->select( where => { viewtext => 1 }, limit => 1, order => 'tdate DESC' );
}

sub get_by_alias{
  my $self = shift;
  my $alias = shift;

  return $self->select( where => { alias => $alias, viewtext => 1 }, limit => 1 );
}

1;
