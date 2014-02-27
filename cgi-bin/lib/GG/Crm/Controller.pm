package GG::Crm::Controller;

use utf8;

use Mojo::Base 'GG::Controller';

sub save_info{
	my $self = shift;
	my %params = (
		send_params	=> 1,
		insType		=> 'INSERT',
		where		=> '',
		@_
	);
	
	my $table = delete $params{table};
	my $field_values = delete $params{field_values} || {};
	my $where	= delete $params{where} || '';
	
	foreach (keys %$field_values){
		unless($self->dbi->exists_keys(from => $table, lkey => $_)){
			delete $field_values->{$_};
		}
	}

	if($params{send_params}){
		my $send_params = $self->send_params;
		foreach (keys %$send_params){
			if($self->dbi->exists_keys(from => $table, lkey => $_)){
				$field_values->{$_} ||= $send_params->{$_}; 
			}			
		}
	}
	

	if(!$self->stash->{index}){
		
		return $self->dbi->insert_hash($table, $field_values, $params{insType});
	} else {
		$where ||= "`ID`='".$self->stash->{index}."'";
		$self->dbi->update_hash($table, $field_values, $where, $params{where});
		return $self->stash->{index};
	}
}


1;

