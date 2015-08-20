package GG::Plugins::Robokassa;

use utf8;

use Mojo::Base 'Mojolicious::Plugin';

use constant DEBUG    => $ENV{GG_ROBOKASSA_BEBUG}    || 0;

my $MRH_URL 	= "https://merchant.roboxchange.com/Index.aspx";

use Digest::MD5 qw(md5_hex);
our $VERSION = '0.02';

sub register {
	my ($self, $app, $conf) = @_;

	my $MRH_LOGIN = $conf->{mrh_login};
	# пароли тестовые
	my $MRH_PASS1 = $conf->{mrh_pass1};
	my $MRH_PASS2 = $conf->{mrh_pass2};

	$app->log->debug("register GG::Plugin::Robokassa");

	$app->helper ( 'robokassa.check_payment' => sub {
		my $self = shift;
		my %params = (
			@_
		);

		my $q = $self->req->params->to_hash;

		my $my_crc = $self->robokassa->params_signature;

		return $my_crc eq uc $q->{SignatureValue} ? 1 : 0;
	});

	$app->helper( 'robokassa.generate_payment_url' => sub {
		my $self = shift;

		my %params = (
			MerchantLogin => $MRH_LOGIN,
			OutSum 				=> 0,
			InvId  				=> 0,
			Shp 					=> {},
			@_
		);

		$params{IsTest} = 1 if DEBUG;

		my $qs = {};

		foreach my $key (keys %params){
			if (ref $params{$key}){
				foreach my $sub (sort keys %{$params{$key}}){
					$qs->{$key.'_'.$sub} = $params{$key}->{$sub};
				}
			}else{
				$qs->{$key} = $params{$key};
			}
		};

		$qs->{SignatureValue} = $self->robokassa->signature_value(%params);

		my @qs = ();

		foreach (sort keys %$qs){
			push @qs, "$_=$$qs{$_}";
		}

		return $MRH_URL.'?'.(join('&', @qs));


	});
	$app->helper( 'robokassa.params_signature' => sub {
		my $self = shift;
		my $params = $self->req->params->to_hash;

		$params->{InvId} =~ s{\D+}{}gi;

		my $str = "$$params{OutSum}:";
		$str .= "$$params{InvId}:" if $params->{InvId};
		$str .= $MRH_PASS2;
		return md5_hex(uc $str);

	});
	$app->helper( 'robokassa.signature_value' => sub {
		my $self = shift;
		my %params = (
			@_
		);
		my $str = "$MRH_LOGIN:$params{OutSum}:";
		$str .= $params{InvId}.':' if $params{InvId};
		$str .= "$MRH_PASS1";

		return md5_hex($str);
	});
}

1;
