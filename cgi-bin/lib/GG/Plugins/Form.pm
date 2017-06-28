package GG::Plugins::Form;

use Mojo::Base 'Mojolicious::Plugin';
use Mojo::ByteStream;

use utf8;

our $VERSION = '0.01';

sub register {
  my ($self, $app, $opts) = @_;

  $app->log->debug("register ".__PACKAGE__);

  $app->helper('form.input' => sub {
    my ($self, $name) = (shift, shift);
    my %params = (
      type          => 'text',
      autodetect    => 1,
      template      => 'plugins/form/input',
      autoreqired   => 1,
      @_,
    );

    $params{type} = detect_type( $name ) if delete $params{autodetect};
    $params{required} = 'required' if delete $params{required};
    $params{placeholder} = $params{placeholder}.'*' if ( $params{placeholder} and $params{required} );


    my $content = $self->render_to_string(
      template    => delete $params{template},
      name        => $name,
      params      => \%params,
    );

    Mojo::ByteStream->new($content);
  });

  $app->helper('form.mail' => sub {
    my ($self, $field, $value) = @_;
    Mojo::ByteStream->new( $self->render_to_string( template => 'plugins/form/mail', field => $field, value => $value) );
  });
}

sub detect_type{
  my $name = shift;

  return 'email' if $name eq 'email';
  return 'tel'   if ($name eq 'phone' or $name eq 'tel');
  return 'password' if $name =~ /password/;

  'text';
}
1;
