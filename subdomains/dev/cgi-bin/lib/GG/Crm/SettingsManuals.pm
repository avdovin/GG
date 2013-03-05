package GG::Crm::SettingsManuals;

use warnings;
use strict;
use utf8;

use Mojo::Base 'GG::Crm::Controller';


sub main{
	my $self = shift;
	
	my $manuals = $self->dbi->query("SELECT * FROM `crm_manuals` WHERE 1")->hashes;
	
	$self->render(	manuals		=> $manuals,
					template	=> '/Crm/Settings/manuals_container'
	);
}

sub list_items{
	my $self = shift;
	
	my $manual_id = $self->send_params->{manual_id};
	
	my $manual = $self->dbi->query("SELECT * FROM `crm_manuals` WHERE `ID`='$manual_id'")->hash;


	my $lkeys = $self->lkeys;
	my $keys = [];

	my $vals = {};
	my $items = [];
	if($manual){

		foreach my $k (sort {$$lkeys{$a}{settings}{rating} <=> $$lkeys{$b}{settings}{rating}} keys %$lkeys) {
			next unless $lkeys->{$k}->{settings}->{manuals_edit};
			
			if($self->dbi->exists_keys(from => $$manual{table}, lkey => $k)){
				push @$keys, $k;	
			}
		}
			
		my $where = " 1 ";
		# быстрый поиск
		if($self->send_params->{qsearch}){
			my $qsearch = $self->send_params->{qsearch};
			
			my $wqs;
			foreach (@$keys){
				$wqs .= ($wqs ? " OR " : " ")." `$_` LIKE '%$qsearch%' " ;
			}
			
			$where .= " AND ($wqs) ";
		}
		
		$self->send_params->{'sort_order'} ||= 'asc';
		$self->send_params->{'sort'} ||= '';
		if($self->send_params->{'sort'}){
			$where .= " ORDER BY `".$self->send_params->{'sort'}."` ".$self->send_params->{'sort_order'};
			
		} else {
			$where .= " ORDER BY `ID` ";
		}
		
		$items = $self->dbi->query("SELECT * FROM `$$manual{table}` WHERE $where ")->hashes;
	}
	
	$vals->{html} = $self->render_partial( items => $items, keys => $keys, manual_id => $manual_id, template => "/Crm/Settings/manuals_list_items");
	
	$self->render_json($vals);
}


sub update_list_items{
	my $self = shift;
	my $manual_id = $self->send_params->{manual_id};
	my $delete = $self->send_params->{'delete'};
	
	my $manual = $self->dbi->query("SELECT * FROM `crm_manuals` WHERE `ID`='$manual_id'")->hash;
	my $vals = {
		
	};
	
	$self->stash->{index} = $self->send_params->{item_id} if $self->send_params->{item_id}; 
	if($manual){
		if($delete && $self->stash->{index}){
			
			$self->dbi->dbh->do("DELETE FROM `$$manual{table}` WHERE `ID`='".$self->stash->{index}."'");
			$vals->{success} = 1;
		} else {
			my $lkeys = $self->lkeys;
			my $keys = [];
			foreach my $k (sort {$$lkeys{$a}{settings}{rating} <=> $$lkeys{$b}{settings}{rating}} keys %$lkeys) {
				next unless $lkeys->{$k}->{settings}->{manuals_edit};
				
				if($self->dbi->exists_keys(from => $$manual{table}, lkey => $k)){
					push @$keys, $k;	
				}
					
			}
			my $data = {};
			foreach (@$keys){
				$data->{$_} = $self->send_params->{$_};
			}	
			if($self->save_info( table => $$manual{table}, field_values => {})){
				$vals->{success} = 1;
				$vals->{index} = $self->stash->{index};
			}
		}
	}
	$self->render_json($vals);
}


1;

