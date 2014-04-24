package GG::Plugins::File;

use utf8;

use Mojo::Base 'Mojolicious::Plugin';

our $VERSION = '1';

use Carp 'croak';
use Lingua::Translit;
use File::Basename ();
use File::Copy ();
use File::Spec ();
use File::Path ();
use File::stat;

use Encode qw( encode decode_utf8 );
use Mojo::Util 'quote';

use Archive::Zip qw( :ERROR_CODES :CONSTANTS );

my $MAX_IMAGE_SIZE = 1000; # Максимальный размер картинки по большей стороне, px

sub register {
	my ( $self, $app, $opts ) = @_;

	$opts ||= {};

	$app->log->debug("register GG::Admin::Plugins::File");

	$app->helper(
		file_delete_pict => sub {
			my $self = shift;
			my %params = (
					folder	=> '', #$self->stash->{folder},
					lfield	=> $self->stash->{lfield},
					pict	=> $self->stash->{pict},
					index	=> $self->stash->{index},
					@_
			);

			$params{folder} ||= $self->lkey(name => $params{lfield}, setting => 'folder' );

			my $document_root = $self->static_path;

			if(my $mini = $self->lkey(name => $params{lfield}, setting => 'mini' )){

				foreach (split(/,/, $mini)){
					s{~[\w]+$}{};

					eval{
						my $path = $self->file_path_with_prefix( path => $document_root.$params{folder}.$params{pict}, prefix => $_);
						unlink( $path );

						my $retina_path = $self->file_path_retina($path);
						unlink( $retina_path );
					};

					warn $@ if $@;
				}
			}

			my $retina_path = $self->file_path_retina($document_root.$params{folder}.$params{pict});
			eval{
				unlink ($document_root.$params{folder}.$params{pict});
				unlink ($retina_path);
			};
			warn $@ if $@;
		}
	);

	# Сохранение картинки с созданием mini из параметра ключа
	$app->helper(
		file_save_pict => sub {
			my $self = shift;
			my %params = (
				filename	=> '',#$self->stash->{filename},
				folder		=> '',#$self->stash->{folder},
				lfield		=> 'pict',
				table		=> $self->stash->{list_table},
				fields		=> {
					folder		=> 'folder',
					type_file	=> 'type_file',
				},
				retina		=> 0,
				watermark 	=> '',
				@_
			);

			$params{filename} ||= $self->send_params->{ $params{lfield} } if $self->send_params->{ $params{lfield} };
			$params{folder} ||= $self->lkey(name => $params{lfield}, tbl => $params{table}, setting => 'folder' );
			$params{retina} = 1 if $self->lkey(name => $params{lfield}, tbl => $params{table}, setting => 'retina' );


			$params{filename} ||= $params{file} if $params{file};
			my $table = delete $params{table};
			my $fields_hashref = delete $params{fields};

			$fields_hashref->{'pict'} = $params{lfield};

			my ($pict_saved, $type_file, $pict_path);

			# Создаем папку если ее нет
			$self->file_make_static_path($params{folder});

			($pict_path, $pict_saved, $type_file) = $self->file_save_from_tmp( filename => $params{filename}, to => $params{folder}.$params{filename} );
			$self->resize_pict(
				file	=> $pict_path,
				fsize 	=> $MAX_IMAGE_SIZE,
				retina 	=> $params{retina},
			);

			foreach (keys %$fields_hashref){
				delete $fields_hashref->{$_} unless $self->dbi->exists_keys(from => $table, lkey => $fields_hashref->{$_} );
			}
			my $values = {};
			$values->{ $fields_hashref->{folder} } = $params{folder} if $fields_hashref->{folder};
			$values->{ $fields_hashref->{pict} } = $pict_saved if $fields_hashref->{pict};
			$values->{ $fields_hashref->{type_file} } = $type_file if $fields_hashref->{type_file};

			$self->save_info(send_params => 0, table => $table, field_values => $values );

			if(my $mini = $self->lkey(name => $params{lfield}, setting => 'mini' )){

				foreach my $d (split(/,/, $mini)) {
					if($d =~ /([\d]+)x([\d]+)~([\w]+)/){
						my ($w, $h) = ($1, $2);
						my %type = ($3 	=> 1);

						my ($path, $pict, $ext) = $self->file_save_from_tmp(filename => $params{filename}, to => $params{folder}.$pict_saved, prefix => $w."x".$h );

						$self->resize_pict(
							file		=> $path,
							width		=> $w,
							height		=> $h,
							retina 		=> $params{retina},
							watermark 	=> $params{watermark},
							%type
						);
					} elsif($d =~ /([\d]+)x([\d]+)/){
						my ($w, $h) = ($1, $2);

						my ($path, $pict, $ext) = $self->file_save_from_tmp( filename => $params{filename}, to => $params{folder}.$pict_saved, prefix => $w."x".$h );

						$self->resize_pict(
							file		=> $path,
							width		=> $w,
							height		=> $h,
							retina 	=> $params{retina},
							watermark 	=> $params{watermark},
						);
					} else {
						my ($path, $pict, $ext) = $self->file_save_from_tmp( filename => $params{filename}, to => $params{folder}.$pict_saved, prefix => $d );

						$self->resize_pict(
							file	=> $path,
							fsize	=> $d,
							retina 	=> $params{retina},
							watermark 	=> $params{watermark},
						);
					}

				}
			}
			unlink($self->file_tmpdir().'/'.$params{filename});

			return $pict_saved;
		}
	);

	$app->helper(
		file_make_static_path => sub {
			my $self = shift;
			my $path = shift;
			my $perms = shift || 0777;

			my $static_path = $self->static_path;
			return 1 if -d $static_path.$path;

			my $dir = '';

			warn "make_path $path";
			for ( split /\//, $path ) {
				next unless $_;

				$dir .= "/$_";
				next if -d $static_path.$dir;

				mkdir $static_path.$dir, $perms or warn "file_make_static_path - $static_path.$dir - ".$!;
			}
		}
	);


	$app->helper(
		file_save_from_tmp => sub {
			my $self = shift;
			my %params = (
				from_tmp	=> 1,
				lfield		=> '',
				prefix		=> '',
				@_
			);
			#$params{from} = $self->global('tempory_dir').$params{filename};
			$params{from} = $self->file_tmpdir().'/'.$params{filename};

			$self->file_save(%params);
		}
	);

	$app->helper(
		file_download => sub {
			my $self = shift;
			my %args     = (
				abs_path 	=> '', 			# полный путь к файлу
				path 		=> '',			# относительный путь
				filename 	=> '',			# имя файла (ОПЦИОНАЛЬНО)
				status 		=> '', 			# код ответа (ОПЦИОНАЛЬНО)
				content_disposition => '',
				format 		=> '',			# формат файла (ОПЦИОНАЛЬНО)
				data 		=> '',			# отдаваемый данные (ОПЦИОНАЛЬНО)
				@_
			);

			unless ($args{filepath}) {
				$args{filepath} =  $args{'abs_path'} || $self->app->static->paths->[0].$args{path};
			}
			my $filename            = decode_utf8($args{filename});
			my $status              = $args{status}               || 200;
			my $content_disposition = $args{content_disposition}  || 'attachment';

			# Content type based on format
			my $content_type;
			$content_type = $self->app->types->type( $args{format} ) if $args{format};
			$content_type ||= 'application/x-download';

			# Create asset
			my $asset;

			if ( my $filepath = decode_utf8($args{filepath}) ) {
				unless ( -f $filepath && -r $filepath ) {
					$self->app->log->error("Cannot read file [$filepath]. error [$!]");
					return;
				}

				$filename ||= File::Basename::fileparse($filepath);
				$asset = Mojo::Asset::File->new( path => $filepath );
			} elsif ( $args{data} ) {
				$filename ||= $self->req->url->path->parts->[-1] || 'download';
				$asset = Mojo::Asset::Memory->new();
				$asset->add_chunk( $args{data} );
			} else {
				$self->app->log->error('You must provide "data" or "filepath" option');
				return;
			}

			# Create response headers
			$filename = quote($filename); # quote the filename, per RFC 5987
			$filename = encode("UTF-8", $filename);

			my $headers = Mojo::Headers->new();
			$headers->add( 'Content-Type', $content_type . ';name=' . $filename );
			$headers->add( 'Content-Disposition', $content_disposition . ';filename=' . $filename );

			# Range
			# Partially based on Mojolicious::Static
			if ( my $range = $self->req->headers->range ) {
				my $start = 0;
				my $size  = $asset->size;
				my $end   = $size - 1 >= 0 ? $size - 1 : 0;

				# Check range
				if ( $range =~ m/^bytes=(\d+)-(\d+)?/ && $1 <= $end ) {
					$start = $1;
					$end = $2 if defined $2 && $2 <= $end;

					$status = 206;
					$headers->add( 'Content-Length' => $end - $start + 1 );
					$headers->add( 'Content-Range'  => "bytes $start-$end/$size" );
				} else {
					# Not satisfiable
					return $self->rendered(416);
				}

				# Set range for asset
				$asset->start_range($start)->end_range($end);
			} else {
				$headers->add( 'Content-Length' => $asset->size );
			}

			# Set response headers
			$self->res->content->headers($headers);

			# Stream content directly from file
			$self->res->content->asset($asset);
			return $self->rendered($status);
		}
	);

	$app->helper(
		file_save => sub {
			my $self = shift;
			my %params = (
				lfield		=> '',
				from		=> '',
				to			=> '',
				dest		=> '',
				replace		=> 0,
				from_tmp	=> 0,
				prefix		=> '',
				prefix_delimiter => '_',
				to_abs_path => 1,
				@_
			);


			my $from = delete $params{from};
			my $to = delete $params{to} || $params{dest};

			if(!$to && $params{lfield} && $self->lkey(name => $params{lfield} ) ){
				$to  = $self->lkey(name => $params{lfield} )->{settings}->{folder};
				$to .= $self->send_params->{ $params{lfield} };
			}

			return unless $to;

			if(delete $params{to_abs_path}){
				$from = $self->static_path.$from unless $params{from_tmp};
				$to = $self->static_path.$to;
			}


#			my($filename, $directories) = File::Basename::fileparse($from);
#			my $ext = ($filename =~ m/([^.]+)$/)[0];
#			$filename =~ s{\.$ext$}{}e;
#
#
#			if(-f $to){
#				my $current = 1;
#				if($filename =~ /(\d)+$/){
#					$current = $1;
#					$filename =~ s/(\d)+$//;
#				}
#
#				foreach (1..1000){
#					my $test_name = $filename;
#					$test_name .= $_;
#					unless (-f $directories.$test_name.'.'.$ext){
#						$filename = $test_name;
#						last;
#					}
#				}
#				$to = $directories.$filename.'.'.$ext;
#			}
			my ($directories, $filename, $ext);

			if($params{prefix}){
				($filename, $directories) = File::Basename::fileparse($to);
				$ext = ($filename =~ m/([^.]+)$/)[0];

				$filename = $params{prefix}.$params{prefix_delimiter}.$filename;
				$to = $directories.$filename;
			} else {
				($directories, $filename, $ext) = $self->file_check_free_name($to);
				$to = $directories.$filename;
			}
			unlink($to) if ($params{replace} && -f $to);
			eval{
				File::Copy::copy($from, $to)
			};
			warn "file_save: Can't move file from '$from' to '$to': $@/" if $@;

			my $size = -s $to || 0;

			return wantarray ? ($to, $filename, $ext, $size) : $filename;
		}
	);

	# Возвращает не занятое имя файла
	$app->helper(
		file_check_free_name => sub {
			my $self = shift;
			my $path = shift;

			return unless $path;

			my($filename, $directories) = File::Basename::fileparse($path);
			my $ext = ($filename =~ m/([^.]+)$/)[0];
			$filename =~ s{\.$ext$}{}e;

			if(-f $path){
				my $current = 0;
				if($filename =~ /(\d)+$/){
					$current = $1;
					$filename =~ s/(\d)+$//;
				}

				my $sch = $current;
;
				while(1){
					$sch++;
					my $test_name = $filename;
					$test_name .= $sch;
					unless (-f $directories.$test_name.'.'.$ext){
						$filename = $test_name;
						last;
					}
				}
			}

			$filename = $filename.'.'.$ext;
			return wantarray ? ($directories, $filename, $ext) : $filename;
		}
	);

	$app->helper(
		file_path_with_prefix => sub {
			my $self = shift;
			my %params = (
				prefix 	=> '',
				prefix_delimiter => '_',
				@_
			);

			my $path = delete $params{path};
			my($filename, $directories) = File::Basename::fileparse($path);
			my $ext = ($filename =~ m/([^.]+)$/)[0];
			$filename =~ s{\.$ext$}{}e;

			$filename = $params{prefix}.$params{prefix_delimiter}.$filename;
			return $directories.$filename.".".$ext;
		}
	);

	$app->helper(
		file_path_retina => sub {
			my $self = shift;
			my $path = shift;

			my $ext = ($path =~ m/([^.]+)$/)[0];
			$path =~ s{\.$ext$}{}e;

			$path .= '@2x.'.$ext;

			return $path;
		}
	);

	$app->helper(
		file_tmpdir => sub {
			my $self = shift;
			return File::Spec->tmpdir().'/';
		}
	);

	$app->helper(
		file_upload_tmp_thumbview => sub {
			my $self = shift;

			my $filename = $self->param('pict');
			my $dir = $self->file_tmpdir;
			my $path;

			if(-f $dir.$filename){
				$path = $dir.$filename;
			} else {
				$path = $self->static_path.'/admin/img/file_broken.png';
			}

			my $ext = ($path =~ m/([^.]+)$/)[0];
			my $content_type;
			$content_type = $self->app->types->type( $ext ) if $ext;
			$content_type ||= 'text/plain';

			$self->res->headers->content_type($content_type);
			$self->res->content->asset(Mojo::Asset::File->new(path => $path));
			$self->rendered(200);
		}
	);

	$app->helper(
		file_copy_tmp => sub {
			my $self = shift;
			my $filepath = shift;

			my ($filename, undef, $ext) = File::Basename::fileparse($filepath,qr/\.[^.]*/);
			$filename = $filename.$ext;

			my $dir = $self->file_tmpdir;

			unlink($dir.$filename);
			if(-f $dir.$filename){
				# Если такой файл в папке tmp залит другим пользователем
				$filename = $self->file_check_free_name($dir.$filename);
			}
			File::Copy::copy($filepath, $dir.$filename) or die $!;

			return wantarray ? ($dir, $filename) : $filename;
	});

	$app->helper(
		file_upload_tmp => sub {
			my $self = shift;
			my %params = (
				field	=> 'Filedata[]',
				size	=> 1,			# флаг добавления к возвращаемому значению размера файла (админка)
				@_
			);

			my $dir = $self->file_tmpdir;#$self->app->static->root.$self->global('tempory_dir');

			if (my $upload = $self->req->upload( $params{field} )) {
				my $filename = $upload->filename;
				$filename = $self->transliteration($filename);

				# чистка старых файлов
#				opendir(DIR, $dir);
#				my @files = grep(!/\.\.?$/, readdir DIR);
#				closedir(DIR);
#				foreach (@files){
#					unlink($dir.$_) if (-M $dir.$_ > 1 and -f $dir.$_);
#				}
				unlink($dir.$filename);
				if(-f $dir.$filename){
					# Если такой файл в папке tmp залит другим пользователем
					$filename = $self->file_check_free_name($dir.$filename);
				}
				$upload->move_to($dir.$filename);
				my $size = -s $dir.$filename;

				$size = $self->file_nice_size($size) if $size;

				$filename .= "| $size" if $params{'size'};
				return $filename;
			}
			return;

		}
	);

	$app->helper(
		transliteration => sub {
			my $self = shift;
			my $name = shift || return '';

			my $tr = new Lingua::Translit("GOST 7.79 RUS");

			if ($name =~ m/[\\\/]/) {
				$name =~ m/[\w\W\\]+(\\)([\w\W\.]+)/;
				$name = $2;
			}
			$name =~ s{\s}{_}gi;

			if(my $name_tr = $tr->translit($name)){
				$name = $name_tr;

			} else {
				my $dec = new decoder;
				my $name_tr;

				for my $i (0..length($name)-1) {
					if ((ord(substr($name, $i, 1)) != 208) and (ord(substr($name, $i, 1)) != 209)) {
						if ((ord(substr($name, $i-1, 1)) == 209) and (ord(substr($name, $i, 1)) == 145)) {
							$name_tr .= $dec -> utfruslat("\xc0");
						} elsif ((ord(substr($name, $i-1, 1)) == 209) and (ord(substr($name, $i, 1)) == 129)) {
							$name_tr .= $dec -> utfruslat("\xc1");
						} else {
							$name_tr .= $dec -> utfruslat(substr($name, $i, 1));
						}
					}
				}
			}
			$name =~ s/[`\:\;\!\~\@\#\$\^\&\(\)\'"]+//g;
			$name =~ tr/\x20-\x7f//cd;
			$name = lc($name);

			return $name;
		}
	);

	$app->helper(
		file_extract_zip => sub {
			my $self = shift;
			my %params = (
				path	=> '',
				ext		=> [qw(jpg jpeg gif png JPG JPEG GIF PNG)],
				@_
			);

			return [] if (!$params{path} or $params{path} !~ m/\.zip$/i);

			my (@textFileMembers, @filenamereturn);
			my $avalaible_ext = $params{ext};

			# Распаковываем архив
			my $zip = Archive::Zip -> new();
			die 'read error' if $zip -> read( $params{path} ) != AZ_OK;
			@textFileMembers = $zip -> memberNames( '.*' );
			my $tmp_dir = $self->file_tmpdir();
			foreach my $f (@textFileMembers) {

				next if ($f =~ /__MACOSX/i);

				my $ext = ($f =~ m/([^.]+)$/)[0];
				$ext =~ s{^\.}{};
				next unless (grep(/$ext/, @$avalaible_ext) );

				my ($filename, undef) = File::Basename::fileparse($f);
				$filename = $self->transliteration($filename);

				my $Upload = $zip -> contents( $f );

				eval{
					unlink($tmp_dir.$filename);
					if(-f $tmp_dir.$filename){
						# Если такой файл в папке tmp залит другим пользователем
						$filename = $self->file_check_free_name($tmp_dir.$filename);
					}

					open(FILE, ">${tmp_dir}$filename") or die("can't open ${tmp_dir}$filename: $!");
					flock(FILE, 2);
					binmode(FILE);
					print FILE $Upload;
					close FILE or die("can't close ${tmp_dir}$filename: $!");
				};

				#die $@ if $@;
				if($@){
					warn $@;
					next;
				}

				next unless my $size = -s $tmp_dir.$filename;
				my ($width, $height) = $self->image_set( file => $tmp_dir.$filename);
				push @filenamereturn, { filename => $filename, ext => $ext, size => $size, oldfilename => $f, width => $width, height => $height};
			}
			return \@filenamereturn;
		}
	);

	$app->helper(
		file_read_data => sub {
			my $self = shift;
			my %params = (
				path	=> '',
				@_
			);
			return unless $params{path};

			my $code;
			open( FILE, "<:utf8", $params{path});
			while (<FILE>) {$code .= $_;}
			close FILE;

			return $code;
		}
	);

	$app->helper(
		file_save_data => sub {
			my $self = shift;
			my %params = (
				data	=> '',
				path	=> '',
				@_
			);
			return unless $params{path};

			my $data = delete $params{data};
			my $path = delete $params{path};

			open( FILE, '>:utf8', $path ) or die $!;
			#binmode FILE;

			print FILE $data;
			close( FILE );

			return 1;
		}
	);

	$app->helper(
		file_save_data_raw => sub {
			my $self = shift;
			my %params = (
				data	=> '',
				path	=> '',
				@_
			);
			return unless $params{path};

			my $path = delete $params{path};
			_create($path);

			my $data = delete $params{data};
			my $needed_bytes = length $data;

			open my $fh, '+<:raw', $path or die "Unable to open $path for write: $!";
			my $current_bytes = ( stat $fh )[7];

			#shrink file if needed
			if ( $needed_bytes < $current_bytes ) {
				truncate $fh, $needed_bytes;
			}

			# make sure we can expand the file to the needed size before we overwrite it
			elsif ( $needed_bytes > $current_bytes ) {
				my $padding = q{ } x ( $needed_bytes - $current_bytes );
				sysseek $fh, 0, 2;
				if ( !syswrite $fh, $padding ) {
					sysseek $fh, 0, 0;
					truncate $fh, $current_bytes;
					close $fh;
					die "Unable to expand $path: $!";
				}
				sysseek $fh, 0, 0;
				seek $fh, 0, 0;
			}
			print {$fh} $data;
			close $fh;
			return 1;
		}
	);

	$app->helper(
		file_convert_ext_to_mime => sub {
			my $self = shift;
			my $ext = shift;

			my $exts = {
				'*.jpg'		=> 'image/jpeg',
				'*.png'		=> 'image/png',
				'*.gif'		=> 'image/gif',

				'*.*'		=> '',
			};

			my @res;
			foreach (split(';', $ext )){
				push @res, $exts->{$_}	if $exts->{$_};
			}
			return join(',', @res);
		}
	);

	$app->helper(
		file_nice_size => sub {
			my $self = shift;

			my $fs = $_[0];	# First variable is the size in bytes
			my $dp = $_[1] || 0;	# Number of decimal places required
			my @units = ('bytes','kB','MB','GB','TB','PB','EB','ZB','YB');
			my $u = 0;
			$dp = ($dp > 0) ? 10**$dp : 1;
			while($fs > 1024){
				$fs /= 1024;
				$u++;
			}
			return $units[$u] ? (int($fs*$dp)/$dp)." ".$units[$u] : int($fs);
		}
	);
}


sub _create{
	my $file = shift;
	if (open(my $FILE,">",$file)) {
		print $FILE "\n";
		close($FILE);
	}
	else {
		warn "Can't write to config file ".$file;
	}
}
1;

package decoder;

use strict;
use warnings;

use CGI::Carp qw(fatalsToBrowser);
#use CGI qw(:standard);

use Time::Local;

sub new {
	my $self = {
		value => undef,
	};
	bless($self);
	return $self;
}

#== lc_rus ====================================================================#

sub lc_rus {
	my $self = shift();
	my $value = shift() if (@_);

	$value =~ tr/ABCDEFGHIJKLMNOPQRSTUVWXYZ/abcdefghijklmnopqrstuvwxyz/;
	$value =~ tr/АБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯ/абвгдеёжзийклмнопрстуфхцчшщъыьэюя/;
	return $value;
} # end of &lc_rus

#== uc_rus ====================================================================#

sub uc_rus {
	my $self = shift();
	my $value = shift() if (@_);

	$value =~ tr/абвгдеёжзийклмнопрстуфхцчшщъыьэюя/АБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯ/;
	$value =~ tr/abcdefghijklmnopqrstuvwxyz/ABCDEFGHIJKLMNOPQRSTUVWXYZ/;
	return $value;
} # end of &uc_rus

#== utfruslat =================================================================#

sub utfruslat {
	my $self = shift();
	my $value = shift() if (@_);

	my $tabl1 =
		'\x90\x91\x92\x93\x94\x95\x81\x96\x97'.
		'\x98\x99\x9a\x9b\x9c\x9d\x9e\x9f'.
		'\xa0\xa1\xa2\xa3\xa4\xa5\xa6\xa7'.
		'\xa8\xa9\xaa\xab\xac\xad\xae\xaf'.
		'\xb0\xb1\xb2\xb3\xb4\xb5\xc0\xb6\xb7'.
		'\xb8\xb9\xba\xbb\xbc\xbd\xbe\xbf'.
		'\x80\xc1\x82\x83\x84\x85\x86\x87'.
		'\x88\x89\x8a\x8b\x8c\x8d\x8e\x8f\x20';
	my $tabl2 =
		'\x41\x42\x56\x47\x44\x45\x45\x47\x5a'.
		'\x49\x49\x4b\x4c\x4d\x4e\x4f\x50'.
		'\x52\x53\x54\x55\x46\x48\x43\x43'.
		'\x53\x53\x57\x49\x57\x45\x55\x41'.
		'\x61\x62\x76\x67\x64\x65\x65\x67\x7a'.
		'\x69\x69\x6b\x6c\x6d\x6e\x6f\x70'.
		'\x72\x73\x74\x75\x66\x68\x63\x63'.
		'\x73\x73\x77\x69\x77\x65\x75\x61\x5f';

	eval "\$value =~ tr/$tabl1/$tabl2/;";
	return $value;
} # end of &utfruslat

#== utfdecode =================================================================#

sub utfdecode {
	my $self = shift();
	my $value = shift() if (@_);

	my $cd = 0;	my $cp = 0;
	while ($value =~ m/%D[01]+/ig) {$cd++;}
	while ($value =~ m/%/ig) {$cp++;}

	if (($cd) && ($cp/$cd >= 2) && ($cp/$cd < 3)) {
		$value =~ s/%D1%8/%D0%C/ig;
		$value =~ s/%D0%9/%D0%B/ig;
		$value =~ s/%D0%A/%D0%C/ig;
		$value =~ s/%D0//ig;
		$self -> {flag_iso} = 1;
	}
	return $value;
} # end of &utfdecode

#== win2unicode ===============================================================#

sub win2unicode {
	my $self = shift();

	my $value = shift() if (@_);

	if (!$value) {return "";}
	my $result = "";
	my $o_code = "";
	my $i_code = "";

	for (my $I = 0; $I < length($value); $I++) {
		$i_code = ord(substr($value, $I, 1));
		if ($i_code == 184){
			$o_code = 1105;
		} elsif ($i_code == 168){
			$o_code = 1025;
		} elsif ($i_code > 191 && $i_code < 256){
			if ($i_code == 194) {
				my $i_code_l = ord(substr($value, $I+1, 1));
				if ($i_code_l != 187 and $i_code_l != 171) {
					$o_code = $i_code + 848;
				} else {$o_code = "";}
			} else {
				$o_code = $i_code + 848;
			}
		} elsif (($i_code == 151) or ($i_code == 150)) {
			$o_code = ord('-');
		} else {
			$o_code = $i_code;
		}
		$result = $result.chr($o_code) if ($o_code);
	}
	return $result;
} # end of &win2unicode

#== urldecode =================================================================#

sub urldecode {
	my $self = shift();

	if (@_) {
		my $value = shift();
		   $value =~ s/\+/ /g;
		   $value =~ s/%([0-9A-H]{2})/pack('C',hex($1))/ge;
		return $value;
	} else {return "";}
} # end of &urldecode

#== urlencode =================================================================#

sub urlencode {
	my $self = shift();

	my $value = shift() if (@_);
	   $value =~ s/([=\+&%\/\\|\0-\x1F\x80-\xFF])/sprintf("%%%02X", unpack('C', $1))/eg;
	   $value =~ s/ /\+/g;
	return $value;
} # end of &urlencode

#== def_gmtime ================================================================#

sub def_gmtime {
	my $self = shift();

	my ($decode_time) = @_;

	my ($date, $time)  = split(/ /, $decode_time);
	my ($y, $m, $d)    = split(/-/, $date);
	my ($h, $min, $sec)= split(/:/, $time) if ($time);
		$h   ||= 0;
		$min ||= 0;
		$sec ||= 0;
		$m -= 1;
	my ($week, $isdst, $yday);

	my $TIME = timelocal($sec, $min, $h, $d, $m, $y);
	($sec, $min, $h, $d, $m, $y, $week, $yday, $isdst) = localtime($TIME);

	if ($isdst) {$isdst = "+0400";} else {$isdst = "+0300";}
		$m = $m;
		$y = $y+1900;
	$decode_time = gmtime(timegm($sec, $min, $h, $d, $m, $y));
	$decode_time =~ s/[\ ]+/ /g;
	($week, $m, $d) = split(/ /, $decode_time);

	return "$week, $d $m $y $time $isdst";
} # end of &def_gmtime

#== get_week ==================================================================#

sub get_week {
	my $self = shift();

	my ($decode_date) = @_;

	my ($date, $time)  = split(/ /, $decode_date);
	my ($y, $m, $d)    = split(/-/, $date);
	my ($h, $min, $sec)= split(/:/, $time) if ($time);
		$h   ||= 0;
		$min ||= 0;
		$sec ||= 0;
		$m -= 1;
	my ($week, $isdst, $yday);

	my $TIME = timelocal($sec, $min, $h, $d, $m, $y);
	($sec, $min, $h, $d, $m, $y, $week, $yday, $isdst) = localtime($TIME);

	return $week;
} # end of &get_week

return 1;