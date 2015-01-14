package GG::Admin::Filemanager::elFinder;

use strict;

use v5.10;

use vars qw/$VERSION $DIRECTORY_SEPARATOR/;

use Digest::MD5 qw(md5_hex);
use File::Basename qw();
use File::Find qw();
use File::Path qw();
use File::Copy::Recursive ();
use Archive::Zip qw( :ERROR_CODES :CONSTANTS );

use Mojolicious::Types;
use Mojo::Util qw(decode encode b64_decode b64_encode url_escape url_unescape);
use Mojo::JSON;

use utf8;

$VERSION = "2.0"; # Версия движка и API
$DIRECTORY_SEPARATOR = '/';

use Mojo::Cache;
my $cache = Mojo::Cache->new(max_keys => 1000);
my $cache_live_time = 3;		# кол-во дней кэша

sub new
{ # Создание нового класса. Отсюда начинается класс
	my ($class, %cfg) = @_; #Mod - список модулей для загрузки
	my $self = bless {}, $class;

	%{$self->{CONF}} = (
		#'root'         	=> 	'../../httpdocs/userfiles',           # path to root directory
		'rootAlias'    	=> 	'userfiles',       # display this instead of root directory name
		'volume_id'		=>	'gg_',
		'copyOverwrite'	=> 	1,			# Разрешена или нет перезапись файлов с одинаковыми именами на текущем томе
		'disabled'     	=> 	[],           # list of not allowed commands
		'dotFiles'     	=> 	'false',      # display dot files
		'dirSize'      	=> 	'true',       # count total directories sizes
		'fileMode'     	=> 	0666,         # new files mode
		'dirMode'      => 0777,         # new folders mode
		'mimeDetect'   => 'auto',       # files mimetypes detection method (finfo, mime_content_type, linux (file -ib), bsd (file -Ib), internal (by extensions))
		'uploadAllow'  => [],           # mimetypes which allowed to upload
		'uploadDeny'   => [],           # mimetypes which not allowed to upload
		'uploadOrder'  => 'deny,allow', # order to proccess uploadAllow and uploadAllow options
		'imgLib'       => 'auto',       # image manipulation library (imagick, mogrify, gd)
		'tmbDir'       => '.tmb',       # directory name for image thumbnails. Set to "" to avoid thumbnails generation
		'tmbCleanProb' => 1,            # how frequiently clean thumbnails dir (0 - never, 200 - every init request)
		'tmbAtOnce'    => 5,            # number of thumbnails to generate per request
		'tmbSize'      => 48,           # images thumbnails size (px)
		'fileURL'      => 'true',       # display file URL in "get info"
		'DateTimeFormat'=> '%d-%m-%Y %H:%i:%S', # file modification date format
		'@Months'      => 'Январь,Февраль,Март,Апрель,Май,Июнь,Июль,Август,Сентябрь,Октябрь,Ноябрь,Декабрь',
		'@WeekDays'    => 'Воскресенье,Понедельник,Вторник,Среда,Четвер,Пятница,Суббота',
		'logger'       => 'null',       # object logger
		'aclObj'       => 'null',       # acl object (not implemented yet)
		'aclRole'      => 'user',       # role for acl
		'defaults'     => {             # default permisions
			'read'   => 'true',
			'write'  => 'true',
			'rm'     => 'true'
		},
		'perms'        => [],           # individual folders/files permisions
		'debug'        => 'false',      # send debug to client
		'archiveMimes' => [],           # allowed archive's mimetypes to create. Leave empty for all available types.
		'archivers'    => [],           # info about archivers to use. See example below. Leave empty for auto detect
		'uplMaxSize'   => '8Mb',
	);
	$self->{CONF} = { %{$self->{CONF}}, %cfg };     # Чтение файла конфигурации
	$self->{app} = $self->{CONF}->{app};

	%{$self->{RES}} = ();

	if (substr($self->{CONF}->{'root'}, -1) eq $DIRECTORY_SEPARATOR)
	{
		$self->{CONF}->{'root'} = substr($self->{CONF}->{'root'}, 0, -1); # Убираем последний /
	}
	if (substr($self->{CONF}->{'URL'}, -1) eq $DIRECTORY_SEPARATOR)
	{
		$self->{CONF}->{'URL'} = substr($self->{CONF}->{'URL'}, 0, -1); # Убираем последний /
	}

	# по умолчанию считаем что кэш включен (есть доступ к таблице sys_filemanager_cache)
	$self->{cache_on} = 1;

	# Не нужно повторно рендерить ответ на выходе (скачка файла)
	$self->{rendered} = 0;

	%{$self->{REQUEST}} = ();

	return $self;
}




sub run
{
	my ($self, %request) = @_;

	if ($self->{CONF}->{'root'} eq '' || !is_dir($self->{CONF}->{'root'}))
	{
		$self->{RES}->{'error'} = 'Invalid backend configuration';
		return;
	}
#	if (!_isAllowed($self, $self->{CONF}->{'root'}, 'read'))
#	{
#		$self->{RES}->{'error'} = 'Access denied';
#		return;
#	}
	$self->{REQUEST} = { %request };

	my $path = $self->_hash_api2_decode( $self->{REQUEST}->{'target'} );

	my $cmd = $self->{REQUEST}->{'cmd'};
	if (exists $self->{REQUEST}->{'init'}){
		$self->{RES}->{'netDrivers'} = [];
		$self->{RES}->{'uplMaxSize'} = $self->{CONF}->{uplMaxSize};
		$self->{RES}->{'api'} = $VERSION;
	}
#		my $ts = $self->_utime();
#		%{$self->{RES}->{'options'}} = (
#			#'path'			=> substr($path, 6),
#			'path'			=> $self->_path2relUrl($path),
#			'url'			=> $self->{CONF}->{URL}.$DIRECTORY_SEPARATOR,
#			'tmbUrl'		=> $self->_path2baseUrl($path),
#			#'tmbUrl'		=> $self->{CONF}->{tmbDir} ? $self->{CONF}->{URL}.$DIRECTORY_SEPARATOR.$self->{CONF}->{tmbDir}.$DIRECTORY_SEPARATOR : 'False',
#			'disabled'		=> [],
#			'copyOverwrite' => $self->{CONF}->{copyOverwrite},
#			'separator'		=> $DIRECTORY_SEPARATOR,
#			'archivers'		=> {
#				'create'	=> [qw(application/zip)],
#				'extract'	=> [qw(application/zip)],
#			},
#
##			'dotFiles'   => $self->{CONF}->{'dotFiles'},
#
#		);
#
#		#$self->{RES}->{'options'}->{tmbUrl} = $self->{CONF}->{URL}.$DIRECTORY_SEPARATOR.$self->{CONF}->{tmbDir}.$DIRECTORY_SEPARATOR if $self->{CONF}->{tmbDir};
#
#		$self->{RES}->{'api'} = $VERSION;
#
#		## clean thumbnails dir
##		if ($self->{CONF}->{'tmbDir'} ne '')
##		{
##			srand(time() * 1000000);
##			if (rand(200) <= $self->{CONF}->{'tmbCleanProb'})
##			{
##				my $ts2 = $self->_utime();
##				opendir(DIR, $self->{CONF}->{'tmbDir'});
##				my @content = grep {!/^\.{1,2}$/} sort readdir(DIR);
##				closedir(DIR);
##				foreach my $subdir (@content)
##				{
##					unlink($self->{CONF}->{'tmbDir'}.$DIRECTORY_SEPARATOR.$subdir);
##				}
##			}
##		}
#	}

	given ($cmd){
		when('open') 					{ $self->_open; }
		when('tree') 					{ $self->_tree($path, 1); }
		when('mkdir') 					{ $self->_mkdir; }
		when('mkfile') 					{ $self->_mkfile; }
		when('upload') 					{ $self->_upload; }
		when('ls') 						{ $self->_ls; }
		when('rm') 						{ $self->_rm; }
		when('get') 					{ $self->_get; }
		when('paste') 					{ $self->_paste; }
		when('upload') 					{ $self->_upload; }
		when('parents') 				{ $self->_parents; }
		when('search') 					{ $self->_search; }
		when('rename') 					{ $self->_rename; }
		when('file') 					{ $self->_file; }
		when('duplicate') 				{ $self->_duplicate; }
		when('resize') 					{ $self->_resize; }
		when('archive') 				{ $self->_archive; }
		when('extract') 				{ $self->_extract; }
		when('tmb') 					{ $self->_tmb; }
		when('put') 					{ $self->_puttext; }

		default							{ $self->_open; }
	}
}

sub _puttext{
	my $self = shift;

	my $content = $self->{REQUEST}->{'content'};

	my $hash = shift || $self->{REQUEST}->{'target'};
	my $path = $self->_hash_api2_decode($hash);

	$self->{RES}->{'changed'} = [];
	if($self->{app}->file_save_data( data => $content, path => $path)){
		return push @{ $self->{RES}->{'changed'} }, { $self->_info($path) };

	}
	$self->{RES}->{'error'} = ('errSave', $path);
}

sub _tmb{
	my $self = shift;

	if(!$self->{REQUEST}->{'targets[]'}){
		return $self->{RES}->{'error'}.= 'Не задан целевой файл/папка';
	}

	my $targets = [];
	if(ref($self->{REQUEST}->{'targets[]'}) eq 'ARRAY'){
		$targets = $self->{REQUEST}->{'targets[]'};
	} else {
		push @$targets, $self->{REQUEST}->{'targets[]'};
	}

	$self->{RES}->{'images'} = {};
	foreach my $target (@$targets){
		my $dstpath = $self->_hash_api2_decode( $target );

		next unless $dstpath;

#		my $filename = _basename($dstpath);
#		my $dir = substr($dstpath, 0, -length($filename));
#		if (substr($dir, -1) ne $DIRECTORY_SEPARATOR){
#			$dir .= $DIRECTORY_SEPARATOR;
#		}
#
#		unless(-d $dir.$self->{CONF}->{tmbDir}.$DIRECTORY_SEPARATOR){
#			mkdir($dir.$self->{CONF}->{tmbDir}.$DIRECTORY_SEPARATOR, $self->{CONF}->{'dirMode'});
#		}
#
#
#		File::Copy::Recursive::fcopy($dir.$filename, $dir.$self->{CONF}->{tmbDir}.$DIRECTORY_SEPARATOR.$filename) or die $!;
#
#		$self->{app}->resize_pict(
#							file	=> $dir.$self->{CONF}->{tmbDir}.$DIRECTORY_SEPARATOR.$filename,
#							width	=> 48,
#							height	=> 48,
#		);
		if(my ($dir, $filename) = $self->__create_tmp($dstpath)){
			$self->{RES}->{'images'}->{ $target } = $filename;
		}

	}
}

sub __create_tmp{
	my $self = shift;
	my $dstpath = shift;

	my $filename = _basename($dstpath);

	my $mime = $self->_mimetype($dstpath);

	if($mime && $mime =~ /image/){

		my $dir = substr($dstpath, 0, -length($filename));
		if (substr($dir, -1) ne $DIRECTORY_SEPARATOR){
			$dir .= $DIRECTORY_SEPARATOR;
		}

		unless(-d $dir.$self->{CONF}->{tmbDir}.$DIRECTORY_SEPARATOR){
			mkdir($dir.$self->{CONF}->{tmbDir}.$DIRECTORY_SEPARATOR, $self->{CONF}->{'dirMode'});
		}

		eval{
			File::Copy::Recursive::fcopy($dir.$filename, $dir.$self->{CONF}->{tmbDir}.$DIRECTORY_SEPARATOR.$filename) or die $!;
		};

		unless($@){
			$self->{app}->resize_pict(
				file		=> $dir.$self->{CONF}->{tmbDir}.$DIRECTORY_SEPARATOR.$filename,
				width		=> 48,
				height	=> 48,
				retina 	=> 0,
			);

			return ($dir, $filename);
		}

	}
	return;
}

sub _isAllowed
{
	my ($self, $path, $action, $bool) = @_;

	my $last_action = $self->{CONF}->{'defaults'}{$action};

	if ($bool)
	{
		return ($last_action eq 'true') ? 1 : 0;
	}
	return ($last_action eq 'true') ? 1 : 0;
	#return (exists $self->{CONF}->{'defaults'}{$action}) ? $self->{CONF}->{'defaults'}{$action} : \0;
}


sub _basename
{
	my ($path) = @_;

	$path = decode 'UTF-8', $path;
	if (rindex($path, $DIRECTORY_SEPARATOR) == -1){
		return $path;
	}
	my @myDir = split('/', $path);

	return pop @myDir || '';
	#return substr($path, rindex($path, $DIRECTORY_SEPARATOR) + 1);
}

sub is_dir
{
	my ($path)=@_;
	if (-d "$path")
	{
		return 1;
	}
	return;
}

sub _isAccepted
{
	my ($self, $file) = @_;
	$file = _basename($file);
	if ('.' eq $file || '..' eq $file)
	{
		return 'false';
	}
	if ($self->{CONF}->{'dotFiles'} ne 'true' && '.' eq substr($file, 0, 1))
	{
		return 'false';
	}
	return 'true';
}

sub _parents{
	my $self = shift;
	my $hash = shift || $self->{REQUEST}->{'target'};

	my $path = $self->_hash_api2_decode($hash);

	my $tree = [];

	if($path && $path ne $self->{CONF}->{root}){

		my @parts = split($DIRECTORY_SEPARATOR, $path);

		pop @parts;
		my $parent_path = join($DIRECTORY_SEPARATOR, @parts);
		while($parent_path && $parent_path ne $self->{CONF}->{root}){
			@$tree = (@$tree, @{ $self->__tree($parent_path, 1) } );
			pop @parts;
			$parent_path = join($DIRECTORY_SEPARATOR, @parts);
		}
		@$tree = (@$tree, @{ $self->__tree($parent_path, 1) } );

		$self->{RES}->{'tree'} = $tree;
	} else {
		push @$tree, { $self->_info($path) };
	}

	$self->{RES}->{'tree'} = $tree;
}

sub _tree{
	my $self = shift;
	$self->{RES}->{'tree'} = $self->__tree(@_);

}

sub __tree
{
	my ($self, $path, $depth) = @_;

	$path ||= $self->{CONF}->{root};


	return [] unless $depth;

	my $dirs = [];
	push @$dirs, { $self->_info($path) };

	opendir(DIR, $path);
	my @content = grep { !/^\.{1,2}$/ } sort readdir(DIR);
	closedir(DIR);
	foreach my $subdir (grep { -d "$path/$_" } @content){
		#next if (substr($subdir, -length($self->{CONF}->{tmbDir})) eq  $self->{CONF}->{tmbDir});
		next if (substr($subdir, 0, 1) eq '.');

		push @$dirs, { $self->_info("$path/$subdir") };
		@$dirs = (@$dirs, @{ $self->__tree("$path/$subdir", $depth-1) } ) if $depth > 1;
	}
	return $dirs;

}

sub _options{
	my ($self, $path) = @_;

	%{$self->{RES}->{'options'}} = (
		'path'			=> substr( $self->_path2relUrl($path), length $DIRECTORY_SEPARATOR) ,
		'url'			=> $self->{CONF}->{URL}.$DIRECTORY_SEPARATOR,# $self->_path2baseUrl($path).$DIRECTORY_SEPARATOR,
		'tmbUrl'		=> $self->_path2baseUrl($path).$DIRECTORY_SEPARATOR.$self->{CONF}->{tmbDir}.$DIRECTORY_SEPARATOR,
		#'tmbUrl'		=> $self->{CONF}->{tmbDir} ? $self->{CONF}->{URL}.$DIRECTORY_SEPARATOR.$self->{CONF}->{tmbDir}.$DIRECTORY_SEPARATOR : 'False',
		'disabled'		=> [],
		'copyOverwrite' => $self->{CONF}->{copyOverwrite},
		'separator'		=> $DIRECTORY_SEPARATOR,
		'archivers'		=> {
			'create'	=> [qw(application/zip)],
			'extract'	=> [qw(application/zip)],
		},
	);
}

sub _cwd
{
	my ($self, $path) = @_;

	%{$self->{RES}->{'cwd'}} = (
		#'path'      => substr($path, 6),
		'hash'      => $self->_hash_api2_encode($path), #_hash($path),
		'phash'		=> $self->_phash($path),
		'name'      => _basename($path),
		'ts'		=> ( stat $path )[9],
		'mime'      => 'directory',
		'size'      => 0,
		'dirs'		=> &__has_subdir($path),
		'read'      => 1,
		'write'     => 1,
	);

	if ($self->{CONF}->{'root'} eq $path){
		$self->{RES}->{'cwd'}->{locked} = 1;
		$self->{RES}->{'cwd'}->{volumeid} = $self->{CONF}->{volume_id},;
	}

}

sub _files
{
	my ($self,$path) = @_;

	opendir(DIR,$path);
	my @content = grep {!/^\.{1,2}$/} sort readdir(DIR);
	closedir(DIR);

	$self->{RES}->{'files'} = [];
	#foreach my $subdir (grep {_isAccepted($self,"$path/$_") eq 'true'} sort {-f "$path/$a" cmp -f "$path/$b"} @content)
	foreach my $subdir (sort {-f "$path/$a" cmp -f "$path/$b"} @content){
		#next if (substr($subdir, -length($self->{CONF}->{tmbDir})) eq  $self->{CONF}->{tmbDir});
		# пропускаем скрытые директории
		next if (substr($subdir, 0, 1) eq '.');

		push @{$self->{RES}->{'files'}}, { $self->_info("$path/$subdir") };
	}

	#Если аргумент tree == true, то добавляются папки из дерева директорий на заданную глубину. Порядок файлов роли не играет
	if($self->{REQUEST}->{'tree'}){

		#my @files = (@{ $self->{RES}->{'files'} }, @{ $self->__tree($path, $self->{REQUEST}->{'tree'}) } );
		my @files = (@{ $self->{RES}->{'files'} }, @{ $self->__tree(undef, $self->{REQUEST}->{'tree'}) } );

		my $hashes = {};
		foreach (0..$#files ){
			my $hash = $files[$_]->{hash} || '';
			next unless $hash;
			if($hashes->{$hash}){
				delete $files[$_];
				next;
			}
			$hashes->{$hash}++;
		}
		$self->{RES}->{'files'} = \@files;

		#foreach ($self->__tree($path, $self->{REQUEST}->{'tree'})){
		#	push @{$self->{RES}->{'files'}}, $_;
		#}
	}
}


sub _info
{
	my ($self, $path) = @_;

	my $hash = $self->_hash_api2_encode($path) || '';

	my %info = ();
	# проверяем в кэше
	if($self->{'cache_on'}){
		# файл есть в кэше
		if(my $hashCache = $cache->get($hash)){
			#warn 'cache exist!';
			return %{$hashCache};
		}
		else {
			if( my $sth = $self->{'app'}->dbi->dbh->prepare("SELECT `hash`,`info` FROM `sys_filemanager_cache` WHERE TO_DAYS(NOW())-TO_DAYS(`updated`)<$cache_live_time") ){
				$sth->execute();
				while(my $row = $sth->fetchrow_hashref){
					$row->{info} =~ s/\-/\=/;
					if(my $hashData = Mojo::JSON::j(b64_decode $row->{info}) ){
		  				$cache->set( $row->{hash}  => $hashData);
					}
				}
				$sth->finish();

				if(my $hashCache = $cache->get($hash)){
					return %{$hashCache};
				}
			}
			else {
				$self->{'cache_on'} = 0;
			}
		}

	}

	my @stat = (-l $path) ? lstat($path) : stat($path);
	%info = (
		'hash'  	=> $hash,
		'mime'  	=> is_dir($path) ? 'directory' : $self->_mimetype($path),
		'ts'		=> $stat[9] || '',
		'phash'		=> $self->_phash($path), #(String) hash of parent directory. Required except roots dirs.
		'name'  	=> _basename($path), # Сделать замену двойных кавычек
		'size'  	=> -d $path ?  0 : $stat[7],
		'read'  	=> 1, #_isAllowed($self, $path, 'read'),
		'write' 	=> 1, #_isAllowed($self, $path, 'write'),
	);

	$info{'date'} = localtime($info{'ts'});

	if ($info{mime} eq 'directory' && $self->{CONF}->{'root'} eq $path){
		delete $info{phash};
		$info{locked} = 1;
	}

	if (-l $path)
	{
		$info{'link'} = 'cvzxv';
	}
	if ($info{'mime'} ne 'directory')
	{

		if ($info{'mime'} =~ /image/)
		{
			eval{
				my $image = Image::Magick->new();
				my $x = $image -> Read($path);

				# в изображении есть ошибки, удаляем его
				if( $x ){
					unlink $path;
					die $x;
					#die $path if $x;
				}


				my ($w, $h) = $image->Get('width', 'height');
				$info{'dim'} = $w.'x'.$h;

				undef $image;
			};
			warn $@ if $@;


			# check tmb
			my $dir = substr($path, 0, -length($info{'name'}));

			if(-f $dir.$self->{CONF}->{tmbDir}.$DIRECTORY_SEPARATOR.$info{name}){
				#die $self->_path2relUrl($dir).$self->{CONF}->{tmbDir}.$DIRECTORY_SEPARATOR.$info{name};
				#$info{'tmb'} = $self->_path2relUrl($dir).$self->{CONF}->{tmbDir}.$DIRECTORY_SEPARATOR.$info{name};
				$info{'tmb'} = $info{'name'};
			} else {
				$info{'tmb'} = 1;
			}

			#$info{'tmb'} = _basename($path);
			if ($info{'read'})
			{

				#$info{'resize'} = (exists $info{'dim'});
				#$tmb = _tmbPath($self,$path);
				#if (-f $tmb) {$info{'tmb'} = _path2url($self,$tmb);}
				#elsif ($info{'resize'}) {$self->{RES}->{'tmb'} = 'true'}
			}
		}
	} else {
		# (Number) Only for directories. Marks if directory has child directories inside it. 0 (or not set) - no, 1 - yes. Do not need to calculate amount.
		$info{dirs} = &__has_subdir($path); #
	}

	if($self->{'cache_on'}){
		my $data = \%info;

		my $encodeData = b64_encode(Mojo::JSON::encode_json($data), '');
		$encodeData =~ y/=/-/;

		$self->{'app'}->dbi->dbh->do("REPLACE INTO `sys_filemanager_cache`(`hash`,`info`, `updated`) VALUES (?, ?, NOW()) ", undef, $hash, $encodeData);
	}

	return %info;
}

sub _path2baseUrl{
	my ($self, $path) = @_;
	my $url = substr $path, length $self->{CONF}->{'root'};
	utf8::decode($url);
	return $self->{CONF}->{'URL'}.$url;
}

sub _path2relUrl{
	my ($self, $path) = @_;
	my $url = substr $path, length $self->{CONF}->{'root'};
	utf8::decode($url);
	return $DIRECTORY_SEPARATOR.$self->{CONF}->{'rootAlias'}.$url;
}

sub _mimetype
{
	my ($self, $path) = @_;

	#use File::MimeInfo;
	#return mimetype($path);

	if (rindex($path,$DIRECTORY_SEPARATOR) != -1)
	{
		$path = substr($path, rindex($path, $DIRECTORY_SEPARATOR) + 1);
	}
	my ($name, $ext);
	if (rindex($path,'.') != -1)
	{
		$ext  = substr($path, rindex($path, '.') + 1);
		$name = substr($path, 0, rindex($path,'.'));
	}
	else
	{
		$name = $path;
	}

	my $types = Mojolicious::Types->new;
	my $mt = $types->type(lc($ext)) || 'application/octet-stream';
	return $mt;


	#my $mt = $self->{CTYPE}->{lc($ext)};
	#$mt = ($mt ne '') ? $mt :'unknown;';
	#return $mt;
}

sub _content
{
	my ($self, $path) = @_;
	_options($self, $path);
	_cwd($self, $path);
	_files($self, $path);
}

sub _get{
	my $self = shift;

	if(!$self->{REQUEST}->{'target'}){
		return $self->{RES}->{'error'}.= 'Не задан файл';
	}

	my $path = $self->_hash_api2_decode( $self->{REQUEST}->{'target'} );
	my $data = $self->{app}->file_read_data(path => $path);

	$self->{'RES'}->{'content'} = $data || '';
}

sub _rm{
	my $self = shift;

	if(!$self->{REQUEST}->{'targets[]'}){
		return $self->{RES}->{'error'}.= 'Не задан целевой файл/папка';
	}

	my $targets = [];
	if(ref($self->{REQUEST}->{'targets[]'}) eq 'ARRAY'){
		$targets = $self->{REQUEST}->{'targets[]'};
	} else {
		push @$targets, $self->{REQUEST}->{'targets[]'};
	}

	$self->{RES}->{'removed'} = [];
	foreach my $target (@$targets){
		my $dstpath = $self->_hash_api2_decode( $target );

		$self->__remove_node($dstpath);
		push @{$self->{RES}->{'removed'}}, $target;
	}
}

sub _rename{
	my $self = shift;

	if(!$self->{REQUEST}->{'target'}){
		return $self->{RES}->{'error'}.= 'Не указаны объект для переименования';
	}
	my $new_name = delete $self->{REQUEST}->{'name'};

	if(!$new_name){
		return $self->{RES}->{'error'}.= 'Не указано название';
	}

	my $path = $self->_hash_api2_decode( $self->{REQUEST}->{'target'} );

	my @parts = split($DIRECTORY_SEPARATOR, $path);
	my $old_name = pop @parts;

	my $dir = join($DIRECTORY_SEPARATOR, @parts);
	eval{
		rename($dir.$DIRECTORY_SEPARATOR.$old_name, $dir.$DIRECTORY_SEPARATOR.$new_name);
	};
	if($@){
		return $self->{RES}->{'error'}.= "Ошибка переименования: $@";
	} else {
		# Удаляем thumb
		unlink($dir.$DIRECTORY_SEPARATOR.$self->{CONF}->{tmbDir}.$DIRECTORY_SEPARATOR.$old_name);

		# Создаем новую
		#$self->{REQUEST}->{'targets[]'} = [$self->{REQUEST}->{'target'}];
		#$self->_tmb;
		#delete $self->{RES}->{'images'};
	}

	push @{ $self->{RES}->{'added'} }, { $self->_info($dir.$DIRECTORY_SEPARATOR.$new_name) };
	$self->{RES}->{'removed'} = [$self->{REQUEST}->{'target'}];

}

sub __get_dir_from_path{
	my $path = shift;

	if (substr($path, -1) eq $DIRECTORY_SEPARATOR){
		$path = substr($path, 0, -1);
	}
	my @parts = split($DIRECTORY_SEPARATOR, $path);
	my $name = pop @parts;
	return (join($DIRECTORY_SEPARATOR, @parts), $name);
}

sub _extract{
	my $self = shift;

	if(!$self->{REQUEST}->{'target'}){
		return $self->{RES}->{'error'}.= 'Не указан архив';
	}

	my $path = $self->_hash_api2_decode( $self->{REQUEST}->{'target'} );

	my $zip = Archive::Zip->new();
	return $self->{RES}->{'error'}.= 'Ошибка распаковки архива' unless ( $zip->read( $path ) == AZ_OK );

	my ($dir, $foldername) = __get_dir_from_path($path);

	$foldername =~ s/(\.[^.]+)$//;
	my $current = 1;
	if($foldername =~ /(\d)+$/){
		$current = $1;
		$foldername =~ s/(\d)+$//;
	}

	foreach (1..1000){
		my $test_name = $foldername;
		$test_name .= $_;
		unless (-d $dir.$DIRECTORY_SEPARATOR.$test_name){
			$foldername = $test_name;
			last;
		}
	}

	mkdir($dir.$DIRECTORY_SEPARATOR.$foldername, $self->{CONF}->{'dirMode'});

	foreach my $element ( $zip->members ){

		next if $element->isDirectory;

		(my $extractName = $element->fileName) =~ s{.*/}{};
		my $filename = $self->{app}->transliteration($extractName);

		next if ($filename eq 'thumbs.db');
		$element->extractToFileNamed($dir.$DIRECTORY_SEPARATOR.$foldername.$DIRECTORY_SEPARATOR.$filename);
	}

	$self->{RES}->{'added'} = [ { $self->_info($dir.$DIRECTORY_SEPARATOR.$foldername) } ];
}

sub _archive{
	my $self = shift;

	if(!$self->{REQUEST}->{'targets[]'}){
		return $self->{RES}->{'error'}.= 'Не указаны файлы/папки для архивации';
	}

	if($self->{REQUEST}->{'type'} ne 'application/zip'){
		return $self->{RES}->{'error'}.= 'Не поддерживаемый тип архива';
	}

	my $targets = [];
	if(ref($self->{REQUEST}->{'targets[]'}) eq 'ARRAY'){
		$targets = $self->{REQUEST}->{'targets[]'};
	} else {
		push @$targets, $self->{REQUEST}->{'targets[]'};
	}

	my $added = [];
	my $zip = Archive::Zip->new();
	my $dir = '';
	foreach my $target (@$targets){
		my $path = $self->_hash_api2_decode( $target );

		my (undef, $target_name) = __get_dir_from_path($path);
		$zip->addFileOrDirectory( $path, $target_name );

		($dir, undef) = __get_dir_from_path($path) unless $dir;
	}

	my $uniquename = $self->{app}->file_check_free_name($dir.$DIRECTORY_SEPARATOR.'Archive1.zip');

	unless ( $zip->writeToFileNamed($dir.$DIRECTORY_SEPARATOR.$uniquename) == AZ_OK ) {
		return $self->{RES}->{'error'}.= 'Ошибка создания архива';
	}

	push @$added, { $self->_info($dir.$DIRECTORY_SEPARATOR.$uniquename) };

	$self->{RES}->{'added'} = $added;
}

sub _resize{
	my $self = shift;

	if(!$self->{REQUEST}->{'target'}){
		return $self->{RES}->{'error'}.= 'Не указаны файлы для создания дубликатов';
	}

	my $path = $self->_hash_api2_decode( $self->{REQUEST}->{'target'} );
	my $mode = $self->{REQUEST}->{'mode'};

	my $changed = [];

	if($mode eq 'resize'){
		my ($w, $h) = ($self->{REQUEST}->{'width'}, $self->{REQUEST}->{'height'});

		$self->{app}->image_set(file => $path, width => $w, height => $h);
		push @$changed, { $self->_info($path) };

	} elsif($mode eq 'crop'){
		my ($w, $h, $x, $y) = ($self->{REQUEST}->{'width'}, $self->{REQUEST}->{'height'}, $self->{REQUEST}->{'x'}, $self->{REQUEST}->{'y'});

		$self->{app}->image_crop_raw(file => $path, width => $w, height => $h, x => $x, y => $y);
		push @$changed, { $self->_info($path) };

	} elsif($mode eq 'rotate'){
		my ($w, $h, $degree) = ($self->{REQUEST}->{'width'}, $self->{REQUEST}->{'height'}, $self->{REQUEST}->{'degree'});

		eval{
			my $image = Image::Magick->new;
			my $x     = $image->Read( $path );
			warn $x if $x;

			$image->set(quality => '80');

			$image -> Rotate(
				degrees		=> $degree,
				background	=> 'red',
			);
			$x = $image->Write( $path );
			undef $image;
		};
		if($@){
			return $self->{RES}->{'error'}.= "Ошибка трансформации: $@";
		} else {
			push @$changed, { $self->_info($path) };
		}
	}
	my $filename = _basename($path);
	my $dir = substr($path, 0, -length($filename));
	unlink($dir.$self->{CONF}->{tmbDir}.$DIRECTORY_SEPARATOR.$filename);

	$self->{RES}->{'changed'} = $changed;
}

sub _duplicate{
	my $self = shift;

	if(!$self->{REQUEST}->{'targets[]'}){
		return $self->{RES}->{'error'}.= 'Не указаны файлы для создания дубликатов';
	}

	my $targets = [];
	if(ref($self->{REQUEST}->{'targets[]'}) eq 'ARRAY'){
		$targets = $self->{REQUEST}->{'targets[]'};
	} else {
		push @$targets, $self->{REQUEST}->{'targets[]'};
	}

	my $added = [];
	foreach my $target (@$targets){
		my $src_path = $self->_hash_api2_decode( $target );

		my ($dir, $name) = __get_dir_from_path($src_path);

		my $save_name = $name;
		my $copyname = $name;
		eval{
			# Копируем папку
			if(-d $dir.$DIRECTORY_SEPARATOR.$name){
				$copyname = $name.' copy 1';
				my $current = 1;
				if($copyname =~ /(\d)+$/){
					$current = $1;
					$copyname =~ s/(\d)+$//;
				}

				foreach (1..1000){
					my $test_name = $copyname;
					$test_name .= $_;
					unless (-d $dir.$DIRECTORY_SEPARATOR.$test_name){
						$copyname = $test_name;
						last;
					}
				}

				File::Copy::Recursive::dircopy($dir.$DIRECTORY_SEPARATOR.$name, $dir.$DIRECTORY_SEPARATOR.$copyname)  or die $!

			} elsif(-f $dir.$DIRECTORY_SEPARATOR.$name){
				my $ext = ($name =~ m/([^.]+)$/)[0];
				$name =~ s{\.$ext$}{}e;
				$copyname = $self->{app}->file_check_free_name($dir.$DIRECTORY_SEPARATOR.$name.' copy 1.'.$ext);
				$name = $save_name;

				File::Copy::Recursive::fcopy($dir.$DIRECTORY_SEPARATOR.$name, $dir.$DIRECTORY_SEPARATOR.$copyname) or die $!;
			}
		};
		# Прекращаем выполнение если произошла ошибка
		if($@){
			$self->{RES}->{'error'} = "Ошибка при создание дубликатов: $@";
			last;
		} else {
			push @$added, { $self->_info($dir.$DIRECTORY_SEPARATOR.$copyname) };
		}
	}

	$self->{RES}->{'added'} = $added;
}

sub _paste{
	my $self = shift;

	if(!$self->{REQUEST}->{'targets[]'}){
		return $self->{RES}->{'error'}.= 'Не указаны файлы для копирования/перемещения';
	}

	my $src = $self->_hash_api2_decode( $self->{REQUEST}->{'src'} );
	my $dst = $self->_hash_api2_decode( $self->{REQUEST}->{'dst'} );
	my $cut = $self->{REQUEST}->{'cut'} || 0; # Флаг перемещения

	unless($src){
		return $self->{RES}->{'error'}.= 'Не задана папка источник';
	}
	unless($dst){
		return $self->{RES}->{'error'}.= 'Не задана папка приемник';
	}


	my $targets = [];
	if(ref($self->{REQUEST}->{'targets[]'}) eq 'ARRAY'){
		$targets = $self->{REQUEST}->{'targets[]'};
	} else {
		push @$targets, $self->{REQUEST}->{'targets[]'};
	}

	my $added = [];
	my $removed = [];
	foreach my $target (@$targets){
		my $src_path = $self->_hash_api2_decode( $target );
		if (substr($src_path, -1) eq $DIRECTORY_SEPARATOR){
			$src_path = substr($src_path, 0, -1);
		}
		my @parts = split($DIRECTORY_SEPARATOR, $src_path);
		my $name = pop @parts;

		# Запрет перезаписи папок или файлов
		#next if( (-d $src.$name && -d $dst.$name) or (-f $src.$name && -f $dst.$name) );

		eval{
			# Копируем папку
			if(-d $src.$DIRECTORY_SEPARATOR.$name){
				File::Copy::Recursive::dircopy($src.$DIRECTORY_SEPARATOR.$name, $dst.$DIRECTORY_SEPARATOR.$name)  or die $!

			} elsif(-f $src.$DIRECTORY_SEPARATOR.$name){
				File::Copy::Recursive::fcopy($src.$DIRECTORY_SEPARATOR.$name, $dst.$DIRECTORY_SEPARATOR.$name) or die $!;
			}
		};
		# Прекращаем выполнение если произошла ошибка
		if($@){
			$self->{RES}->{'error'} = "Ошибка при копирование/перемещении: $@";
			last;
		} else {
			push @$added, { $self->_info($dst.$DIRECTORY_SEPARATOR.$name) };
		}


		if($cut){
			$self->__remove_node($src.$DIRECTORY_SEPARATOR.$name);
			push @$removed, $target;
		}
	}

	$self->{RES}->{'added'} = $added;
	$self->{RES}->{'removed'} = $removed;
}

sub __remove_node{
	my $self = shift;
	my $path = shift;

	if(-f $path){
		unlink($path);
		if($self->{CONF}->{tmbDir}){
			my $filename = _basename($path);
			my $dir = substr($path, 0, -length($filename));
			unlink($dir.$self->{CONF}->{tmbDir}.$DIRECTORY_SEPARATOR.$filename);
		}

	} elsif(-d $path){

		File::Path::rmtree($path);
	}
}

sub _ls{
	my $self = shift;

	if(!$self->{REQUEST}->{'target'}){
		return $self->{RES}->{'error'}.= 'Не задана целевая директория';
	}

	my $path = $self->_hash_api2_decode( $self->{REQUEST}->{'target'} );

	opendir(DIR, $path);
	my @content = grep {!/^\.{1,2}$/} sort readdir(DIR);
	closedir(DIR);

	$self->{RES}->{'list'} = [];
	foreach my $subdir (sort {-f "$path/$a" cmp -f "$path/$b"} @content){

		push @{$self->{RES}->{'list'}},  _basename($subdir);
	}
}

sub _mkfile{
	my $self = shift;

	if(!$self->{REQUEST}->{'target'}){
		return $self->{RES}->{'error'}.= 'Не задана целевая директория';
	}
	my $dstpath = $self->_hash_api2_decode( $self->{REQUEST}->{'target'} );
	my $name = $self->{REQUEST}->{'name'} || 'untitled file.txt';
	$name = $self->{app}->transliteration($name);

	eval{
		open(FILE, ">${dstpath}${DIRECTORY_SEPARATOR}$name") or die("can't open ${dstpath}${DIRECTORY_SEPARATOR}$name: $!");
		flock(FILE, 2);
		binmode(FILE);
		close FILE or die("can't close ${dstpath}${DIRECTORY_SEPARATOR}$name: $!");
		chmod $self->{CONF}->{'fileMode'}, $dstpath.$DIRECTORY_SEPARATOR.$name;
	};

	$self->{RES}->{'added'} = [ { $self->_info($dstpath.$DIRECTORY_SEPARATOR.$name) } ];
}

sub _mkdir{
	my $self = shift;

	if(!$self->{REQUEST}->{'target'}){
		return $self->{RES}->{'error'}.= 'Не задана целевая директория';
	}
	my $dstpath = $self->_hash_api2_decode( $self->{REQUEST}->{'target'} );
	my $name = $self->{REQUEST}->{'name'} || 'new folder';
	$name = $self->{app}->transliteration($name);

	mkdir($dstpath.$DIRECTORY_SEPARATOR.$name, $self->{CONF}->{'dirMode'});

	$self->{RES}->{'added'} = [ { $self->_info($dstpath.$DIRECTORY_SEPARATOR.$name) } ]
}

sub _upload{
	my $self = shift;

	if(!$self->{REQUEST}->{'target'}){
		return $self->{RES}->{'error'}.= 'Не задана целевая директория';
	}

	my $dstpath = $self->_hash_api2_decode( $self->{REQUEST}->{'target'} );

	my $app = $self->{app};

	$self->{RES}->{'added'} = [];
	my @files =$app->req->upload('upload[]');
	foreach my $upload (@files) {
		return $self->{RES}->{'error'} .= 'Размер файла слишком большой' if $app->req->is_limit_exceeded;

		next unless $upload;

		my $filename = $upload->filename;
		$filename = $app->transliteration($filename);
		$upload->move_to($dstpath.$DIRECTORY_SEPARATOR.$filename);

		chmod($dstpath.$DIRECTORY_SEPARATOR.$filename, $self->{CONF}->{'fileMode'});

		if(my $size = $app->get_var('filemanager_max_image_size')){
			$app->resize_pict( fsize => $size, file => $dstpath.$DIRECTORY_SEPARATOR.$filename);
		}
		push @{$self->{RES}->{'added'}}, { $self->_info($dstpath.$DIRECTORY_SEPARATOR.$filename) };
	}
}

sub _search{
	my $self = shift;

	my $path = $self->{CONF}->{'root'};
	my $q = $self->{REQUEST}->{'q'};

	my @Files = ();
	@Files = @{ find($path, $q) } ;

	sub find{
		my $path = shift;
		my $q 	= shift;

		opendir(DIR, $path);
		my @content = grep {!/^\.{1,2}$/} sort readdir(DIR);
		closedir(DIR);

		my $files = [];
		foreach my $node (@content){
			if($node =~ /$q/i){
				push @$files, $path.'/'.$node;
			}

			if(-d $path.'/'.$node and $node ne $self->{CONF}->{tmbDir}){
				@$files = (@$files, @{ find($path.'/'.$node, $q) } );
			}
		}
		return $files;
	}

	my $RES = [];
	foreach (@Files){
		push @$RES, { $self->_info($_) };
	}

	$self->{RES}->{'files'} = $RES;
}

sub _file{
	my $self = shift;

	if(!$self->{REQUEST}->{'target'}){
		return $self->{RES}->{'error'}.= 'Не задана целевая директория';
	}

	my $path = $self->_hash_api2_decode( $self->{REQUEST}->{'target'} );
	my $app = $self->{app};

	$app->file_download(abs_path => $path);
	$self->{rendered} = 1;
}

sub _open
{
	my ($self) = @_;
	my $path = $self->{CONF}->{'root'};
	my $p;

	# try to load dir
	if (exists $self->{REQUEST}->{'target'}){
		$p = _findDir($self, $self->{REQUEST}->{'target'});

		if ('false' eq $p){

			if (! exists $self->{REQUEST}->{'init'}){
				$self->{RES}->{'error'} .= 'Invalid parameters'. $p;


				# очищяем кэш
				$self->dbh->dbh->do("DELETE FROM `sys_filemanager_cache` WHERE TO_DAYS(NOW())-TO_DAYS(`updated`)>$cache_live_time LIMIT 100")
			}
		}
#		elsif (_isAllowed($self, $p, 'read') eq 'false')
#		{
#			if (! exists $self->{REQUEST}->{'init'}) {
#				$self->{RES}->{'error'} .= 'Access denied';
#			}
#		}
		else{
			$path = $p;
		}

	}

	if (exists $self->{REQUEST}->{'current'}){
		$self->{RES}->{'error'} .= $self->{URL}->{current}."<br>"
	}

	#$self->{RES}->{uplMaxSize} = $self->{CONF}->{uplMaxSize};

	_content($self, $path);
}



sub _utime
{
	my ($self) = @_;
	return time().'0';
}


sub _findDir
{
	my ($self, $hash, $path) = @_;
	my $p = 'false';

	if ($path eq '')
	{
		$path = $self->{CONF}->{'root'};
		if ($self->_hash_api2_encode($path) eq $hash)
		{
			return $path;
		}
	}

	opendir( DIR, $path );
	my @content = grep {!/^\.{1,2}$/} sort readdir(DIR);
	#$_ = decode 'UTF-8', $_ for ( @content );
	closedir(DIR);

	foreach my $subdir (grep {-d "$path/$_" } @content)
	{
		next unless $subdir;
		$p = $path.'/'.$subdir;

		if ($self->_hash_api2_encode($p) eq $hash || ($p = _findDir($self, $hash, $p)) ne 'false')
		{
			last;
		}
	}

	return $p;
}


sub _abs_path{
	my $self = shift;
	my $path = shift;

	return $path eq $DIRECTORY_SEPARATOR ? $self->{CONF}{'root'} : $self->{CONF}{'root'}.$path;
}

sub _rel_path{
	my $self = shift;
	my $path = shift;

	return $path eq $self->{CONF}{'root'} ? '' : $DIRECTORY_SEPARATOR.substr($path, length($self->{CONF}{'root'})+1);
}

sub _phash{
	my $self = shift;
	my $path = shift;

	my @myDir = split('/', $path);
	pop @myDir;
	return $self->_hash_api2_encode( join( '/', @myDir) );
}

sub __crypt{
	return shift;
}

sub __uncrypt{
	return shift;
}

sub __has_subdir{
	my $path = shift;

	if (grep -d, glob("$path/*")) {
		return 1;
	}
	return 0;
}


sub _hash_api2_decode{
	my $self = shift;
	my $hash = shift;

	if(substr($hash, 0, length($self->{CONF}->{volume_id})) eq $self->{CONF}->{volume_id}){

		$hash = substr($hash, length($self->{CONF}->{volume_id}) );
		$hash =~ tr{\+\/=}{-_.};
		$hash = b64_decode($hash);
		my $path = __uncrypt( $hash);
		#$path = encode 'UTF-8', $path;

		return $self->_abs_path( $path );
	}
}

sub _hash_api2_encode{
	my $self = shift;
	my $path = shift;
	my $safe = $path;

	if($path){
		$path = encode 'UTF-8', $path;
		$path = $self->_rel_path($path);

		$path ||= $DIRECTORY_SEPARATOR;
		#die $path if ($safe eq '../../userfiles/123');

		my $hash = __crypt($path);

		$hash = b64_encode( $hash );

		$hash =~ tr{\+\/=}{-_.};
		$hash =~ s/[\s\.]+$//;
		$hash =~ s/[\s]+//;
		#die $hash if ($safe eq '../../userfiles/123');
		return $self->{CONF}->{volume_id}.$hash;
	}
}

#use Mojo::ByteStream 'b';
#sub _enc($$) {
#	$_[0] = b($_[0])->encode('UTF-8')->to_string if $_[0];
#	$_[0];
#}

1;
