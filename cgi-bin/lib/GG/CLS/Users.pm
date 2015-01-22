package GG::CLS::Users;
use Mojo::Base -base;

use utf8;

#use Storable qw(freeze thaw);
#use Mojo::Util qw/b64_encode hmac_md5_sum/;

use Mojo::Util qw/b64_decode b64_encode/;
use Mojo::JSON;

has deserialize        => sub { \&Mojo::JSON::j };
has serialize          => sub { \&Mojo::JSON::encode_json };

use base 'Mojo::Base';

# JSON serializer
#my $JSON = Mojo::JSON->new;

__PACKAGE__->attr( userinfo    => sub { shift->{userinfo} }  );
__PACKAGE__->attr( auth		   => sub { shift->{auth} }  );
__PACKAGE__->attr( settings	   => sub { shift->{settings} }  );
__PACKAGE__->attr( ses_settings	   => sub { shift->{ses_settings} }  );
__PACKAGE__->attr( sys		   => sub { shift->{userinfo}->{sys} }  );
__PACKAGE__->attr( access	   => sub { shift->{access} }  );

my $Access = {
	modul	=> {},
	table	=> {},
	lkey	=> {},
	button	=> {},
	menu	=> {}
};

sub new {
	my $class = shift;
	my $args = {
		userinfo	=> {},
		@_
	};

	$args->{userinfo}->{id_group_user} ||= 1;

	my $self = {
		error		=> '',
		settings    => {},
		ses_settings => {},
		userinfo	=>  $args->{userinfo},
		auth		=> 0,
		dbi			=> $args->{dbi},
		access		=> $Access,

		_restored_access => 0,

	};
	bless($self, $class);
	return $self;
}

sub clearAccess{
	shift->{access} = $Access;
}

sub set_settings { # разбор конфига
	my $self   = shift;
	my $settings = shift;

	if ($settings) {
		$settings =~ s/\r//g;
		foreach my $k (split(/\n/, $settings)) {
			$k =~ s/[ ]+$//;
			my ($key, $value) = split(/=/, $k, 2);
			$self -> {settings} -> {$key} = $value;
		}
	}
	#$self->{settings}->{sys}=0 unless($self->{userinfo}->{sys});
}

# сохраняем настройки в сессии
sub save_ses_settings{
	my $self   = shift;
	if (@_ > 0) {
		for (my $i = 0; $i <= $#_; $i += 2) {
			$self->settings->{ $_[$i] } = $self->ses_settings->{ $_[$i] } = $_[$i + 1];
		}
	}
	my $data = $self->settings;
  my $encodeData = b64_encode($self->serialize->($data), '');
  $encodeData =~ y/=/-/;
	#my $encodeData = b64_encode $JSON->encode($data), '';
	#$encodeData =~ s/\=/\-/g;

	$self->{dbi}->{dbh}->do("UPDATE `sys_users_session` SET `data`=? WHERE `id_user`=? AND `cck`=?", undef, $encodeData, $$self{userinfo}{ID}, $$self{userinfo}{cck});
}

sub restore_ses_settings{
	my $self  = shift;
	$self->ses_settings({});

	return unless my $data  = $self->{userinfo}->{session}->{data};

	$data =~ s/\-/\=/;
	if(my $userData = $self->deserialize->(b64_decode $data)){
		$self->ses_settings($userData);

		$self->settings->{$_} = $userData->{$_} foreach (keys %$userData);
	}
}

sub save_settings {
	return shift->save_ses_settings(@_);
	# if (@_ > 0) {
	# 	for (my $i = 0; $i <= $#_; $i += 2) {
	# 		next if ($_ eq 'table');

	# 		$self->settings->{ $_[$i] } = $_[$i + 1];
	# 	}
	# }
	# my (@settings, %settings);

	# foreach (keys %{$$self{settings}}) {
	# 	push(@settings, "$_=$$self{settings}{$_}") if ($$self{settings}{$_} and length($$self{settings}{$_}) > 0 and !exists($settings{$_}));
	# 	$settings{$_} = 1;
	# }
	# my $set_save = join("\n", @settings);

	# return $self->{dbi}->{dbh}->do("UPDATE `sys_users` SET `settings`=? WHERE `ID`=?", undef, $set_save, $$self{userinfo}{ID}) ? 1 : 0;
}

sub check_modul_access {
	my $self   = shift();
	my %params = @_;

	my (@id_group_user, $id_group_user);
	my $user = $self->userinfo;
	push(@id_group_user, "`id_group_user`='$_'") foreach (split(/=/, $user->{id_group_user}));

	$id_group_user = join(" OR ", @id_group_user);

	$self->access({});

	if($user->{sys}){
		my %modul_access = ();
		for my $row  ($self->{dbi}->query("SELECT `ID` FROM `sys_program` WHERE 1")->hashes){
			$modul_access{ $$row{ID} } = 1;
		}
		$self->{access}->{modul} = \%modul_access;

	} else {

		if ($id_group_user) {
			# Проверка правил, где доступ разрешен
			my $sql = "SELECT * FROM `sys_access` WHERE ($id_group_user) AND `r`='1' AND `objecttype`='modul'";

			$self -> check_rules($sql, 0);

			# Исключение правил, где доступ запрещен
			$sql = "SELECT * FROM `sys_access` WHERE ($id_group_user) AND `r`='0' and `objecttype`='modul'";
			$self -> check_rules($sql, 1);
		}

		# проверка наличия правил для данного пользователя |-->
		# Проверка правил, где доступ разрешен
		my $sql = "SELECT * FROM `sys_access` WHERE `users`='$$user{ID}' AND `r`='1' and `objecttype`='modul'";
		$self -> check_rules($sql, 0);
	#
	#	# Исключение правил, где доступ запрещен
		$sql = "SELECT * FROM `sys_access` WHERE `users`='$$user{ID}' and `r`='0' and `objecttype`='modul'";
		$self -> check_rules($sql, 1);

		if ($params{access}) {	# Проверка разрешен ли доступ к конкретному модулю
			$sql = "SELECT `ID` AS `index_modul` FROM `sys_program` WHERE `key_razdel`='$params{access}'";

			my $modul_id = $self->{dbi}->query($sql)->hash;
			return unless($modul_id);

			return if(!exists($self->{access}->{modul}->{$modul_id->{index_modul}}));
		}
	}

	my $moduls = $self->{access}->{modul} || {};

	#foreach (keys %$moduls){
	#	$self->getAccess_by_modul_id( modul_id => $_);
	#}
	$self->store_access;

	return 1;
}


sub store_access{
	my $self   = shift();

	my $access = $self->access || $Access;

	my $encodeData = b64_encode($self->serialize->($access), '');
	$encodeData =~ s/\=/\-/;

	$self->{dbi}->{dbh}->do("UPDATE `sys_users` SET `access`=? WHERE `ID`=?", undef, $encodeData, $self->userinfo->{ID});
	return 1;
}

sub restore_access{
	my $self   = shift();

	return unless my $data = $self->userinfo->{access};

	$data =~ s/\-/\=/;
	if(my $access = $self->deserialize->(b64_decode $data)){

		foreach (keys %$Access){
			if(exists $access->{$_}){
				$self->access->{$_} = $access->{$_};
			}
		}
	}
}


sub getAccess {
	my $self   = shift();
	my %params = @_;

	$self->access->{button} = {};
	$self->access->{lkey} = {};
	$self->access->{table} = {};

	if($self->sys){
		$self -> set_access("table", {
			objectname => join("=", $self->{dbi}->getTablesSQL()),
		});
	}

	my $user = $self->userinfo;

	my (@id_group_user);
	push(@id_group_user, "`sys_access`.`id_group_user`='$_'") foreach (split(/=/, $user->{id_group_user}));

	my $id_group_user = join(" OR ", @id_group_user);

	# Доступ к таблицам
	if ($id_group_user) {
		$params{where} = "($id_group_user OR `users`='$$user{ID}') AND `objecttype`='table'";
	} else {
		$params{where} = "(`users`='$$user{ID}') AND `objecttype`='table'";
	}

	for my $row  ($self->{dbi}->query("SELECT * FROM `sys_access` WHERE `ID`>0 AND $params{where}")->hashes){
		$self -> set_access("table", $row);
	}

	# Проставляем доступ всем пользователям на таблицы sys_*
	unless($self->sys){
		my $sysTables = [];
		foreach ($self->{dbi}->getTablesSQL){
			push @$sysTables, $_ if ( substr($_, 0, 4) eq 'sys_');
		}
		$self->sys(1);
		$self -> set_access("table", {
			objectname	=> 	join('=', @$sysTables)
		});

		$self->sys(0);
	}

	# Доступ к ключам
	if ($id_group_user) {
		$params{where} = "($id_group_user OR `sys_access`.`users`='$$user{ID}') AND `sys_access`.`objecttype`='lkey'";
	} else {
		$params{where} = "(`sys_access`.`users`='$$user{ID}') AND `sys_access`.`objecttype`='lkey'";
	}


	for my $row  ($self->{dbi}->query(qq/
		SELECT `sys_access`.*
		FROM `sys_access` LEFT JOIN `sys_program` ON `sys_access`.`modul`=`sys_program`.`ID`
		WHERE `sys_access`.`ID`>0 AND $params{where} AND `sys_program`.`key_razdel`='$params{modul}'/)->hashes){

		$self -> set_access("lkey", $row);
	}

	# Доступ к кнопкам
	if ($id_group_user) {
		$params{where} = "($id_group_user OR `sys_access`.`users`='$$user{ID}') AND `sys_access`.`objecttype`='button'";
	} else {
		$params{where} = "(`sys_access`.`users`='$$user{ID}') AND `sys_access`.`objecttype`='button'";
	}
	for my $row  ($self->{dbi}->query(qq/
		SELECT `sys_access`.*
		FROM `sys_access` LEFT JOIN `sys_program` ON `sys_access`.`modul`=`sys_program`.`ID`
		WHERE `sys_access`.`ID`>0 AND $params{where} AND `sys_program`.`key_razdel`='$params{modul}'/)->hashes){

		$self -> set_access("button", $row);
	}

	for my $row  ($self->{dbi}->query(qq/
		SELECT `sys_access`.*
		FROM `sys_access` LEFT JOIN `sys_program` ON `sys_access`.`modul`=`sys_program`.`ID`
		WHERE `sys_access`.`ID`>0 AND $params{where} AND `sys_program`.`key_razdel`='global'/)->hashes){

		$self -> set_access("button", $row);
	}

	# Доступ к пунктам меню
	if ($id_group_user) {
		$params{where} = "($id_group_user OR `sys_access`.`users`='$$user{ID}') AND `sys_access`.`objecttype`='menu'";
	} else {
		$params{where} = "(`sys_access`.`users`='$$user{ID}') AND `sys_access`.`objecttype`='menu'";
	}
	for my $row  ($self->{dbi}->query(qq/
		SELECT `sys_access`.*
		FROM `sys_access` LEFT JOIN `sys_program` ON `sys_access`.`modul`=`sys_program`.`ID`
		WHERE `sys_access`.`ID`>0 AND $params{where}/)->hashes){

		$self -> set_access("menu", $row);
	}
}

sub set_access {
	my $self = shift;

	if (@_ == 2) {
		my @keys = ("r", "w", "d");
		my $rule = shift;
		my $row_hashref  = shift;


		my $a;
		foreach (sort keys %$row_hashref) {
			$a .= $row_hashref->{$_} if (defined $row_hashref->{$_} and $_ ne "cck" and $_ ne "objectname" and $_ ne "created_at" and $_ ne "updated_at");
		}

		my $rule_ok = 0;

		if ((defined $a and defined $row_hashref->{cck}) && $self->def_cck_access($a) eq $row_hashref->{cck}) {
			$rule_ok = 1;
		}

		my $user_sys = $self->sys;
		foreach my $obj (split(/=/, $row_hashref->{objectname})) {
			foreach my $k (@keys) {
				if ($rule_ok || $user_sys) {
					$self->access->{$rule}->{$obj}->{$k} = $user_sys ? 1 : $row_hashref->{$k};
				} else {
					$self->access->{$rule}->{$obj}->{$k} = 0;
				}
			}
			$self->access->{$rule}->{$obj}->{w} = 0 unless $self->access->{$rule}->{$obj}->{r};
		}
	} else {
		die "Метод set_access требует двух параметров!";
	}
}


sub check_rules {
	my $self = shift;
	my $sql = shift;
	my $del = shift;

	for my $hash  ($self->{dbi}->query($sql)->hashes){
		my $a;
		foreach my $k (sort keys %$hash){
			$a .= $$hash{$k} if (defined $$hash{$k} and $k ne "cck" and $k ne "objectname" and $k ne "created_at" and $k ne "updated_at");
		}

	#TODO Проверить формирование контрольной сумму (CCK) для прав доступа
#		if ($self -> def_cck_access($a) eq $$hash{cck}) { # проверка контрольной суммы
			foreach (split(/=/, $$hash{objectname})) {
				if ($del) {
					delete $self->access->{modul}->{$_};
				} else {
					$self->access->{modul}->{$_} = 1;
				}
			}
#		}

	}
}

sub def_cck_access {
	my $self = shift;
	my $a 	= shift;

	my $b;
	for my $i(0..length($a)) {$b .= substr($a, length($a)-$i, 1);}

	return crypt($a, $b);
}

1;
