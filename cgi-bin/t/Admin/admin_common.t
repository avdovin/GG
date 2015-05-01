use Test::More;
use Test::Mojo;
use utf8;

no warnings 'experimental::smartmatch';

my $t = Test::Mojo->new('GG');

my $config = $t->app->plugin('JSONConfig' => {file => 't/tconf.json'});

my $login = $config->{login};
my $pass = $config->{password};
my $false_login = "randvallogin";
my $false_pass = "randvalpassword";

# chech mainpage
$t->get_ok('/admin/')->status_is(200)->text_is('#loading-layout span' => 'Идет загрузка...');

# check getting auth form
$t->post_ok('/admin/form_auth' => form => {rndval => time()})
	->status_is(200)
	->text_is('h1' => 'Авторизация');

# check getting mainframe not auth
$t->get_ok('/admin/main/mainframe')
	->status_is(302)
	->header_is(Location => '/admin');
# check auth false
$t->post_ok('/admin/form_auth' =>
			form =>
				{
					rndval => time(),
					auth => 1,
					userlogin => $false_login,
					authpassword => $false_pass
				})
	->status_is(200)
	->content_like(qr/Пожалуйста, введите верные логин и пароль./);

# # check true auth
$t->post_ok('/admin/form_auth' =>
			form =>
				{
					rndval => time(),
					auth => 1,
					userlogin => $login,
					authpassword => $pass
				})
	->status_is(200)
	->text_is('#replaceme' => 'OK');

# getting mainframe
$t->post_ok('/admin/main/mainpage' => form => {rndval => time()})
	->status_is(200)
	->json_like('/content' => qr/Установленные модули/);
done_testing();