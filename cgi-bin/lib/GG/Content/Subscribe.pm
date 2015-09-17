package GG::Content::Subscribe;

use utf8;

use Mojo::Base 'GG::Content::Controller';

my $DB_USERS = 'data_subscribe_users';
my $DB_STATS = 'data_subscribe_stat';

sub unsubscribe {
  my $self = shift;

  my ($cck, $user_id) = ($self->param('cck'), $self->param('user_id'));

  my $message = '';
  if (
    $self->dbi->query(
      "SELECT `ID` FROM `$DB_USERS` WHERE `ID`='$user_id' AND `cck`='$cck'")
    ->hash
    )
  {

    $self->dbi->dbh->do(
      "UPDATE `$DB_USERS` SET `active`=0, `cck`='' WHERE `ID`='$user_id'");

    $message
      = '<span style="color:green;">Вы успешно отписаны от рассылки</span>';
  }
  else {
    $message
      = '<span style="color:red;">Данные для отписки аккаунта некорректны...</span>';
  }

  $self->render(
    message  => $message,
    template => 'Subscribe/unsubscribe_result'
  );
}

sub add_ajax {
  my $self = shift;

  my $email = $self->param('email');

  my $inDB = $self->dbi->query(
    "SELECT `ID` FROM `data_subscribe_users` WHERE `email`='$email'")->list;
  my $json = {};
  if ($inDB) {
    $json->{message}
      = "<h3>Вы уже подписаны на рассылку!</h3>";
    return $self->render(json => $json,);
  }
  $self->dbi->query(
    "INSERT INTO `data_subscribe_users` (`email`) VALUES ('$email')");

  $json->{message}
    = "<h3> Вы успешно подписались на рассылку</h3>";

  return $self->render(json => $json,)


}

sub cron_send_refs {
  my $self = shift;

  $self->app->plugin(
    mail => {
      from     => 'no-reply@' . $self->host,
      encoding => 'base64',
      how      => 'sendmail',
      howargs  => ['/usr/sbin/sendmail -t'],
      type     => 'text/html;charset=utf-8',
    }
  );

  # кол-во отсылаемых писем за раз

  my $total_at_once   = 50;
  my @arrIDSubscribes = ();
  my @arrIDUsers      = ();
  my $subscribes;
  my $users;
  my $letters
    = $self->dbi->query(
    "SELECT * FROM `$DB_STATS` WHERE `send_date`='0000-00-00 00:00:00' LIMIT 0,$total_at_once"
    )->hashes;

  if (scalar @$letters) {

    foreach (@$letters) {
      if (!($_->{id_data_subscribe} ~~ @arrIDSubscribes)) {
        push @arrIDSubscribes, $_->{id_data_subscribe};
      }
    }
    foreach (@$letters) {
      push @arrIDUsers, $_->{id_user};
    }
  }
  else {

    $self->render(data => 'no avalible users for subscribe');

  }
  $subscribes
    = $self->dbi->query(
    "SELECT `ID`,`text`,`name`,`subject` FROM `data_subscribe` WHERE `ID` IN ("
      . join(',', @arrIDSubscribes)
      . ")")->map_hashes('ID');
  $users
    = $self->dbi->query("SELECT `ID`,`email` FROM `$DB_USERS` WHERE `ID` IN ("
      . join(',', @arrIDUsers)
      . ")")->map_hashes('ID');
  foreach (@$letters) {
    $subscribes->{$_->{id_data_subscribe}}->{text}
      = $self->_convert_rel_to_abs_src(
      $subscribes->{$_->{id_data_subscribe}}->{text});
    $self->_send_letter(
      $_,
      $subscribes->{$_->{id_data_subscribe}}->{text},
      $subscribes->{$_->{id_data_subscribe}}->{subject},
      $users->{$_->{id_user}}->{email}
    );
  }
  $self->render(data => "success");
}

sub _convert_rel_to_abs_src {
  my $self = shift;
  my $text = shift;
  my $host = $self->host;
  $text =~ s{src="\/([\s\S]+)"}{src="$host\/$1"}gi;

  return $text;
}

sub _send_letter {
  my $self  = shift;
  my $l     = shift;
  my $text  = shift;
  my $subj  = shift;
  my $email = shift;
  $l->{cck} = int(rand(10000000000));
  $self->dbi->dbh->do("UPDATE `$DB_USERS` SET `cck`=? WHERE `ID`=?",
    undef, $l->{cck}, $l->{id_user});

  $self->dbi->query(
    "UPDATE `$DB_STATS` SET `send_date`=NOW() WHERE `ID`='$l->{ID}'");

  $self->stash->{cck}         = $l->{cck};
  $self->stash->{letter_text} = $text;
  $self->stash->{user_id}     = $l->{id_user};
  $self->stash->{host}        = $self->host;

  $self->loadVars();
  $self->stash->{sitename} = $self->site_name;

  my $email_body = $self->render_mail(template => 'Subscribe/subscribe_mail',);

  $self->mail(to => $email, subject => $subj, data => $email_body,);

}


1;
