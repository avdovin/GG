package GG::Plugins::Bitrix;

use utf8;

use Mojo::Base 'Mojolicious::Plugin';
use Mojo::UserAgent;

my $BITRIX_LOGIN    = '';
my $BITRIX_PASSWORD = '';
my $BITRIX_COMPANY  = 'ifrog';

sub register {
  my ($self, $app, $conf) = @_;

  $app->helper(
    'bitrix.crm_add_lead' => sub {
      my $self   = shift;
      my %params = @_;

      return unless my $title = delete $params{'TITLE'};

      my $ua = Mojo::UserAgent->new;
      my $url
        = 'https://'
        . $BITRIX_COMPANY
        . '.bitrix24.ru/crm/configs/import/lead.php';

      my $tx = $ua->post(
        $url => form => {
          LOGIN      => $BITRIX_LOGIN,
          PASSWORD   => $BITRIX_PASSWORD,
          TITLE      => $title,
          EMAIL_WORK => $params->{email},
          PHONE_WORK => $params->{phone},
          %params
        }
      );

      my $response = $tx->res->json;

      if(my $response = $tx->res->json){
        if ($response->{error_message}) {
          $self->stash->{'bitrix.error_message'} = $response->{error_message};
          return;
        }
        return $response->{ID};
      }
      else {
        $self->stash->{'bitrix.error_message'} = $tx->res->body;
      }
      return;
    }
  );
}
1;
