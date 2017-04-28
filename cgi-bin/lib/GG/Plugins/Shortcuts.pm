package GG::Plugins::Shortcuts;

use utf8;

use Mojo::Base 'Mojolicious::Plugin';

sub register {
  my ($self, $app, $opt) = @_;

  $app->routes->add_shortcut(resource => sub {
    my ($r, $name, $controller) = @_;
    $controller ||= $name;
    # Prefix for resource
    my $resource = $r->any("/$name")->to("$name#");

    # Render a list of resources
    $resource->get->to('#index')->name($name);

    # Render a form to create a new resource (submitted to "store")
    $resource->get('/create')->to('#create')->name("create_$name");

    # Store newly created resource (submitted by "create")
    $resource->post->to('#store')->name("store_$name");

    # Render a specific resource
    $resource->get('/:id')->to('#show')->name("show_$name");

    # Render a form to edit a resource (submitted to "update")
    $resource->get('/:id/edit')->to('#edit')->name("edit_$name");

    # Store updated resource (submitted by "edit")
    $resource->put('/:id')->to('#update')->name("update_$name");

    # Remove a resource
    $resource->delete('/:id')->to('#remove')->name("remove_$name");

    return $resource;
  });

  $app->routes->add_shortcut(texts => sub {
    my ($r, $name, $admin_name) = @_;

    my $resource = $r->any("/$name")->to("Texts#");

    $resource->any('/list')->to('#texts_list', admin_name => $admin_name, alias => $name, key_razdel => $name)->name($name."_list");
    $resource->any('/:list_item_alias', [list_item_alias => $app->alias_re])->to('#text_list_item', alias => $name, key_razdel => $name)->name($name."_item");


    return $resource;
  });
}
1;
