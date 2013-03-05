package GG::Admin::Plugins::Fields;

use utf8;

use Mojo::Base 'Mojolicious::Plugin';

our $VERSION = '1';

				
sub register {
	my ( $self, $app, $opts ) = @_;

	$opts ||= {};

	$app->log->debug("register GG::Admin::Plugins::Fields");

	$app->helper(
		field_url_for => sub {
			my $self = shift;
			my %params = @_;
			
			my $value = delete $params{value} || 0;

			 # Check if application has routes
  			my $app = $self->app;
  			return unless $app->can('routes');

			 # Walk and draw
  			my $routes = [];

  			_walk($self, $_, 0, $routes) for @{$app->routes->children};
  			
  			return _draw($self, $routes, $value);
  			
			sub _draw {
			  my ($self, $routes, $value) = @_;
			
			  my $options = '';
			  foreach my $node (@$routes) {
			  	next if (!$node->[1]->pattern->defaults->{admin_name} or !$node->[1]->has_custom_name);
			  	my $route_admin_name = $node->[1]->pattern->defaults->{admin_name}; #$node->[1]->name;
			  	my $route_layout = $node->[1]->pattern->defaults->{layout};
			  	my $route_name = $node->[1]->name;
			  	my $route_alias = $node->[1]->pattern->defaults->{alias} || '';

			  	$options .= "<option data-layout='$route_layout' data-alias='$route_alias' value='$route_name' ".( $value eq $route_name ? " selected='true' " : "").">$route_admin_name</option>";
			  }
			  return $options;
			}
			
			# "I surrender, and volunteer for treason!"
			sub _walk {
			  my ($self, $node, $depth, $routes) = @_;

			  # Pattern
			  my $prefix = '';
			  if (my $i = $depth * 2) { $prefix .= '-' x $i }
			  
			  my $route_url = $node->pattern->pattern || '/';

			  # Пропускаем админские роуты
			  return if ($route_url =~ /^\/admin[\s\S]*/);
			  
			  push @$routes, [$prefix . ($route_url), $node];
			
			  $depth++;
			  _walk($self, $_, $depth, $routes) for @{$node->children};
			  $depth--;
			}
		}
	);
	
	$app->helper(
		field_select_dir => sub {
			my $self = shift;
			my %params = (
				from			=> $self->stash->{list_table},
				parent_field	=> $self->stash->{dir_field},
				parent_id		=> $self->stash->{index},
				lfield			=> $self->send_params->{lfield},
				items			=> 0,
				index			=> 0,
				@_
			);
			my $table = delete $params{from};
			my $parent_field = delete $params{parent_field};
			my $parent_id = delete $params{parent_id};
			
			my $dir = $self->dbi->exists_keys(from => $table, lkey => 'dir') ? " `dir`='1' AND " : "";
			my $order = $self->dbi->exists_keys(from => $table, lkey => 'rating') ? 'rating' : 'ID';
			
			my $dop_where = '';
			$dop_where .= " AND `ID`!='$params{index}'" if ($params{index});

			my $items = $self->getHashSQL(	select	=> "`ID`,`name`".($dir ? ",`dir`" : ""),
											from 	=> $table, 
											where 	=> " $dir `$parent_field`='$parent_id' $dop_where ORDER BY `$order`",
											) || [];

			foreach my $i (0..$#{$items}){
				$items->[$i]->{flag_plus} = 0;
				$items->[$i]->{param_default} = '';
				
				if($dir && $items->[$i]->{dir}){
					$items->[$i]->{flag_plus} = 1;
				
				} elsif(!$dir){
					if($self->dbi->getCountCol( from => $table, where => "`$parent_field`='".$items->[$i]->{ID}."'")){
						$items->[$i]->{flag_plus} = 1;
					} else {
						$items->[$i]->{icon} = 'doc';
					}
				
				} else {
					$items->[$i]->{icon} = 'doc';
				}
			}
			
			$self->param_default(lfield => $params{lfield});
			
			return $items if $params{items};
			
			my $html = $self->render_partial(
									lfield		=> $params{lfield},
									items		=> $items,
									template	=> "Admin/AnketForm/tree_elements_select"
									);
			
			$self->render_json({
					content	=> $html,
					items	=> [
						{
							type		=> 'eval',
							value		=> "treeObj['".$self->stash->{replaceme}.$params{lfield}."'].initTree();",
							
						}
					],
			});
		}
	);

	$app->helper(
		field_upload_swf => sub {
			my $self = shift;
			my %params = (
				lfield			=> $self->stash->{lfield},
				index			=> $self->stash->{index},
				@_
			);

			my $html = $self->render(
									%params,
									template	=> "Admin/AnketForm/pict_uploader"
									);

		}
	);

	$app->helper(
		field_delete_pict => sub {
			my $self = shift;
			my %params = (
					table	=> $self->stash->{dop_table} || $self->stash->{list_table},
					folder	=> '',#$self->stash->{folder},
					fields	=> [qw(folder pict type_file)],
					lfield	=> $self->stash->{lfield},
					index	=> $self->stash->{index},
					@_
			);
			
			$params{folder} ||= $self->lkey(name => $params{lfield}, setting => 'folder' );
			
			my $folder = delete $params{folder};
			my $fields = delete $params{fields};
			my $index = delete $params{index};
			my $lfield	= delete $params{lfield};

			if(my $item = $self->getArraySQL( 	from 	=> $params{table},
												where	=> "`ID`='$index'",
												sys		=> 1)){
				
				$self->file_delete_pict(%params, pict => $item->{ $lfield });
				
				my $clear_fields = {};
				$clear_fields->{$_} = '' foreach (@$fields);		
		
				$self->save_info( table => $params{table}, field_values => $clear_fields);
			}
			
			my $content = $self->render_partial( key => $lfield, lkey => $self->lkey(name => $lfield), template => '/Admin/AnketForm/Reload/field_pict_reload');
			$self->render_json({
					content	=> $content,
					items	=> $self->get_init_items(),
			});
		}
	);

	$app->helper(
		field_delete_file => sub {
			my $self = shift;
			my %params = (
					table	=> $self->stash->{dop_table} || $self->stash->{list_table},
					folder	=> '', #$self->stash->{folder},
					fields	=> [qw(folder docfile type_file)],
					lfield	=> $self->stash->{lfield},
					index	=> $self->stash->{index},
					@_
			);
			
			$params{folder} ||= $self->lkey(name => $params{lfield}, setting => 'folder' );
			
			my $folder = delete $params{folder};
			my $fields = delete $params{fields};
			my $lfield	= delete $params{lfield};
			my $index = delete $params{index};

			if(my $item = $self->getArraySQL( 	from 	=> $params{table},
												where	=> "`ID`='$index'")){
		
		
				my $document_root = $ENV{DOCUMENT_ROOT};

				unlink($document_root.$folder.$item->{$lfield}) if $item->{$lfield};
				
				my $clear_fields = {};
				$clear_fields->{$_} = ''foreach (@$fields);
		
				$self->save_info( table => $params{table}, field_values => $clear_fields);
			}
	
			my $content = $self->render_partial(key => $lfield, lkey => $self->lkey(name => $lfield), template => '/Admin/AnketForm/Reload/field_file_reload');
			$self->render_json({
					content	=> $content,
					items	=> $self->get_init_items(),
			});
		}
	);
	
	$app->helper(
		field_dop_table_reload => sub {
			my $self = shift;
			
			my $controller = $self->param('replaceme');
			$controller = $1 if $controller =~ /^([^_]+)/;

			return unless $self->def_program($controller);
			
			
			$self->stash->{list_table} = $self->param('replaceme');
			$self->stash->{list_table} =~ s{^$controller}{};
			$self->stash->{list_table} =~ s{^_|[\d]+}{}gi;
		
			$self->get_keys( type => ['lkey'], controller => $controller );

			$self->stash->{controller} = $controller;
			
			$self->stash->{group} = $self->lkey(name => $self->stash->{lfield}, setting => 'group', controller => $controller ) || 1;

			
			$self->stash->{not_init} = 1;
			$self->stash->{dop_table_reload} = 1;
			$self->stash->{key} = $self->stash->{lfield};
			$self->stash->{lkey} = $self->lkey( name => $self->stash->{lfield}, controller => $controller );
			$self->stash->{class} = '';
				
			$self->restore_doptable;
			
			$self->define_anket_form( 	access => $self->stash->{access_flag},
										template_dir => "/Admin/AnketForm/",
										template	=> "field_table");

		}
	);

	$app->helper(
		lists_select_search => sub {
			my $self = shift;
			
			my $controller = $self->param('controller') || $self->param('key_program');
			my $lfield = $self->param('lfield');
			$lfield =~ s{^fromselect}{};
			
			$self->get_keys( type => ['lkey'], controller => $controller);
			
			my $replaceme = $self->param('replaceme') || '';

			if(my $rules = $self->param('rules')){
				my $list_table = $self->lkey(name => $lfield, setting => 'list', controller => $controller );

				my $menu = "lstobj[out].options[lstobj[out].options.length] = new Option('----', '');\n";
			
				my $where  = " 1 ";
				my $select = "`ID`,`name`";
				#my $from   = $list_table;
				my (@rules, $field_rules_f1, $field_rules_f2);
				
				return $self->render_text($list_table) unless $list_table;
				
				$rules =~ s/&brvbar;/\|/g;
				(@rules) = split(/\|/, $rules);
				
				#$rules = $rules[0];
				
				my ($from, $field_rules) = split(/\./, $rules[0]);
				($field_rules_f1, $field_rules_f2) = split(/=/, $field_rules);
		
				if ($field_rules_f2 eq "index") {
					$where .= " ".$self->lkey(name => $field_rules_f1, setting => 'rules_where', controller => $controller );
					$where .= " AND `$field_rules_f1`='".$self->stash->{ $field_rules_f2 }."' ";
				
				} else {
		
					$select = "`".$self->lkey(name => $field_rules_f2, setting => 'list', controller => $controller )."`.`ID`,`".$self->lkey(name => $field_rules_f2, setting => 'list' , controller => $controller)."`.`name`";
					$where  = "`$from`.`ID`='".$self->stash->{ $field_rules_f2 }."' GROUP BY `$field_rules_f2`";
					$from   = "`$from` INNER JOIN ".$self->lkey(name => $field_rules_f2, setting => 'list', controller => $controller )." ON `$from`.`$field_rules_f2`=`".$self->lkey(name => $field_rules_f2, setting => 'list', controller => $controller )."`.`ID`";			
				}		

				
				my $flag_sel = 0;

				
				if (my $items = $self->dbi->query("SELECT $select FROM `$from` WHERE $where")->hashes) {
					$menu .= "document.getElementById('ok_${replaceme}' + out).innerHTML = \"<span style='background-color:lightgreen;width:45px;padding:3px'>найдено: ".scalar(@$items)."</span>\";\n";
					foreach my $item (@$items) {
						my $name = _def_name_list_select($item->{name});
			
						$flag_sel = 1 if ($self->stash->{ $field_rules_f2 } && $self->stash->{ $field_rules_f2 } == $item->{ID});
						
						$menu .= "lstobj[out].options[lstobj[out].options.length] = new Option('$name', '$$item{ID}');\n" if $name;
				    }
				    # Если найдена 1 запись делаем ее выбранной 
				    unless($flag_sel){
				    	if(scalar(@$items) == 1){
				    		$flag_sel = 1;
				    		$self->stash->{$lfield} = $items->[0]->{ID};
				    	}
				    }
				} else {
					$menu .= "document.getElementById('ok_${replaceme}' + out).innerHTML = \"<span style='background-color:red;color:yellow;width:45px;padding:3px'>ничего не найдено...</span>\";\n";
				}
			
				if ($flag_sel) {$menu .= "for (j = 0; j < lstobj[out].options.length; j++) { if (lstobj[out].options[j].value == ".$self->stash->{$lfield}.") lstobj[out].options[j].selected = true; }\n";}
			
#				if ($#rules >= 0) {
#					foreach (@rules) {
#						$menu .= "getListOther(out, '$_', '$controller');\n";
#					}
#				}
			
				$self->render_text($menu) 		
			
			
			} elsif(my $keystring = $self->param('keystring')){
			

				my $selected_vals = $self->send_params->{$lfield};
				$selected_vals =~ s{=}{,}gi;
										
				my $list_out = "";# "lstobj[out].options[lstobj[out].options.length] = new Option('----', '');\n";
				my $sch = 0;
				
				my $lkey = $self->lkey(name => $lfield, controller => $controller );
				
				if($lkey){
					my $table = $lkey->{settings}->{list};
					my  $where  = " 1 ";
						$where	.= $lkey->{settings}->{where}." " if $lkey->{settings}->{where};

						$where	.= " AND `ID` NOT IN ($selected_vals) " if ( $selected_vals && ($self->send_params->{multi} or $self->send_params->{mult})); # Исключаем ИД если мультисписок
	   					$where .= " AND `name` LIKE '%$keystring%' ORDER BY `name` LIMIT 0,50";

	   				for my $item ($self->dbi->query("SELECT `ID`,`name` FROM `$table` WHERE $where")->hashes){
	   					my $name = _def_name_list_select($item->{name});
	   					$list_out .= "lstobj[out].options[lstobj[out].options.length] = new Option('$name', '$$item{ID}');\n" if $name;
	   					$sch++;
	   				}
	   				
				}
   				$list_out .= "document.getElementById('ok_' + out).innerHTML = \"<span style='background-color:lightgreen;width:45px;padding:3px'>найдено: ".$sch."</span>\";\n";
				
				$self->render_text($list_out);				
			}
			
						
			sub _def_name_list_select {
				my $name = shift;
		
				$name =~ s/&laquo;/"/;
				$name =~ s/&raquo;/"/;
				$name =~ s/["']+//g;
		
				return $name;
			}
			

		}
	);
}

1;