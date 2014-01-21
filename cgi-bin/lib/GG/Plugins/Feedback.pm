package GG::Plugins::Feedback;

use utf8;

use Mojo::Base 'Mojolicious::Plugin';



sub register {
	my ($self, $app, $conf) = @_;


	$app->routes->route("feedback")->to(seo_title_sitename => 1, admin_name => 'Контакты', lang => 'ru',layout => 'default', alias =>  'contacts', cb => sub{
		my $self   = shift;
		my %params = @_;

		$self->feedback_form(%params)

	})->name('feedback');


	$app->helper(
		feedback_form => sub {
			my $self = shift;
			my %params = (
				template	=> "Feedback/form",
				@_
			);

			$self->metaHeader( title => 'Контакты' );

			my $method = $self->req->method;

			$self->stash->{success} = 0;

			if($method eq 'POST'){
				my $send_params = $self->req->params->to_hash;
				my $json = {
					errors 	=> {},
					message_success => '',
				};

				my $fields = {
					name 		=> {
						label 			=> 'Ваше имя',
						required 		=> 1,
						error_text 	=> 'Укажите Ваше имя',
					},
					phone 		=> {
						label 			=> 'Номер телефона',
						required 		=> 1,
						error_text 	=> 'Укажите контактный номер телефона',
					},
					email 		=> {
						label 			=> 'Электронная почта',
						required 		=> 1,
						error_text 	=> 'Укажите электронную почту',
					},
					ftext 		=> {
						label 			=> 'Ваше сообщение',
						required 		=> 1,
						error_text 	=> 'Укажите текст сообщения',
					},
				};


				foreach my $f (keys %$fields){
					if( $send_params->{$f} ){
						$self->stash->{ $f } = $send_params->{$f}

					}
					elsif($fields->{ $f }->{required}){
						$json->{errors}->{$f} = $fields->{ $f }->{error_text};

					}

				}

				unless(keys %{ $json->{errors} }){
					my $email_body = 	$self->render_mail(
						template	=> "Feedback/_admin"
					);

					$self->mail(
						to      => $self->get_var(name => 'email_admin', controller => 'global', raw => 1),
						subject => 'Новое сообщение с сайта '.$self->get_var(name => 'site_name', controller => 'global', raw => 1),
						data    => $email_body,
					);

					$json->{message_success} = $self->render(
						template 	=> 'Feedback/_message_success',
						partial 	=> 1,
					);
				}

				return $self->render(
					json => $json
				);
			}

			$self->render(
				errors		=> $self->stash->{errors} || {},
				template	=> $params{template}
			);

		}
	);
}



1;
