package GG::Plugins::Search;

use strict;
use warnings;
use utf8;

use Mojo::Base 'Mojolicious::Plugin';

our $VERSION = '0.05';

sub register {
	my ($self, $app, $conf) = @_;
	
	
	$app->routes->route("search/result")->to( cb => sub{
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
		
		my %hash_table = def_search_tables($self);

		$ksearch =~ s/["']+//g;
		
		foreach my $table (keys %hash_table) {
			my $search_str  = "MATCH($hash_table{$table}{fields}) AGAINST('\"$ksearch\"' IN BOOLEAN MODE)";
			
			for my $row  ($self->app->dbi->query("SELECT `ID` FROM `$table` WHERE $search_str")->hashes){
				$result_search{$table}{ $row->{ID} } = 1;
				$result_search_index[$sch] = $sch."|".$table."|".$hash_table{$table}{links}."|".$hash_table{$table}{names}."|".$row->{ID}."|".$hash_table{$table}{linktpl};
				$sch++;
			}
			
			my $search = $ksearch;
	   		   $search =~ s/,/ /g;
	   		  
	   		my (@search_str) = ();
	   		my $lkeys = $self->app->lkeys;
	   		my $dbi = $self->app->dbi;
			foreach my $k (split(/ /, $search)) {
				foreach my $f (split(/,/, $hash_table{$table}{fields})) {
					next unless (length($k) > 1);
					my $lkey = $lkeys->{$f}->{settings}->{type};
					
					if($lkey eq 'tlist'){
						my $table = $lkeys->{$f}->{settings}->{list};
						if(my %str = $dbi->query("SELECT `ID` FROM `$table` WHERE `name` LIKE '%$k%'")->map){
							push(@search_str, "`$f` IN (".join(',', keys %str).")");
						}
						
					} else {
						push(@search_str, "`$f` LIKE '%$k%'");	
					}
					
				}
			}
			$search_str = join(" OR ", @search_str);
			
			if($search_str){
				for my $row  ($self->app->dbi->query("SELECT `ID` FROM `$table` WHERE $search_str")->hashes){
					if (!$result_search{$table}{ $row->{ID} }) {
						$result_search{$table}{ $row->{ID} } = 1;
						$result_search_index[$sch] = $sch."|".$table."|".$hash_table{$table}{links}."|".$hash_table{$table}{names}."|".$row->{ID}."|".$hash_table{$table}{linktpl};
						$sch++;
					}
				}
			}
		}
		
		my $result_search_index = join("\n", @result_search_index);
		
		$params{count} = 0;
		$params{total_pages} = 0;
		
		if ($sch && $ksearch) {
			$self->app->dbh->do("INSERT INTO `dtbl_search_results` (`qsearch`,`tdate`,`res_search_indx`) values (\"$ksearch\", NOW(), \"$result_search_index\")");
			$params{index} = $self->app->dbh->{'mysql_insertid'};

			$self->app->dbh->do("DELETE FROM `dtbl_search_results` WHERE TO_DAYS(NOW()) - TO_DAYS(`tdate`) > 1");
			$params{found} = 1;
			
			
		}  	
		print_search_result($self, %params);		
			
	})->name('search');
		
}

sub print_search_result{
	my $self = shift;
	my %params = @_;
	
	$params{limit} ||= 10;
	
	my $index = delete $params{index};
	my @result = ();
	my $sch = 0;
	if($index){
		if(my $search_result = $self->app->dbi->query("SELECT * FROM `dtbl_search_results` WHERE `ID`='$index'")->hash){
			
			my @result_search_index = split(/\n/, $search_result->{res_search_indx});
			$params{count} = scalar(@result_search_index);
			$params{total_pages}  = int($#result_search_index / $params{limit}) + 1;
			
			my $npage = $params{limit} * ($params{page} - 1);
			
			foreach my $res (@result_search_index) {
				my ($i, $table, $links, $name, $indx, $linktpl) = split(/\|/, $res);
				#if ($i >= $npage and $i < $npage + $params{limit}) {
					if (my $find_node = $self->app->dbi->query("SELECT * FROM `$table` WHERE `ID`='$indx'")->hash) {
						
	
						$find_node->{text} =~ s/<.*?>//gi;
	#					next if($$self{text} !~ m/([\s\S]{0,200})($$self{qsearch})([\s\S]{0,200})/i);
	#					$$self{text} = "...$1<span style='font-weight: bold;color:black;'>$2</span>$3...";
						$sch++;
						my $vals = {
							name	=> $find_node->{name},
							index	=> $sch,
							text	=> $find_node->{text} || $find_node->{name}
						};		
	
	
						if ($links eq "free") {
							$vals->{'link'} = $find_node->{'link'} || $find_node->{docfile} || $self->url_for('text', alias => $find_node->{alias});
	
						} elsif($linktpl){
							while ($linktpl =~ m/\%([\d\w~]+)\%/ig) {
								my $item = $1;
								my ($type, $val) = split("~", $item);

						
								if($type =~ /list/){
									$find_node->{$val} = $self->VALUES( name => $val, value => $find_node->{$val}) || '';
								}
								
							
								if($find_node->{$val}) {$val = $find_node->{$val}} else {$val = ""};
								$linktpl =~ s/\%([\d\w~]+)\%/$val/;
							}

							$vals->{'link'} = $linktpl;
						}
						push @result, $vals;
					}
				#}
			}
		}
	}
	
	$self->render(	%params,
					items		=> \@result,
   					template	=> "Search/list" ); 
}


sub def_search_tables {
	my $self = shift;

	my %hash_table;
	foreach my $t ($self->app->dbi->getTablesSQL()) {
		if ($t =~ m/^texts_/  && $t !~ /manual/) {
			my @keys_search = ();
			my @keys_total = $self->app->dbi->getKeysSQL(from => $t);
			my @searchkeys = ();
			
			foreach my $k (@keys_total) {
				if ($k eq "name") {
					$hash_table{$t}{names} = "name";
					push(@keys_search, $k);
				} elsif ($k eq "text")    { push(@keys_search, $k);
				} elsif ($k eq "alias")   { $hash_table{$t}{links} = "free";
				} elsif ($k eq "docfile") { $hash_table{$t}{links} = "free";
				}
			}
			if (!$hash_table{$t}{links}) {
				$t =~ m/texts_([\w]+)_[\w]+/;
				$hash_table{$t}{links} = "id:$1";
			}
			$hash_table{$t}{fields} = join(",", @keys_search);
			$hash_table{$t}{keys}   = join(",", @keys_total);

		} elsif($t =~ m/^data_/  && $t !~ /manual/){
			my @keys_search = ();
			my @keys_total = $self->app->dbi->getKeysSQL(from => $t);
			my @searchkeys = ();
			
			$self->get_keys( type => ['lkey','list'], key_program => 'catalog');
			
			if($t eq 'data_catalog_items'){
				@searchkeys = qw(name gosnomer seats text price);
				$hash_table{$t}{linktpl} = '/catalog/%s~groups%/%s~alias%';
			
			} else{
				next;
			}
			
			if($hash_table{$t}{linktpl}){
				$hash_table{$t}{fields} = join(",", @searchkeys);
				$hash_table{$t}{keys}   = join(",", @keys_total);
				next;				
			};			
		}
	}
	return (%hash_table);
} # end of &def_search_tables

1;
