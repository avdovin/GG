 #!/usr/bin/perl
# SMSC.RU API (smsc.ru) версия 1.6 (07.06.2012)

package smsc_api;

use utf8;

use strict;
use warnings;

# Константы для настройки библиотеки
use constant SMSC_LOGIN => 'amgtravel';        # логин клиента
use constant SMSC_PASSWORD => 'ifrogspb';    # пароль или MD5-хеш пароля в нижнем регистре
use constant SMSC_POST => 0;                # использовать метод POST
use constant SMSC_HTTPS => 0;                # использовать HTTPS протокол
use constant SMSC_CHARSET => 'utf-8';        # $charset - кодировка сообщения (windows-1251 или koi8-r), по умолчанию используется utf-8
use constant SMSC_DEBUG => 0;                # флаг отладки

# Константы для отправки SMS по SMTP
use constant SMTP_FROM => 'api@smsc.ru';    # e-mail адрес отправителя
use constant SMTP_SERVER => 'send.smsc.ru';    # адрес smtp сервера

use LWP::UserAgent;
use URI::Escape;
use Net::SMTP;

use vars qw(@EXPORT);
use Exporter 'import';
@EXPORT = qw(send_sms send_sms_mail get_sms_cost get_status get_balance);

# Функция отправки SMS
#
# обязательные параметры:
#
# $phones - список телефонов через запятую или точку с запятой
# $message - отправляемое сообщение
#
# необязательные параметры:
#
# $translit - переводить или нет в транслит (1,2 или 0)
# $time - необходимое время доставки в виде строки (DDMMYYhhmm, h1-h2, 0ts, +m)
# $id - идентификатор сообщения. Представляет собой 32-битное число в диапазоне от 1 до 2147483647.
# $format - формат сообщения (0 - обычное sms, 1 - flash-sms, 2 - wap-push, 3 - hlr, 4 - bin, 5 - bin-hex, 6 - ping-sms)
# $sender - имя отправителя (Sender ID). Для отключения Sender ID по умолчанию необходимо в качестве имени
# передать пустую строку или точку.
# $query - строка дополнительных параметров, добавляемая в URL-запрос ("valid=01:00&maxsms=3")
#
# возвращает массив (<id>, <количество sms>, <стоимость>, <баланс>) в случае успешной отправки
# либо массив (<id>, -<код ошибки>) в случае ошибки

sub send_sms {
    my ($phones, $message, $translit, $time, $id, $format, $sender, $query) = @_;

    my @formats = ("flash=1", "push=1", "hlr=1", "bin=1", "bin=2", "ping=1");

    my @m = _smsc_send_cmd("send", "cost=3&phones=".uri_escape($phones)."&mes=".uri_escape_utf8($message).
                ($translit ? "&translit=$translit" : "").($id ? "&id=$id" : "").($format ? "&".$formats[$format-1] : "").
                (defined $sender ? "&sender=".uri_escape($sender) : "")."&charset=".SMSC_CHARSET.
                ($time ? "&time=".uri_escape($time) : "").($query ? "&$query" : ""));

    # (id, cnt, cost, balance) или (id, -error)

    if (SMSC_DEBUG) {
        if ($m[1] > 0) {
            print "Сообщение отправлено успешно. ID: $m[0], всего SMS: $m[1], стоимость: $m[2] руб., баланс: $m[3] руб.\n";
        }
        else {
            print "Ошибка №", -$m[1], $m[0] ? ", ID: ".$m[0] : "", "\n";
        }
    }

    return @m;
}

# SMTP версия функции отправки SMS

sub send_sms_mail {
    my ($phones, $message, $translit, $time, $id, $format, $sender) = @_;

    my $smtp = Net::SMTP->new(SMTP_SERVER);

    $smtp->mail(SMTP_FROM);
    $smtp->to('send@send.smsc.ru');

    $smtp->data();
    $smtp->datasend("To: send\@send.smsc.ru\n");
    $smtp->datasend("Content-Type: text/plain; charset=".SMSC_CHARSET."\n");
    $smtp->datasend("\n");
    $smtp->datasend(SMSC_LOGIN.":".SMSC_PASSWORD.":".($id ? $id : "").
                    ":".($time ? $time : "").":".($translit ? $translit : "").
                    ",".($format ? $format : "").(defined $sender ? ",".$sender : "").
                    ":$phones:$message\n");
    $smtp->dataend();
    $smtp->quit;
}

# Функция получения стоимости SMS
#
# обязательные параметры:
#
# $phones - список телефонов через запятую или точку с запятой
# $message - отправляемое сообщение
#
# необязательные параметры:
#
# $translit - переводить или нет в транслит (1,2 или 0)
# $format - формат сообщения (0 - обычное sms, 1 - flash-sms, 2 - wap-push, 3 - hlr, 4 - bin, 5 - bin-hex, 6 - ping-sms)
# $sender - имя отправителя (Sender ID)
# $query - строка дополнительных параметров, добавляемая в URL-запрос ("list=79999999999:Ваш пароль: 123\n78888888888:Ваш пароль: 456")
#
# возвращает массив (<стоимость>, <количество sms>) либо массив (0, -<код ошибки>) в случае ошибки

sub get_sms_cost {
    my ($phones, $message, $translit, $format, $sender, $query) = @_;

    my @formats = ("flash=1", "push=1", "hlr=1", "bin=1", "bin=2", "ping=1");

    my @m = _smsc_send_cmd("send", "cost=1&phones=".uri_escape($phones)."&mes=".uri_escape($message).
                (defined $sender ? "&sender=".uri_escape($sender) : "")."&charset=".SMSC_CHARSET.
                ($translit ? "&translit=$translit" : "").($format ? "&".$formats[$format-1] : "").($query ? "&$query" : ""));

    # (cost, cnt) или (0, -error)

    if (SMSC_DEBUG) {
        if ($m[1] > 0) {
            print "Стоимость рассылки: $m[0] руб. Всего SMS: $m[1]\n";
        }
        else {
            print "Ошибка №", -$m[1], "\n";
        }
    }

    return @m;
}

# Функция проверки статуса отправленного SMS или HLR-запроса
#
# $id - ID cообщения
# $phone - номер телефона
#
# возвращает массив:
# для отправленного SMS (<статус>, <время изменения>, <код ошибки sms>)
# для HLR-запроса (<статус>, <время изменения>, <код ошибки sms>, <код IMSI SIM-карты>, <номер сервис-центра>, <код страны регистрации>,
# <код оператора абонента>, <название страны регистрации>, <название оператора абонента>, <название роуминговой страны>,
# <название роумингового оператора>)
#
# При $all = 1 дополнительно возвращаются элементы в конце массива:
# (<время отправки>, <номер телефона>, <стоимость>, <sender id>, <название статуса>, <текст сообщения>)
#
# либо массив (0, -<код ошибки>) в случае ошибки

sub get_status {
    my ($id, $phone, $all) = @_;
    $all ||= 0;

    my @m = _smsc_send_cmd("status", "phone=".uri_escape($phone)."&id=$id&all=$all");

    # (status, time, err, ...) или (0, -error)

    if (SMSC_DEBUG) {
        if (exists $m[2]) {
            print "Статус SMS = $m[0]", $m[1] ? ", время изменения статуса - ".localtime($m[1]) : "", "\n";
        }
        else {
            print "Ошибка №", -$m[1], "\n";
        }
    }

    if ($all && @m > 9 && (!exists $m[14] || $m[14] ne "HLR")) { # ',' в сообщении
        @m = split(",", join(",", @m), 9);
    }

    return @m;
}

# Функция получения баланса
#
# без параметров
#
# возвращает баланс в виде строки или undef в случае ошибки

sub get_balance {
    my @m = _smsc_send_cmd("balance"); # (balance) или (0, -error)

    if (SMSC_DEBUG) {
        if (!exists $m[1]) {
            print "Сумма на счете: ", $m[0], " руб.\n";
        }
        else {
            print "Ошибка №", -$m[1], "\n";
        }
    }

    return exists $m[1] ? undef : $m[0];
}


# ВНУТРЕННИЕ ФУНКЦИИ

# Функция вызова запроса. Формирует URL и делает 3 попытки чтения

sub _smsc_send_cmd {
    my ($cmd, $arg) = @_;

    my $url = (SMSC_HTTPS ? "https" : "http")."://smsc.ru/sys/$cmd.php";
    $arg = "login=".uri_escape(SMSC_LOGIN)."&psw=".uri_escape(SMSC_PASSWORD)."&fmt=1&".($arg ? $arg : "");

    my $ret;
    my $i = 0;

    do {
        sleep(2) if ($i);
        $ret = _smsc_read_url($url, $arg);
    }
    while ($ret eq "" && ++$i < 3);

    if ($ret eq "") {
        print "Ошибка чтения адреса: $url\n" if (SMSC_DEBUG);
        $ret = ",0"; # фиктивный ответ
    }

    return split(/,/, $ret);
}

# Функция чтения URL

sub _smsc_read_url {
    my ($url, $arg) = @_;

    my $ret = "";
    my $post = SMSC_POST || length($arg) > 2000;

    my $ua = LWP::UserAgent->new;
    $ua->timeout(60);

    my $response = $post ? $ua->post($url, Content => $arg) : $ua->get($url."?".$arg);

    $ret = $response->content if $response->is_success;

    return $ret;
}

1;

# Examples:
# use smsc_api;
# my ($sms_id, $sms_cnt, $cost, $balance) = send_sms("79999999999", "Ваш пароль: 123", 1);
# my ($sms_id, $sms_cnt, $cost, $balance) = send_sms("79999999999", "http://smsc.ru\nSMSC.RU", 0, 0, 0, 0, undef, "maxsms=3");
# my ($sms_id, $sms_cnt, $cost, $balance) = send_sms("79999999999", "0605040B8423F0DC0601AE02056A0045C60C036D79736974652E72750001036D7973697465000101", 0, 0, 0, 5);
# my ($sms_id, $sms_cnt, $cost, $balance) = send_sms("79999999999", "", 0, 0, 0, 3);
# my ($cost, $sms_cnt) = get_sms_cost("79999999999", "Вы успешно зарегистрированы!");
# send_sms_mail("79999999999", "Ваш пароль: 123");
# my ($status, $time) = get_status($sms_id, "79999999999");
# my $balance = get_balance(); 