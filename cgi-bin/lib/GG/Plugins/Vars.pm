package GG::Plugins::Vars;

use utf8;

use Mojo::Base 'Mojolicious::Plugin';

sub register {
	my ( $self, $app ) = @_;

	$app->log->debug("register GG::Plugins::Vars");

	unless (ref($app)->can('vars')){
		ref($app)->attr('vars');
	}

	$app->helper( global => sub {
		return shift->get_var(@_);
	});

	$app->helper( get_var => sub {
		my $self = shift;
		my ($varName, $controller, $raw) = ('', '', 0);

		if($_[1]){
			my %params = (
				name		=> '',
				controller 	=> 'global',
				raw			=> 0,
				@_
			);
			$varName 	= delete $params{name};
			$controller = delete $params{controller};
			$raw		= delete $params{raw};
		} else {
			$varName = shift;
			$controller = $self->stash->{controller}
		}


		$controller ||= $self->stash->{controller} || 'global';

		if(my $var = $self->app->vars->{ 'controller_'.$controller }->{$varName}){

			my $varSetting = $self->parse_keys_settings($var->{settings});
			$varSetting->{type} ||= 's';

			if($raw or $varSetting->{type} eq 's' or $varSetting->{type} eq 'd'){
				return $var->{envvalue};
			}

			my $lkey = $self->lkey(
				tmp			=> 1,
				controller  => 'global',
				name		=> 'временный ключ',
				lkey 		=> 'tmp',
				settings	=> $varSetting,
				type		=> $varSetting->{type},
				object		=> 'lkey',
			);

			return $self->VALUES( name => 'tmp', 'values' => $var->{envvalue}, controller => 'global');

		}
		return '';
	});

	$app->helper( setVar => sub {
		my $self = shift;
		my %params = (
			controller	=> 'global',
			key			=> '',
			value		=> 0,
			@_
		);

		return if(!$params{controller} or !$params{key} or !$self->app->vars->{ 'controller_'.$params{controller} }->{ $params{key} });

		my $programId = 0;
		if($params{controller} ne 'global'){
			if(my $program = $self->dbi->query("SELECT `ID` FROM `sys_program` WHERE `key_razdel`='$params{controller}' LIMIT 0,1 ")->hash){
				$programId = $program->{ID};
			}
		}
		$self->dbi->dbh->do("UPDATE `sys_vars` SET `envvalue`='$params{value}' WHERE `envkey`='$params{key}' AND `id_program`='$programId' ");

		$self->app->vars->{ 'controller_'.$params{controller} }->{ $params{key} }->{envvalue} = $params{value};
	});


	$app->hook( before_dispatch => sub {
		return _loadVars(shift);
	});
}

sub _loadVars{
	my $self = shift;


	unless($self->app->vars){
		$self->app->vars({});

		for my $row  ($self->app->dbi->query(qq/
			SELECT `sys_vars`.*,  `sys_program`.`key_razdel`
			FROM `sys_vars`
			LEFT JOIN `sys_program`
				ON `sys_program`.`ID`=`sys_vars`.`id_program`
			WHERE 1/)->hashes ){

			my $controller = $row->{key_razdel} || 'global';
			$self->app->vars->{ 'controller_'.$controller } ||= {};
			$self->app->vars->{ 'controller_'.$controller }->{ $row->{envkey} } = GG::Plugins::Vars::Var->new( $row );
		}
	}
}

1;

package GG::Plugins::Vars::Var;

sub new {
	my $class = shift;
	my $args = shift;

	my $self = {
		envkey  	=> $args->{envkey} || undef,
		name    	=> $args->{name} || undef,
		types   	=> $args->{types} || "s",
		envvalue	=> $args->{envvalue} || '',
		settings	=> $args->{settings} || '',
		id_program 	=> $args->{id_program} || 0,
		comment		=> $args->{comment} || undef,
	};

	bless($self, $class);
	return $self;
}

sub value{
	return shift->{envvalue};
}


1;
