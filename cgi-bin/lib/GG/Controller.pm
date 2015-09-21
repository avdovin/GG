package GG::Controller;

use Mojo::Base 'Mojolicious::Controller';

sub redirect_to_301 {
  my $self = shift;
  my $url  = shift;

  my $res = $self->res;
  $res->code(301);
  $res->headers->location($url);
  $res->headers->content_length(0);
  $self->rendered;
}

sub _load_controller {
  my $self   = shift;
  my %params = @_;

  my $class  = delete $params{controller};
  my $action = delete $params{action};
  return unless $class;

  # Arguments
  #my $args = ref $_[0] ? $_[0] : {@_};

  my $app = $self->app;

  # Module
  $app->log->debug("load_module: $class");

  # Load
  my $e = Mojo::Loader->load($class);
  if (ref $e) { die $e }
  if ($e) {
    $app->log->debug("can't load_module $class - $e");
    return;
  }

  $class = $class->new($self) unless ref $class;
  my $continue = $class->$action(%params) if $action; # if $class->can($action);

  #   Merge stash
  # my $new = $class->stash;
  # @{$self->stash}{keys %$new} = values %$new;

  return $continue;

  # Register
  #return $class->$action($app, %params);
}

sub render_not_found {
  my $self = shift;

  delete $self->stash->{layout};

  return $self->reply->not_found;
}

sub save_info {
  my $self = shift;
  my %params = (send_params => 1, insType => 'INSERT', where => '', @_);

  my $table        = delete $params{table};
  my $field_values = delete $params{field_values} || {};
  my $where        = delete $params{where} || '';

  foreach (keys %$field_values) {
    unless ($self->dbi->exists_keys(from => $table, lkey => $_)) {
      delete $field_values->{$_};
    }
  }

  if ($params{send_params}) {
    my $send_params = $self->send_params;
    foreach (keys %$send_params) {
      if ($self->dbi->exists_keys(from => $table, lkey => $_)) {
        $field_values->{$_} ||= $send_params->{$_};
      }
    }
  }

  if (!$self->stash->{index}) {

    return $self->dbi->insert_hash($table, $field_values, $params{insType});
  }
  else {
    $where ||= "`ID`='" . $self->stash->{index} . "'";
    $self->dbi->update_hash($table, $field_values, $where, $params{where});
    return $self->stash->{index};
  }
}

1;
