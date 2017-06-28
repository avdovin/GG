package GG::Content::Users;

use utf8;

use Mojo::Base 'GG::Content::Controller';

my $UserTable = 'data_users';

has required_fields_registration => sub {[qw(firstname lastname middlename email city street house agree_with_conditions password password_confirm)]};
has required_fields_profile      => sub {[qw(firstname lastname middlename email city street house)]};
has optional_fields              => sub {[qw(housing phone flat postcode)]};
has virtual_fields               => sub {[qw(agree_with_conditions password password_confirm)]};

sub update_reminded_password{
  my $self = shift;

  my $json = {};
  my $send_params = $self->req->params->to_hash;
  my $validation  = $self->validation->input($send_params);

  if( $validation->required('cck')->is_cck_valid ){
    $validation->required('password_confirm')->equal_to('password')
     if $validation->required('password')->size(1, 255)->is_valid;
  }

  if ($validation->has_error) {
    $json->{'errors'} = {};
    foreach my $f (@{$validation->failed}) {
      my $error_label = $validation->error($f)->[0];
      my $error_label_human
        = $self->_user_human_labels($f, $error_label);

      $json->{'errors'}->{$f} = $error_label_human;
    }
  }

  my $values = $validation->output;

  my $user = $self->dbi->select( $UserTable, '*', { cck => delete $values->{cck} } )->hash;
  $values->{'password_digest'} = $self->encrypt_password( delete $values->{'password_confirm'} ) if delete $values->{'password'};

  if( $self->dbi->update_hash( $UserTable, { %$values, cck => '' }, " ID=".$user->{ID} ) ){
    $json->{success} = 1;
  }else{
    $json->{errors} = {
      global => 'Системная ошибка',
    }
  }

  $self->render( json => $json );
}

sub redirect_to_password_remind{
  my $self = shift;

  my $cck = $self->param('cck');

  return $self->render_not_found if ( !$self->dbi->select($UserTable, 'ID', { cck => $cck })->list or $self->is_auth );

  $self->flash('cck', $cck);
  $self->redirect_to( $self->url_for('main').'#remind_password' );
}

sub remind_password{
  my $self = shift;

  my $json = {};
  my $validation = $self->validation;

  $validation->required('email')->is_user_email_valid;

  if ($validation->has_error) {
    $json->{'errors'} = {};
    foreach my $f (@{$validation->failed}) {
      my $error_label = $validation->error($f)->[0];
      my $error_label_human
        = $self->_user_human_labels($f, $error_label);

      $json->{'errors'}->{$f} = $error_label_human;
    }
  }

  return $self->render( json => $json ) if keys %$json;

  my $user = $self->dbi->select($UserTable, '*', { email => $validation->output->{email} })->hash;

  my $cck = $self->defCCK();

  if( $self->dbi->update_hash( $UserTable, { cck => $cck }, " ID=".$user->{ID} ) ){
    $user->{cck} = $cck;

    my $email_body = $self->render_mail(
      user     => $user,
      template => "users/_remind_password",
    );

    $self->mail(
      to      => $user->{email},
      subject => 'Вы заказали восстановление пароля на сайте '
        . $self->get_var(name => 'site_name', controller => 'global',
        raw => 1),
      data => $email_body,
    );

    return $self->render( json => { success => 1 } );
  }

  $self->render(
    json => {
      errors => {
        global => 'Системная ошибка',
      }
    }
  );
}

sub update_password{
  my $self = shift;

  $self->stash->{update_password} = 1;
  return $self->sign_up;
}

sub profile {
  my $self = shift;
  $self->meta_title('Профиль пользователя');
}

sub update {
  my $self = shift;

  $self->stash->{profile} = 1;
  return $self->sign_up;
}

sub sign_up {
  my $self = shift;

  my $is_profile = $self->stash('profile') || undef;
  my $is_password_update = $self->stash('update_password') || undef;

  my $json        = {};
  my $send_params = $self->req->params->to_hash;
  my $validation  = $self->validation->input($send_params);

  unless( $is_password_update ){
    my $fields = $is_profile ? $self->required_fields_profile : $self->required_fields_registration;

    foreach ( @$fields ){
      $validation->required($_)->size(1, 255);
    }

    foreach ( @{ $self->optional_fields } ){
      $validation->optional($_)->size(1, 255);
    }
  }

  if ( $is_password_update ){
    $validation->required('password_confirm')->equal_to('password')

      if ($validation->required('old_password')
          ->password_digest_eq( $self->current_user->{password_digest} )
          ->is_valid
            and
          $validation->required('password')
          ->size(1, 255)
          ->not_equal_to('old_password')
          ->is_valid);

  }elsif(!$is_profile){
    $validation->required('email')->size(1, 255)->is_user_email_exist;
    $validation->required('password')->size(1, 255);
    $validation->required('password_confirm')->equal_to('password')
      if $validation->required('password')->size(1, 255)->is_valid;
  }

  if ($validation->has_error) {
    $json->{'errors'} = {};
    foreach my $f (@{$validation->failed}) {
      my $error_label = $validation->error($f)->[0];
      my $error_label_human
        = $self->_user_human_labels($f, $error_label);

      $json->{'errors'}->{$f} = $error_label_human;
    }
  }

  unless (keys %{$json->{errors}}) {

    my $values = $validation->output;

    $values->{'active'} = 1;
    $values->{'password_digest'} = $self->encrypt_password( delete $values->{'password_confirm'} ) if delete $values->{'password'};
    $values->{'name'} = join(' ', map{ $values->{ $_ } } qw(firstname middlename lastname)) if ( $values->{ firstname } and $values->{ middlename } and $values->{ lastname } );

    map{ delete $values->{$_} } @{ $self->virtual_fields };

    my $has_errors = undef;

    if ( $is_profile || $is_password_update ){
      map { delete $values->{$_} } qw(email active old_password);
      if ( $self->dbi->update_hash($UserTable, $values, " ID=".$self->current_user->{ID}) ){
        $self->reload_current_user;

        $json->{message_success} = 'Информация обновлена';
      }else{
        $has_errors = 1;
      }
    }else{
      if (my $user_id = $self->dbi->insert_hash($UserTable, $values)) {
        $values->{id} = $user_id;

        my $email_body = $self->render_mail(
          user     => $values,
          user_id  => $user_id,
          template => "users/_signup",
          is_admin => undef,
        );

        my $email_body_admin = $self->render_mail(
          user     => $values,
          user_id  => $user_id,
          template => "users/_signup",
          is_admin => 1,
        );

        $self->mail(
          to      => $values->{email},
          subject => 'Вы зарегистрировались на сайте '
            . $self->get_var(name => 'site_name', controller => 'global',
            raw => 1),
          data => $email_body,
        );

        $self->mail(
          to      => $self->get_var(name => 'email_admin', controller => 'global', raw => 1),
          subject => 'Новый пользователь зарегистрировался на сайте '
            . $self->get_var(name => 'site_name', controller => 'global',
            raw => 1),
          data => $email_body_admin,
        );


        $json->{message_success} = $self->render_to_string(
          template => 'users/_signup_submit_success_msg');

        $self->authenticate( $values->{email}, $self->param('password') );
        $json->{success} = $self->url_for('main');
      }else {
        $has_errors = 1;
      }
    }

    if ( $has_errors ){
      $json->{errors}->{global}
        = 'Системная ошибка, повторите попытку позже';
    }
  }

  $self->render(json => $json);
}

sub password_recovery {
  my $self = shift;

  my $email = $self->param('email');

  my $json = {};

  if (my $user = $self->dbi->select('data_users', '*', {email => $email})->hash)
  {

    my $new_password = substr($self->defCCK(), 0, 10);
    my $new_password_encrypted = $self->encrypt_password($new_password);

    $self->dbi->update(
      'data_users',
      {password_digest => $new_password_encrypted},
      {ID       => $user->{ID}}
    );

    my $email_body = $self->render_mail(
      new_password => $new_password,
      user         => $user,
      template     => "users/_password_recovery",
    );

    $self->mail(
      to      => $user->{email},
      subject => 'Восстановление пароля на сайте '
        . $self->get_var(name => 'site_name', controller => 'global', raw => 1),
      data    => $email_body,
    );
    $json->{success} = 'Пароль успешно выслан на указанный адрес';
  }
  else {
    $json->{errors} = 'Адрес не найден';
    $json->{error_fields} = ['email'];
  }

  $self->render(json => $json);
}

sub sign_out {
  my $self = shift;

  $self->logout;
  my $redirect_url = $self->tx->req->content->headers->header('referer') || '/';
  $redirect_url = '/' if $redirect_url =~ /(users)/;
  return $self->redirect_to($redirect_url);
}

sub sign_in {
  my $self = shift;

  my $user_email    = $self->param('email');
  my $user_password = $self->param('password');

  my $json = {};
  if ($self->authenticate($user_email, $user_password)) {
    $json = {
      success   => '/',
      result    => $self->render_to_string('users/_signin_popup_result'),
    };
  }
  else {
    my $stash = $self->stash;
    my $message = $stash->{'session.msg.err'};
    my ($error_text, $error_fields) = (undef, [qw(global)]);
    if($message eq 'user_not_found'){
      $error_text = 'пользователь не найден';
      $error_fields = [qw(email password)];
    }
    elsif($message eq 'user_password_not_set'){
      $error_text = 'у пользователя не установлен пароль';
      $error_fields = [qw(password)];
    }
    elsif($message eq 'user_disabled'){
      $error_text = 'пользователь заблокирован';
    }
    elsif($message eq 'user_password_wrong'){
      $error_text = 'не правильный логин и/или пароль';
      $error_fields = [qw(email password)];
    }
    else {
      $error_text = 'системная ошибка';
      $error_fields = [qw(email password)];
    }
    $json->{errors} = {};
    foreach( @$error_fields){
      $json->{errors}->{ $_ } = '';
    }
    $json->{errors}->{ (keys %{ $json->{errors} })[0] } = $error_text;
  }

  return $self->render(json => $json);
}

sub _user_human_labels {
  my $self  = shift;
  my $field = shift;
  my $label = shift;

  my $MSG = {
    lastname => {
      required => 'Укажите фамилию',
      size =>
        'Длина фамилии должна быть менее 255 сивмолов'
    },
    firstname => {
      required => 'Укажите имя',
      size =>
        'Длина имени должна быть менее 255 сивмолов'
    },
    middlename => {
      required => 'Укажите отчество',
      size =>
        'Длина отчества должна быть менее 255 сивмолов'
    },
    phone => {
      size =>
        'Длина телефона должна быть менее 255 сивмолов'
    },
    email => {
      required => 'Укажите электронную почту',
      size =>
        'Длина электронной почты должна быть менее 255 сивмолов',
      is_user_email_exist =>
        'Такая электронная почта уже зарегистрирована',
      is_user_email_valid =>
        'Пользователь с такой электронной почтой не найден',
    },
    password => {
      required => 'Укажите пароль',
      size =>
        'Длина пароля должна быть менее 255 сивмолов',
      not_equal_to       => 'Новый пароль должен быть отличен от старого',
    },
    password_confirm => {
      required => 'Введите подтверждение пароля',
      equal_to => 'Пароли не совпадают'
    },
    company_name => {
      required => 'Укажите название компании или ИП',
    },
    inn          => {
      required => 'Укажите ИНН',
    },
    city         => {
      required => 'Укажите город',
    },
    old_password => {
      password_digest_eq => 'Старый пароль не верен',
      required           => 'Введите старый пароль',
    },
    cck          => {
      required      => 'Ошибка при восстановлении пароля, попробуйте еще раз',
      is_cck_valid  => 'Ошибка при восстановлении пароля, попробуйте еще раз',
    },
  };

  return $MSG->{$field}
    && $MSG->{$field}->{$label} ? $MSG->{$field}->{$label} : $label;
}

1;
