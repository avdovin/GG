package GG::Plugins::Crm;

use utf8;

use Mojo::Base 'Mojolicious::Plugin';


use Mojo::Util qw/b64_decode b64_encode/;
use Mojo::JSON;
# JSON serializer
my $JSON = Mojo::JSON->new;


sub register {
	my ($self, $app, $conf) = @_;

	unless (ref($app)->can('crmuser')){
		ref($app)->attr('crmuser');
	}
	unless (ref($app)->can('crmuserdata')){
		ref($app)->attr('crmuserdata');
	}
	
	#$app->plugin('pdf');

 	#$app->sessions->default_expiration(3600*24*7); 
	#$app->sessions->cookie_name("GG");
	#$app->sessions->cookie_path("/");
		
    my %defaults = (
        namespace   => 'GG::Crm',
        controller  => 'crm_controller',
        handler 	=> $conf->{handler},
        cb          => undef,
        layout		=> 'crm',
    );
    
    my $r = $app->routes;

	$r->route('/crm')->to(%defaults, cb => sub {
        my $self = shift;
		
        if($self->crm_auth_check){
			$self->redirect_to('crm_routes', controller => 'users', action => 'list');
        } 
		
   		return $self->render(template	=> "Crm/auth_form", layout => '');
   		
     })->name('crm_login_form');
	

	$r->route('/crm/auth')->to(%defaults, cb => sub {
        my $self = shift;
		
        if($self->crm_auth){

			$self->cookie('crm', $self->app->crmuser->{cck}, {
					path 	=> '/crm/',
					expires	=>  time+360000000
				}
			);

			$self->redirect_to('crm_routes', controller => 'users', action => 'list');
        } else {
			$self->render(template	=> "Crm/auth_form", layout => '');
        }
    });

	my $crm_route = $r->bridge('/crm')->to(%defaults, cb => sub {
        my $self = shift;
	
		unless($self->crm_auth_check){
			return $self->redirect_to('crm_login_form');
		} else {
		
			$self->get_keys( type => ['lkey'], controller => 'crm', no_global => 1);
			
			$self->validate( controller => 'crm' );
		}
		return 1;		
    });
    
    $crm_route->route('/logout')->to(%defaults, cb => sub {
        my $self = shift;
		
		if($self->app->crmuser->{auth}){
			my $user_id = $self->app->crmuser->{ID};
			$self->app->dbh->do("UPDATE `crm_sys_users` SET `cck`='' WHERE `ID`=?", undef, $user_id);
			$self->app->crmuser->{auth} = 0;
		}

		$self->cookie('crm', '', {
				path 	=> '/crm/',
				expires	=>  time-1000
			}
		);
  		
		$self->redirect_to('crm_login_form');
    })->name('crm_logout');

    $crm_route->route('/:controller/:action')->name('crm_routes');

	my $user = {
				email	=> '',
				cck		=> '',
				auth	=> 0,
				check	=> 0
	};
		
	$app->hook(
		before_dispatch => sub {
			my $self = shift;
			
			$self->app->stash->{rndval} = rand();
			
			$self->app->crmuser($user);
			$self->app->crmuserdata({});
			
			$self->app->stash->{message} = {};
			$self->app->stash->{message}->{crm_success} = [];
			$self->app->stash->{message}->{crm_errors} = [];
		}
	);
	$app->hook(
		after_dispatch => sub {
			my $self = shift;
			
			$self->save_crmuserdata;
		}
	);
	
	$app->helper(
		crm_auth_check => sub {
			my $self = shift;
			my %params = @_;
			
			my $cck = $self->cookie('crm');
			return unless $cck;

			if(my $user = $self->app->dbi->query(qq/
				SELECT * FROM `crm_sys_users` 
				WHERE `cck`='$cck' AND `active`='1' 
				/)->hash){
				$user->{auth} = 1;
					
				$self->app->crmuser($user);
				
				$self->app->crmuserdata({});
				if($user->{data}){
					$user->{data} =~ s/\-/\=/g;
					if(my $userData = $JSON->decode(b64_decode $user->{data})){
						$self->app->crmuserdata( $userData );	
					}
				}
				return 1;
			}
			$self->cookie('crm', '', {
					path 	=> '/crm/',
					expires	=>  time-1000
				}
			);
  			
			return;
		}
	);	

	$app->helper(
		crm_auth => sub {
			my $self = shift;
			
			my $email = $self->param('email');
			my $password = $self->param('password');
			
		    $self->crm_msg_errors('Введите Ваш E-mail') unless $email;
			$self->crm_msg_errors('Введите Ваш Пароль') unless $password;
		
			if(my $user = $self->app->dbi->query(qq/
					SELECT * FROM `crm_sys_users` 
					WHERE `email`='$email' AND `password`='$password' AND `active`='1'
					/)->hash){
					
					$user->{auth} = 1;
		
					$self->app->crmuserdata({});
					
					$user->{data} =~ s/\-/\=/g;
					if(my $userData = $JSON->decode(b64_decode $user->{data})){
						$self->app->crmuserdata( $userData );	
					}
					
					my $ip  = $self->tx->remote_address;
					my $vdate = sprintf ("%04d-%02d-%02d %02d:%02d:%02d", (localtime)[5]+1900, (localtime)[4]+1, (localtime)[3], (localtime)[2], (localtime)[1], (localtime)[0]);
					my $cck = $self->defCCK;
					
					$self->app->dbh->do("UPDATE `crm_sys_users` SET `cck`=?, `vdate`=?, count='0', ip=? WHERE `ID`=?", undef, $cck, $vdate, $ip, $$user{ID});
					$user->{cck} = $cck;

					$self->app->crmuser($user);
			} else {
				$self->crm_msg_errors('Ошибка E-mail и/или Пароля');
			}
			
			return $self->app->crmuser->{auth};
		}
	);	

	$app->helper(
		crmuserdata => sub{
			return shift->app->crmuserdata;
		}
	);
	
	$app->helper(
		save_crmuserdata => sub {
			my $self = shift;
			

		    # Serialize
		    my $data = $self->crmuserdata;
		    my $encodeData = b64_encode $JSON->encode($data), '';
    		$encodeData =~ s/\=/\-/g;
			
			my $cck = $self->app->crmuser->{cck};
			
			$self->app->dbh->do("UPDATE `crm_sys_users` SET `data`=? WHERE `cck`=?", undef, $encodeData, $cck);
			return $self->crmuserdata;
		}
	);
			
	$app->helper(
		crm_is_auth => sub {
			shift->app->crmuser->{auth};
		}
	);			
	
	$app->helper(
		crm_has_errors => sub {
			my $self  = shift;
			return $self->stash->{message}->{crm_errors} ? scalar(@{$self->stash->{message}->{crm_errors}}) : 0;
		}	
	);

	$app->helper( crm_msg_nw => sub {
			return shift->crm_msg_no_wrap;
		}	
	);
	
	$app->helper(
		crm_msg_no_wrap => sub {
			my $self  = shift;
			
			$self->stash->{crm_msg_no_wrap} = 1;
			return $self->msg;
		}	
	);
	
	$app->helper(
		crm_msg => sub {
			my $self  = shift;
			
			# проверка флеш сообщения

			if($self->flash('crm_msg_errors')){
				$self->crm_msg_errors($self->flash('crm_msg_errors'));
			} elsif($self->flash('crm_msg_success')){
				$self->crm_msg_success($self->flash('crm_msg_success'));
			}
			
			if($self->stash->{message}->{crm_errors} && scalar(@{ $self->stash->{message}->{crm_errors} })){
				return $self->crm_msg_errors;
			}
			return $self->crm_msg_success;
		}	
	);
		
	$app->helper(
		crm_msg_success => sub {
			my $self  = shift;
			
			if($_[0]){
				push @{$self->stash->{message}->{crm_success}}, $_[0];
			} else {
				my $no_wrap = delete $self->stash->{crm_msg_no_wrap} || 0;
				my $msg = $self->stash->{message}->{crm_success} || [];
				return '' if (scalar(@$msg) == 0);
				
				my 	$msgString  = "<div class='message-success'>" unless $no_wrap;
					$msgString .= join("<br />", @$msg);
					$msgString .= "</div>" unless $no_wrap;
				return $msgString;
			}
		}	
	);
	
	$app->helper( crm_msg_errors_nw => sub {
		return shift->crm_msg_errors_no_wrap;
	});
	
	$app->helper( crm_msg_success_nw => sub {
		return shift->crm_msg_success_no_wrap;
	});
	
	$app->helper( crm_msg_errors_no_wrap => sub {
		my $self = shift;
		$self->stash->{crm_msg_no_wrap} = 1;
		return $self->crm_msg_errors;
	});

	$app->helper( crm_msg_success_no_wrap => sub {
		my $self = shift;
		$self->stash->{crm_msg_no_wrap} = 1;
		return $self->crm_msg_success;
	});
				
	$app->helper(
		crm_msg_errors => sub {
			my $self  = shift;
			
			if($_[0]){
				push @{$self->stash->{message}->{crm_errors}}, $_[0];
			} else { 
				my $msg = $self->stash->{message}->{crm_errors} || [];
				my $no_wrap = delete $self->stash->{crm_msg_no_wrap} || 0;
				return '' if (scalar(@$msg) == 0);
				
				my 	$msgString  = "<div class='message-errors'>" unless $no_wrap;
					$msgString .= join("<br />", @$msg);
					$msgString .= "</div>" unless $no_wrap;
				return $msgString;
			}
		}
	);

	$app->helper(
		is_crm_admin => sub {
			shift->app->crmuser->{users_common_group} == 1 ? 1 : 0;
		}
	);
}

1;
