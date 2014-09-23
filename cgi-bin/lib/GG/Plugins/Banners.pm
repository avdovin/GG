package GG::Plugins::Banners;

use utf8;

use Mojo::Base 'Mojolicious::Plugin';



sub register {
	my ($self, $app, $conf) = @_;


	$app->routes->route("bb/:id_banner", id_banner => qr/\d+/)->to( cb => sub{
		my $self   = shift;

		my $ip = $ENV{'REMOTE_ADDR'}."|".$ENV{'HTTP_REFERER'};
		my $date = sprintf ("%04d-%02d-%02d", (localtime)[5]+1900, (localtime)[4]+1, (localtime)[3]);
		my $id_banner = $self->stash('id_banner');
		my $redirect = "/";

		if(my $banner = $self->app->dbi->query(qq/
							SELECT *
							FROM `data_banner`
							WHERE `ID`='$id_banner' AND `view`='1'/)->hash){

			if(my $banner_stats_id = $self->app->dbi->query(qq/
							SELECT `id_banner`, `ip_data_click`
							FROM `dtbl_banner_stat`
							WHERE `id_banner`='$id_banner' AND `tdate`='$date'/)->hash){

				$self->app->dbh->do("UPDATE `dtbl_banner_stat` SET `click_count`=`click_count`+1, `ip_data_click`='$$banner_stats_id{ip_data_click}$ip\n' WHERE `id_banner`='$id_banner' AND `tdate`='$date'");
			} else {
				$self->app->dbh->do("INSERT INTO `dtbl_banner_stat` (`id_banner`,`tdate`,`click_count`,`ip_data_click`) values ($id_banner, NOW(), 1, \"$ip\n\")");
			}

			if ($$banner{type_show} && $$banner{type_show} == 2) {
				if(my $banner_block = $self->app->dbi->query(qq/
						SELECT `per_click`
						FROM `data_banner_advert_block`
						WHERE `ID`='$$banner{id_advert_block}'/)->hash){
					$self->app->dbh->do("UPDATE `data_banner` SET `cash`=`cash`-$$banner_block{per_click} WHERE `ID`='$id_banner'");
					$self->app->dbh->do("UPDATE `dtbl_banner_stat` SET `click_pay`=`click_pay`-$$banner_block{per_click} WHERE `id_banner`='$id_banner' AND `tdate`='$date'");
				}

			}

			$redirect = $banner->{'link'} if $banner->{'link'};
		}
		$self->redirect_to($redirect);

	})->name('banner');


	$app->helper(
		banner_place => sub {
			my $self   = shift;
			my %params = (
				count 		=> 1, # кол-во показываемых баннеров
				place		=> 0, # баннерное место
				template 	=> 'Banners/manywithdelimiter',
				delimiter 	=> '',
				before_html	=> '',
				after_html	=> '',
				@_
			);

			my $banner_block = {
				per_show	=> 0,
				width		=> 0,
				height		=> 0
			};

			my $lang = $self->lang;

			$params{page} = $lang.":main:".$self->stash->{info}->{ID};

			return '' unless $params{place};

			$banner_block = $self->app->dbi->query(qq/
				SELECT `per_show`, `width`, `height`
				FROM `data_banner_advert_block`
				WHERE `ID`='$params{place}'/)->hash;


			my $limit = $params{count} ? " LIMIT 0,".$params{count} : "";

			my $time  = (localtime)[2]+1;
			my %wdays = (0 => 7, 1 => 1, 2 => 2, 3 => 3, 4 => 4, 5 => 5, 6 => 6);
			my $week  = $wdays{(localtime)[6]};
			$params{url_id} =  $self->dbi->query("SELECT `ID` FROM `lst_banner_urls` WHERE `name`='".'/'.$self->req->url->path->to_string."'")->list || '0';

      my $where  = "`view` = 1";
			  $where .= " AND (`id_advert_block` = $params{place} OR (`id_advert_block` LIKE '$params{place}=%' OR `id_advert_block` LIKE '%=$params{place}=%' OR `id_advert_block` LIKE '%=$params{place}'))";
			   $where .= " AND (`docfile` != '' OR `textlink` != '' OR `code` != '')";
			   $where .= " AND (`type_show` = 0 OR (`type_show` > 0 AND `cash` > 0))";
			   $where .= " AND (`showdatefirst` <= NOW()) AND (`showdateend` = '0000-00-00' OR `showdateend` >= NOW())";
			   $where .= " AND (`time` = -1 OR `time` = $time OR (`time` LIKE '$time=%' OR `time` LIKE '%=$time=%' OR `time` LIKE '%=$time'))";
			   $where .= " AND (`week` = -1 OR `week` = $week OR (`week` LIKE '$week=%' OR `week` LIKE '%=$week=%' OR `week` LIKE '%=$week'))";
			   $where .= sprintf(" AND (`target` = 0 OR (`target` = 1 AND `list_page` REGEXP '[[:<:]]%s[[:>:]]') OR (`target` = 2 AND `list_page` NOT REGEXP '[[:<:]]%s[[:>:]]'))", $params{page}, $params{page}) if ($params{page});
			   $where .= "
			   AND (`target_url`=0 
			   OR (`target_url`=1
			   AND (`urls` = $params{url_id}
			   		OR `urls` LIKE '$params{url_id}=%'
			   		OR `urls` LIKE '%=$params{url_id}=%'
			   		OR `urls` LIKE '%=$params{url_id}')
				OR (`target_url`=2
					AND NOT (`urls` = $params{url_id} 
					OR `urls` LIKE '$params{url_id}=%' 
					OR `urls` LIKE '%=$params{url_id}=%' 
					OR `urls` LIKE '%=$params{url_id}'))))";
			   $where .= " ORDER BY `rating`,RAND() $limit";

			my $ip = $self->ip;

			my $banners = [];

			if( $banners = $self->app->dbi->query(qq/
					SELECT *, `docfile` AS `pict`
					FROM `data_banner`
					WHERE $where/)->hashes){
				foreach my $banner (@$banners){
					my $date = sprintf ("%04d-%02d-%02d", (localtime)[5]+1900, (localtime)[4]+1, (localtime)[3]);

					if(my $banner_stats_id = $self->app->dbi->query(qq/
							SELECT `id_banner`
							FROM `dtbl_banner_stat`
							WHERE `id_banner`=$$banner{ID} AND `tdate` = '$date'/)->hash){
						my $type_show_stat = "";
						$type_show_stat = ",`view_pay`=`view_pay`-$$banner_block{per_show}" if ($$banner{type_show} && $$banner{type_show}==1 && $$banner_block{per_show});
						$self->app->dbh->do("UPDATE `dtbl_banner_stat` SET `view_count`=`view_count`+1 $type_show_stat WHERE `id_banner`=$$banner{ID} AND `tdate`='$date'");
					} else {
						my $type_show_stat_field = "";
						my $type_show_stat_value = "";
						if ($$banner{type_show}==1) {
							$type_show_stat_field = ",`view_count`";
							$type_show_stat_value = ",$$banner_block{per_show}";
						}
						$self->app->dbh->do("INSERT INTO `dtbl_banner_stat` (`id_banner`,`tdate`,`view_count`$type_show_stat_field) values ($$banner{ID}, NOW(), 1 $type_show_stat_value)");
					}
					if ($$banner{type_show} && $$banner{type_show}==1 && $$banner_block{per_show}) { # списываем деньги за показ
						$self->app->dbh->do("UPDATE `data_banner` SET `cash`=`cash`-$$banner_block{per_show} WHERE `ID`=$$banner{ID}");
					}
				}
			}

			my $banner_content = 	$self->render_to_string(
				%params,
				banners			=> $banners || [],
				banner_block	=> $banner_block,
				template		=> $params{template},

				partial			=> 1
			);

			return $params{before_html} . $banner_content . $params{after_html};

		}
	);


}

1;