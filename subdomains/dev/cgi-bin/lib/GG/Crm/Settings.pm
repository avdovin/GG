package GG::Crm::Settings;

use warnings;
use strict;
use utf8;

use Mojo::Base 'GG::Crm::Controller';


sub users_list{
	my $self = shift;
	
	$self->render( 
					template	=> 'Crm/Settings/users_list_container');

}


sub users_list_items{
	my $self = shift;
	my %params = (
		template => 'Crm/Settings/users_list_items',
		@_,
	);
		
	my $user = $self->app->crmuser;
	
	my $where = " `ID`>0 "; 
	#sys_users_common
	unless($self->is_crm_admin){ # Не администратор
		$where .= " AND `ID`='$$user{ID}' ";
	}

	$self->stash->{limit} = 100000000 if($self->stash->{limit} eq 'Все');
	
	$self->stash->{limit} ||= 25;
	$self->stash->{page} ||= 1;
	
	$self->crmuserdata->{limit} = $self->stash->{limit};
		
	$self->stash->{total_count} = 0;
	if($self->stash->{limit}){
		my $count = $self->dbi->getCountCol(from => 'sys_users_common', where => $where);
		$self->stash->{total_count} = $count;
		$self->def_text_interval( total_vals => $count, cur_page => $self->stash->{page}, col_per_page => $self->stash->{limit} );
		$params{npage} = $self->stash->{limit} * ($self->stash->{page} - 1);
		$where .= " LIMIT $params{npage},".$self->stash->{limit};
		$self->stash('count', $count);
	}
	
		
	my $items = $self->dbi->query("SELECT * FROM `sys_users_common` WHERE $where ")->hashes;

	my $body_items = $self->render_partial( items 		=> $items,
											template => 'Crm/Settings/users_list_items');
	
		
	$self->render_json({ html => $body_items });
}

sub users_edit{
	my $self = shift;
	
	return $self->render_not_found if ($self->app->user->{users_common_group} > 1);
	
	my $index = $self->stash->{index};
	my $user = {};
	
	if($self->req->method eq 'POST'){
		
		my @fields = qw(name email password users_common_group);
		unless($self->is_crm_admin){
			@fields = qw(name email password);
			delete $self->send_params->{users_common_group};
			delete $self->send_params->{id_office};
		}
		
		my $lkeys = $self->app->lkeys;
		foreach (@fields){
			unless( $self->send_params->{$_}){
				#$self->crm_msg_errors('Не заполнено обязательное поле - '.$lkeys->{$_}->{name});
			} else {
				$user->{$_} = $self->send_params->{$_};
			}
		}

		$index = $self->save_info(table => 'sys_users_common', field_values => {active => 1, crm => 1}) unless $self->crm_has_errors;

		unless($index){
			$self->crm_msg_errors("Такой E-mail уже используется");
		} else {
			$self->crm_msg_success("Данные сохранены ...");
		}
		$self->flash({
			crm_msg_errors => $self->crm_msg_errors,
			crm_msg_success => $self->crm_msg_success,
		});
		
		unless ($self->crm_has_errors){
			return $self->redirect_to('crm/settings/users_list');
		} else {
			return $self->redirect_to('/crm/settings/users_edit?index='.$index);
		}
			
	} elsif($self->param('delete')){
		$self->dbi->query("DELETE FROM `sys_users_common` WHERE `ID`='$index'");
		return $self->redirect_to('crm_routes', controller => 'settings', action => 'users_list');
	}
	
	$user = $self->dbi->query("SELECT * FROM `sys_users_common` WHERE `ID`='$index' ")->hash if $index;
	
	$self->render( 	user		=> $user || {},
					template 	=> 'Crm/Settings/users_edit')	
}



1;

