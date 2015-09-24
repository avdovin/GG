package GG::Plugins::Sessions;

use utf8;

use Mojo::Base 'Mojolicious::Plugin';

use Mojo::JSON;
use Mojo::Util qw(b64_decode b64_encode);
no warnings 'experimental::smartmatch';

has default_expiration => 3600;

sub register {
  my ($self, $app, $conf) = @_;

  $conf ||= {};

  my $stash_key         = $conf->{'stash_key'}         || '__authentication__';
  my $autoload_user     = $conf->{'autoload_user'}     || 1;
  my $session_key       = $conf->{'session_key'}       || 'auth_data';
  my $anonymous_session = $conf->{'anonymous_session'} || 1;
  my $merge_userdata    = $conf->{'merge_userdata'}    || 1;

  # tables
  my $User_Table      = 'data_users';
  my $Anonymous_Table = 'anonymous_session';

  $app->sessions->default_expiration(3600 * 24 * 7 * 48);

  $app->helper(
    current_user_data => sub {
      my $c = shift;
      return unless my $current_user = $c->current_user;

      return $current_user->{'data'} || {};
    }
  );

  $app->helper(
    save_userdata => sub {
      my $c   = shift;
      my $cck = $c->session($session_key);

      #return unless my $uid = $c->session($session_key);

      # Serialize
      my $data = $c->current_user_data;

      my $encoded_data = b64_encode(Mojo::JSON::encode_json($data), '');
      $encoded_data =~ y/=/-/;

      if ($c->current_user->{is_anonymous}) {
        $c->dbi->update_hash($Anonymous_Table, {data => $encoded_data},
          "`cck`='$cck'");
      }
      else {
        $c->dbi->update_hash(
          $User_Table,
          {data => $encoded_data},
          "`ID`=" . $c->current_user->{ID}
        );
      }

      return $data;
    }
  );

  my $session_vars = sub {
    my $c = shift;
    my $cck = shift || $c->defCCK();

    return {
      ip   => $c->ip_to_number($c->ip) || 'empty',
      host => $c->host                 || 'empty',
      cck  => $cck,
      user_id => 0,
    };
  };

  my $create_anonymous_session = sub {
    my $c    = shift;
    my $data = $session_vars->($c);

    $c->dbi->insert_hash($Anonymous_Table, $data);
    $c->session($session_key => $data->{cck});
    $c->stash($stash_key => {user => $data});
    return $data;
  };

  my $load_user_cb = sub {
    my $c   = shift;
    my $cck = shift;

    # get session from anonymous table
    my $user = $c->dbi->query(
      qq/
      SELECT
        `$Anonymous_Table`.`data` AS `session_data`,
        `$User_Table`.*
      FROM
        `$Anonymous_Table`
      LEFT JOIN
        `$User_Table`
        ON
        `$Anonymous_Table`.`user_id`=`$User_Table`.`ID`
      WHERE
        `$Anonymous_Table`.`cck`='$cck'/
      )->hash
      || {};

    if (!keys %$user) {

      # create session if not exist in database
      $user = $create_anonymous_session->($c);
    }

    $user->{data} = $user->{session_data} || $user->{data};

    unless ($user->{ID}) {

      # if anonymous
      $user->{is_anonymous} = 1;

      $user->{data} = $user->{session_data};
      my @values = qw(data cck user_id time host ip is_anonymous);

      foreach (keys %$user) {
        next if $_ ~~ @values;
        delete $user->{$_};
      }
    }


    if (my $user_data = $user->{data}) {
      $user_data =~ y/-/=/;
      $user->{data} = Mojo::JSON::j(b64_decode $user_data);
    }
    $user->{data} ||= {};
    return $user;
  };

  # Unconditionally load the user based on uid in session
  my $user_loader_sub = sub {
    my $c = shift;

    return if $c->req->url->path->[0] eq 'admin';

    if (my $cck = $c->session($session_key)) {
      if (my $user = $load_user_cb->($c, $cck)) {
        $c->stash($stash_key => {user => $user});
      }
      else {
        # cache result that user does not exist
        $c->stash($stash_key => {no_user => 1});
      }
    }
    else {
      $create_anonymous_session->($c);
    }

  };

# Fetch the current user object from the stash - loading it if not already loaded
  my $user_stash_extractor_sub = sub {
    my $c = shift;

    if (
      !(
        defined($c->stash($stash_key))
        && ($c->stash($stash_key)->{no_user}
          || defined($c->stash($stash_key)->{user}))
      )
      )
    {
      $user_loader_sub->($c);
    }

    my $user_def = defined($c->stash($stash_key))
      && defined($c->stash($stash_key)->{user});

    return $user_def ? $c->stash($stash_key)->{user} : undef;

  };

  my $validate_user_cb = sub {
    my $c = shift;
    my ($email, $password, $extradata) = @_;
    return unless $email || $password;
    my $where = {email => $email, active => 1,};

    # my $cck = undef;
    my $user_id = undef;
    if ($c->dbi->exists_keys(from => $User_Table, lkey => 'password_digest')) {
      my $password_digest
        = $c->dbi->select($User_Table, 'password_digest', $where)->list;
      if ($c->check_password($password, $password_digest)) {
        $user_id = $c->dbi->select($User_Table, 'ID', $where)->list || undef;
      }
    }
    else {
      $where->{password} = $password;
      $user_id = $c->dbi->select($User_Table, 'ID', $where)->list || undef;
    }

    # if ($user_id){
    #   $cck = $c->session($session_key);

    #   unless($cck){
    #     $cck = $c->defCCK;

    #     $c->dbi->insert_hash($Anonymous_Table,{
    #         cck     => $cck,
    #         user_id => $user_id,
    #         data    => {},
    #       });
    #   }
    # }


    return $user_id;
  };

  my $current_user = sub {
    my $c = shift;

    return $user_stash_extractor_sub->($c);
  };

  $app->hook(before_dispatch => $user_loader_sub) if ($autoload_user);

  $app->helper(current_user => $current_user);

  $app->validator->add_check(
    password_digest_eq => sub {
      my ($validation, $name, $value, $user_password_digest) = @_;
      return $app->check_password($value, $user_password_digest) ? 0 : 1;
    }
  );


  $app->routes->add_condition(
    authenticated => sub {
      my ($r, $c, $captures, $required) = @_;
      return (!$required || $c->is_auth) ? 1 : 0;
    }
  );

  $app->routes->add_condition(
    signed => sub {
      my ($r, $c, $captures, $required) = @_;
      return (!$required || $c->signature_exists) ? 1 : 0;
    }
  );

  $app->helper(
    is_auth => sub {
      my $c = shift;
      return defined $current_user->($c)->{ID} ? 1 : 0;
    }
  );
  $app->helper(
    signature_exists => sub {
      my $c = shift;
      return $c->session($session_key) ? 1 : 0;
    }
  );

  $app->helper(
    logout => sub {
      my $c = shift;
      delete $c->stash->{$stash_key};
      delete $c->session->{$session_key};
    }
  );

  $app->helper(
    authenticate => sub {
      my ($c, $email, $password, $extradata) = @_;

# if extradata contains "auto_validate", assume the passed username is in fact valid, and
# auto_validate contains the uid; used for oAuth and other stuff that does not work with
# usernames and passwords.
      if (defined($extradata->{auto_validate})) {
        $c->session($session_key => $extradata->{auto_validate});
        delete $c->stash->{$stash_key};
        return 1 if defined($current_user->($c));

      }
      elsif (my $uid = $validate_user_cb->($c, $email, $password, $extradata)) {
        $c->dbi->update_hash(
          $Anonymous_Table,
          {user_id => $uid},
          "`cck`='" . $c->session($session_key) . "'"
        );
        delete $c->stash->{$stash_key};
        delete $current_user->($c)->{is_anonymous};
        return 1 if defined(!$current_user->($c)->{is_anonymous});
      }
      return undef;
    }
  );
}
1;
