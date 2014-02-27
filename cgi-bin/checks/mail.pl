#!/usr/bin/env perl

use strict;
use warnings;


use lib '../extlib';
use MIME::Lite;
### Create a new single-part message, to send a GIF file:

my $msg = MIME::Lite->new(
    From    =>'info@tisonline.ru',
    To      => 'dm_alexey@mail.ru',
    Subject =>'A test message22',
    Type    =>'text/html;charset=utf-8',
    Data    =>"Test msg"
);


$msg->send();

