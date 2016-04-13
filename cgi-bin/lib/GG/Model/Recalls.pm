package GG::Model::Recalls;

use Mojo::Base 'GG::Model';


sub table{
  "data_recall";
}


sub get_list{
  my $self = shift;

  my %params = (
    limit   => 10,
    order   => " updated_at DESC ",
    @_,
  );

  my $where = {};

  map { $where->{$_}   = $params{where}->{$_} } keys %{ $params{where} } if $params{where};

  $where->{active} ||= 1;

  return $self->select( %params, where => $where );
}

sub create{
  my $self = shift;
  my $vals = shift;

  return $self->dbi->insert_hash( $self->table, $vals );
}

sub count {
  return shift->SUPER::count( { active => 1 } );

}

1;
