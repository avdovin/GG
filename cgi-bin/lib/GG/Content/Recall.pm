package GG::Content::Recall;

use utf8;

use Mojo::Base 'GG::Content::Controller';

sub list {
  my $self   = shift;
  my %params = (
    limit => $self->get_var(name => 'recall_limit', controller => 'recall')
						|| 10,
    page => $self->param('page') || 1,
    @_
  );

  my $where = " `active`='1' ORDER BY `updated_at` DESC ";

  if ($params{limit}) {
    my $count = $self->dbi->getCountCol(from => 'data_recall', where => $where);
    $self->def_text_interval(
      total_vals   => $count,
      cur_page     => $params{page},
      col_per_page => $params{limit}
    );
    $params{npage} = $params{limit} * ($params{page} - 1);
    $where .= " LIMIT $params{npage},$params{limit} ";
  }

  my $items
    = $self->dbi->query("SELECT * FROM `data_recall` WHERE $where")->hashes;

  return $self->render_not_found
    unless my $item
    = $self->dbi->query("SELECT * FROM `texts_main_"
      . $self->lang
      . "` WHERE `alias`='recall' AND `viewtext`=1")->hash;

  $self->stash->{'recall_form_errors'} = {};

  # Добавление нового отзыва
  if ($self->req->method eq 'POST') {

    # Check CSRF token
    my $validation = $self->validation;
    return $self->render(text => 'Bad CSRF token!', status => 403)
      if $validation->csrf_protect->has_error('csrf_token');

    my $send_params = $self->req->params->to_hash;

    $self->get_keys(type => ['lkey'], no_global => 1, controller => 'recall');

    my $lkeys = $self->app->lkeys->{recall};

    foreach (keys %$lkeys) {
      if ($lkeys->{$_}->{settings}->{obligatory}) {
        my $lkey = $lkeys->{$_}->{lkey};

        if ($send_params->{$lkey}) {
          $self->stash->{$lkey} = $send_params->{$lkey} || '';

        }
        elsif ($lkeys->{$_}->{settings}->{obligatory} && !$send_params->{$lkey})
        {
          $self->flash->{'recall_form_errors'}->{$lkey} = 1;
        }
      }
    }

    if (!keys %{$self->flash->{'recall_form_errors'}}) {

      $self->dbi->insert_hash(
        'data_recall',
        {
          name     => $self->stash->{'name'},
          email    => $self->stash->{'email'},
          question => $self->check_string(value => $self->stash->{'recall'}),
          active   => 0,
        }
      );
      $self->flash->{recall_success} = 1;
      my $email_body = $self->render_mail(template => "Recall/_admin");

      eval {
        $self->mail(
          to => $self->get_var(
            name       => 'email_admin',
            controller => 'global',
            raw        => 1
          ),
          ,
          subject => 'Получен новый отзыв с сайта '
            . $self->site_name,
          data => $email_body,
        );
      };

    }
  }

  $self->render(items => $items, item => $item, template => 'Recall/list',);
}

1;
