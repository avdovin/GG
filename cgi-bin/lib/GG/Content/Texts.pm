package GG::Content::Texts;

use utf8;
use Mojo::Base 'GG::Content::Controller';

sub redirect_to_first_item {
  my $self = shift;

  return $self->render_not_found unless my $item = $self->m( $self->stash('model') || 'Main' )->get_last();

  $self->redirect_to($self->stash->{key_razdel} . '/' . $item->{alias});
}

sub events_item {
  my $self   = shift;
  my %params = @_;

  return $self->list_item(%params);
}

sub events_arhive_list {
  my $self   = shift;
  my %params = @_;

  $params{where} = " AND `tdate` <= NOW() ";
  $self->stash->{arhive} = 1;

  return $self->texts_list(%params);
}

sub events_list {
  my $self   = shift;
  my %params = @_;

  $params{where} = " AND `tdate` > NOW() ";

  return $self->texts_list(%params);
}

# This action will render a template
sub texts_list {
  my $self   = shift;
  my %params = (
    key_razdel  => $self->stash('key_razdel'),
    date        => $self->stash('date') || "tdate",
    order_desc  => 'desc',
    order_field => $self->stash('date') || "tdate",
    select      => '*',
    page        => $self->stash('page') || 1,
    where       => $self->stash->{'where'} || '',
    lang_tables => defined $self->stash->{'lang_tables'}
    ? $self->stash->{'lang_tables'}
    : 1,
    limit => 0
    ,   # $self->get_var(name => 'news_limit', controller => 'texts', raw => 1),
    model       => ucfirst $self->stash('key_razdel'),
    @_
  );

  my $key_razdel = delete $params{key_razdel};
  my $template = $key_razdel . '_list';

  my $main_page = {};

  if ($self->stash->{alias}) {
    if ( $main_page = $self->m('Main')->get_by_alias( $self->stash->{alias} ) ){
      $self->meta_title($main_page->{title} || $main_page->{name});
      $self->meta_keywords($main_page->{keywords});
      $self->meta_description($main_page->{description});
    }
  }
  # Условия выборки:
  my $where = { viewtext => 1 };

  $where->{"YEAR($params{order_field})"} = $self->param('year') if $self->param('year');

  my %p = (
    where     => $where,
    order     => ( $params{order_field} ? "`$params{order_field}` $params{order_desc} " : ""),
  );

  if ($params{limit}) {
    my $count = $self->m($params{model})->count( $where);
    $self->def_text_interval(
      total_vals   => $count,
      cur_page     => $params{page},
      col_per_page => $params{limit}
    );
    $params{npage} = $params{limit} * ($params{page} - 1);

    $p{offset} = $params{npage};
  }

  my $items = $self->m("$params{model}")->get_list(%p);

  $self->render(template => "texts/$template", items => $items, main_page => $main_page);

}

sub text_main_item {
  my $self  = shift;
  my $alias = $self->stash('alias');


  return $self->render_not_found
    unless my $text = $self->m('Main')->get_by_alias( $self->stash('alias') );

  #AJAX request
  return $self->render(text => $text->{text}) if ($self->req->is_xhr);

  if ($text->{url_for} && $self->stash->{redirect_to_url_for}) {
    my $href = $self->menu_item($text);
    return $self->redirect_to_301($href);
  }

  $self->meta_title($text->{title} || $text->{name});
  $self->meta_keywords($text->{keywords});
  $self->meta_description($text->{description});

  my $template = $self->stash->{template} ||= 'texts/_body_default';
  $self->render(
    item     => $text,
    template => $template,
    layout   => $text->{'layout'} || 'default',
  );
}


sub text_list_item {
  my $self = shift;
  my %params = ( @_ );

  my $alias      = $self->stash('list_item_alias');
  my $template   = "texts/" . $self->stash('key_razdel') . "_item";

  return $self->render_not_found unless my $item = $self->m( ucfirst $self->stash('key_razdel') )->get_by_alias( $self->stash('list_item_alias') );

  if ($self->stash->{alias}) {
    if ( my $textSection = $self->m('Main')->get_by_alias( $self->stash('alias') ) ){
      $self->meta_title($textSection->{title} || $textSection->{name});
    }
  }

  $self->meta_title($item->{title} || $item->{name});
  $self->meta_keywords($item->{keywords});
  $self->meta_description($item->{description});

  $self->render(item => $item, template => $template);
}


1;
