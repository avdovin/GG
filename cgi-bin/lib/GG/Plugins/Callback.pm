package GG::Plugins::Callback;

use Mojo::Base 'Mojolicious::Plugin';

use utf8;

sub register {
  my ($self, $app, $opts) = @_;

  $opts ||= {};

  $app->log->debug("register ".__PACKAGE__);

  $app->routes->post('/callback')->to(
    cb => sub {
      my $self = shift;

      $self->callback->send;
    }
  )->name('callback');

  $app->helper(
    'callback.send' => sub {
      my $self = shift;
      my $args = {@_};


      my $vals = {error => '',};

      if ($self->req->method eq 'POST') {
        my $send_params = $self->req->params->to_hash;
        my $json = {errors => {}, message_success => '',};

        my $fields = {
          callback_name => {
            label      => 'Ваше имя',
            required   => 1,
            error_text => 'Укажите Ваше имя',
          },
          callback_phone => {
            label    => 'Номер телефона',
            required => 1,
            error_text =>
              'Укажите контактный номер телефона',
          },
        };

        foreach my $f (keys %$fields) {
          if ($send_params->{$f}) {
            $self->stash->{$f} = $send_params->{$f}

          }
          elsif ($fields->{$f}->{required}) {
            $json->{errors}->{$f} = $fields->{$f}->{error_text};

          }
        }

        unless (keys %{$json->{errors}}) {
          my $templates_mail
            = $args->{'templates_mail'} || 'plugins/callback/_admin';

          my $email_body = $self->render_mail(template => $templates_mail);

          $self->mail(
            to => $self->get_var(
              name       => 'email_admin',
              controller => 'global',
              raw        => 1
            ),
            subject =>
              'Заказ обратного звонка с сайта '
              . $self->get_var(
              name       => 'site_name',
              controller => 'global',
              raw        => 1
              ),
            data => $email_body,
          );

          my $templates_msg_success = $args->{'templates_msg_success'}
            || 'plugins/callback/_message_success';
          $json->{message_success}
            = $self->render_to_string(template => $templates_msg_success);
        }

        return $self->render(json => $json);
      }
    }
  );

  $app->helper(
    'callback.form' => sub {
      return shift->render_to_string(template => 'plugins/callback/_form');
    }
  );
}
1;
