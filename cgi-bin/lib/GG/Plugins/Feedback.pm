package GG::Plugins::Feedback;

use utf8;

use Mojo::Base 'Mojolicious::Plugin';

sub register {
  my ($self, $app, $conf) = @_;

  $app->log->debug("register GG::Plugin::Feedback");

  $app->routes->get("/feedback")->to(
    seo_title_sitename => $app->{seo_title_sitename},
    admin_name         => 'Контакты',
    layout             => 'default',
    alias              => 'feedback',
    cb                 => sub {
      my $self   = shift;
      my %params = @_;

      $self->feedback->form(%params);
    }
  )->name('feedback');

  $app->routes->post("/feedback")->to(
    alias => 'feedback',
    cb    => sub {
      my $self   = shift;
      my %params = @_;

      $self->feedback->form(%params, submit => 1);
    }
  )->name('feedback_submit');

  $app->helper(
    'feedback.form' => sub {
      my $self = shift;
      my %params = (submit => 0, template => 'plugins/feedback/form', @_);

      my $alias = $self->stash->{'alias'};
      my $page
        = $self->dbi->query(
        "SELECT * FROM `texts_main_" . $self->lang . "` WHERE `alias`='$alias'")
        ->hash;

      $self->meta_title($page->{title} || $page->{name});
      $self->meta_keywords($page->{keywords});
      $self->meta_description($page->{description});

      $self->stash->{success} = 0;

      if (delete $params{'submit'}) {

        # Check CSRF token
        my $validation = $self->validation;
        return $self->render(text => 'Bad CSRF token!', status => 403)
          if $validation->csrf_protect->has_error('csrf_token');

        my $send_params = $self->req->params->to_hash;
        my $json = {errors => {}, message_success => '',};

        my $fields = {
          name => {
            label      => 'Ваше имя',
            required   => 1,
            error_text => 'Укажите Ваше имя',
          },
          phone => {
            label    => 'Номер телефона',
            required => 0,
            error_text =>
              'Укажите контактный номер телефона',
          },
          email => {
            label      => 'Электронная почта',
            required   => 1,
            error_text => 'Укажите электронную почту',
          },
          body => {
            label      => 'Ваше сообщение',
            required   => 1,
            error_text => 'Укажите текст сообщения',
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
          my $email_body
            = $self->render_mail(template => 'plugins/feedback/_admin');

          $self->mail(
            to => $self->get_var(
              name       => 'email_admin',
              controller => 'global',
              raw        => 1
            ),
            subject => 'Новое сообщение с сайта '
              . $self->get_var(
              name       => 'site_name',
              controller => 'global',
              raw        => 1
              ),
            data => $email_body,
          );

          $json->{message_success} = $self->render_to_string(
            template => 'plugins/feedback/_message_success',);
        }

        return $self->render(json => $json);
      }

      $self->render(
        errors    => $self->stash->{errors} || {},
        template  => $params{template},
        page      => $page,
      );
    }
  );
}


1;
