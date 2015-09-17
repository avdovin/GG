package GG::Plugins::Crypt;

use Mojo::Base 'Mojolicious::Plugin';

use utf8;

my $Bcrypt_cost = 6;
my $Salt_len    = 10;

sub register {
  my ($self, $app, $opts) = @_;

  $opts ||= {};

  my $ALGORITM = 'none';
  eval "use Crypt::Eksblowfish::Bcrypt";
  $ALGORITM = 'bcrypt' unless $@;

  if ($ALGORITM eq 'none') {
    eval "use Crypt::PBKDF2";
    $ALGORITM = 'pbkdf2' unless $@;
  }

  $app->log->debug("Crypt password using algoritm - $ALGORITM");

  $app->helper(
    encrypt_password => sub {
      my $self = shift;
      my ($password, $settings) = @_;

      if ($ALGORITM eq 'bcrypt') {
        my ($password, $settings) = @_;
        unless (defined $settings && $settings =~ /^\$2a\$/) {
          my $cost = sprintf('%02d', $Bcrypt_cost);
          $settings = join('$', '$2a', $cost, _salt());
        }
        return Crypt::Eksblowfish::Bcrypt::bcrypt($password, $settings);

      }
      elsif ($ALGORITM eq 'pbkdf2') {

        my $pbkdf2 = Crypt::PBKDF2->new(
          hash_class => 'HMACSHA2',
          iterations => 10000,
          salt_len   => $Salt_len,
        );

        return $pbkdf2->generate($password);

      }
      else {
        return $password;
      }

    }
  );

  $app->helper(
    check_password => sub {
      my $self = shift;
      my ($password, $crypted) = @_;

      if ($ALGORITM eq 'bcrypt') {
        return $self->encrypt_password($password, $crypted) eq $crypted;

      }
      elsif ($ALGORITM eq 'pbkdf2') {

        my $pbkdf2 = Crypt::PBKDF2->new(
          hash_class => 'HMACSHA2',
          iterations => 10000,
          salt_len   => $Salt_len,
        );

        return $pbkdf2->validate($crypted, $password);

      }
      else {
        return $password eq $crypted;
      }


    }
  );
}

sub _salt {
  my $num = 999999;
  my $cr = crypt(rand($num), rand($num)) . crypt(rand($num), rand($num));
  Crypt::Eksblowfish::Bcrypt::en_base64(substr($cr, 4, 16));
}

1;
