package GG::Plugins::Keys;

use Mojo::Base 'Mojolicious::Plugin';

use utf8;

use Mojo::Cache;

use List::Util 'first';

our $VERSION = '0.05';

my $cache = Mojo::Cache->new(max_keys => 50);

sub register {
	my ( $self, $app, $args ) = @_;

	$args ||= {};

	$app->plugin('validator');

	unless (ref($app)->can('buttons')){
		ref($app)->attr('buttons');
		$app->buttons( {} );
	}
	unless (ref($app)->can('lkeys')){
		ref($app)->attr('lkeys');
		$app->lkeys( {} );
	}

	$app->helper( buttons => sub {
		return shift->app->buttons;
	});

	$app->helper( lkeys => sub {
		return shift->app->lkeys;
	});

#	unless (ref($app)->can('lists')){
#		ref($app)->attr('lists');
#		$app->lists( {} );
#	}

	$app->helper(
		# name - имя переменной
		# split - разделитель для списка
		# values - масив значений переменной

		VALUES => sub {
			my $self   	= shift;
			my $params 	= ref $_[0] ? $_[0] : {@_};

			return unless $$params{'name'};

			my $name = $$params{'name'};
			my $type = $$params{'type'};
			my $param = $$params{'param'} || 'name';
			my $controller = lc(delete $$params{'controller'} || $self->stash->{controller});


			return unless my $lkey = $self->lkey(name => $name, controller => $controller);

			$type ||= $lkey->{settings}->{type} || return '';
			#return unless $type;

			my $values //= $$params{'value'};
			   $values //= $$params{'values'};
			   $values //= [];

			my $values_split = $$params{'value_split'} || $$params{'values_split'} || "=";

			if(ref($values) ne 'ARRAY'){
				$_ = $values;
				$values = [];
				@$values = split($values_split, $_);
			}

			if($type eq 'user'){
				my $result = $$params{param} ?  $self->app->sysuser->settings->{$name} : $self->app->sysuser->userinfo->{$name};
				$result = 'checked' if $$params{chbox};
				return $result;

			} elsif($type eq 'env'){

				return $self->req->env->{$name} || '';

			} elsif($type =~ /list/){
				$self->def_list( name => $name, controller => $controller);

				my $attr = {
					split 	=> '<br />',
					name	=> 'name',
					%{$params},
				};

				if(my $listRef = $lkey->{list}){
					my @vals = ();
					foreach (@$values){
						push @vals, $listRef->{$_} if $listRef->{$_};
					}
					return join($$attr{split}, @vals);
				}
				return;

			} elsif($type eq 'chb'){
				return $values->[0] && $values->[0] == 1 ? $lkey->{settings}->{yes} : $lkey->{settings}->{no};

			} else {
				return join(' ', @$values);
			}

			return "VALUES type '$type' for name '$name' not supported ";
		}
	);

	$app->helper(
		LIST => sub {
			my $self   	= shift;
			my $params 	= ref $_[0] ? $_[0] : {@_};

			return if !$self->app->lkeys;

			my $name = delete $$params{'name'};
			my $type = delete $$params{'type'};
			my $controller = lc(delete $$params{'controller'} || $self->stash->{controller});

			my $values //= $$params{'value'};
			   $values //= $$params{'values'};
			   $values //= [];

			return unless my $lkey = $self->lkey(name => $name, controller => $controller);

			my $values_split = delete $$params{value_split} || "=";
			my $setting =  $lkey->{settings};
			my $replaceme = $self->stash->{replaceme} || '';

			if(ref($values) ne 'ARRAY'){
				$_ = $values;
				$values = [];
				@$values = split($values_split, $_);
			}

			$type ||= $lkey->{settings}->{list_type} || 'select';

			my $required = $$params{required} || $setting->{required} ? " required " : "";
			my $list_delimetr = $$params{delimetr} || $setting->{list_delimetr} || '<br />';
			my $list_style = $$params{style} || $setting->{list_style} || '';
			my $list_class = $$params{class} || $setting->{list_class} || '';

			$self->def_list( name => $name, controller => $controller);

			my $list = $lkey->{list} || {};
			my $list_labels = $lkey->{list_labels} || [];


			my $backup = {};
			if($$params{onlyindex}){
				$backup->{$_}  = $list->{$_} foreach (keys %{$list});
				if($$params{onlyindex} == -1){
					delete $list->{$_} foreach (@$values);
				} elsif($$params{onlyindex} == 1){
					foreach my $k (keys %{$list}){
						delete $list->{$k} unless(grep(/^$k$/, @$values));
					}
				}
			}
			push @$values, 0 if(!scalar(@$values) and !$lkey->{settings}->{notnull});

			my $code = "";

			if($type eq 'select'){

				$code .= "<select name='$name' $list_style $list_class id='$name' $required>" unless $params->{option};

				foreach my $k (@$list_labels){
					next unless $list->{$k};

					my $selected = (defined first { $k eq $_ } @$values) ? " selected='selected' " : "";
					#my $selected = ( grep(/^$k$/, @$values ) or (!$k and !scalar(@$values)) ) ? "selected='selected'" : "";
					$code .= "<option value='".($k || '')."' $selected>".$list->{$k}."</option>";
				}

				$code .= "</select>" unless $params->{option};

			} elsif($type eq 'checkbox'){

				foreach my $k (@$list_labels){
					next unless $list->{$k};

					#my $selected = ( grep(/^$k$/, @$values ) or (!$k and !scalar(@$values)) ) ? "checked='checked'" : "";
					my $selected = (defined first { $k eq $_ } @$values) ? " checked='checked' " : "";
					$code .= "<input value='$k' name='$name' id='${replaceme}${name}_$k' $list_style type='checkbox' $list_class $required class='checkbox' $selected><label for='${replaceme}${name}_$k' ".($replaceme ? 'style=\'float:none;cursor:pointer;\'' : '')."'>".$list->{$k}."</label>";
					$code .= $list_delimetr
				}

			} elsif($type eq 'radio'){
				foreach my $k (@$list_labels){
					next unless $list->{$k};
					#my $selected = ( grep(/^$k$/, @$values ) or (!$k and !scalar(@$values)) ) ? "checked='checked'" : "";
					my $selected = (defined first { $k eq $_ } @$values) ? " checked='checked' " : "";
					$code .= "<input value='$k' name='$name' $list_style type='radio' id='${replaceme}${name}_$k' $list_class $required $selected><label for='${replaceme}${name}_$k' ".($replaceme ? 'style=\'float:none;cursor:pointer;\'' : '')."'>".$list->{$k}." </label>";;
					$code .= $list_delimetr
				}

			} else {
				return "LIST type '$type' for name '$name' not supported ";
			}

			$lkey->{list} = $backup if $$params{onlyindex};
			return $code;
		}
	);

	$app->helper(
		def_list => sub {
			my $self 	= shift;
			my $args 	= ref $_[0] ? $_[0] : {@_};

			return unless my $lkey = $self->lkey(name => $args->{name}, controller => $args->{controller});
			return if $lkey->{list};


			my $list = $lkey->{settings}->{list} || '';
			my $type = $lkey->{settings}->{type} || 's';
			my $list_vals = {};
			if($type eq 'list'){

				foreach my $l (split(/~/, $list)) {
					my ($key, $value) = split(/\|/, $l);
					$list_vals->{$key} = $value;
				}

			} elsif($type eq 'tlist'){
				my $where = $lkey->{settings}->{where} || '';
				$where = $self->render( inline => $where, partial => 1 ) if $where;

				eval{
					$list_vals = $self->app->dbi->query(qq/
						SELECT `ID`,`name`
						FROM `$list`
						WHERE 1 $where
					/)->map;
				};

				$app->log->error("Error read lkey list '$$args{name}': $@") && return if $@;
			}

			$lkey->{list} = $list_vals;

			$self->_def_list_labels($lkey);
		}
	);

	$app->helper(
		_def_list_labels => sub {
			my $self = shift;
			my $lkey = shift;

			my $list_vals = $lkey->{list} || {};
			my $sort = $lkey->{settings}->{list_sort} || 0;
			my $labels = [];
			# Сортировка по значению
			if($sort eq 'asc_d'){
				push @$labels, $_ foreach sort {$a <=> $b} keys %$list_vals;
			} elsif($sort eq 'asc_s'){
				push @$labels, $_ foreach sort {$a cmp $b} keys %$list_vals;
			} elsif($sort eq 'desc_d'){
				push @$labels, $_ foreach sort {$b cmp $a} keys %$list_vals;
			} elsif($sort eq 'desc_s'){
				push @$labels, $_ foreach sort {$b cmp $a} keys %$list_vals;
			} else {
				push @$labels, $_ foreach sort {$list_vals->{$a} cmp $list_vals->{$b}} keys %$list_vals;
			}

			if(!$list_vals->{0} and (defined $lkey->{settings}->{notnull} && $lkey->{settings}->{notnull} == 0) || not defined $lkey->{settings}->{notnull}){
				my $null_value = $lkey->{settings}->{nullvalue} || "------";
				unshift @$labels, 0;
				$lkey->{list}->{'0'} = $null_value;
			}

			$lkey->{list_labels} = $labels;
		}
	);

	$app->helper(
		get_keys => sub {
			my $self         = shift;
			my %params	  = (
				validator	=> 1,
				controller	=> '',
				key_program	=> '',
				no_global	=> 0,
				type		=> [],
				@_
			);

			$params{controller} ||= $params{key_program};

			my $type 	  		= delete $params{type};
			my $keys_table 	= 'keys_'.$params{controller} ;
			#my $use_cache = $self->app->get_var('cache_keys');


			my $app = $self->app;
			#my $cached = 0;
			#my $cached_global = 0;

			if( !$params{no_global} &&
				$self->app->lkeys->{ '_cached_global_'.$params{controller} } &&
				$self->app->lkeys->{ '_cached_'.$params{controller} }
				){
				$self->validate( controller => $params{controller} ) if $params{validator};
				return 1;

			} elsif( $params{no_global} && $self->app->lkeys->{ '_cached_'.$params{controller} } ){

				$self->validate( controller => $params{controller} ) if $params{validator};
				return 1;
			}

			unless($params{no_global}){
				if( my $rows = $app->dbi->query("SELECT * FROM `keys_global` WHERE 1")->hashes){
					_parseLkeys(
						app			=> $app,
						controller 	=> $params{controller},
						lkeys		=> $rows,
					);
					_parseLkeys(
						app			=> $app,
						controller 	=> 'global',
						lkeys		=> $rows,
					);
				}

				$self->app->lkeys->{ '_cached_global_'.$params{controller} } = 1;
			}

			if($keys_table){
				if( my $rows = $app->dbi->query("SELECT * FROM `$keys_table` WHERE 1")->hashes){
					_parseLkeys(
						app			=> $app,
						controller 	=> $params{controller},
						lkeys		=> $rows,
					);
				}
				$self->app->lkeys->{ '_cached_'.$params{controller} } = 1;
			}

			$self->validate( controller => $params{controller} ) if $params{validator};
		}
	);

	$app->helper(
		parse_keys_settings => sub {
			my $self         = shift;
			my $settings_result = {};

			foreach my $settings (@_){

				map {
					my ( $k, $v ) = split( "=", $_, 2);
					$k =~ s/\s*//g;
					$settings_result->{$k} = $v;
				} split( "\n", $settings );
			}
			return $settings_result;

		}
	);

	$app->helper(
		button => sub {
			my $self   		= shift;
			my $args 		= ref $_[0] ? $_[0] : {@_};

			my $lkeyName = $args->{name};
			my $controller = $args->{controller} || $self->stash->{controller} || return '';

			return $self->app->buttons->{$controller} unless $lkeyName;

			if($self->app->buttons->{$controller}->{$lkeyName}){
				if($args->{setting}){
					$self->app->buttons->{$controller}->{$lkeyName}->{ $args->{setting} } || '';
				} else {
					$self->app->buttons->{$controller}->{$lkeyName};
				}
			}

		}
	);

	$app->helper(
		lkey => sub {
			my $self   		= shift;
			my $args 		= ref $_[0] ? $_[0] : {@_};

			my $lkeyName = $args->{name};
			my $controller = $args->{controller} || $self->stash->{controller} || return '';
			my $lkeys = $self->app->lkeys;

			if(delete $args->{'tmp'}){
		 		return $self->app->lkeys->{'global'}->{'tmp'} = Lkey->new( {
					name     => $lkeyName || 'временный ключ',
					lkey     => $args->{'lkey'} || 'tmp',
					object   => 'lkey',
					tbl		 => '',
					settings => $args->{settings},
					type	 => $args->{type} || $args->{settings}->{type} || 's',
					group	 => 1,
					access	 => {
						r	=> 1,
						w	=> 0,
						d	=> 0,
					}
				});

			}

			return $self->app->lkeys->{$controller} unless $lkeyName;

			if($self->app->lkeys->{$controller}->{$lkeyName}){
				if(my $list_table = $args->{'tbl'} || $self->stash->{list_table}){

					my $lkey = ($lkeys->{$controller}->{_tbl}->{$list_table} &&
								$lkeys->{$controller}->{_tbl}->{$list_table}->{$lkeyName}) ?
								$lkeys->{$controller}->{_tbl}->{$list_table}->{$lkeyName} :
								$lkeys->{$controller}->{$lkeyName};


					if($args->{setting}){
						if($lkey->{ $args->{setting} } ){
							return $lkey->{ $args->{setting} } ;

						} elsif($lkey->{settings}->{ $args->{setting} } ){
							return $lkey->{settings}->{ $args->{setting} }
						}
						return '';
					}

					return $lkey

				} else {
					if($args->{setting}){

						if($lkeys->{$controller}->{$lkeyName}->{$args->{setting}}){
							return $lkeys->{$controller}->{$lkeyName}->{$args->{setting}};

						} elsif($lkeys->{$controller}->{$lkeyName}->{settings}->{ $args->{setting} }){
							return $lkeys->{$controller}->{$lkeyName}->{settings}->{ $args->{setting} }
						}
						return '';

					} else {
						return $lkeys->{$controller}->{$lkeyName};
					}
				}
			}
			return $args->{setting} ? "" : {};

		}
	);

	$app->helper(
		merge_keys_settings => sub {
			my $self         = shift;
			my $settings_result = {};

			foreach my $settings (@_){
				$settings_result->{$_} = $settings->{$_} foreach (keys %$settings);
			}
			return $settings_result;

		}
	);
}

#sub restore_keys{
#	my 	$self	= shift;
#	my	$keys_table	= shift;
#
#	my $app = $self->app;
#	#my $tmp = $self->stash->{'_get_keys'}->{$keys_table};
#	my $tmp = $cache->get('keys_'.$keys_table);
#
#	warn "restore keys: $keys_table";
#
##	use Data::Dumper;
##	warn Dumper($tmp->{buttons});
##
#	$app->buttons($tmp->{buttons});
#	$app->lkeys($tmp->{lkeys});
#	#$app->lists($tmp->{lists});
#	return 1;
#}

#sub store_keys{
#	my 	$self	= shift;
#	my	$keys_table	= shift;
#
#	my $app = $self->app;
#	my $vals = {
#		buttons => $app->buttons,
#		lkeys	=> $app->lkeys,
#		#lists	=> $app->lists
##	};
##
##	warn "store keys: $keys_table";
##	$cache->set('keys_'.$keys_table => $vals);
##
##	#$self->stash->{'_get_keys'}->{$keys_table} = $vals;
##}

sub _parseLkeys{
	my %params  = @_;

	my $app = delete $params{app};
	my $controller = delete $params{controller};
	my $lkeys 	= delete $params{lkeys};

	unless($app->buttons->{$controller}){
		$app->buttons->{$controller} = {};
	}
	unless($app->lkeys->{$controller}){
		$app->lkeys->{$controller} = {};
		$app->lkeys->{$controller}->{_tbl} = {};
	}

	foreach my $dbKey (@$lkeys){

		my $lkey = _parseLkeySettings($dbKey);

		if($lkey->{object} eq 'lkey'){

			$lkey = Lkey->new( $lkey );
			$lkey->access->{r} = 1;

			if($lkey->{tbl}){
				$app->lkeys->{$controller}->{_tbl}->{$lkey->{tbl}}->{$lkey->{lkey}} = $lkey

			} else {

				$app->lkeys->{$controller}->{$lkey->{lkey}} = $lkey;
			}



		} elsif($lkey->{object} eq 'button'){
			my $button = Button->new( $lkey );
			$button->access->{r} = 1;
			$app->buttons->{$controller}->{$lkey->{lkey}} = $button;

		}
	}

	#$app->buttons($buttons_exist);
	#$app->lkeys($lkeys_exist);
	#$app->lists($lists_exist);
}

sub _parseLkeySettings{
	my $dbKey = shift;

	my $settings = $dbKey->{settings};
	$settings =~ s/\r//g;

	my @settings_strings = split( "\n", $settings );
	my $settings_hash = {
		rating	=> 99,
		type	=> 's',
	};

	map {
		my ( $k, $v ) = split( "=", $_, 2);
		$k =~ s/\s*//g;
		$settings_hash->{$k} = $v;
	} @settings_strings;

	return {
		name     => $dbKey->{name},
		lkey     => $dbKey->{lkey},
		object   => $dbKey->{object},
		tbl		 => $dbKey->{tbl},
		settings => $settings_hash,
		type	 => $settings_hash->{type} || 's',
		group	 => $settings_hash->{group} || 1,
	 };
}

1;

package Lkey;

use utf8;
use base 'Mojo::Base';

__PACKAGE__->attr( access	=> sub { shift->{access} }  );

sub new {
	my $class = shift;
	my $args  = shift || {};

	my $self = {
		tbl      => undef,
		lkey     => undef,
		name     => undef,
		type     => "s",
		filter   => 0,
		group	 => 1,
		#rating   => 99,
		object   => "lkey",
		settings => {
			type	=> 's',
		},
		access	 => {
						d	=> 0,
						r	=> 0,
						w	=> 0
		},
		%{$args}
	};
	bless($self, $class);
	return $self;
}

1;

package Button;

use strict;
use warnings;
use utf8;

use base 'Mojo::Base';

__PACKAGE__->attr( access	=> sub { shift->{access} }  );

sub new {
	my $class = shift;
	my $args  = shift || {};

	my $self = {
		lkey   	 => undef,
		name   	 => undef,
		image	 => undef,
		program	 => undef,
		action	 => undef,
		#rating 	 => 99,
		object 	 => "button",
		settings => {},
		code	 => undef,
		imageicon	=> '',
		access	 => {
						d	=> 0,
						r	=> 0,
						w	=> 0
		},
		stash	=> {},
		%{$args}
	};
	bless($self, $class);
	return $self;
}


sub button_item_json{
	my $self   = shift;
	my $vals = {
		type			=> 'additembutton',
		menubarkey		=> 'button',
		id				=> $$self{ID}, #sprintf("%03d%03d", rand('999'), rand('999') ),
		itemtext		=> $$self{name},
		itemicon		=> $$self{settings}->{imageiconmenu},
		helptext		=> $$self{settings}->{title},
		jsfunction		=> $$self{settings}->{script}
	};
	return $vals;
}

sub def_icons { # Определение кнопки типа "Icons"
	my $self   = shift();


	$$self{settings}->{imageicon} ||= "/admin/img/icons/menu/icon_no.gif";

	$self -> def_params_button();
	$self -> def_script_button();
}

sub def_params_button { # определение параметров
	my $self   = shift;
	my $stash   = shift;

	my %params = @_;

	my (@params);

	my $settings = $$self{settings};

	if ($settings->{params}) {
		foreach my $p (split(/,/, $settings->{params})) {
			push(@params, "$p=".$stash->{$p}) if ($p && $stash->{$p});
		}
	}

	$settings->{controller} ||= $stash->{controller};
	$$self{params_string} = join("&", @params) || '';
	#$settings->{params_string} = join("&", @params) || '';
	#$settings->{controller} ||= $settings->{modul} || 'undef';
	$settings->{action} ||= $settings->{'do'} || 'undef';
	$settings->{controller} ||= '';

	$settings->{program} = '/admin/'.$settings->{controller}.'/body?do='.$settings->{action};

	$$self{settings} = $settings;
}

sub def_script_button { # определение скрипта выполнения
	my $self   = shift();
	my $stash   = shift;

	my %params = @_;
	no warnings;

	my $settings = $$self{settings};
	if (!$settings->{type_link}) {
		$settings->{script} = "doNothing()";
	} else {

		     if ($settings->{type_link} eq "openurl") {
				$settings->{script} = "open_url('$$settings{program}?$$settings{params_string}')";

		} elsif ($settings->{type_link} eq "openlink") {
				$settings->{script} = "openNewWin($$settings{width}, $$settings{height}, '$$settings{program}', '$$self{params_string}', '$$settings{ID}')";

		} elsif ($settings->{type_link} eq "modullink") {
				$settings->{script} = "displayMessage('$$settings{program}&$$self{params_string}', $$settings{width}, $$settings{height}, $$settings{level})";

		} elsif ($settings->{type_link} eq "loadcontent") {
				my $replaceme = $settings->{replaceme} || $stash->{replaceme} || '';

				$settings->{program}	  ||= $stash->{script_link};

				if ($settings->{confirm}) {
					$settings->{script} = "if (confirm('$$settings{confirm}')) ld_content('$replaceme','$$settings{program}&$$self{params_string}')";
				} else {
					$settings->{script} = "ld_content('$replaceme','$$settings{program}&$$self{params_string}')";
				}

		} elsif ($settings->{type_link} eq "javascript") {
				$settings->{script} = $$self{settings}{function};

		} elsif ($settings->{type_link} eq "openpage") {
				$settings->{position} ||= "center";
				$settings->{id}		 ||= $$self{replaceme};
				$$self{title}    ||= $$self{settings}{id};
				$$self{tabtitle} ||= $$self{settings}{id};
				if ($settings->{confirm}) {
					$settings->{script} = "if (confirm('$$settings{confirm}')) openPage('$$settings{position}','$$settings{id}','$$settings{program}?$$settings{params_string}','$$settings{title}','$$settings{tabtitle}')";
				} else {
					$settings->{script} = "openPage('$$settings{position}','$$settings{id}','$$settings{program}?$$settings{params_string}','$$settings{title}','$$settings{tabtitle}')";
				}
		}
	}
	use warnings;
	$$self{settings} = $settings;
}


1;

