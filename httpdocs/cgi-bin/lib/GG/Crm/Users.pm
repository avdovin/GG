package GG::Crm::Users;

use utf8;

use Mojo::Base 'GG::Crm::Controller';

sub edit{
	my $self = shift;
	my $index = $self->send_params->{ID} || '';
	
	my $item = {};

	if($self->req->method eq 'POST'){
		$item = $self->send_params;
		
		# validate
		my $required_fields = {
			name	=> 'Имя ',
			phone	=> 'Телефон',
		};
		
		foreach (keys %$required_fields){
			$self->crm_msg_errors("Не заполнено поле: <b>$$required_fields{$_}</b>") unless $self->send_params->{$_};
		}

		unless($self->crm_has_errors){
			if($index = $self->save_info( table => 'crm_users', field_values => {})){
				$self->crm_msg_success("Данные сохранены ...");
			}
		}
		$self->flash({
			crm_msg_errors => $self->crm_msg_errors_no_wrap,
			crm_msg_success => $self->crm_msg_success_no_wrap,
		});
		
		
		return $self->redirect_to('/crm/users/edit?ID='.$index);
	}

	if($index){
		return $self->render_not_found unless $item = $self->dbi->query("SELECT * FROM `crm_users` WHERE `ID`='$index'")->hash;
		$item =~ s{^\+7}{}gi;
	}

	$self->render(	item		=> $item,
					index		=> $index,
					template	=> 'Crm/Users/edit');		
}

sub list{
	my $self = shift;
	
	$self->_build_where;
	
	$self->stash->{limit} ||= 25;
	$self->stash->{page} ||= 1;
	
	$self->crmuserdata->{limit} = $self->stash->{limit};

	
	$self->render( template => 'Crm/Users/list_container');
}

sub list_items{
	my $self = shift;
	my %params = @_;
	
	my $where = $self->_build_where;
	$where .= $params{where} if $params{where};
	
	$self->stash->{limit} = 100000000 if($self->stash->{limit} eq 'Все');
	
	$self->stash->{limit} ||= 25;
	$self->stash->{page} ||= 1;
	
	$self->crmuserdata->{limit} = $self->stash->{limit};
		
	$self->stash->{total_count} = 0;

	if($self->stash->{limit}){
		my $count = $self->dbi->getCountCol(from => 'crm_users', where => $where);
		$self->stash->{total_count} = $count;
		$self->def_text_interval( total_vals => $count, cur_page => $self->stash->{page}, col_per_page => $self->stash->{limit} );
		$params{npage} = $self->stash->{limit} * ($self->stash->{page} - 1);
		$where .= " LIMIT $params{npage},".$self->stash->{limit};
		$self->stash('count', $count);
	}
	
	my $items = $self->dbi->query(qq~
		SELECT *
		FROM `crm_users`
		WHERE $where
	~)->hashes;

	my $body_items = $self->render_partial( 
											items	=> $items,
											template => 'Crm/Users/list_items');
	
	$self->render_json( {html => $body_items}, status => 200 );
}


sub _build_where{
	my $self = shift;
	
	my $where = "1 ";
	
	my $send_params = $self->send_params;
	
	if($self->param('q') or $self->param('qsearch')){
		my $str = $self->param('q') || $self->param('qsearch');
		
		$where .= " AND (`crm_users`.`name` LIKE '%$str%' OR `crm_users`.`lname` LIKE '%$str%' OR `crm_users`.`phone` LIKE '%$str%' ) ";
		
		$self->crmuserdata->{users}->{qsearch} = $str if $self->param('qsearch');
	}

	my @order_fields = qw(name lname phone);
	my $order = $self->param('order') || $self->crmuserdata->{users}->{order} || "name"; 
	$order = 'name' unless (grep(/^$order$/, @order_fields));
	my $order_type = $self->param('order_type') || 'asc';
	$order_type = 'asc' unless (grep(/^$order_type$/, qw(asc desc)));

	$where .= " ORDER BY `$order` $order_type";
	$self->crmuserdata->{services}->{order} = $order;
	$self->crmuserdata->{services}->{order_type} = $order_type;

	return $where;

}
1;

