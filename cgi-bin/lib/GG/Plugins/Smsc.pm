package GG::Plugins::Smsc;

use utf8;

#use Digest::MD5;
use URI::Escape;
use Mojo::UserAgent;

use Mojo::Base 'Mojolicious::Plugin';

my 	$FROM		= '';
my 	$LOGIN 		= '';
my 	$PASSWORD 	= '';

sub register {
	my ($self, $app, $conf) = @_;

	$app->helper(
		'smsc.send' => sub{
			my $self = shift;
			my %params = (
				phones		=> '',
				mes			=> '',
				utf			=> 1,
				charset 	=> 'utf-8',
				@_
			);
			my $args = "";

			return 0 unless ($params{phones} || $params{mes});

			foreach (qw(phones mes charset)){
				$args .= "&$_=".uri_escape_utf8($params{$_});
			}

			my $url = "http://smsc.ru/sys/send.php?login=$LOGIN&psw=$PASSWORD&fmt=3".$args;

			my $ua = Mojo::UserAgent->new;
			my $result = $ua->get($url)->res;

			if($result->{error}){
				$self->app->log->error("Smsc Ошибка № $$result{error_code} - ".$result->{error});
				return 0;
			}

			return 1;

		}
	);
}



1;
