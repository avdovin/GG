package GG::Content::Controller;

use utf8;

use Mojo::Base 'GG::Controller';
use Regexp::Common qw /URI/;

sub validation{
  my $self = shift;

  my $validator = $self->SUPER::validation->validator;

  $validator = $validator->add_check(is_decimal => sub {
    my ($validation, $name, $value) = @_;
    return $value =~ /^(?:\d+(?:\.\d*)?|\.\d+)$/ ? undef : 1;
  });
  $validator = $validator->add_check(is_integer => sub {
    my ($validation, $name, $value) = @_;
    return $value =~ /^\d+$/ ? undef : 1;
  });
  $validator = $validator->add_check(is_human_date => sub {
    my ($validation, $name, $value) = @_;
    $value =~ /^\d{2}\.\d{2}\.\d{4}$/ ? undef : 1;
  });
  $validator = $validator->add_check(is_base64_image => sub {
    my ($validation, $name, $value) = @_;
    return $value =~ m~^(?:[A-Za-z0-9+/]{4})*(?:[A-Za-z0-9+/]{2}==|[A-Za-z0-9+/]{3}=|[A-Za-z0-9+/]{4})$~ ? undef : 1;
  });
  $validator = $validator->add_check(is_url => sub {
    my ($validation, $name, $value) = @_;
    return $value =~ /$RE{URI}{HTTP}/ ? undef : 1;
  });
  $validator = $validator->add_check(is_user_email_exist => sub {
    my ($validation, $name, $value) = @_;

    my $sth = $self->dbh->prepare("select id from data_users where email like ? limit 1");
    my $valid = 0;
    $valid = 1 if($sth->execute($value) ne '0E0');
    $sth->finish();
    return $valid;
  });
  $validator = $validator->add_check(range => sub {
    my ($validation, $name, $value, $min, $max) = @_;
    return $value < $min || $value > $max;
  });
  $validator = $validator->add_check(gt_to => sub {
    my ($validation, $name, $value, $to) = @_;
    return 1 unless defined(my $other = $validation->input->{$to});
    return int($value) < int($other);
  });

  return $validator->validation;
}

1;
