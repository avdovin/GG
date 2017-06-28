package GG::Plugins::RSS;

use utf8;

use Mojo::Base 'Mojolicious::Plugin';

sub register {
  my ($self, $app, $conf) = @_;

  $app->log->debug("register ".__PACKAGE__);

  $app->routes->route("rss.xml")->to(
    cb => sub {
      my $self = shift;

      my $CONFIG = {
        'news_item' => {
          'title'        => 'name',
          'table'        => 'texts_news_ru',
          'placeholders' => {'list_item_alias' => 'alias'},
          'where'        => " `viewtext`='1' ",
          'description'  => "description"
        }
      };

      my $host = $self->host;
      my $nodes;
      foreach my $route (keys %$CONFIG) {
        my $routeConfig = $CONFIG->{$route};

        my @placeholders;
        foreach (keys %{$routeConfig->{placeholders}}) {
          push @placeholders, $routeConfig->{placeholders}->{$_};
        }
        my $fields_str = join(",", @placeholders);
        $fields_str .= ',' . $fields_str if $fields_str;

        for my $row (
          $self->app->dbi->query(
            "SELECT `name`,`text`, DATE_FORMAT(  `tdate` ,  '%a, %e %b %Y %H:%i:%s +0400' ) AS `tdate`, $fields_str FROM `$$routeConfig{table}` WHERE "
              . $routeConfig->{where}
          )->hashes
          )
        {

          my $url_vals = {};

          foreach (keys %{$routeConfig->{placeholders}}) {
            $url_vals->{$_} = $row->{$routeConfig->{placeholders}->{$_}};
          }

          my $url = 'http://' . $host . $self->url_for($route, %$url_vals);


          $nodes .= $self->render_to_string(
            node     => $row,
            url      => $url,
            template => 'Plugins/RSS/node',
            format   => 'xml',
          );

        }
      }

      $self->render(
        nodes    => $nodes,
        template => 'Plugins/RSS/rss',
        format   => 'xml'
      );
    }
  );
}

1;
