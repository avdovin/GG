package GG::Plugins::ContentCommon;

use Mojo::Base 'Mojolicious::Plugin';

use utf8;

sub register {
  my ($self, $app, $opts) = @_;

  $opts ||= {};

  $app->log->debug("register GG::Plugin::Content");

  $app->helper(
    'content_common.news_list' => sub {
      my $self = shift;
      my %params = (page => 1, @_);

      my $where = " `viewtext`='1' ";
      if (my $year = $self->param('year')) {
        if ($year =~ /\-/) {
          my ($y1, $y2) = split('-', $year);
          $where .= " AND (YEAR(tdate)>=$y1 AND YEAR(tdate)<=$y2) ";
        }
        else {
          $where .= " AND YEAR(tdate)='$year' ";
        }

      }
      $where .= " ORDER BY `tdate` DESC ";

      my $dbTable = 'texts_news_' . $self->lang;

      if ($params{limit}) {
        my $count = $self->dbi->getCountCol(from => $dbTable, where => $where);
        $self->def_text_interval(
          total_vals   => $count,
          cur_page     => $params{page},
          col_per_page => $params{limit}
        );
        $params{npage} = $params{limit} * ($params{page} - 1);
        $where .= " LIMIT $params{npage},$params{limit} ";
      }

      my $items = $self->app->dbi->query("
			SELECT *
			FROM `$dbTable`
			WHERE $where
		")->hashes;

      return $self->render_to_string(
        items    => $items,
        template => 'texts/_news_list_items',
      );
    }
  );

  $app->helper(
    'content_common.news_anons' => sub {
      my $self   = shift;
      my %params = @_;

      my $dbTable = 'texts_news_' . $self->lang;
      my $items
        = $self->app->dbi->query(
        "SELECT * FROM `$dbTable` WHERE `viewtext`='1' ORDER BY `tdate` DESC LIMIT 0,2"
        )->hashes;

      return $self->render_to_string(
        items    => $items,
        template => 'texts/news_anons',
      );
    }
  );

}
1;
