package GG::Plugins::UtilHelpers;

use utf8;
use Mojo::Base 'Mojolicious::Plugin';

use File::stat;
use Mojo::ByteStream;

sub register {
  my ($self, $app) = @_;

  $app->helper(vu => sub { shift->tx->req->url->path->parts->[+shift] || '' });

  $app->helper(alias_re => sub { return qr/[a-zA-Z0-9-_]+/ });

  $app->helper(
    retina_src => sub {
      my $self = shift;
      my $src  = shift;

      $self->stash->{'_retina_cookie'} = $self->cookie('device_pixel_ratio')
        unless defined $self->stash->{'_retina_cookie'};

      return $src unless $self->stash->{'_retina_cookie'};

      $self->file_path_retina($src);
    }
  );

  $app->helper(
    static_path => sub {
      return shift->app->static->paths->[0];
    }
  );

  $app->helper(
    host => sub {
      my $self = shift;
      return
           $self->req->headers->host()
        || $self->stash->{'config'}->{'http_host'}
        || '';
    }
  );

  $app->helper(
    protocol => sub {
      return shift->req->url->scheme;
    }
  );

  # caselang field HASH => FIELD_NAME
  $app->helper(
    clf => sub {
      my $self = shift;
      return '' unless my $item  = shift;
      return '' unless my $field = shift;

      my $lang = $self->lang;
      if ($lang ne 'ru') {
        return $item->{$field . '_' . $lang};
      }
      else {
        return
          defined $item->{$field . '_ru'}
          ? $item->{$field . '_ru'}
          : $item->{$field};
      }
    }
  );

  $app->helper(
    cl => sub {
      return shift->caselang(@_);
    }
  );

  $app->helper(
    caselang => sub {
      my $self = shift;
      my $values = ref $_[0] ? $_[0] : {@_};

      my $lang = $self->lang;
      return $values->{$lang} || '';
    }
  );

# заменяет в тексте все ссылки на картинки (attr=src) с относительного пути в абсолютный
  $app->helper(
    text_convert_src_rel_to_abs => sub {
      my $self = shift;
      my $text = shift;

      my $host = $self->host;
      $text =~ s{src="\/(.*?)"}{src="http:\/\/host\/$1"}sgi;

      return $text;
    }
  );

  $app->helper(
    trim => sub {
      my $str = $_[1];
      $str =~ s/^\s+|\s+$//g;
      return $str;
    }
  );

  $app->helper(
    return_url => sub {
      my $self    = shift;
      my $default = shift || '/';
      my $referer = $self->req->headers->header('Referer');

      return $referer && $referer !~ /login|logout|enter/ ? $referer : $default;
    }
  );

  $app->helper(
    ip_to_number => sub {
      my $self = shift;
      my $ip = shift || return undef;

      $ip =~ s/\s//gs;
      $ip =~ s/\,/\./g;
      if ($ip
        =~ /^((([01]?\d{1,2})|(2([0-4]\d|5[0-5])))\.){3}(([01]?\d{1,2})|(2([0-4]\d|5[0-5])))$/
        )
      {
        my @bits = split /\./, $ip;
        my $ADDRESS
          = $bits[0] * 256 * 256 * 256
          + $bits[1] * 256 * 256
          + $bits[2] * 256
          + $bits[3];
        return $ADDRESS;
      }
      else {
        return undef;
      }
    }
  );

  $app->helper(
    ip => sub {
      my $self = shift;
      my $for  = $self->req->headers->header('X-Forwarded-For');

      return
           $for
        && $for !~ /^192\.168\./
        && $for !~ /unknown/i ? $for : undef    # hack
        || $self->req->headers->header('X-Real-IP')
        || $self->tx->{remote_address};
    }
  );

  $app->helper(
    is_linux => sub {
      my $ua = shift->tx->req->headers->user_agent;
      return $ua && $ua =~ /(linux|ubuntu)/i ? $1 : 0;
    }
  );

  $app->helper(
    is_mac => sub {
      my $ua = shift->tx->req->headers->user_agent;
      return $ua && $ua =~ /(mac|macintosh)/i ? $1 : 0;
    }
  );

  $app->helper(
    is_win => sub {
      my $ua = shift->tx->req->headers->user_agent;
      return $ua && $ua =~ /(windows|win)/i ? $1 : 0;
    }
  );

  $app->helper(
    is_iphone => sub {
      my $ua = shift->tx->req->headers->user_agent;
      return $ua && $ua =~ /(cfnetwork|iphone|ipod|ipad)/i ? $1 : 0;
    }
  );

  $app->helper(
    is_mobile_device => sub {
      return
        shift->req->headers->user_agent
        =~ /(iPhone|iPod|iPad|Android|BlackBerry|Mobile|Palm)/ ? 1 : 0;
    }
  );

  $app->helper(
    is_mobile => sub {
      my $self = shift;
      return $self->is_mobile_device && $self->is_iphone ne 'iPad' ? 1 : 0;
    }
  );

  $app->helper(
    lang_prefix => sub {
      my $self = shift;
      my $lang = $self->stash->{lang} || $self->stash->{'lang_default'};

      return $lang eq $self->config->{'lang_default'} ? '' : '/' . $lang;
    }
  );

  $app->helper(
    lang => sub {
      my $self = shift;
      $self->stash->{lang} || $self->config->{'lang_default'};
    }
  );

  $app->helper(
    texts_year_navigator => sub {
      my $self   = shift;
      my %params = (
        key_razdel => 'news',
        where      => '',
        datefield  => 'tdate',
        prefix     => '',
        postfix    => '',
        @_,
      );

      my $where = " AND `viewtext`='1' AND YEAR(`$params{datefield}`) > 0";
      $where .= $params{where} if $params{where};

      my $items
        = $self->app->dbi->query(
            "SELECT `ID`,YEAR(`$params{datefield}`) AS `year` FROM `texts_"
          . $params{key_razdel} . "_"
          . $self->lang
          . "` WHERE 1 $where GROUP BY YEAR(`$params{datefield}`) ORDER BY `$params{datefield}` DESC"
        )->hashes;

      return $self->render_to_string(
        items    => $items,
        prefix   => $params{prefix},
        postfix  => $params{postfix},
        template => 'Texts/_' . $params{key_razdel} . '_year_nav',
      );
    }
  );

  $app->helper(
    text_page_by_alias => sub {
      my $self = shift;
      return unless my $alias = shift // $self->stash->{alias};

      return $self->stash->{'_page_' . $alias}
        if defined $self->stash->{'_page_' . $alias};

      my $item
        = $self->dbi->query("
        SELECT * FROM texts_main_" . $self->lang . "
        WHERE `viewtext`='1' AND `alias`='$alias'")->hash;

      return $self->stash->{'_page_' . $alias} = $item;
    }
  );

  $app->helper(
    text_by_alias => sub {
      my $self = shift;

      if( my $page = $self->text_page_by_alias(@_) ){
        return $page->{'text'};
      }
    }
  );

  $app->helper(
    uncache => sub {
      my $self = shift;
      my $file = shift;

      return unless $file;

      my $ext = $file;
      $ext =~ /.+\.(.+)$/;
      $ext = $1;

      if (my $fh = $self->static_path . $file) {
        $file .= "?t=" . stat($fh)->mtime;
      }

      if ($ext eq 'css') {
        $self->css_files($file);
      }
      elsif ($ext eq 'js') {
        $self->js_files($file);
      }
    }
  );

  $app->helper(
    js_controller => sub {
      my $self = shift;
      return unless my $controller = shift || $self->stash->{controller};

      $controller = lc $controller;

      my @files = ();
      if (-e $self->static_path . '/js/controllers/' . $controller . '.js') {

        #$self->js_files( '/js/controllers/'.$controller.'.js' );
        push @files, '/js/controllers/' . $controller . '.js';
      }
      if (-d $self->static_path . '/js/controllers/' . $controller) {
        opendir(DIR,
          $self->app->static->paths->[0] . '/js/controllers/' . $controller);
        while (my $file = readdir(DIR)) {
          next if ($file =~ m/^\./);
          my $ext = ($file =~ m/([^.]+)$/)[0];

          #$self->js_files('/js/controllers/'.$controller.'/'.$file)
          push @files, '/js/controllers/' . $controller . '/' . $file
            if ($ext eq 'js');
        }
        closedir(DIR);
      }
      if (scalar(@files)) {
        $self->asset($controller . '.js' => @files);
        return $self->asset($controller . '.js');
      }
      return '';
    }
  );

  $app->helper(
    js_files => sub {
      my $self = shift;
      my %params = scalar @_ > 1 ? @_ : (file => $_[0]);

      my $out;

      $self->stash->{'gg.js_files'} ||= [];

      if (my $file = delete $params{file}) {
        push @{$self->stash->{'gg.js_files'}}, $file;

        $out .= '<!-- from template ' . $params{template} . " -->"
          if $params{template} && !$params{alone};
        $out .= $self->javascript($params{file}) . ($params{alone} ? "" : "\n");

        $params{alone} ? return $out : $self->content_for(js_files => $out);
      }

      my $js_files = $self->stash->{'gg.js_files'} || [];
      foreach (@$js_files) {
        $out .= $self->javascript($_) . "\n" if $_;
      }

      return $out;
    }
  );

  $app->helper(
    js_files_cdn => sub {
      my $self = shift;
      my %params = scalar @_ > 1 ? @_ : (file => $_[0]);

      if ($params{file}) {
        $params{file} = $self->cdn . $params{file};
        return $self->js_files(%params);
      }
    }
  );

  $app->helper(
    css_files => sub {
      my $self = shift;
      my %params = scalar @_ > 1 ? @_ : (file => $_[0]);

      my $out;
      if ($params{file}) {
        $out .= '<!-- from template ' . $params{template} . " -->"
          if $params{template} && !$params{alone};
        $out .= $self->stylesheet($params{file}) . ($params{alone} ? "" : "\n");

        $params{alone} ? return $out : $self->content_for(headers => $out);
      }
    }
  );

  $app->helper(
    css_files_cdn => sub {
      my $self = shift;
      my %params = scalar @_ > 1 ? @_ : (file => $_[0]);

      if ($params{file}) {
        $params{file} = $self->cdn . $params{file};
        return $self->css_files(%params);
      }
    }
  );

  $app->helper(
    cdn => sub {
      return shift->config->{cdn} // undef;
    }
  );


  $app->helper(
    cat => sub {
      my $self = shift;
      my $tmpl = shift || return '';
      my $file = $self->conf('path')->{tmpl} . "/$tmpl.html.ep";

      my $data = do { local $/; open my $fh, '<:utf8', $file or return; <$fh> };
      return $data || '';
    }
  );

  $app->helper(
    render_html => sub {
      my $self = shift;
      my $tmpl = shift || return '';

      my $html = $self->render_to_string($tmpl, format => 'html', @_);
      $html =~ s{\n+}{}sg;
      $html =~ s{\t+}{}sg;

      return Mojo::ByteStream->new($html);
    }
  );

  # в rails этот helper называется - pluralize
  $app->helper(
    pluralize => sub {
      return shift->declension(@_);
    }
  );

  $app->helper(
    declension => sub {
      my $self        = shift;
      my $int         = shift;
      my $expressions = shift;

      my $count = $int % 100;
      my $result;
      if ($count >= 5 && $count <= 20) {
        $result = $$expressions[2];
      }
      else {
        $count = $count % 10;
        if ($count == 1) {
          $result = $$expressions[0];
        }
        elsif ($count >= 2 && $count <= 4) {
          $result = $$expressions[1];
        }
        else {
          $result = $$expressions[2];
        }
      }
      return $result;
    }
  );

  $app->helper(
    setLocalTime => sub {
      if ($_[1]) {
        return sprintf(
          "%04d-%02d-%02d %02d:%02d:%02d",
          (localtime)[5] + 1900,
          (localtime)[4] + 1,
          (localtime)[3], (localtime)[2], (localtime)[1], (localtime)[0]
        );
      }
      else {
        return sprintf("%04d-%02d-%02d",
          (localtime)[5] + 1900,
          (localtime)[4] + 1,
          (localtime)[3]);
      }
    }
  );

  $app->helper(
    defCCK => sub {
      my $c = shift;
      my @user_info = map { $ENV{$_} } grep {/USER|REMOTE/} keys %ENV;
      return Digest::MD5::md5_hex(rand() . join('', @user_info));
    }
  );

  $app->helper(
    cut => sub {
      my $c = shift;
      my %params = (string => '', size => 300, ends => " &hellip;", @_);

      return unless my $string = delete $params{string};
      return unless my $size   = delete $params{size};

      $string =~ s/^<br>//g;
      $string =~ s/<br>/\n/ig;
      $string =~ s/<P>/\n/ig;
      $string =~ s/<SCRIPT[\w\W\s\S]+<\/SCRIPT>//igs;
      $string =~ s/<.*?>//gs;
      $string =~ s/<!.*?-->//gs;

      if (length($string) >= $size) {
        $string = substr($string, 0, $size - 1);

        if ($string =~ m/ /) {
          while (substr($string, length($string) - 1, 1) ne " ") {
            $string = substr($string, 0, length($string) - 1);
          }
        }
        else { $string = substr($string, 0, $size); }

        $string =~ s{\s$}{}gi;

        my $str_temp = substr($string, length($string) - 1, 1);

# Проверка на знаки препинания в конце урезаной строки
        if ($str_temp !~ m/[\.\,\:\;\-\(\!\?]+/) {
          $string .= $params{ends};
        }
      }

      #return $string;
      return Mojo::ByteStream->new($string);
    }
  );

  $app->helper(
    shorty => sub {
      my $self   = shift;
      my $str    = shift || return;
      my $length = shift || 20;

      for ($str) {
        s/&nbsp;/ /sg;
        s/&amp;/&/sg;
        s/&quote?;/'/sg;
        s/&ndash;/–/sg;
        s/&mdash;/—/sg;
        s/&lquot;/«/sg;
        s/&rquot;/»/sg;
      }

      return length $str > $length ? substr($str, 0, $length) . '...' : $str;
    }
  );

  $app->helper(
    shorty_fix => sub {
      my $self = shift;
      my $short = $self->shorty(@_) || return '';

      for my $tag (qw(strong span p div)) {
        my $start = @{[$short =~ m{<$tag[^>]*>}g]};
        my $end   = @{[$short =~ m{</$tag>}g]};

        next unless my $c = $start - $end;

        $short .= join "\n", ("</$tag>") x $c;
      }

      return $short;
    }
  );

  $app->helper(
    text_url => sub {
      my $self  = shift;
      my $text  = shift || return;
      my $short = sub {
        my $t = shift;
        return length $t > 35 ? substr($t, 0, 35) . '...' : $t;
      };

      $text
        =~ s{(http://\S+)}{qq(<a href="$1" class="external">) . $short->($1) . q(</a>)}seg;
      $text =~ s{\n+}{<br/>}g;

      return $text;
    }
  );

  # XXX
  $app->helper(
    paragraph => sub {
      my $self = shift;
      my $info = shift || return;

#$info =~ s\\\g;
# XXX: Malformed UTF-8 character (unexpected continuation byte 0x98, with no preceding start byte
# eval { $info =~ s{(.*?)(\n\s){2,}}{<p>$1</p>\n}sg;  };

      $info = "<p>$info</p>" unless $info =~ /<p>/;
      return $info;
    }
  );

  $app->helper(
    date_format => sub {
      my $self   = shift;
      my %params = (
        format  => 'dd month yyyy',
        date    => '',
        lang    => $self->stash->{lang} || 'ru',
        curdate => 0,
        @_
      );

      if ($params{'curdate'} || $params{'now'}) {
        $params{'date'} = $self->setLocalTime(1);
      }

      # для старой совместимости
      return '' unless my $date = delete $params{'date'};
      return $date
        unless my $format
        = delete $params{'format'} || delete $params{'dateformat'};

      my (%month1, %month2);
      my $lang = delete $params{'lang'};

      if ($lang eq "ru") {
        %month1 = (
          1  => "января",
          2  => "февраля",
          3  => "марта",
          4  => "апреля",
          5  => "мая",
          6  => "июня",
          7  => "июля",
          8  => "августа",
          9  => "сентября",
          10 => "октября",
          11 => "ноября",
          12 => "декабря"
        );
        %month2 = (
          1  => "январь",
          2  => "февраль",
          3  => "март",
          4  => "апрель",
          5  => "май",
          6  => "июнь",
          7  => "июль",
          8  => "август",
          9  => "сентябрь",
          10 => "октябрь",
          11 => "ноябрь",
          12 => "декабрь"
        );
      }
      elsif ($lang eq "en") {
        %month1 = (
          1  => "January",
          2  => "Febuary",
          3  => "March",
          4  => "April",
          5  => "May",
          6  => "June",
          7  => "July",
          8  => "August",
          9  => "September",
          10 => "October",
          11 => "November",
          12 => "December"
        );
        %month2 = (
          1  => "January",
          2  => "Febuary",
          3  => "March",
          4  => "April",
          5  => "May",
          6  => "June",
          7  => "July",
          8  => "August",
          9  => "September",
          10 => "October",
          11 => "November",
          12 => "December"
        );
      }

      if (length($date) == 19) {    # Если дата со временем
        $date =~ m/([\d]+-[\d]+-[\d]+) ([\d\:]+)/;
        $date = $1;
        $params{time} = $2;
      }

      my ($y, $m, $d) = split(/-/, $date);
      my ($h, $min, $sec) = ('', '', '');
      ($h, $min, $sec) = split(/:/, $params{'time'}) if $params{'time'};

      $y =~ m/\d\d(\d\d)/;
      my $ys = $1;
      $d += 0;
      $m += 0;
      my $month;

      if ($format =~ m/dd|day/ && $d > 0) {
        $month = $month1{int($m)};
      }
      elsif ($format =~ m/dd|day/ && $d == 0) {
        $month = ucfirst $month2{int($m)};
      }

      # вариант с отсутствием даты
      $month ||= '';

      $format =~ s/month/$month/;
      if ($d > 0) {
        $format =~ s/DD/sprintf("%02d", $d)/e;
        $format =~ s/dd|day/$d/e;
      }
      else {
        $format =~ s/dd|day//e;
      }

      $format =~ s/yyyy/sprintf("%04d", $y)/e;
      $format =~ s/yy/sprintf("%02d", $ys)/e;
      $format =~ s/mm/sprintf("%02d", $m)/e;

      if ($params{'time'}) {
        $format =~ s/hh/sprintf("%02d", $h)/e;
        $format =~ s/min/sprintf("%02d", $min)/e;
        $format =~ s/sec/sprintf("%02d", $sec)/e;
      }
      if ($format =~ /dow/) {
        my @DOW = (
          'Понедельник', 'Вторник',
          'Среда',             'Четверг',
          'Пятница',         'Суббота',
          'Воскресенье'
        );

        require Date::Calc;
        my $dow = Date::Calc::Day_of_Week($y, $m, $d);
        $format =~ s/dow/$DOW[$dow-1]/e;
      }

      return $format;
    }
  );

  $app->helper(
    numberformat => sub {
      my $self = shift;
      my $d    = shift;
      my $sep  = shift || ' ';

      return unless defined $d;

      $d =~ s/(\d)(?=((\d{3})+)(\D|$))/$1$sep/g;
      return $d;
    }
  );

  $app->helper(
    get_next_index => sub {
      my $self   = shift;
      my %params = (
        from  => '',
        index => $self->stash->{ID},
        where => '',
        order => 'ID',
        @_
      );

      die "helper get_next_index. Отсутствует параметр FROM"
        unless $params{from};
      die "Не задан index" unless $params{index};

      my $sql = qq/
				SELECT `ID`
				FROM `$params{from}`
				WHERE 1 $params{where}
				ORDER BY `$params{order}` ASC
			/;

      $sql .= ", `ID` ASC" if ($params{order} ne 'ID');

      my @IDs = $self->dbi->query($sql)->flat;

      foreach (0 .. $#IDs) {
        return $IDs[$_ + 1] if ($IDs[$_ + 1] && $IDs[$_] == $params{'index'});
      }
      return $params{ring} ? shift(@IDs) : 0;
    }
  );
  $app->helper(
    get_prev_index => sub {
      my $self   = shift;
      my %params = (
        from  => '',
        index => $self->stash->{ID},
        where => '',
        order => 'ID',
        @_
      );

      die "helper get_prev_index. Отсутствует параметр FROM"
        unless $params{from};
      die "Не задан index" unless $params{index};

      my $sql = qq/
				SELECT `ID`
				FROM `$params{from}`
				WHERE 1 $params{where}
				ORDER BY `$params{order}` desc
			/;

      $sql .= ", `ID` desc" if ($params{order} ne 'ID');

      my @IDs = $self->app->dbi->query($sql)->flat;

      foreach (0 .. $#IDs) {
        return $IDs[$_ + 1] if ($IDs[$_ + 1] && $IDs[$_] == $params{'index'});
      }
      return $params{ring} ? shift(@IDs) : 0;
    }
  );

  $app->helper(
    def_text_interval => sub {
      my $c      = shift;
      my %params = @_;

      $params{cur_page} ||= $c->stash('page') || 1;
      $params{postfix} = $params{postfix} ? "_" . $params{postfix} : '';

      my $total_page = int($params{total_vals} / $params{col_per_page});
      $total_page++
        if (
        int($params{total_vals} / $params{col_per_page})
        != $params{total_vals} / $params{col_per_page});
      $c->stash('total_page' . $params{postfix}, $total_page);

      $params{cur_page} = 1 if ($params{cur_page} > $total_page);

      if ($total_page >= $params{cur_page}) {
        $c->stash('first_index_page' . $params{postfix},
          ($params{cur_page} - 1) * $params{col_per_page});
      }

    }
  );

  $app->helper(
    page_navigator => sub {
      my $self   = shift;
      my %params = (
        prefix   => '',
        postfix  => '',
        template => 'Elements/_nav_container',
        page     => $self->stash->{page} || $self->param('page') || 1,
        @_
      );

      $params{prefix} ||= $self->req->url->to_abs->path . '?page=';
      $params{postfix} = $params{postfix} ? '_' . $params{postfix} : '';

      my $page = delete $params{page};
      my $total_page = $self->stash('total_page' . $params{postfix}) || 1;

      my ($first_page, $end_page) = ($page, $total_page);
      if ($page <= 3) {
        $first_page = 1;
        if ($total_page <= $page + 6) {
          $end_page = $total_page;
        }
        else {
          $end_page = $page + 6;
        }
      }
      else {
        $first_page = $page - 3;
        if ($first_page + 6 > $total_page) {
          $end_page = $total_page;

        }
        elsif ($first_page + 6 <= $total_page) {
          $end_page = $first_page + 6;
        }
        else {
          $end_page = $total_page;
        }
      }
      my $html = $self->render_to_string(
        first_page => $first_page,
        end_page   => $end_page,
        page       => $page,
        total_page => $total_page,
        %params
      );
      return Mojo::ByteStream->new($html);
    }
  );

}

1;
