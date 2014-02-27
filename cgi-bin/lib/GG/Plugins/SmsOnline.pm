package GG::Plugins::SmsOnline;

use utf8;

#use Digest::MD5;
use URI::Escape;
use Mojo::UserAgent;

use Mojo::Base 'Mojolicious::Plugin';

my 	$FROM		= '';
my 	$LOGIN 		= '';
my 	$PASSWORD 	= '';
my 	$HTTP		= 'http';	# http / https

my 	$DEBUG		= 1;

my 	$TRANSLIT = 0;		# Переводим или нет СМС в транслит


my $CODES = {
	0 	=> 'Ошибок нет',
	1	=> 'Синтаксическая ошибка в параметрах',
	2	=> 'Ошибка авторизации',
	3	=> 'Системная ошибка',
	4	=> 'Неверное значение параметра',
	5	=> 'Исчерпан баланс sms-сообщений', 
};	

sub register {
	my ($self, $app, $conf) = @_;

	$app->helper(
		sms_send => sub{
			my $self = shift;
			my %params = (
				to		=> '',
				txt		=> '',
				utf		=> 1,
				from	=> $FROM,
				@_
			);
			my $args = "";
			foreach (keys %params){
				$args .= "&$_=".uri_escape_utf8($params{$_});
			}
			
			my $url = $HTTP."://sms.smsonline.ru/mt.cgi?user=${LOGIN}&pass=$PASSWORD".$args;
			die $url;
	
			my $ua = Mojo::UserAgent->new;
			my $dom = $ua->get($url)-->res->dom;
			
			my $result = $dom->at('result')->text;
			if($result ne 'OK'){
				my $code = $dom->at('code')->text;
				$self->app->log->error("SmsOnline Ошибка № $code - ".$CODES->{$code});
				return 0;
			}
			return 1;

		}
	);	
}



1;
