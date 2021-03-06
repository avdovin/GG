package GG::Dbi;

use strict;
use warnings;
use Carp ();
use utf8;
use base qw(DBIx::Simple);
use Term::ANSIColor qw(:constants);
use Time::HiRes qw( time );

$Carp::Internal{$_} = 1 for qw( GG::Dbi );

# build where select for GG multiselect fields
# ex:
#	in: 	where_multiselect('ID', 2)
# 	out: 	AND `ID` REGEXP  '(^|=)(2)(=|$)'
#	in: 	where_multiselect('ID', [2,5])
# 	out: 	AND `ID` REGEXP  '(^|=)(2,5)(=|$)'

sub where_multiselect{
	my $self = shift;
	my $field = shift;

	my $arr = ref $_[0] ? $_[0] : [@_];

	return scalar @$arr ? " `$field` REGEXP '(^|=)(".join('|',@$arr).")(=|\$)' " : '';
};


sub query{
	my $self = shift;

	my $sql = $_[0];
	$sql =~ s{[\t\n]+}{ }gi;

  my ($start, $end);
  if($self->debug){
    $start = time();
  }

	my $query = $self->SUPER::query(@_);
  if($ENV{IS_MORBO} && $self->{reason}){
    print RED, ">>$sql<<", "\n";
    print $self->{reason};
    print RESET, "\n";
    delete $self->{reason};
  }
  else{
    if($ENV{IS_MORBO} && $self->debug){
      $end = time();

      my $elapsed_type = sprintf("%.4f", $end - $start);
      print CYAN, ">>$sql<< ($elapsed_type sec) ";
      print RESET, "\n";
      $start = time();
    }
  }

  return $query;
}

# Get table fields (columns)
sub getKeysSQL{
	my $self = shift;
	my %params = @_;

	if(!$params{from}) { Carp::croak("Функция getKeysSQL. Отсутствует параметр FROM"); }

	my $sql = "SHOW FIELDS FROM `$params{from}`";
	my (@fields);
	if($self->{'_from_'.$params{from}}){
		@fields = @{$self->{'_from_'.$params{from}}};
	} else {
		for my $row ($self->SUPER::query($sql)->arrays){
			push @fields, $row->[0];
		}
		$self->{'_from_'.$params{from}} = \@fields;
	}

	return wantarray ? @fields : $fields[-1];
}

# Check exist key in table
sub exists_keys{
	my $self = shift;
	my %params = @_;

	$params{from} ||= $params{table} if $params{table};
	if (!$params{from}) {Carp::croak("Функция exists_keys. Отсутствует параметр FROM");}
	my $lkey = delete $params{lkey} || return;

	return grep(/^$lkey$/, $self -> getKeysSQL(from => $params{from})) ? 1 : 0;
}


sub getCountCol{
	my $self = shift;
	my %params = @_;

	if (!$params{from})  {Carp::croak("Функция getCountCol. Отсутствует параметр FROM");}

	my $sql = "SELECT count(*) FROM $params{from} WHERE $params{where}";

	my $fetch = $self->SUPER::query($sql)->fetch;
	my $count = $fetch ? $fetch->[0] : 0;
	return $count || 0;
}

sub getTablesSQL {
	my $self = shift();

	my (@array);

	if (!$self->{tables_list}) {

		for my $row ($self->SUPER::query("SHOW TABLES")->arrays){
			push @array, $row->[0];
		}

		$self->{tables_list} = \@array;
	} else {
		@array = @{$self->{tables_list}};
	}

	return (@array);
} # end of &getTablesSQL

sub upsert{
 	my $self = shift;
 	my ($table, $field_values) = @_;
 	my $dbh = $self->dbh;

	my $created_at = sprintf ("%04d-%02d-%02d %02d:%02d:%02d", (localtime)[5]+1900, (localtime)[4]+1, (localtime)[3], (localtime)[2], (localtime)[1], (localtime)[0]);

	$field_values->{$_} ||= 'NULL'  foreach (qw(created_at updated_at));

	foreach my $k (keys %$field_values){

		unless($self->exists_keys(from => $table, lkey => $k) ){
			delete $field_values->{$k};
			next;
		}

		   if($k eq 'updated_at'){ $field_values->{$k} ||= 'NULL';}
		elsif($k eq 'created_at'){ $field_values->{$k} ||= $created_at;}
	}

	my @fields = sort keys %$field_values;
	my @values = @{$field_values}{@fields};

	my $update_fields = [];
	foreach my $f (@fields){
		push @$update_fields, $f if (
			$f ne 'alias' and
			$f ne 'active' and
			$f ne 'updated_at' and
			$f ne 'created_at'
		);
	}

		my $sql = sprintf "INSERT INTO %s (%s) VALUES (%s)",
		$table, join(",", map{ "`$_`" }@fields), join(",", ("?")x@fields);

	$sql .= " ON DUPLICATE KEY UPDATE ";
	$sql .= sprintf " %s, updated_at=NOW() ",
		join(",", map{ "`$_`=VALUES($_)" }@$update_fields);

	my $index = 0;
	eval{
	    my $sth = $dbh->prepare($sql);
	    $sth->execute(@values) || die $DBI::errstr;
	    $index = $dbh->{'mysql_insertid'};
	    $sth->finish();
	};
	if($@){
	  if($ENV{IS_MORBO}){
	    print RED, ">>$sql<<", "\n";
	    print $@;
	    print RESET, "\n";
	  }
	  else {
			$self->save_mysql_error($@, $sql, \@values);
	  }
		$self->{error} = $@;
		return;
	}

	$index = $field_values->{ID} if $field_values->{ID};
	return $index;
}


sub insert{
 	my $self = shift;
 	my ($table, $field_values, $insType) = @_;
 	my $dbh = $self->dbh;

	my @fields = sort keys %$field_values;
	my @values = @{$field_values}{@fields};

	my $sql = sprintf "$insType INTO %s (%s) VALUES (%s)",
		 $table, join(",", map{ "`$_`" }@fields), join(",", ("?")x@fields);

    # USING SQL::Abstract
    #my($stmt, @bind) = $self->dbi->insert($table, $field_values);
	#return unless $self->dbi->insert($table, $field_values);

	my $index = 0;
	eval{
	  my $sth = $dbh->prepare($sql);
	  $sth->execute(@values) || die $DBI::errstr;
	  $index = $dbh->{'mysql_insertid'};
	  $sth->finish();
	};
	if($@){
	  if($ENV{IS_MORBO}){
	    print RED, ">>$sql<<", "\n";
	    print $@;
	    print RESET, "\n";
	  }
	  else {
			$self->save_mysql_error($@, $sql, \@values);
	  }
		$self->{error} = $@;
		return;
	}
	$index = $field_values->{ID} if $field_values->{ID};
	return $index;
}

sub insert_hash {
 	my $self = shift;

  my ($table, $field_values, $insType) = @_;
  my $dbh = $self->dbh;

	$insType ||= 'INSERT';

  my $created_at = sprintf ("%04d-%02d-%02d %02d:%02d:%02d", (localtime)[5]+1900, (localtime)[4]+1, (localtime)[3], (localtime)[2], (localtime)[1], (localtime)[0]);

	$field_values->{'created_at'} ||= $created_at;

	$field_values->{'updated_at'} = undef
		if(($field_values->{'updated_at'} && $field_values->{'updated_at'} eq '0000-00-00 00:00:00') or ($field_values->{'updated_at'} && $field_values->{'updated_at'} eq '0000-00-00'));

	foreach my $k (keys %$field_values){

		unless($self->exists_keys(from => $table, lkey => $k) ){
			delete $field_values->{$k};
			next;
		}
	}

  my @fields = sort keys %$field_values;
  my @values = @{$field_values}{@fields};


 	return $self->insert($table, $field_values, $insType);
}

sub update{
	my $self = shift;
	my ($table,$field_values, $where) = @_;

	my $dbh = $self->dbh;

	#USING SQL::Abstract
	#my($stmt, @bind) = $self->SUPER::update($table, $field_values,  $where);

	my @fields = sort keys %$field_values;
	my @values = @{$field_values}{@fields};
	my $sql = sprintf "UPDATE `%s` SET %s WHERE $where", $table, join(",", map{"`$_`=?"}@fields);

	my $count = 0;
	eval{
		my $sth = $dbh->prepare($sql) or die $DBI::errstr;
		$count = $sth->execute(@values) or die $DBI::errstr;
	};
	if($@){
	  if($ENV{IS_MORBO}){
	    print RED, ">>$sql<<", "\n";
	    print $@;
	    print RESET, "\n";
	  }
	  else {
			$self->save_mysql_error($@, $sql, \@values);
	  }

		$self->{error} = $@;
		return;
	}

		return $count;
}

# Обновление
sub update_hash {
	my $self = shift;

	my $dbh = $self->dbh;
	my ($table,$field_values, $where) = @_;

	if($self->exists_keys(from => $table, lkey => 'updated_at')){

		if($field_values->{'updated_at'} eq '0000-00-00 00:00:00' or $field_values->{'updated_at'} eq '0000-00-00'){
			$field_values->{'updated_at'} = undef
		}
		else {
			my $updated_at = sprintf ("%04d-%02d-%02d %02d:%02d:%02d", (localtime)[5]+1900, (localtime)[4]+1, (localtime)[3], (localtime)[2], (localtime)[1], (localtime)[0]);
			$field_values->{'updated_at'} = $updated_at;
		}
	}

	return $self->update($table,$field_values, $where);
}

sub save_mysql_error{
	my $self = shift;
	my ($error, $sql, $values) = @_;

	$values ||= [];

	foreach my $v (@$values){
		$sql =~ s{\?}{"\"$v\""}ei;
	}

	$self->dbh->do("
	INSERT INTO
		`sys_mysql_error`
		(`sql`, `error`, `qstring`, `created_at`)
	VALUES
		(?, ?, ?, CURRENT_TIMESTAMP)
	", undef, $sql, $error, '');

}

sub debug{
	my $self = shift;
	if(defined $_[0]){
		$self->{'debug'} = $_[0];
	}
	return $self->{'debug'};
}
1;
