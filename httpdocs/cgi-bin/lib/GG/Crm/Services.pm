package GG::Crm::Services;

use warnings;
use strict;
use utf8;

use Mojo::Base 'GG::Crm::Controller';

use Date::Calc qw(Add_Delta_Days);

sub _generate_contract_number{
	my $self = shift;
	
	my ($day, $month, $year) = ((localtime)[3], (localtime)[4]+1, (localtime)[5]+1900);  
	my $year_last_number = (split("", $year))[3];
	require Date::Calc;
	
	my $week_number = sprintf("%02d", Date::Calc::Week_Number($year, $month, $day)); 
	my $day_of_week = Date::Calc::Day_of_Week($year, $month, $day);
	
	#my @rand = (1..9);
	#my $rand = int(rand(@rand));

	my $id_office = $self->app->crmuser->{id_office} || 0;
	my $number = $year_last_number.$week_number.$day_of_week.'-'.$id_office;

	my $last_number = 1;
	if(my $item = $self->dbi->query("SELECT `contract` FROM `crm_data_users` WHERE `contract` LIKE '$number%' ORDER BY `rdate` DESC")->hash){
		if ($item->{contract} =~ /$number([\d]+)$/){
			$last_number = $1;
			$last_number++;
		}
		
	}
	$last_number = sprintf("%02d", $last_number );
	
	$number .= $last_number;
	return $number;
}

sub pdf{
	my $self = shift;
	my $index = $self->send_params->{ID};

	my $services = [];
	my $services_payments = [];

	my $item = $self->dbi->query("SELECT * FROM `crm_data_users` WHERE `ID`='$index'")->hash;
	
	my $payment_first = $self->dbi->query("SELECT * FROM `crm_dtbl_payments` WHERE `id_crm_user`='$index' ORDER BY `rdate` DESC LIMIT 0,1")->hash;
	my $sum = $self->dbi->query("SELECT SUM(price) AS `totalprice`, SUM(dolg) AS `totaldolg` FROM `crm_data_services` WHERE `id_crm_user`='$index'")->hash;
	
	my $office = $self->dbi->query("SELECT * FROM `crm_lst_office` WHERE `ID`='".$self->app->crmuser->{id_office}."'")->hash;
	$self->render(
					layout	=> '',
					sum	=> $sum,
					office	=> $office,
					item	=> $item,
					payment_first	=> $payment_first,
					template => 'Crm/Services/Pdf'
					)	
}

sub delete{
	my $self = shift;
	my $index = $self->send_params->{ID};
	
	my $exist = $self->dbi->query("SELECT * FROM `crm_data_services` WHERE `ID`='$index'")->hash;
	
	if($exist && $self->dbh->do("DELETE FROM `crm_data_services` WHERE `ID`='$index'")){
		$self->flash({crm_msg_success => "Услуга успешна удалена"});
	} else {
		$self->flash({crm_msg_errors => "Ошибка удаления услуги"});
	}
	
	$self->redirect_to('/crm/services/list');
}

sub save_service_payment{
	my $self = shift;	
	my $delete = $self->send_params->{'delete'};
	
	my ($id_data_services, $rdate) = split('_', $self->send_params->{payment_id});
	$self->send_params->{id_data_services} = $id_data_services;
	
	my $send_params = $self->send_params;
	my $vals = {};
	
	if($id_data_services){
		if($delete && $rdate){
		
			$self->dbi->dbh->do("DELETE FROM `crm_dtbl_payments` WHERE `rdatestr`='$rdate' AND `id_data_services`='$id_data_services'");
		
		# Обновление записи
		} elsif($rdate){
			
			$self->update_hash("crm_dtbl_payments", {price => $send_params->{price}, id_payments_names => $send_params->{id_payments_names} }, "`id_data_services`='$id_data_services' AND `rdatestr`='$rdate'");
			
			my $values = $self->dbi->query("SELECT * FROM `crm_data_services` WHERE `ID`='$id_data_services'")->hash;
			my $services_payments = $self->dbi->query("SELECT * FROM `crm_dtbl_payments` WHERE `id_data_services`='$id_data_services' ORDER BY `rdate`")->hashes;
			$self->stash->{services_payments} = $services_payments;
			$vals->{html} = $self->render_partial( template => 'Crm/Services/edit_services_item', service => $values);
				
		} else {
			#rdatestr
			my $rdatestr = sprintf ("%04d%02d%02d%02d%02d%02d", (localtime)[5]+1900, (localtime)[4]+1, (localtime)[3], (localtime)[2], (localtime)[1], (localtime)[0]);
			my $rdate = sprintf ("%04d-%02d-%02d %02d:%02d:%02d", (localtime)[5]+1900, (localtime)[4]+1, (localtime)[3], (localtime)[2], (localtime)[1], (localtime)[0]);
			$self->save_info( table => 'crm_dtbl_payments', field_values => {rdatestr => $rdatestr, rdate => $rdate});
			
			$vals->{success} = 1;
			$vals->{index} = $self->stash->{index};
			
			my $id_data_services = $send_params->{id_data_services};
				
			my $values = $self->dbi->query("SELECT * FROM `crm_data_services` WHERE `ID`='$id_data_services'")->hash;

			my $services_payments = $self->dbi->query("SELECT * FROM `crm_dtbl_payments` WHERE `id_data_services`='$id_data_services' ORDER BY `rdate`")->hashes;

			$self->stash->{services_payments} = $services_payments;
						
			$vals->{html} = $self->render_partial( template => 'Crm/Services/edit_services_item', service => $values);
		}
		$vals->{success} = 1;
		
		$self->dbi->dbh->do("OPTIMIZE TABLE `crm_dtbl_payments`");
	}
	
	$self->render_json($vals);	
}

sub save_service_item{
	my $self = shift;
	
	my $delete = $self->send_params->{'delete'};
	
	my $send_params = $self->send_params;
	my $vals = {};
	
	$self->stash->{services_payments} = [];
	
	if($delete && $send_params->{service_id}){
		my $service_id = $send_params->{service_id};
		$self->dbi->dbh->do("DELETE FROM `crm_data_services` WHERE `ID`='$service_id'");
	
	# Обновление записи
	} elsif($send_params->{service_id}){
		my $service_id = $send_params->{service_id};
		$self->update_hash("crm_data_services", {servicestatus => $send_params->{servicestatus} }, "`ID`='$service_id'");
		
		my $values = $self->dbi->query("SELECT * FROM `crm_data_services` WHERE `ID`='$service_id'")->hash;
		my $services_payments = $self->dbi->query("SELECT * FROM `crm_dtbl_payments` WHERE `id_data_services`='$service_id' ORDER BY `rdate`")->hashes;
		$self->stash->{services_payments} = $services_payments;
						
		$vals->{html} = $self->render_partial( template => 'Crm/Services/edit_services_item', service => $values);		
	} else {
		my $id_user = $self->app->crmuser->{ID};
		if($self->save_info( table => 'crm_data_services', field_values => {id_user => $id_user } )){
			$vals->{success} = 1;
			$vals->{index} = $self->stash->{index};
			
			my $values = $self->dbi->query("SELECT * FROM `crm_data_services` WHERE `ID`='".$self->stash->{index}."'")->hash;
			
			$vals->{html} = $self->render_partial( template => 'Crm/Services/edit_services_item', service => $values);
		}
	}
	$vals->{success} = 1;
	$self->dbi->dbh->do("OPTIMIZE TABLE `crm_data_services`");
	
	$self->render_json($vals);
}

sub edit{
	my $self = shift;
	
	my $index = $self->send_params->{ID};
	
	my $item = {};
	
	if($self->req->method eq 'POST'){
		$item = $self->send_params;
		
		# validate
		my $required_fields = {
			name	=> 'ФИО ',
			phone	=> 'Телефон',
		};
		
		foreach (keys %$required_fields){
			$self->crm_msg_errors("Не заполнено поле: <b>$$required_fields{$_}</b>") if(!$self->send_params->{$_})
		}

		unless($self->crm_has_errors){
			
			if(!$index){
				# Формируем номер договора
				$self->send_params->{contract} = $self->_generate_contract_number;
			}
			
			if(my $new_index = $self->save_info( table => 'crm_data_users', field_values => {})){
				$index ||= $new_index;
				$self->crm_msg_success("Данные сохранены ...");
			}
		}
		$self->flash({
			crm_msg_errors => $self->crm_msg_errors,
			crm_msg_success => $self->crm_msg_success,
		});
		
		
		return $self->redirect_to('/crm/services/edit?ID='.$index.($self->send_params->{ID} ? "" : "&add_service=1") );
	}
	
	my $services = [];
	my $services_payments = [];
	if($index){
		$item = $self->dbi->query("SELECT * FROM `crm_data_users` WHERE `ID`='$index'")->hash;

		$services = $self->dbi->query("SELECT * FROM `crm_data_services` WHERE `id_crm_user`='$index' ORDER BY `rdate`")->hashes;
		
		my $services_ids = [];
		foreach (@$services){
			push @$services_ids, $_->{ID};
		}
		if(scalar(@$services_ids) > 0){
			$services_payments = $self->dbi->query("SELECT * FROM `crm_dtbl_payments` WHERE `id_data_services` IN (".join(',', @$services_ids).") ORDER BY `rdate`")->hashes;
		}
		
		foreach my $i (0..$#$services){
			my $payments = 0;
			foreach my $p (@$services_payments){
				if($p->{id_data_services} == $services->[$i]->{ID}){
					$payments += $p->{price};
				}
			}
			$services->[$i]->{dolg} = $services->[$i]->{price} - $payments;
			
		}
	}
	my $services_price = $self->dbi->query("SELECT * FROM `crm_lst_services` WHERE 1")->hashes;

	$self->stash->{index} = $index;
	
	$self->render(	item		=> $item,
					services	=> $services,
					services_price	=> $services_price,
					services_payments	=> $services_payments,
					template	=> 'Crm/Services/edit');		
}


sub list{
	my $self = shift;
	
	$self->_build_where;
	
	$self->stash->{limit} ||= 25;
	$self->stash->{page} ||= 1;
	
	$self->crmuserdata->{limit} = $self->stash->{limit};
	
	$self->stash->{services} = $self->dbi->query("SELECT * FROM `crm_lst_services` WHERE 1")->hashes;
	$self->stash->{services_status} = $self->dbi->query("SELECT * FROM `crm_lst_services_status` WHERE 1")->hashes;
	my $user_id_office =  $self->app->crmuser->{id_office} || 0;
	$self->stash->{crm_lst_office} = $self->dbi->query("SELECT * FROM `crm_lst_office` WHERE 1 ".($self->is_crm_admin ? "" : " AND `ID`='$user_id_office' " )." ")->hashes;

	my ($year,$month,$day) = Add_Delta_Days((localtime)[5]+1900, (localtime)[4]+1, (localtime)[3], -31);
	$self->stash->{date_from} = sprintf ("%02d.%02d.%04d", $day,$month,$year);
	
	
	# Обновление долга
	my @tmp = $self->dbi->query("SELECT `ID`,`price` FROM `crm_data_services` WHERE 1")->hashes;
	my $sth_update = $self->dbi->dbh->prepare("UPDATE `crm_data_services` SET `dolg`=? WHERE `ID`=?");
	my $sth_payments = $self->dbi->dbh->prepare("SELECT SUM(price) FROM `crm_dtbl_payments` WHERE `id_data_services`=?");
	foreach (@tmp){
		my $price = $_->{price};
		my $payments_price = 0 ;
		$payments_price = $sth_payments->fetchrow_array if($sth_payments->execute( $_->{ID} ) ne '0E0');

		my $dolg = $price - $payments_price;
		$sth_update->execute($dolg, $_->{ID});
	}
	#$self->dbi->dbh->do("UDPATE ")
	
	$self->render( template => 'Crm/Services/list_container');
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
	my $where_total = $where;
	if($self->stash->{limit}){
		my $count = $self->dbi->getCountCol(from => 'crm_data_services', where => $where);
		$self->stash->{total_count} = $count;
		$self->def_text_interval( total_vals => $count, cur_page => $self->stash->{page}, col_per_page => $self->stash->{limit} );
		$params{npage} = $self->stash->{limit} * ($self->stash->{page} - 1);
		$where .= " LIMIT $params{npage},".$self->stash->{limit};
		$self->stash('count', $count);
	}
	

	my @items = $self->dbi->query(qq/
		SELECT `crm_data_services`.*, `crm_data_services`.`rdate` AS `servicesrdate`, `crm_data_users`.`name` AS `username`, `crm_data_users`.`passport`,
		`crm_lst_services_status`.`name` AS `statusname`, `crm_lst_services_status`.`colorcode` AS `colorcode`, `crm_lst_services`.`name` AS `servicename`
		FROM `crm_data_services`
		LEFT JOIN `crm_data_users` ON `crm_data_services`.`id_crm_user`=`crm_data_users`.`ID`
		LEFT JOIN `crm_lst_services_status` ON `crm_data_services`.`servicestatus`=`crm_lst_services_status`.`ID`
		LEFT JOIN `crm_lst_services` ON `crm_data_services`.`id_service`=`crm_lst_services`.`ID`
		WHERE $where
	/)->hashes;
	
	# Просчитаваем суммы по всей выборке
	my @total_items = $self->dbi->query(qq/
		SELECT `ID`,`price`
		FROM `crm_data_services`
		WHERE $where_total
	/)->hashes;
	
	my $total_dolg = 0;
	my $total_price = 0;
	my $total_count_full_paid = 0; # Кол-во полностью оплаченных услуг
	
	my $sth_payments = $self->dbi->dbh->prepare("SELECT SUM(price) FROM `crm_dtbl_payments` WHERE `id_data_services`=?");
	foreach my $item (@total_items){
		my $price = $item->{price};
		$total_price += $price;
		my $payments_price = 0 ;
		$payments_price = $sth_payments->fetchrow_array if($sth_payments->execute( $item->{ID} ) ne '0E0');

		my $dolg = $price - $payments_price;
		$total_dolg += $dolg;
		
		$total_count_full_paid++ unless $dolg
#		foreach my $i (0..$#items){
#			if($items[$i]->{ID} == $item->{ID}){
#				
#				$items[$i]->{dolg} = $dolg || 0;
#				
#				$total_count_full_paid ++ unless $dolg;
#				last;
#			}
#		}
	}
	$self->stash->{total_dolg} = $total_dolg;
	$self->stash->{total_price} = $total_price;
	$self->stash->{total_count_full_paid} = $total_count_full_paid;
	$self->stash->{total_price_avg} = $self->stash->{total_count} ? sprintf("%.2f", $total_price / $self->stash->{total_count} ) : 0;
	
	my $body_items = $self->render_partial( 
											items	=> \@items,
											template => 'Crm/Services/list_items');
	
	$self->render_json( {html => $body_items}, status => 200 );
}


sub _build_where{
	my $self = shift;
	
	my $where = "1 ";
	
	my $send_params = $self->send_params;
	
	if($self->param('q') or $self->param('qsearch')){
		my $str = $self->param('q') || $self->param('qsearch');
		
		# check tlist table
		my $where_qsearch = '';
		
		my @vals = $self->dbi->query("SELECT `ID` FROM `crm_data_users` WHERE `name` LIKE '%$str%' OR `passport` LIKE '%$str%' OR `contract` LIKE '%$str%'")->flat;
		$where_qsearch .= " OR `crm_data_services`.`id_crm_user` IN (".join(',', @vals).") " if (scalar(@vals) > 0);
		
		$where .= " AND (`crm_data_services`.`price` LIKE '%$str%' $where_qsearch ) ";
		
		$self->crmuserdata->{services}->{qsearch} = $str if $self->param('qsearch');
	}
	
	if($send_params->{id_service}){
		$where .= " AND `crm_data_services`.`id_service`='".$send_params->{id_service}."' ";
	}
	if($send_params->{servicestatus}){
		$where .= " AND `crm_data_services`.`servicestatus`='".$send_params->{servicestatus}."' ";
	}
	
	if(!$self->is_crm_admin){
		$send_params->{id_office} = $self->app->crmuser->{id_office};
	}
	
	if($send_params->{id_office}){
		my @users = $self->dbi->query("SELECT `ID` FROM `sys_users_common` WHERE `id_office` IN (".join(',', split('=', $send_params->{id_office})).")")->flat;
		$where .= " AND `crm_data_services`.`id_user` IN (".join(',', @users).")  ";
	}
		
	if($send_params->{tdate_from}){
		my ($day, $month, $year) = split('\.', $send_params->{tdate_from});	#03.02.2012
		my $tdate_mysql_format = sprintf("%04d-%02d-%02d", $year, $month, $day);
		$where .= " AND DATE(crm_data_services.rdate)>='$tdate_mysql_format' ";		
	}

	if($send_params->{tdate_to}){
		my ($day, $month, $year) = split('\.', $send_params->{tdate_to});	#03.02.2012
		my $tdate_mysql_format = sprintf("%04d-%02d-%02d", $year, $month, $day);
		$where .= " AND DATE(crm_data_services.rdate)<='$tdate_mysql_format' ";		
	}
	
	my @order_fields = qw(username passport statusname servicename dolg servicesrdate);
	my $order = $self->param('order') || $self->crmuserdata->{students}->{order} || "id_service"; 
	$order = 'id_service' unless (grep(/^$order$/, @order_fields));
	my $order_type = $self->param('order_type') || 'asc';
	$order_type = 'asc' unless (grep(/^$order_type$/, qw(asc desc)));

	$where .= " ORDER BY `$order` $order_type";
	$self->crmuserdata->{services}->{order} = $order;
	$self->crmuserdata->{services}->{order_type} = $order_type;

	return $where;

}
1;

