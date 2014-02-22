package GG::Content::Subscribe;

use strict;
use warnings;
use utf8;

use Mojo::Base 'GG::Content::Controller';

my $DB_USERS = 'dtbl_subscribe_users';
my $DB_STATS = 'dtbl_subscribe_stat';
my $Host = 'tandem.ru';

sub unsubscribe{
	my $self = shift;
	
	my ($cck, $user_id) = ($self->param('cck'), $self->param('user_id'));
	
	my $message = '';
	if($self->dbi->query("SELECT `ID` FROM `$DB_USERS` WHERE `ID`='$user_id' AND `cck`='$cck'")->hash){
		
		$self->dbi->dbh->do("DELETE FROM `$DB_USERS` WHERE `ID`='$user_id' AND `cck`='$cck'");
		
		$message = '<span style="color:green;">Вы успешно отписаны от рассылки</span>';
	} else {
		$message = '<span style="color:red;">Данные для отписки аккаунта некорректны...</span>';
	}

	$self->render(
		message		=> $message,
		template	=> 'Subscribe/unsubscribe_result'
	);
}

sub add_ajax{
	my $self = shift;
	
	my $email = $self->check_email( value => $self->param('email') );
	
	my $message = 'Некорректный емайл';
	my $inserted = 0;
	if($email){
		$inserted = $self->insert_hash($DB_USERS, {
			email	=> $email,
			cck		=> '',
			rdate	=> $self->setLocalTime(1),
		});
		$message = $inserted ? 'Спасибо за доверие!' : 'Вы уже подписаны на рассылку!';
	}
	
	$self->render_json({message => $message});
}

sub cron_send{
	my $self = shift;

	$self->app->plugin(mail => {
	    from     => 'no-reply@'.$Host,
	    encoding => 'base64',
    	how      => 'sendmail',
    	howargs  => [ '/usr/sbin/sendmail -t' ],
    	type	 => 'text/html;charset=utf-8',
  	});	
			  		
	my $dbh = $self->dbi->dbh;
	foreach (1..10){
		my $sql = qq/
			SELECT a.`ID`, b.`subject`, b.`text`, b.`soffers`, c.`ID` AS `user_id`, c.`email`, a.`id_data_subscribe`
			FROM `$DB_STATS` a LEFT JOIN `data_subscribe` b ON a.`id_data_subscribe` = b.`ID` LEFT JOIN $DB_USERS c ON a.`id_user` = c.`ID`
			WHERE a.`send_date` = '0000-00-00 00:00:00'
		/;

		if(my $letters = $self->dbi->query($sql)->hashes){
			
			#Добавляем к письму спецпредложения
			my $soffers = $self->dbi->query("SELECT * FROM `texts_soffers_ru` WHERE `viewtext`='1'")->hashes;
			my $offers_text = $self->render_partial(
					soffers		=> $soffers,
					template	=> 'Subscribe/mail_part_soffers'
			);
						
			foreach my $l (@$letters){
				$l->{cck} = int(rand(10000000000));
				$dbh->do("UPDATE `$DB_USERS` SET `cck`=? WHERE `ID`=?", undef, $l->{cck}, $l->{user_id} );
				$dbh->do("UPDATE `$DB_STATS` SET `send_date`=NOW() WHERE `id_user`=? AND `id_data_subscribe`=?", undef, $l->{user_id}, $l->{id_data_subscribe});
				
				
				
				my $email_body = $self->render_partial(
					offers_text	=> $offers_text,
					letter		=> $l,
					template	=> 'Subscribe/mail'
				);
				
		  	   												
				$self->mail(
			    	to      => $l->{email},
			    	subject => $l->{subject},
			    	data    => $email_body,
			  	);		
			}
			
		}
	}
	
	$self->render(data => 'success');
}

1;
