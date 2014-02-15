package GG::Plugins::UtilHelpers;

use utf8;
use Mojo::Base 'Mojolicious::Plugin';

use File::stat;

sub register {
	my ( $self, $app ) = @_;

	$app->helper( retina_src => sub {
		my $self = shift;
		my $src  = shift;

		$self->stash->{'_retina_cookie'} = $self->cookie('device_pixel_ratio') unless defined $self->stash->{'_retina_cookie'};

		return $src unless $self->stash->{'_retina_cookie'};

		$self->file_path_retina($src);
	});

	$app->helper( static_path => sub {
		return shift->app->static->paths->[0];
	});

	$app->helper( host => sub {
		return shift->req->headers->host() || '';
	});

	$app->helper( cl => sub {
		return shift->caselang(@_)
	});

	$app->helper( caselang => sub {
		my $self   = shift;
		my $values 	= ref $_[0] ? $_[0] : {@_};

		my $lang = $self->lang;
		return $values->{ $lang } || ''
	});

	$app->helper( trim => sub {
		my $str = $_[1];
  		$str =~ s/^\s+|\s+$//g;
  		return $str;
	});

	$app->helper( return_url => sub {
		my $self = shift;
		my $default = shift || '/';
		my $referer = $self->req->headers->header('Referer');

		return $referer && $referer !~ /login|logout|enter/ ? $referer : $default;
	});

	$app->helper( ip_to_number => sub {
		my $self  = shift;
		my $ip	  = shift || return undef;

		$ip =~ s/\s//gs;
		$ip =~ s/\,/\./g;
		if ($ip =~ /^((([01]?\d{1,2})|(2([0-4]\d|5[0-5])))\.){3}(([01]?\d{1,2})|(2([0-4]\d|5[0-5])))$/) {
			my @bits = split /\./, $ip;
			my $ADDRESS = $bits[0]*256*256*256 + $bits[1]*256*256 + $bits[2]*256 + $bits[3];
			return $ADDRESS;
		} else {
			return undef;
		}
	});

	$app->helper( ip => sub {
		my $self = shift;
		my $for  = $self->req->headers->header('X-Forwarded-For');

		return
			$for && $for !~ /^192\.168\./ && $for !~ /unknown/i ? $for : undef # hack
		 ||
			$self->req->headers->header('X-Real-IP')
		 ||
			$self->tx->{remote_address}
		;
	});

	$app->helper(is_linux => sub {
		my $ua = shift->tx->req->headers->user_agent;
		return $ua && $ua =~ /(linux|ubuntu)/i ? $1 : 0;
	});

	$app->helper(is_mac => sub {
		my $ua = shift->tx->req->headers->user_agent;
		return $ua && $ua =~ /(mac|macintosh)/i ? $1 : 0;
	});

	$app->helper(is_win => sub {
		my $ua = shift->tx->req->headers->user_agent;
		return $ua && $ua =~ /(windows|win)/i ? $1 : 0;
	});

	$app->helper(is_iphone => sub {
		my $ua = shift->tx->req->headers->user_agent;
		return $ua && $ua =~ /(cfnetwork|iphone|ipod|ipad)/i ? $1 : 0;
	});

	$app->helper(is_mobile_device => sub {
		return shift->req->headers->user_agent =~
			/(iPhone|iPod|iPad|Android|BlackBerry|Mobile|Palm)/
		? 1 : 0;
	});

	$app->helper(is_mobile => sub {
		my $self = shift;
		return $self->is_mobile_device && $self->is_iphone ne 'iPad' ? 1 : 0;
	});

	$app->helper( lang => sub {
		shift->stash->{lang} || 'ru';
	});

	$app->helper(
		texts_year_navigator => sub {
			my $self   = shift;
			my %params = (
				key_razdel	=> "news",
				where		=> "",
				@_,
			);

			my 	$where = " AND `viewtext`='1' AND YEAR(`tdate`) > 0";
				$where .= $params{where} if $params{where};

			my $items = $self->app->dbi->query("SELECT `ID`,YEAR(`tdate`) AS `year` FROM `texts_news_".$self->lang."` WHERE 1 $where GROUP BY YEAR(`tdate`) ORDER BY `tdate` DESC")->hashes;

			return $self->render(
							items	=> $items,
							template => 'Texts/news_year_navigator',
							partial	=> 1,);

		}
	);

	$app->helper(
		text_page_by_alias => sub {
			my $self   = shift;
			my $alias = shift || $self->stash->{alias};

			my $item = $self->app->dbi->query("SELECT * FROM `texts_main_".$self->lang."` WHERE `viewtext`='1' AND `alias`='$alias'")->hash;
			return $self->stash->{text} = $item;
		}
	);

	$app->helper(
		text_by_alias => sub {
			my $self   = shift;
			my $alias = shift || return;

			if(my $item = $self->app->dbi->query("SELECT `text` FROM `texts_main_".$self->lang."` WHERE `viewtext`='1' AND `alias`='$alias'")->hash){
				return $item->{text};
			}
			return;
		}
	);

	$app->helper(
		uncache => sub {
			my $self   	= shift;
			my $file 	= shift;

			return unless $file;

			my $ext = $file;
			$ext =~ /.+\.(.+)$/;
			$ext = $1;

			if(my $fh = $self->app->static->paths->[0].$file){
				$file .= "?t=".stat($fh)->mtime;
			}

			if ($ext eq 'css') {
				return $self->stylesheet($file) if $file;
				#return qq~<link href="$file" rel="stylesheet" type="text/css" media="all" />~;

			} elsif ($ext eq 'js') {
				$self->js_files($file);
				#return qq~<script src="$file" type="text/javascript" language="javascript"></script>~;
			}
		}
	);

	$app->helper(
		js_controller	=> sub {
			my $self = shift;
			return unless my $controller = shift || $self->stash->{controller};

			$self->js_files( '/js/controllers/'.$controller.'.js' );
			if(-d $self->app->static->paths->[0].'/js/controllers/'.$controller){
				opendir(DIR, $self->app->static->paths->[0].'/js/controllers/'.$controller);
				while (my $file = readdir(DIR)) {
					next if ($file =~ m/^\./);
					my $ext = ($file =~ m/([^.]+)$/)[0];

					$self->js_files('/js/controllers/'.$controller.'/'.$file)
						if ($ext eq 'js');
				}
				closedir(DIR);
			}
	});

	$app->helper(
		js_files	=> sub {
			my $self = shift;
 			my $file = shift;
 			my $template = shift || '';

 			if($file){
 				push @{ $self->stash->{_js_files} }, {
 					file			=> $file,
 					template	=> $template,
 				};
 				return;
 			}

 			my $js_files = $self->stash->{_js_files} || [];
 			my $out = '';
 			foreach (@$js_files){
 				next unless $_->{file};

 				$out .= '<!-- '.$_->{template}." -->\n" if $_->{template};
 				$out .= $self->javascript($_->{file})."\n";
 			}

 			return $out;
		}
	);

	# в rails этот helper называется - pluralize
	$app->helper( pluralize	=> sub {
		return shift->declension( @_ );
	});

	$app->helper(
		declension	=> sub {
			my $self = shift;
 			my $int = shift;
 			my $expressions = shift;

    		my $count = $int % 100;
    		my $result;
		    if ($count >= 5 && $count <= 20) {
				$result = $$expressions[2];
			} else {
				$count = $count % 10;
				if ($count == 1) {
					$result = $$expressions[0];
				} elsif ($count >= 2 && $count <= 4) {
					$result = $$expressions[1];
				} else {
					$result = $$expressions[2];
				}
			}
		    return $result;
		}
	);

	$app->helper(
		setLocalTime => sub {
			my $c   = shift;
			my $value;
			if (shift) {
				$value = sprintf ("%04d-%02d-%02d %02d:%02d:%02d", (localtime)[5]+1900, (localtime)[4]+1, (localtime)[3], (localtime)[2], (localtime)[1], (localtime)[0]);}
			else {
				$value = sprintf ("%04d-%02d-%02d", (localtime)[5]+1900, (localtime)[4]+1, (localtime)[3]);
			}

			return $value;
		}
	);

	$app->helper(
		defCCK => sub {
			my $c   = shift;
			my @user_info = map { $ENV{$_} } grep { /USER|REMOTE/ } keys %ENV;
   			return Digest::MD5::md5_hex( rand() . join('', @user_info) );

			#my $string = "./0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
			#my $b;

			#for my $i(0..31) { $b .= substr($string, int(rand(length($string))), 1); }

			#return Digest::MD5::md5_hex($string, $b);
		}
	);

	$app->helper(
		load_controller => sub {
			my $self   = shift;
			my %params = @_;

			return $self->_load_controller(%params);
		}
	);

	$app->helper(
		anons_list => sub {
			my $self   = shift;
			my %params = @_;
			$params{key_razdel} ||= 'main';
			$params{template}   ||= $params{key_razdel} . '_list_anons';

			my $rows = $self->dbi->query("
				SELECT *
				FROM `texts_$params{key_razdel}_ru`
				WHERE 1 ORDER BY `rdate` DESC LIMIT 0,3"
			)->hashes;

			return $self->render(
				template => "Texts/anons/$params{template}",
				handler  => $params{handler},
				rows     => $rows,

				partial  => 1,
			);
		}
	);

	$app->helper(
		cut => sub {
			my $c      = shift;
			my	%params = (
				string	=> '',
				size	=> 300,
				ends	=> " &hellip;",
				@_
			);

			my $string = delete $params{string};
			my $size = delete $params{size};
			if ( !$size )   { return $string; }
			if ( !$string ) { return $string; }

			$string =~ s/^<br>//g;
			$string =~ s/<br>/\n/ig;
			$string =~ s/<P>/\n/ig;
			$string =~ s/<SCRIPT[\w\W\s\S]+<\/SCRIPT>//igs;
			$string =~ s/<.*?>//gs;
			$string =~ s/<!.*?-->//gs;

			if ( length($string) >= $size ) {
				$string = substr( $string, 0, $size - 1 );

				if ( $string =~ m/ / ) {
					while ( substr( $string, length($string) - 1, 1 ) ne " " ) {
						$string = substr( $string, 0, length($string) - 1 );
					}
				}
				else { $string = substr( $string, 0, $size ); }

				$string =~ s{\s$}{}gi;

				my $str_temp =
				  substr( $string, length($string) - 1, 1 );

				# Проверка на знаки препинания в конце урезаной строки
				if ( $str_temp !~ m/[\.\,\:\;\-\(\!\?]+/ ) {
					$string .= $params{ends};
				}
			}

			return $string;
		  }
	);

	$app->helper(shorty => sub { my $self = shift;
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
	});

	$app->helper(shorty_fix => sub { my $self = shift;
		my $short = $self->shorty(@_) || return '';

		for my $tag (qw(strong span p div)) {
			my $start = @{[ $short =~ m{<$tag[^>]*>}g ]};
			my $end   = @{[ $short =~ m{</$tag>}g     ]};

			next unless my $c = $start - $end;

			$short .= join "\n", ( "</$tag>" ) x $c;
		}

		return $short;
	});

	$app->helper(
		date_format => sub {
			my $c      = shift;
			my %params = (
				format 	=> 'dd month yyyy',
				date	=> '',
				lang	=> $c->stash->{lang} || 'ru',
				curdate	=> 0,
				@_
			);

			# для старой совместимости
			$params{format} ||= $params{dateformat} if $params{dateformat};

			$params{curdate} = 1 unless $params{date};
			if($params{curdate}){
				$params{date} = sprintf( "%04d-%02d-%02d",
					(localtime)[5] + 1900,
					(localtime)[4] + 1,
					(localtime)[3] );
			}



			my ( %month1, %month2 );

			if ( $params{lang} eq "ru" ) {
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
			elsif ( $params{lang} eq "en" ) {
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
			elsif ( $params{lang} eq "fr" ) {
				%month1 = (
					1  => "Janvier ",
					2  => "F&eacute;vrier",
					3  => "Mars",
					4  => "Avril",
					5  => "Mai",
					6  => "Juin",
					7  => "Juillet",
					8  => "Ao&ucirc;t",
					9  => "Septembre",
					10 => "Octobre",
					11 => "Novembre",
					12 => "D&eacute;cembre"
				);
				%month2 = (
					1  => "Janvier ",
					2  => "F&eacute;vrier",
					3  => "Mars",
					4  => "Avril",
					5  => "Mai",
					6  => "Juin",
					7  => "Juillet",
					8  => "Ao&ucirc;t",
					9  => "Septembre",
					10 => "Octobre",
					11 => "Novembre",
					12 => "D&eacute;cembre"
				);
			}

			if ( length( $params{date} ) == 19 ){    # Если дата со временем
				$params{date} =~ m/([\d]+-[\d]+-[\d]+) ([\d\:]+)/;
				$params{date} = $1;
				$params{time} = $2;
			}
			my ( $y, $m,   $d )   = split( /-/, $params{'date'} );
			my ( $h, $min, $sec ) = split( /:/, $params{'time'} ) if $params{'time'};

			$y =~ m/\d\d(\d\d)/;
			my $ys = $1;
			$d += 0;
			$m += 0;
			my $month;
			if ( $params{format} !~ m/dd/ ) {
				$month = $month2{$m}; }
			else {
				$month = $month1{$m};
			}
			# вариант с отсутствием даты
			$month ||= '';

			$params{date} = $params{format};
			$params{date} =~ s/month/$month/;
			$params{date} =~ s/dd/sprintf("%02d", $d)/e;
			$params{date} =~ s/day/$d/e;
			$params{date} =~ s/yyyy/sprintf("%04d", $y)/e;
			$params{date} =~ s/yy/sprintf("%02d", $ys)/e;
			$params{date} =~ s/mm/sprintf("%02d", $m)/e;

			if ( $params{'time'} ) {
				$params{date} =~ s/hh/sprintf("%02d", $h)/e;
				$params{date} =~ s/min/sprintf("%02d", $min)/e;
				$params{date} =~ s/sec/sprintf("%02d", $sec)/e;
			}
			if($params{date} =~ /dow/){
				my @DOW = ('Понедельник', 'Вторник', 'Среда', 'Четверг', 'Пятница', 'Суббота', 'Воскресенье');

				require Date::Calc;
				my $dow = Date::Calc::Day_of_Week($y,$m,$d);
				$params{date} =~ s/dow/$DOW[$dow-1]/e;
			}

			return $params{date};
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
			my $self    = shift;
			my %params 	= (
				from 	=> '',
				index 	=> $self->stash->{ID},
				where 	=> '',
				order 	=> 'ID',
				@_
			);

			die "helper get_next_index. Отсутствует параметр FROM" unless $params{from};
			die "Не задан index" unless $params{index};

			my $sql = qq/
				SELECT `ID`
				FROM `$params{from}`
				WHERE 1 $params{where}
				ORDER BY `$params{order}` ASC
			/;

			$sql .= ", `ID` ASC" if($params{order} ne 'ID');

			my @IDs = $self->dbi->query($sql)->flat;

			foreach (0..$#IDs){
				return $IDs[$_+1] if($IDs[$_+1] && $IDs[$_]==$params{'index'});
			}
			return $params{ring} ? shift(@IDs) : 0;
		}
	);
	$app->helper(
		get_prev_index => sub {
			my $self    = shift;
			my %params 	= (
				from 	=> '',
				index 	=> $self->stash->{ID},
				where 	=> '',
				order 	=> 'ID',
				@_
			);

			die "helper get_prev_index. Отсутствует параметр FROM" unless $params{from};
			die "Не задан index" unless $params{index};

			my $sql = qq/
				SELECT `ID`
				FROM `$params{from}`
				WHERE 1 $params{where}
				ORDER BY `$params{order}` desc
			/;

			$sql .= ", `ID` desc" if($params{order} ne 'ID');

			my @IDs = $self->app->dbi->query($sql)->flat;

			foreach (0..$#IDs){
				return $IDs[$_+1] if($IDs[$_+1] && $IDs[$_]==$params{'index'});
			}
			return $params{ring} ? shift(@IDs) : 0;
		}
	);

	$app->helper(
		def_text_interval => sub {
			my $c      = shift;
			my %params = @_;

			$params{cur_page} ||= $c->stash('page') || 1;
			$params{postfix} = $params{postfix} ? "_".$params{postfix} : '';

			my $total_page = int($params{total_vals} / $params{col_per_page});
			$total_page++ if (int($params{total_vals} / $params{col_per_page}) != $params{total_vals} / $params{col_per_page});
			$c->stash("total_page".$params{postfix}, $total_page);

			$params{cur_page} = 1 if ($params{cur_page} > $total_page);

			if ($total_page >= $params{cur_page}) {
				$c->stash("first_index_page".$params{postfix}, ($params{cur_page} - 1) * $params{col_per_page});
			}

		}
	);

	$app->helper(
		page_navigator => sub {
			my $self   = shift;
			my %params = (
				url			=> '',
				template	=> 'Texts/nav_container',
				page		=> $self->stash->{page} || $self->param('page') || 1,
				@_
			);

			$params{postfix} 		= $params{postfix} ? "_".$params{postfix} : '';

			my $page = delete $params{page};
			my $total_page = $self->stash("total_page".$params{postfix}) || 1;

			my ($first_page, $end_page) = ($page, $total_page);
			if ($page <= 3) {
				$first_page = 1;
				if($total_page <= $page+6){
					$end_page = $total_page;
				} else {
					$end_page = $page+6;
				}
			} else {
				$first_page = $page - 3;
				if($first_page + 6 > $total_page){
					$end_page = $total_page;

				} elsif($first_page + 6 <= $total_page){
					$end_page = $first_page + 6;
				} else {
					$end_page = $total_page;
				}
			}
			return $self->render(
				first_page 	=> $first_page,
				end_page	=> $end_page,
				page		=> $page,
				total_page  => $total_page,
				partial		=> 1,
				%params
			);

		}
	);

}

1;
