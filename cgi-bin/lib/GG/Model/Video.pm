package GG::Model::Video;

use Mojo::Base 'GG::Model';


sub table{
  "data_video";
}


sub get_list{
  my $self = shift;

  my %params = (
    limit   => 12,
    order   => " tdate DESC, rating",
    @_,
  );

  my $where = {};

  map { $where->{$_}   = $params{where}->{$_} } keys %{ $params{where} } if $params{where};

  $where->{active} ||= 1;

  return $self->select( %params, where => $where );

}
1;
