package GG::Plugins::Forms;

use Mojo::Base 'Mojolicious::Plugin';

our $VERSION = '1';

sub register {
	my ( $self, $app, $opts ) = @_;

	$opts ||= {};

	$app->log->debug("register GG::Plugin::Forms");

	$app->helper(
		def_anket_form => sub {
			my $self   = shift;
			my %params = @_;

			unless($self->app->lkeys){
				die "Please, load lkeys";
			}
			
			$params{controller} ||= '';
			
			my $template_fields = $params{template_fields};
			my $access = $params{access};
			return unless $template_fields->{$access};
			
			my $keys = $params{'keys'};
			my %using_keys = ();
			foreach (@$keys){
				if( $self->app->lkeys->{$_}->{settings}->{ $template_fields->{$access} } ){
					$using_keys{ $_ } = 1;
				}
			}

			my $output_form = "";
			
			foreach (@$keys){
				if($using_keys{ $_ }){
					$output_form .= $self->render_partial(
										lkey		=> $self->app->lkeys->{$_},
										value		=> $self->stash('send_params')->{$_},
										template 	=> $params{controller}.'/'.$self->app->lkeys->{$_}->{settings}->{ $template_fields->{$access} });	
				}
			}
			
			return $output_form;		
		}
	);

	$app->helper(
		error => sub {
			my $self   = shift;
			my %params = @_;

			return $self->flash->{errors}->{ $params{lkey} }->{text} || "";	
		}
	);
	return $self;
}

1;