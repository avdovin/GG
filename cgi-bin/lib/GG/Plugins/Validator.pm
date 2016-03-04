package GG::Plugins::Validator;

use Mojo::Base 'Mojolicious::Plugin';

use Carp;

our $VERSION = '0.5';
use utf8;

# Reserved stash values
my %RESERVED = map { $_ => 1 } (
  qw(action app cb controller data extends format handler inline json layout),
  qw(namespace path status template text variant)
);

use Mojo::Util qw(url_escape trim squish);
use Encode qw(encode);
use Regexp::Common qw /URI/;

sub register {
  my ($self, $app, $args) = @_;

  $args ||= {};

  unless (ref($app)->can('send_params')) {
    ref($app)->attr('send_params');
    $app->send_params({});
  }

  $app->helper(
    send_params => sub {
      return shift->app->send_params;
    }
  );

  my $validator = $app->validator;
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

    my $sth = $app->dbh->prepare("select id from data_users where email like ? limit 1");
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

  $app->helper(
    validate => sub {
      my $self = shift;
      my %params = (controller => '');

      unless (@_ % 2) {
        %params = (%params, vals => $self->req->params->to_hash, @_);
      }
      else {
        $params{'vals'} = shift;
      }

      my $vals = delete $params{'vals'};

      my $valid_params = {};
      my $lkeys        = $self->lkey;
      while (my ($k, $v) = each %$vals) {
        my $type     = 's';
        my $settings = {};
        $v = trim $v;

        if (my $lk = $self->lkey(name => $k, controller => $params{controller}))
        {
          $type             = $lk->{type} || next;
          $settings         = $lk->{settings};
          $settings->{lkey} = $lk;
        }
        $settings->{controller}
          ||= $params{controller} || $self->stash->{controller};

        $k = "ID" if ($k eq 'id');

        if ($type eq 's') {
          $valid_params->{$k} = $self->check_string(%$settings, value => $v);
        }
        elsif ($type eq 'pict') {
          $valid_params->{$k} = $self->check_string(%$settings, value => $v);
        }
        elsif ($type eq 'videolink') {
          $valid_params->{$k} = $self->check_videolink(%$settings, value => $v);
        }
        elsif ($type eq 'file') {
          $valid_params->{$k} = $self->check_filename(%$settings, value => $v);
        }
        elsif ($type eq 'email') {
          $valid_params->{$k} = $self->check_email(%$settings, value => $v);
        }
        elsif ($type eq 'slat') {
          $valid_params->{$k} = $self->check_lat(%$settings, value => $v);
        }
        elsif ($type eq 'site') {
          $valid_params->{$k} = $self->check_site(%$settings, value => $v);
        }
        elsif ($type eq 'text') {
          $valid_params->{$k} = $self->check_string(%$settings, value => $v);
        }
        elsif ($type eq 'html') {
          $valid_params->{$k} = $self->check_html(%$settings, value => $v);
        }
        elsif ($type eq 'code') { $valid_params->{$k} = $v }
        elsif ($type eq 'd') {
          $valid_params->{$k} = $self->check_integer(%$settings, value => $v);
        }
        elsif ($type eq 'decimal') {
          $valid_params->{$k} = $self->check_decimal(%$settings, value => $v);
        }
        elsif ($type eq 'float') {
          $valid_params->{$k} = $self->check_float(%$settings, value => $v);
        }
        elsif ($type eq 'list') {
          $valid_params->{$k} = $self->check_list(%$settings, value => $v);
        }
        elsif ($type eq 'tlist') {
          $valid_params->{$k} = $self->check_tlist(%$settings, value => $v);
        }
        elsif ($type eq 'date') {
          $valid_params->{$k} = $self->check_date(%$settings, value => $v);
        }
        elsif ($type eq 'chb') {
          $valid_params->{$k} = $self->check_checkbox(%$settings, value => $v);
        }
        elsif ($type eq 'password') {
          $valid_params->{$k}
            = $self->check_password_digest(%$settings, value => $v);
        }
        elsif ($type eq 'datetime') {
          $valid_params->{$k} = $self->check_datetime(%$settings, value => $v);
        }
        elsif ($type eq 'time') {
          $valid_params->{$k} = $self->check_time(%$settings, value => $v);
        }
        else {
          $valid_params->{$k} = $self->check_string(%$settings, value => $v);
        }

        if ($RESERVED{$k}) {
          $self->app->log->warn(
            "validator: param $k is reserved by mojolicious!");
        }
        else {
          $self->stash->{$k} = $valid_params->{$k};
        }
      }

      $self->stash->{index} = $self->stash->{ID} if $self->stash->{ID};
      $app->send_params($valid_params);

      return $valid_params;
    }
  );

  $app->helper(check_email           => \&_check_email);
  $app->helper(check_checkbox        => \&_check_checkbox);
  $app->helper(check_password_digest => \&_check_password_digest);
  $app->helper(check_datetime        => \&_check_datetime);
  $app->helper(check_time            => \&_check_time);
  $app->helper(check_date            => \&_check_date);
  $app->helper(check_site            => \&_check_site);
  $app->helper(check_tlist           => \&_check_tlist);
  $app->helper(check_list            => \&_check_list);
  $app->helper(check_string          => \&_check_string);
  $app->helper(check_filename        => \&_check_filename);
  $app->helper(check_float           => \&_check_float);
  $app->helper(check_integer         => \&_check_integer);
  $app->helper(check_decimal         => \&_check_decimal);
  $app->helper(check_lat             => \&_check_lat);
  $app->helper(check_formatted_text  => \&_check_formatted_text);
  $app->helper(check_no_tag          => \&_check_no_tag);
  $app->helper(check_html            => \&_check_html);
  $app->helper(check_videolink       => \&_check_videolink);
}

sub _check_videolink {
  my $self = shift;
  my %settings = @_ % 2 ? (value => shift, @_) : @_;

  return '' unless my $value = delete $settings{value};

  $value =~ s/.+v=(\w+)/$1/i;    # youtube

  return $value;
}

sub _check_float {
  my $self = shift;
  my %settings = @_ % 2 ? (value => shift, @_) : @_;

  my $value = delete $settings{value};
  return '' unless $value;
  $value =~ s/,/./;
  $value =~ s/б/./;
  $value =~ s/ю/./;
  my $round = $settings{round} || $settings{minimum} || 2;

  return sprintf("%." . $round . "f", $value);
}

sub _check_email {
  my $self = shift;
  my %settings = @_ % 2 ? (value => shift, @_) : @_;

  my $value = delete $settings{value};
  return '' unless $value;

  my @emails    = ();
  my $separator = undef;
  if ($value =~ /,/) {
    $separator = ',';
  }
  elsif ($value =~ /;/) {
    $separator = ';';
  }
  elsif ($value =~ /\S/) {
    $separator = ' ';
  }

  if (defined $separator) {
    @emails = split($separator, $value);
  }
  else {
    push @emails, $value;
  }
  foreach (0 .. $#emails) {
    $emails[$_] =~ s{^\s+|\s+$}{}gi;
  }
  @emails = grep(/^([\w\.\-\_]+@[\w\.\-\_]+)$/, @emails);
  return scalar(@emails) > 0 ? join(",", @emails) : '';
}


sub _check_checkbox {
  my $self     = shift;
  my %settings = @_ % 2 ? (value => shift, @_) : @_;
  my $value    = delete $settings{value};
  my $lkey     = $settings{lkey};
  $settings{minimum} = 1;
  if ($value =~ m/on/i) { $value = 1; }
  if (($value =~ m/^TRUE/i)  or ($value =~ m/ИСТИНА/i)) { $value = 1; }
  if (($value =~ m/^FALSE/i) or ($value =~ m/ЛОЖЬ/i))     { $value = 0; }

  return
    $value
    ;    #$self -> check_decimal(minimum => 0, maximum => 1, value => $value);
}

sub _check_password_digest {
  my $self     = shift;
  my %settings = @_ % 2 ? (value => shift, @_) : @_;
  my $value    = delete $settings{value};

  if ($value) {
    $value = encode("utf8", $value);
    return $self->encrypt_password($value);
  }
  return undef;
}

sub _check_datetime {
  my $self     = shift;
  my %settings = @_ % 2 ? (value => shift, @_) : @_;
  my $value    = delete $settings{value};
  my $lkey     = $settings{lkey};

  my ($date, $time) = split(/ /, $value);

  if ($date = $self->check_date(%settings, value => $date)) {
    if ($time) {
      my ($hh, $mm, $sec) = split(/:/, $time);

      $hh = $self->check_decimal(minimum => 00, maximum => 23, value => $hh);

      $mm = $self->check_decimal(minimum => 00, maximum => 59, value => $mm);

      $sec ||= 0;
      $sec = $self->check_decimal(minimum => 00, maximum => 59, value => $mm);

      $time = sprintf("%02d:%02d:%02d", $hh, $mm, $sec);
    }
    else {
      $time = "00:00:00";
    }

    return "$date $time";
  }

  return '0000-00-00 00:00:00';
}

sub _check_time {
  my $self     = shift;
  my %settings = @_ % 2 ? (value => shift, @_) : @_;
  my $value    = delete $settings{value};
  my $lkey     = $settings{lkey};

  if ($value) {
    my ($hh, $mm, $sec) = split(/:/, $value);

    $hh = $self->check_decimal(minimum => 00, maximum => 23, value => $hh);
    $mm = $self->check_decimal(minimum => 00, maximum => 59, value => $mm);

    #$sec ||= 0;
    #$sec = $self -> check_decimal(minimum => 00, maximum => 59, value => $mm);

    #$value = sprintf("%02d:%02d:%02d", $hh, $mm, $sec);
    $value = sprintf("%02d:%02d:00", $hh, $mm);
  }
  else {
    $value = "00:00:00";
  }

  return $value;
}

sub _check_date {
  my $self     = shift;
  my %settings = @_ % 2 ? (value => shift, @_) : @_;
  my $value    = delete $settings{value};
  my $lkey     = $settings{lkey};

  my %month = (
    1  => 31,
    2  => 28,
    3  => 31,
    4  => 30,
    5  => 31,
    6  => 30,
    7  => 31,
    8  => 31,
    9  => 30,
    10 => 31,
    11 => 30,
    12 => 31
  );

  if (
    (
      $value
      and (($value =~ m/0000-00-00/) or ($value !~ m/\d\d\d\d-\d\d-\d\d/))
    )
    or (!$value)
    ) {
    return "0000-00-00";
  }

  my ($y, $m, $d) = split(/-/, $value);

  $y = $self->check_decimal(
    minimum => 0000,
    maximum => (localtime)[5] + 1900 + 100,
    value   => $y
  );

  $m = $self->check_decimal(minimum => 1, maximum => 12, value => $m);

  if (($y / 4) == int($y / 4)) { $month{2} = 29; }

  $d = $self->check_decimal(minimum => 1, maximum => $month{$m}, value => $d);

  return $value || '0000-00-00';
}

sub _check_site {
  my $self = shift;
  my %settings = @_ % 2 ? (value => shift, @_) : @_;

  return '' unless my $value = delete $settings{value};

  if($value !~ m{^/} && $value !~ m/^http:\/\// && $value !~ m/^https:\/\//){

# если ссылка не относительная добавляем протокол HTTP
    $value = "http://$value";
  }


  return $value;
}

sub _check_tlist {
  my $self     = shift;
  my %settings = @_ % 2 ? (value => shift, @_) : @_;
  my $value    = delete $settings{value};
  my $lkey     = $settings{lkey};

  return unless $lkey;

  unless (
    $self->def_list(
      name       => $lkey->{lkey},
      controller => $settings{controller},
      setting    => 'list'
    )
    ) {
    $self->def_list(name => $lkey->{lkey}, controller => $settings{controller});
  }
  my $list = $self->lkey(
    name       => $lkey->{lkey},
    controller => $settings{controller},
    setting    => 'list'
  ) || {};

  my @list_validated = ();

  $value = join(',', @$value) if (ref($value) eq 'ARRAY');
  foreach my $v (split(/,/, $value)) {
    if (defined $list->{$v}) {
      push @list_validated, $v;
    }
  }

  return join("=", sort @list_validated);
}

sub _check_list {
  my $self     = shift;
  my %settings = @_ % 2 ? (value => shift, @_) : @_;
  my $value    = delete $settings{value};
  my $lkey     = $settings{lkey};

  return unless $lkey;

  unless (
    $self->def_list(
      name       => $lkey->{lkey},
      controller => $settings{controller},
      setting    => 'list'
    )
    ) {
    $self->def_list(name => $lkey->{lkey}, controller => $settings{controller});
  }
  my $list = $self->lkey(
    name       => $lkey->{lkey},
    controller => $settings{controller},
    setting    => 'list'
  ) || {};


  my @list_validated = ();
  $value = join(',', @$value) if (ref($value) eq 'ARRAY');
  foreach my $v (split(/,/, $value)) {
    if (defined $list->{$v}) {
      push @list_validated, $v;
    }
  }

  return join("=", sort @list_validated);
}

sub _check_filename {
  my $self = shift;
  my %settings = @_ % 2 ? (value => shift, @_) : @_;
  return unless my $value = delete $settings{value};

  $value =~ s/^\s+|\s+$//g;
  $value =~ s{^.*(\\|\/)}{}gi;       # get only the filename, not the whole path
  $value =~ s{[^0-9A-Za-z.\-]}{_}gi; # # Strip out the non-ascii character

  return $value;
}

sub _check_string {
  my $self     = shift;
  my %settings = @_ % 2 ? (value => shift, @_) : @_;
  my $value    = delete $settings{value};

  if ($value) {
    $value = squish $value;

    $value =~ s/\|/&brvbar;/g;
    $value =~ s/\^/ /g;
    $value = $self->check_no_tag(value => $value) if exists $settings{no_tag};
    $value =~ s/[\r\n]+/ /g;
    $value =~ s/\t/ /g;
    $value =~ s/[\ ]+/ /g;

    $value = $self->check_formatted_text(%settings, value => $value)
      unless exists($settings{no_format});
  }

  return $value;
}

sub _check_integer {
  my $self     = shift;
  my %settings = @_ % 2 ? (value => shift, @_) : @_;
  my $value    = delete $settings{value};

  if ($settings{signed}) {
    $value = 0 if ($value !~ m/-?\d+/);
  }
  else {
    $value = 0 if ($value !~ m/\d+/);
  }

  if ($settings{min} && $value && $value < $settings{min}) {
    $value = $settings{min};
    $self->stash->{errors}
      = "Ошибка: значение переменной ниже нижнего ограничения - $settings{min}";
  }
  if ($settings{max} && $value && $value > $settings{max}) {
    $value = $settings{max};
    $self->stash->{errors}
      = "Ошибка: значение переменной выше верхнего ограничения - $settings{max}";
  }
  $value = undef if ($value eq '');
  $value;
}

sub _check_decimal {
  my $self     = shift;
  my %settings = @_ % 2 ? (value => shift, @_) : @_;
  my $value    = delete $settings{value};

  $value =~ s/,/./;
  $value =~ s/б/./;
  $value =~ s/ю/./;
  if ($settings{signed}) {
    $value = 0 if ($value !~ m/^-?(?:\d+(?:\.\d*)?|\.\d+)/);
  }
  else {
    $value = 0 if ($value !~ m/^(?:\d+(?:\.\d*)?|\.\d+)/);
  }

  $settings{round} ||= 2;

  $settings{min} ||= $settings{minimum};
  $settings{max} ||= $settings{maximum};

  if ($settings{min} && $value && $value < $settings{min}) {
    $value = $settings{min};
    $self->stash->{errors}
      = "Ошибка: значение переменной ниже нижнего ограничения - $settings{min}";
  }
  if ($settings{max} && $value && $value > $settings{max}) {
    $value = $settings{max};
    $self->stash->{errors}
      = "Ошибка: значение переменной выше верхнего ограничения - $settings{max}";
  }

  return sprintf("%." . $settings{round} . "f", $value);
}

sub _check_lat {
  my $self     = shift;
  my %settings = @_ % 2 ? (value => shift, @_) : @_;
  my $value    = delete $settings{value};

  $settings{no_tag}    = 1;
  $settings{no_format} = 1;
  $value = $self->check_string(%settings, value => $value);
  $value = $self->transliteration($value);

  return $value;
}

sub _check_formatted_text {
  my $self     = shift;
  my %settings = @_ % 2 ? (value => shift, @_) : @_;
  my $value    = delete $settings{value};

  if ($value) {
    my $posn  = 0;
    my $poss  = 0;
    my $index = 0;

    $value = "<'>" . $value . "<'>";
    $value =~ s/ _fck[\w]+="[\w\/\:\_\-\ \.\#\$\%\&\;]+"/ /g;
    my $temp = $value;
    my @ar   = ($temp =~ m/(<.*?>)/gs);
    while ($index++ <= $#ar) {
      $value =~ m/(<.*?>)/gsc;
      my $temp = $1;
      $posn = pos($value);
      $poss = $posn - length($temp);
      $temp =~ tr/"/'/;
      pos($value) = $poss;
      $value =~ s/\G<.*?>/$temp/s;
      pos($value) = $posn;
    }

    $value =~ s/<'>//g;
    if (!exists($settings{no_format})) {
      $value =~ s/\A"/«/g;

#     $value =~ s/«/&laquo;/g;
#     $value =~ s/»/&raquo;/g;
      $value =~ s/([\(\n\ \>])"/$1«/g;
      $value =~ s/"([\ \.\,\:\;\!\?\)\<])/»$1/g;
      $value =~ s/"$/»/g;
      $value =~ s/[\r\n]+- /\n– /g;
      $value =~ s/\A- /\n– /g;
      $value =~ s/'/"/g;
    }
  }
  return $value;
}

sub _check_no_tag {
  my $self     = shift;
  my %settings = @_ % 2 ? (value => shift, @_) : @_;
  my $value    = delete $settings{value};

  if ($value) {
    $value =~ s/<SCRIPT[\w\W\s\S]+<\/SCRIPT>/ /igs;
    $value =~ s/<.*?>/ /gs;
    $value =~ s/<!.*?-->/ /gs;
    $value =~ s/[\ ]+/ /g;
  }

  return $value;
}

sub _check_html {
  my $self     = shift;
  my %settings = @_ % 2 ? (value => shift, @_) : @_;
  my $value    = delete $settings{value};

  my $res = $value;
  if ($value =~ m/class="FCK__Flash"/ or $value =~ m/class=FCK__Flash/)
  { # Заменяем псевдокартинку флеша на сам флеш

    #   Обновленный алгоритм
    while ($value =~ m/<img .*?>/ig) {
      my $frag   = $&;
      my $stream = new HTML::TokeParser(\$frag);
      my $flash_code;

      while (my $token = $stream->get_token) {
        if (  $token->[0] eq "S"
          and $token->[1] eq "img"
          and $token->[2]{class} eq "FCK__Flash") {
          my %params;
          foreach my $k (keys %{$token->[2]}) {
            if ($k =~ m/_flash_/) {
              my (undef, $param) = split(/_flash_/, $k);
              $params{$param} = $token->[2]{$k};
            }
          }

          $flash_code
            = "<object classid='clsid:d27cdb6e-ae6d-11cf-96b8-444553540000' codebase='http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=8,0,0,0'";
          $flash_code
            .= $params{width} ? " width='$params{width}'" : " width='100'";
          $flash_code
            .= $params{height} ? " height='$params{height}'" : " height='100'";
          $flash_code .= " id='$params{id}'" if ($params{id});
          $flash_code
            .= " ><param name='allowScriptAccess' value='sameDomain' /><param name='allowFullScreen' value='false' /><param name='quality' value='high' /><param name='bgcolor' value='#ffffff' />";
          $flash_code .= "<param name='movie' value='$params{src}' />";
          $flash_code
            .= "<embed src='$params{src}' quality='high' bgcolor='#ffffff' menu='$params{menu}' loop='$params{loop}' play='$params{play}'";
          $flash_code
            .= $params{width} ? " width='$params{width}'" : " width='100'";
          $flash_code
            .= $params{height} ? " height='$params{height}'" : " height='100'";
          $flash_code .= " name='$params{id}'" if ($params{id});
          $flash_code
            .= " allowScriptAccess='sameDomain' allowFullScreen='false' type='application/x-shockwave-flash' pluginspage='http://www.macromedia.com/go/getflashplayer' /></object>";

          $res =~ s/$frag/$flash_code/i;
        }
      }    # end while
    }
  }

  $value = $self->check_formatted_text(%settings, value => $value);
  return $value;
}

1;
