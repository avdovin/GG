package GG::Plugins::Search;

use utf8;
use Mojo::Base 'Mojolicious::Plugin';
use Encode;

our $VERSION = '0.05';

sub register {
	my ($self, $app, $conf) = @_;


	$app->routes->route("search/result")->to( lang => 'ru', cb => sub{
		my $self   = shift;
		my %params = @_;

		$params{page} = $self->stash('page') || 1;

#        $self->app->sessions_check( $self->session('cck') );
#        $self->session( cck => $self->app->user->{cck});

		my $ksearch = $self->param('qsearch');

		$params{qsearch} = $ksearch;

		my $sch = 0;
		my (%result_search, @result_search_index);
		my ($search_str, $search_base);

		my $hash_table = _config($self);

		$ksearch =~ s/["']+//g;

		foreach my $table (keys %$hash_table) {
			$hash_table->{$table}->{primary_key} ||= [qw(ID)];

			my ($keyFieldSelect) = _buildKeyFieldsSelect( $hash_table->{$table}->{primary_key} );

			my $search = $ksearch;
			   $search =~ s/,/ /g;

			my (@search_str) = ();

			#$self->get_keys( type => ['lkey'], controller => $hash_table->{$table}->{controller} );

			my $dbi = $self->app->dbi;
			foreach my $k (split(/ /, $search)) {
				foreach my $f (@{ $hash_table->{$table}->{searchfields} } ){
					next unless (length($k) > 1);

					push(@search_str, "`$f` LIKE '%$k%'");
				}
			}
			$search_str = join(" OR ", @search_str);

			if($search_str){
				for my $row  ($self->app->dbi->query("SELECT $keyFieldSelect FROM `$table` WHERE $search_str")->hashes){

					$result_search_index[$sch] = {
						table 		=> $table,
						primary_key	=> _buildKeyFieldsValue($hash_table->{$table}->{primary_key}, $row),
						controller  => $hash_table->{$table}->{controller},
					};

					$sch++;
				}
			}
		}

		#my $result_search_index = join("\n", @result_search_index);

		$params{count} = 0;
		$params{total_pages} = 0;

		if ($sch && $ksearch) {

			my $sth_insert = $self->app->dbh->prepare("REPLACE INTO `dtbl_search_results` (`idx`,`qsearch`,`table`,`controller`,`tdate`,`primary_key`) values (?, ?, ?, ?, NOW(), ?)");
			foreach my $i (0..$#result_search_index){
				$sth_insert->execute($i + 1, $ksearch, $result_search_index[$i]->{table}, $result_search_index[$i]->{controller}, $result_search_index[$i]->{primary_key} );
			}
			$sth_insert->finish();

			# $self->app->dbh->do("INSERT INTO `dtbl_search_results` (`qsearch`,`tdate`,`res_search_indx`) values (\"$ksearch\", NOW(), \"$result_search_index\")");
			# $params{index} = $self->app->dbh->{'mysql_insertid'};

			# $self->app->dbh->do("DELETE FROM `dtbl_search_results` WHERE TO_DAYS(NOW()) - TO_DAYS(`tdate`) > 1");
			# $params{found} = 1;
		}
		print_search_result($self, %params);

	})->name('search');

}

sub _buildKeyFieldsSelect{
	my $keyField = shift || [qw(ID)];

	my $keyFieldSelect = join(",", map{ "`$_`" } @$keyField );
	return $keyFieldSelect;
}


sub _buildKeyFieldsValue{
	my $keyField = shift || [qw(ID)];
	my $row = shift;

	return join('_', @$row{ @$keyField } );

}

sub print_search_result{
	my $self = shift;
	my %params = (
		limit 	=> 0,
		qsearch => '',
		index 	=> 0,
		@_
	);

	my $qsearch = $params{qsearch};

	my $search_items = $self->dbi->query("SELECT * FROM `dtbl_search_results` WHERE `qsearch`='$qsearch' ORDER BY `idx`")->hashes || [];

	my $hash_table = _config($self);

	my $result_items = [];

	foreach my $row (@$search_items){
		my $table = $row->{table};

		my @primaryVals = split('_', $row->{primary_key});
		my $whereIndex = '';
		foreach my $i (0..$#primaryVals){
			$whereIndex .= " AND `".$hash_table->{$table}->{primary_key}->[$i]."`='$primaryVals[$i]' ";
		}

		if (my $node = $self->app->dbi->query("SELECT * FROM `$table` WHERE 1 $whereIndex ")->hash) {

			if(my $mapfields = $hash_table->{$table}->{mapfields}){
				$node->{ $mapfields->{$_} } = $node->{ $_ } foreach keys %$mapfields;
			}

			if( $node->{text} ) {
				$node->{text} =~ s/<.*?>//gi;

				if($node->{text} =~ /([\s\S]*)?$qsearch([\s\S]*)?/){
					my $pref = substr($1, -200 );
					my $post = substr($2, 200 );

					$node->{text} = "...".$pref." <b style='font-style:italic;'>".$qsearch."</b> ".$post."...";
				}
				else {
					$node->{text} = $self->cut(string => $node->{text}, size => 1000);
				}
			}
			my $vals = {
				%$node,
				name	=> $node->{name},
				index	=> $row->{idx},
				text	=> $node->{text}
			};

			if($hash_table->{$table}->{route}){
				$vals->{'link'} = $self->url_for($hash_table->{$table}->{route}, %$node);
			}
			elsif(my $linktmlp = $hash_table->{$table}->{linktmlp}){
				while ($linktmlp =~ m/\%([\d\w~]+)\%/ig) {
					my $item = $1;
					my ($type, $val) = split("~", $item);


					if($type =~ /list/){
						$node->{$val} = $self->VALUES( name => $val, value => $node->{$val} ) || '';
					}
					$val = $node->{$val} || "";

					$linktmlp =~ s/\%([\d\w~]+)\%/$val/;
				}
				$vals->{'link'} = $linktmlp;
			}

			push @$result_items, $vals;
		}
	}


	$self->render(
		%params,
		items		=> $result_items,
		template	=> "Search/list"
	);
}


# sub print_search_result{
# 	my $self = shift;
# 	my %params = @_;

# 	$params{limit} ||= 10;

# 	my $index = delete $params{index};
# 	my @result = ();
# 	my $sch = 0;
# 	if($index){
# 		my $qsearch = $params{qsearch};

# 		if(my $search_result = $self->app->dbi->query("SELECT * FROM `dtbl_search_results` WHERE `ID`='$index'")->hash){

# 			my @result_search_index = split(/\n/, $search_result->{res_search_indx});
# 			$params{count} = scalar(@result_search_index);
# 			$params{total_pages}  = int($#result_search_index / $params{limit}) + 1;

# 			my $npage = $params{limit} * ($params{page} - 1);

# 			my $hash_table = _config($self);

# 			foreach my $res (@result_search_index) {
# 				my ($i, $table, $keyFields) = split(/\|/, $res);
# 				#if ($i >= $npage and $i < $npage + $params{limit}) {
# 					# build index

# 					my $keyFieldSelect = _buildKeyFieldsSelect( $hash_table->{$table}->{selectfields} );
# die $keyFields;
# 					my @keysF = split('_', $keyFields);
# 					my $whereIndex = '';
# 					#foreach (split('_', $hash_table->{$table}->{linktmlp})){
# 					#	$whereIndex .= " AND `$keysF[$i]`='$_' ";
# 					#}

# 					# if (my $node = $self->app->dbi->query("SELECT $keyFieldSelect FROM `$table` WHERE 1 $whereIndex")->hash) {

# 					# 	if( $node->{text} ) {
# 					# 		$node->{text} =~ s/<.*?>//gi;

# 					# 		if($find_node->{text} =~ /([\s\S]*)?$qsearch([\s\S]*)?/){
# 					# 			my $pref = substr($1, -200 );
# 					# 			my $post = substr($2, 200 );

# 					# 			$node->{text} = "...".$pref." <b style='font-style:italic;'>".$qsearch."</b> ".$post."...";
# 					# 		}
# 					# 		else {
# 					# 			$node->{text} = $self->cut(string => $node->{text}, size => 1000);
# 					# 		}
# 					# 	}
# 					# 	$sch++
# 					# 	my $vals = {
# 					# 		%$node,
# 					# 		name	=> $node->{name},
# 					# 		index	=> $sch,
# 					# 		text	=> $node->{text}
# 					# 	};

# 					# 	if($hash_table->{$table}->{route}){
# 					# 		$vals->{'link'} = $self->route($hash_table->{$table}->{route}, %$node);
# 					# 	}
# 					# 	elsif(my $linktmlp = $hash_table->{$table}->{linktmlp}){
# 					# 		while ($linktmlp =~ m/\%([\d\w~]+)\%/ig) {
# 					# 			my $item = $1;
# 					# 			my ($type, $val) = split("~", $item);


# 					# 			if($type =~ /list/){
# 					# 				$find_node->{$val} = $self->VALUES( name => $val, value => $node->{$val} ) || '';
# 					# 			}
# 					# 			$val = $node->{$val} || "";

# 					# 			$linktmlp =~ s/\%([\d\w~]+)\%/$val/;
# 					# 		}
# 					# 		$vals->{'link'} = $linktmlp;
# 					# 	}
# 					# 	push @result, $vals;

# 					# 	# $find_node->{text} =~ s/<.*?>//gi;

# 					# 	# Encode::_utf8_on( $find_node->{text} );

# 					# 	# if($find_node->{text} =~ /([\s\S]*)?$qsearch([\s\S]*)?/){
# 					# 	# 	my $pref = substr($1, -200 );
# 					# 	# 	my $post = substr($2, 200 );

# 					# 	# 	$find_node->{text} = "...".$pref." <b style='font-style:italic;'>".$qsearch."</b> ".$post."...";
# 					# 	# }
# 					# 	# else {
# 					# 	# 	$find_node->{text} = $self->cut(string => $find_node->{text}, size => 1000);
# 					# 	# }

# 					# 	# $sch++;
# 					# 	# my $vals = {
# 					# 	# 	%$find_node,
# 					# 	# 	name	=> $find_node->{name},
# 					# 	# 	index	=> $sch,
# 					# 	# 	text	=> $find_node->{text} || $find_node->{name}
# 					# 	# };


# 					# 	# if ($links eq "free") {
# 					# 	# 	if($find_node->{'link'}){
# 					# 	# 		$vals->{'link'} = $find_node->{'link'};
# 					# 	# 	} else {
# 					# 	# 		die $vals->{route};
# 					# 	# 		$vals->{'link'} = $self->url_for($vals->{route}, alias => $find_node->{alias});
# 					# 	# 	}


# 					# 	# } elsif($linktpl){
# 					# 	# 	while ($linktpl =~ m/\%([\d\w~]+)\%/ig) {
# 					# 	# 		my $item = $1;
# 					# 	# 		my ($type, $val) = split("~", $item);


# 					# 	# 		if($type =~ /list/){
# 					# 	# 			$find_node->{$val} = $self->VALUES( name => $val, value => $find_node->{$val}) || '';
# 					# 	# 		}


# 					# 	# 		if($find_node->{$val}) {$val = $find_node->{$val}} else {$val = ""};
# 					# 	# 		$linktpl =~ s/\%([\d\w~]+)\%/$val/;
# 					# 	# 	}

# 					# 	# 	$vals->{'link'} = $linktpl;
# 					# 	# }
# 					# 	#push @result, $vals;
# 					# }
# 				#}
# 			}
# 		}
# 	}

# 	$self->render(	%params,
# 					items		=> \@result,
# 					template	=> "Search/list" );
# }


sub _config{
	my $self = shift;

	my $hash_table = {
		'texts_main_ru' => {
				searchfields 	=> [qw(name text)],
				primary_key 	=> [qw(ID)],
				controller 		=> 'text',
				route 			=> 'text',
				linktmlp 		=> '',
				mapfields 		=> {},
			},
		'texts_news_ru' => {
				searchfields 	=> [qw(name text)],
				primary_key 	=> [qw(ID)],
				controller 		=> 'text',
				route 			=> 'news_item',
				linktmlp 		=> '',
				mapfields 		=> {
					alias 	=> 'list_item_alias',
				},
			},
		'texts_events_ru' => {
				searchfields 	=> [qw(name text)],
				primary_key 	=> [qw(ID)],
				controller 		=> 'text',
				route 			=> 'events_item',
				linktmlp 		=> '',
				mapfields 		=> {
					alias 	=> 'list_item_alias',
				},
			},
		'data_catalog_items' => {
				searchfields 	=> [qw(name article text)],
				primary_key 	=> [qw(sync variantcode)],
				controller 		=> 'catalog',
				route 			=> '',
				linktmlp 		=> '/catalog/item/%s~sync%_%s~variantcode%',
			},
	};

	return $hash_table;
}

# sub def_search_tables {
# 	my $self = shift;

# 	my %hash_table;
# 	foreach my $t ($self->app->dbi->getTablesSQL()) {
# 		if ($t =~ m/^texts_/ ) {
# 			my @keys_search = ();
# 			my @keys_total = $self->app->dbi->getKeysSQL(from => $t);
# 			my @searchkeys = ();

# 			foreach my $k (@keys_total) {
# 				if ($k eq "name") {
# 					$hash_table{$t}{names} = "name";
# 					push(@keys_search, $k);
# 				} elsif ($k eq "text")    { push(@keys_search, $k);
# 				} elsif ($k eq "alias")   { $hash_table{$t}{links} = "free";
# 				} elsif ($k eq "docfile") { $hash_table{$t}{links} = "free";
# 				}
# 			}

# 			if($t eq 'texts_main_ru'){
# 				$hash_table{$t}{route} = 'text';
# 			}
# 			else {
# 				$t =~ m/texts_([\w]+)_[\w]+/;
# 				$hash_table{$t}{route} = $1.'_item';
# 			}
# 			# if (!$hash_table{$t}{links}) {
# 			# 	$t =~ m/texts_([\w]+)_[\w]+/;
# 			# 	$hash_table{$t}{links} = "id:$1";
# 			# }


# 			$hash_table{$t}{fields} = join(",", @keys_search);
# 			$hash_table{$t}{keys}   = join(",", @keys_total);

# 		} elsif($t eq 'data_catalog_items'){
# 			my @keys_search = ();
# 			my @keys_total = $self->app->dbi->getKeysSQL(from => $t);
# 			my @searchkeys = ();

# 			$self->get_keys( type => ['lkey'], controller => 'catalog');

# 			if($t eq 'data_catalog_items'){
# 				@searchkeys = qw(name sync article);
# 				$hash_table{$t}{linktpl} = '/catalog/item/%s~sync%_%s~variantcode%';
# 				$hash_table{$t}{keyField} = [qw(sync variantcode)];
# 			} else{
# 				next;
# 			}

# 			if($hash_table{$t}{linktpl}){
# 				$hash_table{$t}{fields} = join(",", @searchkeys);
# 				$hash_table{$t}{keys}   = join(",", @keys_total);
# 				next;
# 			};
# 		}
# 	}
# 	return (%hash_table);
# } # end of &def_search_tables

1;
