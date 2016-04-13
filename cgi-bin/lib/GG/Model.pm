package GG::Model;

use Mojo::Base -base;

sub new {
    my ($class, $app) = @_;
    my $self = {
        app => $app
    };
    return bless $self, $class;
}

sub dbi {
  shift->{app}->dbi;
}

sub count {
    my ($self, $where) = @_;

    my $count;
    if ($where) {
        $count = $self->dbi->query( 'SELECT COUNT(ID) FROM '. $self->table .' WHERE 1 '. (ref $where ? _where_to_string($where) : $where) )->list;
    }
    else {
        $count = $self->dbi->query( 'SELECT COUNT(ID) FROM '. $self->table )->list;
    }
    return $count;
}

sub insert {
    my ($self, $data_hashref) = @_;
    my $result = $self->dbi->query( 'INSERT INTO', $self->table, $data_hashref );
    return $result;
}

sub select {
    my $self = shift;

    my %params = (
      select    => "*",
      where     => {},
      order     => undef,
      offset    => 0,
      limit     => undef,
      table     => undef,
      @_
    );

    my $req = ref $params{select} ? join(',', @{ $params{select} }) : $params{select};
    $params{table} ||= $self->table;
    $req .= " FROM ".$params{table};
    $req .= " WHERE 1 ";
    if( $params{where} ){
      if( ref $params{where}  ){
        $req .= _where_to_string( $params{where} ) if scalar keys %{$params{where}};
      }else{
        $req .= $params{where};
      }
    }

    if( $params{order} ){
        $req .= " ORDER BY $params{order} ";
    }

    if( $params{limit} ){
        $req .= " LIMIT $params{offset}, $params{limit} ";
    }

    my $list = $self->dbi->query("SELECT $req");

    return ( $params{limit} and $params{limit} == 1 ) ? $list->hash || {} : $list->hashes || [];
}

# sub update {
#     my ($self, $where, $data_hashref) = @_;
#     my $result = $self->dbi->query( 'UPDATE', $self->table, 'SET', $data_hashref, 'WHERE', $where );
#     return $result;
# }

# sub delete {
#     my ($self, $where) = @_;
#     my $result = $self->db->iquery( 'DELETE FROM', $self->table, 'WHERE', $where );
#     return $result;
# }

sub _where_to_string{
  my $where = shift;
  my $str   = "";

  foreach my $k ( keys %$where ){
    if( !( ref $where->{$k} ) ){
      $str .= " AND $k='$$where{$k}'";
    }elsif( ref $where->{$k} eq 'ARRAY' ){
      $str .= " AND $k IN (". join(',', @{ $where->{$k} }) .") ";
    }elsif( ref $where->{$k} eq 'HASH' ){
      my @spl = ();
      foreach my $s ( keys %{ $where->{$k} } ){
        push @spl, "$k $s ".$where->{$k}->{$s};
      }
      $str .= " AND (". join (' OR ', @spl). ")";
    }
  };
  return $str;
}
1;
