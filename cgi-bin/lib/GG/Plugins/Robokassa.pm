package GG::Plugins::Robokassa;

use utf8;

use Mojo::Base 'Mojolicious::Plugin';


my $mrh_login = "tis";
my $mrh_pass1 = "kAdCJMa49d";
my $mrh_pass2 = "etFWgJR69Qi";

use Digest::MD5 qw(md5_hex);


sub register {
	my ($self, $app, $conf) = @_;

	$app->helper( robokassa_mrh_login => sub {
		return $mrh_login;
	});

	$app->helper( robokassa_chech_payment => sub {
		my $self = shift;
		my %params = (
			@_
		);

		my $q = $self->req->params->to_hash;

		# считывание параметров
		# read parameters
		$q->{SignatureValue} =~ s/([a-z])/uc "$1"/eg;   # force uppercase
		$q->{InvId} =~ s{\D+}{}gi;

		# формирование подписи
		# generate signature

		#return $self->render( text => "$$q{OutSum}:$$q{InvId}:$mrh_pass2:Shp_item=$$q{Shp_item}" );

		my $my_crc = md5_hex("$$q{OutSum}:$$q{InvId}:$mrh_pass2:Shp_item=$$q{Shp_item}");
		$my_crc =~ s/([a-z])/uc "$1"/eg;   # force uppercase

		my $is_correct = ($my_crc eq $q->{SignatureValue} ? 1 : 0);

		unless($is_correct){
			return;
			#return $self->render( text => 'incorrect sign passed' );
		}

		return 1;
	});

	$app->helper( robokassa_build_signaturevalue => sub {
		my $self = shift;
		my %params = (
			OutSum 		=> 0,
			InvId 		=> 0,
			Shp_item 	=> 1,
			@_
		);

		return md5_hex("$mrh_login:$params{OutSum}:$params{InvId}:$mrh_pass1:Shp_item=$params{Shp_item}");
	});

	$app->helper( robokassa_build_send_params => sub {
		my $self = shift;
		my %params = (
			OutSum 		=> 0,
			InvId 		=> 0,
			Shp_item 	=> 1,
			Desc 		=> '',
			AddParams 	=> {},
			@_
		);

		my $SignatureValue = md5_hex("$mrh_login:$params{OutSum}:$params{InvId}:$mrh_pass1:Shp_item=$params{Shp_item}");

		my $HTML = qq{
			<input type=hidden name=MrchLogin value="$mrh_login">
			<input type=hidden name=OutSum value="$params{OutSum}">
			<input type=hidden name=InvId value="$params{InvId}">
			<input type=hidden name=Desc value="$params{Desc}">
			<input type=hidden name=SignatureValue value="$SignatureValue">
			<input type=hidden name=Shp_item value="$params{Shp_item}">
			<input type=hidden name=IncCurrLabel value="">
			<input type=hidden name=Culture value="ru">

			<input type=submit class="button button-blue button-right" value="Оплатить заказ">
		};

		return $HTML;
	});
}

1;