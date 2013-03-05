#!/usr/bin/perl

use strict;
use warnings;
use DBI;

my $dbh = DBI -> connect("dbi:mysql:gg9:localhost:3306", 'root', 'vbhhje', {AutoCommit=>1, RaiseError=>0 , PrintError=>1, ShowErrorStatement => 1});
   $dbh -> do("SET NAMES utf8");


foreach (1..1000){
	my $sql = qq/INSERT INTO `gg9`.`dtbl_banner_stat` (`ID` ,`id_banner` ,`tdate` ,`view_count` ,`click_count` ,
				`view_pay` ,`click_pay` ,`ip_data_click`)VALUES (NULL , '2', '0000-00-00', '1', '3', '0.00', '0.00', '')/;

	$dbh->do($sql);
}