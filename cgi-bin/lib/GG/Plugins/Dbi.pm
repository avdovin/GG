package GG::Plugins::Dbi;

use Mojo::Base 'Mojolicious::Plugin';

use GG::Dbi;

our $VERSION = '0.033';

sub register {
	my ($self, $app, $args) = @_;
	$args ||= {};

	unless (ref($app)->can('dbi')) {
		ref($app)->attr('dbi');
		ref($app)->attr('dbh');
		ref($app)->attr('_dbh_requests_counter' => 0);

		#$self->helper( dbi => sub { shift->dbi(@_));
	}

	my $max_requests_per_connection = $args->{requests_per_connection} || 100;

	$app->hook(
		before_dispatch => sub {
			shift->dbi_connect(@_);
		}
	);

	$app->helper( dbi => sub {
		return shift->app->dbi;
	});

	$app->helper( dbh => sub {
		return shift->app->dbi->dbh;
	});

	$app->helper(
		dbi_connect => sub {
			my ($self) = @_;
			my $dbi;
			if ($args->{dbi}) {

				#external dbi
				$dbi = $args->{dbi};
			}
			elsif ( $self->app->dbh
				and $self->app->_dbh_requests_counter
				< $max_requests_per_connection
				and _check_connected($self->app->dbh))
			{
				$dbi = $self->app->dbh;
				$self->app->log->debug(
					"use cached DB connection, requests served: "
					  . $self->app->_dbh_requests_counter);
				$self->app->_dbh_requests_counter(
					$self->app->_dbh_requests_counter + 1);
			}

			else {

        		#make new connection
        		$self->app->log->debug("start new DB connection to DB $args->{dsn}");

				$dbi = GG::Dbi->connect(
					'DBI:mysql:'
					  . $args->{db_name} . ':'
					  . $args->{db_host},    # DSN
					$args->{db_user},
					$args->{db_password},    # Username and password
					{

						# Additional options
						PrintError        => 1,    # warn() on errors
						RaiseError        => 0,    # don't die on error
						AutoCommit        => 1,
						mysql_enable_utf8 => 1,
					}
				);
				unless ($dbi) {
					my $err_msg =
					  "DB connect error. 'DBI:mysql:$args->{db_name}:$args->{db_host}, $args->{db_user}, $args->{db_password}, error: $DBI::errstr";
					$self->app->log->error($err_msg);

					# Render exception template
					$self->render(
						status    => 500,
						format    => 'html',
						template  => 'exception',
						exception => $err_msg
					);
					$self->stash(rendered => 1);
					return;
				}
				$dbi->lc_columns = 0;    					# Lower Case column

				$dbi->dbh->do("SET NAMES utf8");
				$self->app->dbi($dbi);
				$self->app->dbh($dbi->dbh);
				$self->app->_dbh_requests_counter(1);

				# clear config access params
				#delete $self->stash->{config}->{$_} foreach (qw(db_host db_name db_password db_user));
			}
	});

	unless ($args->{db_no_disconnect}) {
	    $app->plugins->on(
	      after_dispatch => sub {
	        my $self = shift;
	        $self->app->dbh(0);
	        $self->app->dbi(0);
	        $self->app->_dbh_requests_counter(0);
	        if ($self->app->dbh) {

	         	$self->app->dbh->disconnect
	            or $self->app->log->error("Disconnect error $DBI::errstr");
	        }
	        $self->app->log->debug("disconnect from DB");
	      }
	    );
	}

#	$app->hook(
#		after_dispatch => sub {
#			my ($self) = @_;
#			$self->app->dbi->disconnect
#			  or $self->app->log->error("Disconnect error $DBI::errstr");
#			$self->app->log->debug("disconnect from DB $args->{db_name}");
#		}
#	);
}

sub _check_connected {
	my $dbh = shift;
	return unless $dbh;
	local $dbh->{RaiseError} = 1;    # be on the safe side
	return $dbh->ping();
}

1;
