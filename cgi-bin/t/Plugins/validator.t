use Mojo::Base -strict;

use Test::More;
use Test::Mojo;
use utf8;
use Encode qw(encode);

my $t = Test::Mojo->new('GG');

my $test_value;
my $valid_value;

# check password digest
$test_value = '1';
#$test_value = encode("utf8", $test_value);
$valid_value = $t->app->check_password_digest( value => $test_value );
ok $t->app->check_password($test_value, $valid_value), "password crypt default with '$test_value'" ;

$test_value = 'привет';
$test_value = encode("utf8", $test_value);
$valid_value = $t->app->check_password_digest( value => $test_value );
ok $t->app->check_password($test_value, $valid_value), "password crypt default with '$test_value'" ;

done_testing();
