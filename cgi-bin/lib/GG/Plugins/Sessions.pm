package GG::Plugins::Sessions;

use utf8;

use Mojo::Base 'Mojolicious::Plugin';

use Mojo::JSON;
use Mojo::Util qw(b64_decode b64_encode);

has default_expiration => 3600;

## JSON serializer
#my $JSON = Mojo::JSON->new;

sub register {
  my ($self, $app, $conf) = @_;

  $conf ||= {};

  my $stash_key = $conf->{'stash_key'} || '__authentication__';
  my $autoload_user = $conf->{'autoload_user'} || 1;
  my $session_key = $conf->{'session_key'} || 'auth_data';

  $app->sessions->default_expiration(3600*24*7*48);

  $app->helper(current_user_data => sub {
    my $c = shift;
    return unless my $current_user = $self->current_user;

    return $current_user->{'data'} || {};
  });

  $app->helper(save_userdata => sub {
    my $c = shift;

    return unless my $uid = $c->session($session_key);

    # Serialize
    my $data = $c->current_user_data;
    my $encodeData = b64_encode(Mojo::JSON::encode_json($data), '');
    $encodeData =~ y/=/-/;

    my $cck = $c->app->user->{cck};
    $c->app->dbh->do("UPDATE `data_users` SET `data`=? WHERE `ID`=?", undef, $encodeData, $uid);
    return $data;
  });

  my $load_user_cb = sub {
    my $c = shift;
    my $uid = shift;

    return undef unless my $user = $c->dbi->query("SELECT * FROM data_users WHERE ID='$uid' AND active=1 ")->hash;

    if($user->{'data'}){
      $user->{'data'} =~ s/\-/\=/;
      if(my $userData = Mojo::JSON::j(b64_decode $user->{data}) ){
        $user->{'data'} = $userData;
      }
      else {
        delete $user->{'data'};
      }
    }

    return $user;
  };

  # Unconditionally load the user based on uid in session
  my $user_loader_sub = sub {
    my $c = shift;

    if (my $uid = $c->session($session_key)) {
      my $user = $load_user_cb->($c, $uid);
      if ($user) {
        $c->stash($stash_key => { user => $user });
      }
      else {
        # cache result that user does not exist
        $c->stash($stash_key => { no_user => 1 });
      }
    }
  };

  # Fetch the current user object from the stash - loading it if not already loaded
  my $user_stash_extractor_sub = sub{
    my $c = shift;

    if(
      !(
        defined($c->stash($stash_key))
        &&
        (
          $c->stash($stash_key)->{no_user} ||
          defined($c->stash($stash_key)->{user}))
        )
      )
    {
      $user_loader_sub->($c);
    }

    my $user_def = defined($c->stash($stash_key))
                      && defined($c->stash($stash_key)->{user});

    return $user_def ? $c->stash($stash_key)->{user} : undef;

  };

  my $validate_user_cb = sub{
    my $c = shift;
    my ($email, $password, $extradata) = @_;

    my $where = {
        email    => $email,
        active   => 1,
    };

    my $userId = undef;
    if($c->dbi->exists_keys(from => 'data_users', lkey => 'password_digest')){
      my $password_digest = $c->dbi->select('data_users', 'password_digest', $where)->list;
      if ($c->check_password($password, $password_digest)){
        $userId = $c->dbi->select("data_users", 'ID', $where)->list || undef;
      }
    }else{
      $where->{password} = $password;
      $userId = $c->dbi->select("data_users", 'ID', $where)->list || undef;
    }

    return $userId;
  };

  my $current_user = sub {
    my $c = shift;
    return $user_stash_extractor_sub->($c);
  };
  $app->hook(after_static => sub {
    my $self = shift;
    return $self->rendered();
  });

  $app->hook(before_dispatch => $user_loader_sub) if($autoload_user);

  $app->helper(current_user => $current_user);

  $app->routes->add_condition(authenticated => sub {
    my ($r, $c, $captures, $required) = @_;
    return (!$required || $c->is_auth) ? 1 : 0;
  });

  $app->routes->add_condition(signed => sub {
    my ($r, $c, $captures, $required) = @_;
    return (!$required || $c->signature_exists) ? 1 : 0;
  });

  $app->helper(is_auth => sub {
    my $c = shift;
    return defined $current_user->($c) ? 1 : 0;
  });
  $app->helper(signature_exists => sub {
    my $c = shift;
    return $c->session($session_key) ? 1 : 0;
  });

  $app->helper(logout => sub {
    my $c = shift;
    delete $c->stash->{$stash_key};
    delete $c->session->{$session_key};
  });

  $app->helper(authenticate => sub {
    my ($c, $email, $password, $extradata) = @_;

    # if extradata contains "auto_validate", assume the passed username is in fact valid, and
    # auto_validate contains the uid; used for oAuth and other stuff that does not work with
    # usernames and passwords.
    if(defined($extradata->{auto_validate})) {
      $c->session($session_key => $extradata->{auto_validate});
      delete $c->stash->{$stash_key};
      return 1 if defined( $current_user->($c) );

    } elsif (my $uid = $validate_user_cb->($c, $email, $password, $extradata)) {

      $c->session($session_key => $uid);
      # Clear stash to force reload of any already loaded user object
      delete $c->stash->{$stash_key};
      return 1 if defined( $current_user->($c) );
    }
    return undef;
  });
}

sub _session_vars{
  my $c = shift;
  my $cck  = shift || $c->defCCK();

  return {
    ip    => 'empty',
    host    => 'empty',
    cck   => $cck,
    user_id => 0,
  };
}

1;
