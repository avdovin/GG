package GG::Plugins::Sessions;

use utf8;

use Mojo::Base 'Mojolicious::Plugin';

use Mojo::Util qw/b64_decode b64_encode/;
use Mojo::JSON;

# JSON serializer
my $JSON = Mojo::JSON->new;

my $user = {
			login	=> '',
			cck		=> '',
			ip		=> '',
			host	=> '',
			auth	=> 0,
			check	=> 0
};
	
sub register {
	my ($self, $app, $conf) = @_;

	unless (ref($app)->can('user'))
	{
		ref($app)->attr('user');
	}

	unless (ref($app)->can('userdata'))
	{
		ref($app)->attr('userdata');
	}
		
	$app->sessions->default_expiration(3600*24*7*48); 
	$app->sessions->cookie_name("GG");

	$app->hook(
		before_dispatch => sub {
			my ( $self ) = @_;
			$self->app->user({});
			$self->app->userdata({});
		}
	);

	$app->hook(
		after_dispatch => sub {
			my ( $self ) = @_;
			
			$self->app->user({});
			$self->app->userdata({});
			
			#$self->save_userdata();
		}
	);

	$app->helper(
		userdata => sub{
			return shift->app->userdata;
		}
	);
	
	$app->helper(
		save_userdata => sub {
			my $self = shift;
			
			#my $stored_filter = freeze($self->userdata);
			#b64_encode $stored_filter, '';
			
		    # Serialize
		    my $data = $self->userdata;
		    my $encodeData = b64_encode $JSON->encode($data), '';
    		$encodeData =~ s/\=/\-/g;
			
			my $cck = $self->app->user->{cck};
			
			$self->app->dbh->do("UPDATE `anonymous_session` SET `data`=? WHERE `cck`=?", undef, $encodeData, $cck);
			return $self->userdata;
		}
	);

	
	$app->helper(
		is_auth => sub {
			shift->app->user->{auth};
		}
	);
			
	$app->helper(
		sessions_vars => sub {
			my $self   = shift;
			my %params = @_;
			$params{cck} ||= $self->defCCK;

			my %vars = (	'host'	=> $ENV{'REMOTE_HOST'} || 'empty',
							'ip'	=> $self->tx->remote_address || 'empty',
							'cck'	=> $params{cck}
			);
			return \%vars;
		}
	);

	$app->helper(
		sessions_check => sub {
			my $self   	= shift;
			my $cck		= shift;
			my $vars 	= $self->sessions_vars( cck => $cck);

			return 1 if $self->app->user->{check};
			
			
			if($self->app->dbh->do(qq/
				SELECT * FROM `anonymous_session` 
				WHERE `cck`='$$vars{cck}' AND `ip`='$$vars{ip}' AND `host`='$$vars{host}' 
				/) eq '0E0'){

				$self->app->dbh->do("REPLACE INTO `anonymous_session` (`cck`, `time`, `host`, `ip`) 
									VALUES ('$$vars{cck}', NOW(), '$$vars{host}', '$$vars{ip}')");
													
			} else{
				$self->app->dbh->do("UPDATE `anonymous_session` SET `time`=NOW() WHERE `cck`='$$vars{cck}' AND `ip`='$$vars{ip}' AND `host`='$$vars{host}' ");
				
			}
			
#			if(my $user = $self->dbi->query(qq/
#				SELECT * FROM `sys_users_common` 
#				WHERE `cck`='$$vars{cck}' AND `active`='1' 
#				/)->hash){
#				$user->{auth} = 1;
#				
#				$self->app->user($user);
#			}
			
			my $session = $self->app->dbi->query("SELECT * FROM `anonymous_session` 
			WHERE `cck`='$$vars{cck}' AND `ip`='$$vars{ip}' AND `host`='$$vars{host}' LIMIT 0,1")->hash;
			
			$self->app->user->{cck} = $$vars{cck};
			$self->app->user->{check} = 1;
			
			$self->app->userdata({});
			
			$session->{data} =~ s/\-/\=/g;
			if(my $userData = $JSON->decode(b64_decode $session->{data})){
  				$self->app->userdata($userData);
			}
			
			
			#$self->app->userdata( $session->{data} ? $JSON->decode($session->{data}) : {} );
			#$self->app->userdata( $session->{data} ? thaw($session->{data}) : {} );

			#$self->session( cck	=> $$vars{cck});
			return 1;
		}
	);
}

1;