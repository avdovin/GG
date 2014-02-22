package GG::Crm::Orders;

use warnings;
use strict;
use utf8;

use Mojo::Base 'GG::Crm::Controller';

my %STATUS	= (
			0	=> {
						name		=> 'В работе',
						divclass	=> '',
						icon		=> '',
			},
			1	=> {
						name		=> 'Готов',
						divclass	=> 'zakaz-entry-green',
						icon		=> '',
			},
			2	=> {
						name		=> 'Ожидание',
						divclass	=> 'zakaz-entry-blue',
						icon		=> '<img src="/img/clock.png" width="16" height="16" alt="Ожидание"/>',
			},
			3	=> {
						name		=> 'Просроченный заказ',
						divclass	=> 'zakaz-entry-yellow',
						icon		=> '<img src="/img/warning.png" width="16" height="16" alt="Просроченный заказ"/>',
			},
			4	=> {
						name		=> 'Горячий заказ',
						divclass	=> '',
						icon		=> '<img src="/img/element_fire.png" width="16" height="16" alt="Горячий заказ"/>',
			},
			5	=> {
						name		=> 'Закрытые заказы',
						divclass	=> '',
						icon		=> '',
			},
);



sub list{
	my $self = shift;
	
	$self->render( template => 'Crm/Orders/list_container');
}

sub list_items{
	my $self = shift;
	my %params = @_;
	
	
	my $where = $self->_build_where;
	$where .= $params{where} if $params{where};
	
	$self->stash->{limit} ||= 25;
	$self->stash->{page} ||= 1;
	
	$self->userdata->{limit} = $self->stash->{limit};
	
	if($self->stash->{limit}){
		my $count = $self->dbi->getCountCol(from => 'data_crm_orders_items', where => $where);
		$self->def_text_interval( total_vals => $count, cur_page => $self->stash->{page}, col_per_page => $self->stash->{limit} );
		$params{npage} = $self->stash->{limit} * ($self->stash->{page} - 1);
		$where .= " LIMIT $params{npage},".$self->stash->{limit};
		
		$self->stash('count', $count);
	}


	my @items = $self->dbi->query(qq/
		SELECT *
		FROM `data_crm_orders_items`
		WHERE $where
	/)->hashes;
	
	
	require Date::Calc;
	my $overdue = $self->vars->{orders_overdue}->value;
	foreach my $i (0..$#items){
		$items[$i]->{icon} = $STATUS{ $items[$i]->{status} }->{icon};
		$items[$i]->{divclass} = $STATUS{$items[$i]->{status}}->{divclass};
		my ($rdate_year, $rdate_month, $rdate_day, undef, undef, undef) = ($items[$i]->{rdate} =~ /([\d]{4})-([\d]{2})-([\d]{2})\s([\d]{2}):([\d]{2}):([\d]{2})/);
		if($rdate_year){
			my $days;
			eval{
				$days = Date::Calc::Delta_Days(($rdate_year, $rdate_month, $rdate_day), ((localtime)[5]+1900, (localtime)[4]+1, (localtime)[3] ) );
			};
			unless($@){
				$items[$i]->{delta_days} = $days;
				$items[$i]->{delta_days_word} = $self->declension($days, ['день', 'дня', 'дней']);
				
				if($days > $overdue and ($items[$i]->{status} eq '0' or $items[$i]->{status} eq '4')){
					$self->dbh->do("UPDATE `data_crm_orders_items` SET `status`=? WHERE `ID`=?", undef, 3, $items[$i]->{ID});
				}
			}
		}
		
	}
	
	my $body_items = $self->render_partial( items	=> \@items,
											template => 'Crm/Orders/list_items');
	
	$self->render_json( {html => $body_items}, status => 200 );
}


sub _build_where{
	my $self = shift;
	
	$self->stash->{status} = 1 if($self->stash->{status} == '-1');
	
	my @fields = qw(qsearch);

	my $where = "1 ";
	
    $self->stash->{status} = $self->param('status');
    
	if(!defined $self->stash->{status}){
		$self->stash->{status} = $self->userdata->{status} if defined $self->userdata->{status}; 	
	} else {
		$self->userdata->{status} = $self->stash->{status};
	}
	
	my $status = $self->stash->{status};


	if(defined $status and $status >= 0){
		$where	.= " AND `status`='$status'";

	} elsif($status == '-1'){
		#my $localtime = $self->setLocalTime();
		#$where	.= " AND LEFT(rdate, 10)='$localtime'";
		$where .= " AND `status`!='1' AND `status`!='5' ";
	}

	
	if($self->stash->{q}){
		my $str = $self->stash->{q};
		
		# check tlist table
		my $where_ids;
		my $brands_ids = $self->dbi->dbh->selectcol_arrayref("SELECT `ID` FROM `data_catalog_brands` WHERE `name` LIKE '%$str%'");
		$where_ids = " OR `id_data_brand` IN (".join(",", @{$brands_ids}).")" if($brands_ids && scalar(@{$brands_ids}) > 0);

		my $catalog_ids = $self->dbi->dbh->selectcol_arrayref("SELECT `ID` FROM `data_catalog_items` WHERE `name` LIKE '%$str%'");
		$where_ids .= " OR `id_data_brand` IN (".join(",", @{$catalog_ids}).")" if($catalog_ids && scalar(@{$catalog_ids}) > 0);
				
		my $search_id = $str;
		$search_id =~ s{^0+}{};
		$where .= " AND (`ID` LIKE '%$str%' OR `ID` LIKE '%$search_id%' OR `name` LIKE '%$str%' OR `tel` LIKE '%$str%' OR `email` LIKE '%$str%' OR `comment` LIKE '%$str%' $where_ids) ";
	}

	foreach (@fields){
		$where .= " AND `$_`='".$self->stash->{$_}."' " if $self->stash->{$_};
	}


	$where .= " ORDER BY `rdate`";
	return $where;
}

1;

