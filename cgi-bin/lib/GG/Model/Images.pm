package GG::Model::Images;

use Mojo::Base 'GG::Model';

sub table{
  "images_gallery";
}

sub get_dir_by_alias{
  my $self = shift;
  my $alias = shift;

  return $self->select(limit => 1, where => { dir => 1, viewimg => 1, alias => $alias });
}

sub get{
  my $self = shift;
  my %params = ( order => 'tdate desc', @_ );

  $params{where} ||= {};
  $params{where}->{viewimg} = 1;


  return $self->select(%params);

}
1;
