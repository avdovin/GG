package MojoX::Loader;

use Mojo::Base -base;
use Mojo::Log;

our $VERSION = 0.01;

has app        => 'App';
has controller => 'Mojolicious::Controller';

has log        => sub {
	Mojo::Log->new(level => 'debug', handler => \*STDERR);
};

has 'prefix';

sub load {
	my $class = shift;
	my $self  = $class->new(@_);
	
	# app load
	
	my $app = $self->_load( $self->app );
	$app->log( $self->log );
	
	$app->renderer->paths( [map {$self->prefix . $_}  @{$app->renderer->paths}] ) if $self->prefix;
	
	# controller load
	
	my $c = $self->_load( $self->controller, app => $app );
 	return $c;
}

sub _load {
	my $self = shift;
	my $name = shift || return;
	
	(my $file = $name) =~ s{::|'}{/}g;
	require "$file.pm" unless $name->can('new');
	
	return $name->new(@_);
}

1;

__END__

=head1 NAME

MojoX::Loader - Loader of any Mojolicious Controller Modules in standalone scripts

=head1 SYNOPSIS

   # script.pl
   
   use MojoX::Loader;
   
   # Load App::User controller (App/User.pm) uses the base application module App (App.pm)
   my $user = MojoX::Loader->load(controller => 'App::User');
   
   # or

   # Load MyApp::User controller (MyApp/User.pm) uses the base application module MyApp (MyApp.pm)
   my $user = MojoX::Loader->load(app => 'MyApp', controller => 'MyApp::User');

   # call the _total method from MyApp::User
   say $user->_total;

=head1 DESCRIPTION

L<MojoX::Loader> is a module can load any Mojolicious Controller Modules
in a standalone scripts (none Mojolicious scripts).

=head1 ATTRIBUTES

L<MojoX::Loader> implements the following attributes.

=head2 C<app>

  my $app = $loader->app;
  $app = $loader->app('MyApp');

Name of the base Mojolcious application, the default value is I<App>.

=head2 C<controller>

  my $c = $loader->controller;
  $c = $loader->controller('MyApp::User');

Name of the Mojolicious Controller, the default value is I<Mojolicious::Controller>.

=head2 C<log>

  my $log = $loader->log;
  $app = $loader->log(Mojo::Log->new);

The logging layer of your application, by default a L<Mojo::Log> object with debug level and STDERR handler.

=head2 C<prefix>

  my $prefix = $loader->prefix;
  $prefix = $loader->prefix('../../');

The prefix for any path in application, for example renderer root.

=head1 METHODS

L<MojoX::Loader> inherits all methods from L<Mojo::Base> and implements the
following new ones.

=head2 C<load>

  my $user = MojoX::Loader->load(app => 'App', controller => 'App::User', prefix => '../../');

Load any Mojolicious Controller of application.

=head1 EXAMPLES

  #!/usr/bin/env perl
  use common::sense;
  use lib qw(../.. ../../lib);

  use MojoX::Loader;
  my $user = MojoX::Loader->load(controller => 'App::User', prefix => '../../');
  
  # call the method _total
  say $user->_total;
  <>;
  
  # call the helper db
  say $user->db;
  <>;
  
  # call the helper conf
  say $user->conf('server')->{www};
  <>;
  
  # call the helper from App::Helpers
  say $user->format_digital('1234567');
  <>;
  
  # render any template
  say $user->render_partial('mail/test', format => 'mail');
  

=head1 SEE ALSO

L<Mojolicious> L<Mojolicious::Guides> L<http://mojolicio.us>.

=head1 AUTHOR

Anatoly Sharifulin <sharifulin@gmail.com>

=head1 BUGS

Please report any bugs or feature requests to C<bug-mojox-loader at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.htMail?Queue=MojoX-Loader>.  We will be notified, and then you'll
automatically be notified of progress on your bug as we make changes.

=over 5

=item * Github

L<http://github.com/sharifulin/mojox-loader/tree/master>

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.htMail?Dist=MojoX-Loader>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/mojox-loader>

=item * CPANTS: CPAN Testing Service

L<http://cpants.perl.org/dist/overview/mojox-loader>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/mojox-loader>

=item * Search CPAN

L<http://search.cpan.org/dist/mojox-loader>

=back

=head1 COPYRIGHT & LICENSE

Copyright (C) 2011 by Anatoly Sharifulin.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut
