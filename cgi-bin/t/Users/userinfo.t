use Test::More;
use Test::Mojo;
use utf8;

no warnings 'experimental::smartmatch';

my $t = Test::Mojo->new('GG');

my $userdata_invalid = {
	email   => time.'@test.ru',
};

my $create_user_valid = {
	firstname 				    => 'Тест',
	lastname 					    => 'Тестов',
	middlename 				    => 'Тестович',
  email 						    => 'rn.dev@ifrog.ru',
	city 							    => 'Санкт-Петербург',
  street                => 'ул. Улица',
  house                 => '1',
  housing               => '1',
  flat                  => '1',
  postcode              => '123456',
	password 					    => '123456',
	password_confirm 	    => '123456',
	phone 						    => '+7 (123) 123-12-12',
  agree_with_conditions => 1,
};

my $update_user_valid = {
	firstname 				    => 'Тест1',
	lastname 					    => 'Тестов2',
	middlename 				    => 'Тестович3',
	city 							    => 'Москва',
  email 						    => 'rn.dev@ifrog.ru',
  street                => 'ул. Улица1',
  house                 => '2',
  housing               => '2',
  flat                  => '2',
  postcode              => '1234567',
	phone 						    => '+7 (123) 123-12-16',
};

my $update_password_invalid = {
	old_password 			=> 'bazfoo',
	password 					=> '123321',
	password_confirm 	=> 'foobar',
};

my $update_password_valid = {
	old_password 			=> '123456',
	password 					=> 'rightpasswd',
	password_confirm 	=> 'rightpasswd',
};

my $update_reminded_password_valid = {
	password 					=> 'remindedpasswd',
	password_confirm 	=> 'remindedpasswd',
};

# check not logged in
$t->get_ok('/')->status_is(200)->text_is('.login__lnk' => 'Войти');

# check reg false
$t->post_ok('/signup' => form => {})
	->status_is(200)
	->json_is('/errors/city' => 'Укажите город')
  ->json_is('/errors/street' => 'Укажите улицу')
  ->json_is('/errors/house' => 'Укажите дом')
  ->json_is('/errors/email' => 'Укажите электронную почту')
  ->json_is('/errors/firstname' => 'Укажите имя')
  ->json_is('/errors/lastname' => 'Укажите фамилию')
  ->json_is('/errors/middlename' => 'Укажите отчество')
  ->json_is('/errors/password' => 'Укажите пароль');

# check reg right
$t->post_ok('/signup' => form => $create_user_valid )
	->status_is(200)
	->json_like('/message_success' => qr/Спасибо/)
	->json_is('/success' => '/')
	->json_hasnt('/errors/global');

# check reg with existing email
$t->post_ok('/signup' => form => $create_user_valid)
	->status_is(200)
	->json_is('/errors/email' => 'Такая электронная почта уже зарегистрирована');

die;
# check user successfully logged in
$t->get_ok('/')
	->status_is(200)
	->text_like('.login__lnk span' => qr/Тест Тестович Тестов/);

# check profile update
$t->put_ok('/users/profile' => form => $update_user_valid)
	->status_is(200)
	->json_is('/message_success' => 'Информация обновлена');

# check all fields updated
my $update_test = $t->get_ok('/users/profile')
	->status_is(200);

foreach ( keys %$update_user_valid ){
	$update_test->element_exists('input[name=' . $_ . '][value="' . $update_user_valid->{ $_ } . '"]');
}

# check password update failed (old password wrong)
$t->put_ok('/users/password' => form => $update_password_invalid)
		->json_like('/errors/old_password' => qr/не верен/);

# check password update failed (password not equal)
$update_password_invalid->{ old_password } = $create_user_valid->{ password };

$t->put_ok('/users/password' => form => $update_password_invalid)
		->json_like('/errors/password_confirm' => qr/не совпадают/);

$t->put_ok('/users/password' => form => $update_password_valid)
		->json_has('/message_success');

# check logout
$t->get_ok('/signout')
	->status_is(302)
	->header_is('Location' => '/');

# check login failed
$t->post_ok('/signin' =>
				form => {
					email 		=> $create_user_valid->{email},
					password 	=> $update_password_invalid->{password},
				})
	->status_is(200)
	->json_has('/errors');

# check login ok
$t->post_ok('/signin' =>
				form => {
					email 		=> $update_user_valid->{email},
					password 	=> $update_password_valid->{password},
				})
	->status_is(200)
	->json_is('/success' => '/')
	->json_like('/result' => qr/Здравствуйте/);

# logout
$t->get_ok('/signout')
	->status_is(302)
	->header_is('Location' => '/');

# check password remind
$t->post_ok('/remind_password' => form => { email => $userdata_invalid->{email} })
	->status_is(200)
	->json_has('/errors/email');

$t->post_ok('/remind_password' => form => { email => $create_user_valid->{email} })
	->status_is(200)
	->json_is('/success' => 1);

$t->app->dbi_connect();
my $cck = $t->app->dbi->query('select cck from data_users where email="'. $update_user_valid->{email} .'"' )->list;
my $remind_url = $t->app->url_for('users_remind', cck => $cck);

$t->get_ok($remind_url)
	->status_is(302)
	->header_is('Location' => '/#remind_password');

$t->get_ok('/')
	->element_exists('input[name=cck][value*=' . $cck . ']');

$update_reminded_password_valid->{ cck } = $cck;

$t->post_ok('/update_reminded_password' => form => $update_reminded_password_valid)
	->status_is(200)
	->json_has('/success')->or( sub { diag $t->app->dumper( $update_reminded_password_valid ) } );

# try login with new values
$t->post_ok('/signin' =>
				form => {
					email 		=> $update_user_valid->{email},
					password 	=> $update_reminded_password_valid->{password},
				})
	->status_is(200)
	->json_is('/success' => '/')->or( sub { diag $t->app->dumper( {
					email 		=> $update_user_valid->{email},
					password 	=> $update_reminded_password_valid->{password},
				} ) } )
	->json_like('/result' => qr/Здравствуйте/);

# clear

$t->app->dbi_connect();
$t->app->dbi->query('delete from data_users where email="'. $update_user_valid->{email} .'"');

done_testing();
