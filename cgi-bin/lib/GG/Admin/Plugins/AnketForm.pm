package GG::Admin::Plugins::AnketForm;

use utf8;

use Mojo::Base 'Mojolicious::Plugin';

our $VERSION = '1';

my $templates = {
	w	=> {
			slat		=> "field_input",
			login		=> "field_input",
			s			=> "field_input",
			site		=> "field_input",
			d			=> "field_input",
			email		=> "field_input",
			datetime	=> "field_datetime",
			time		=> "field_time",
			password	=> "field_password",
			tlist		=> "field_list",
			list		=> "field_list",
			date		=> "field_date",
			text		=> "field_text",
			code		=> "field_text",
			html		=> "field_html",
			chb			=> "field_checkbox",
			pict		=> "field_pict",
			file		=> "field_file",
			filename	=> "field_file",
			table		=> "field_table"		
	},
	r	=> {
			slat		=> "field_input_read",
			login		=> "field_input_read",
			s			=> "field_input_read",
			site		=> "field_site_read",
			d			=> "field_input_read",
			password	=> "field_password_read",
			email		=> "field_input_read",
			datetime	=> "field_input_read",
			time		=> "field_input_read",
			tlist		=> "field_list_read",
			list		=> "field_list_read",
			date		=> "field_date_read",
			text		=> "field_input_read",
			code		=> "field_input_read",
			html		=> "field_html_read",
			chb			=> "field_checkbox_read",
			pict		=> "field_pict_read",
			file		=> "field_file_read",
			filename	=> "field_input_read",
			table		=> "field_table"		
	},
	f	=> {
			slat		=> "field_input_filter",
			login		=> "field_input_filter",
			s			=> "field_input_filter",
			site		=> "field_input_filter",
			d			=> "field_decimal_filter",
			password	=> "field_password_filter",
			email		=> "field_input_filter",
			datetime	=> "field_input_filter",
			time		=> "field_input_filter",
			tlist		=> "field_list_filter",
			list		=> "field_list_filter",
			date		=> "field_date_filter",
			text		=> "field_input_filter",
			code		=> "field_input_filter",
			html		=> "field_input_filter",
			chb			=> "field_checkbox_filter",
			pict		=> "field_pict",
			file		=> "field_file_filter",
			filename	=> "field_input_filter",
			table		=> "tabledop_container_filter"		
	}
};
					
sub register {
	my ( $self, $app, $opts ) = @_;

	$opts ||= {};

	$app->log->debug("register GG::Admin::Plugins::AnketForm");

	$app->helper(
		define_anket_form => sub {
			my $self = shift;
			my %params = (
				dop	=> 0,
				win	=> $self->stash->{flag_win},
				@_
			);

			$self->stash->{group} ||= 1;
			$params{table} ||= $self->stash->{list_table};
			
			my 	$win = "";
	   			$win = "_win" if ($params{win});
	   			$win = "_dop" if ($params{dop});
			

			my $do = $self->stash->{'do'} || '';
			if($self->stash->{dop_table} && $self->stash->{lfield} && !$win && grep(/^$do$/, qw(add save edit)) ){
				$win ||= "_dop";
				my $lfield = $self->stash->{lfield};
				
				my @groupnames = split(/\|/, $self->lkey( name => $lfield )->{settings}->{table_groupname} );
				$self->app->program->{groupname} = \@groupnames;
				
				foreach (("dop_table", "lfield", "access_flag", $self->lkey( name => $lfield )->{settings}->{table_svf})){
					$self->param_default($_ => $self->stash->{$_} );	
				}
				
				$params{table} = $self->stash->{dop_table};
 
				$params{render_html} = 1;
				$self->stash->{not_init} = 1;
				
				delete $params{noget};
			
			} elsif($self->stash->{dop_table} && $self->stash->{lfield} && $win && grep(/^$do$/, qw(add save edit)) ){
				if(substr($params{table}, 0, 4) eq 'lst_'){
					$self->get_keys( type => ['lkey'], validator => 0, controller => 'lists');
				}
				
				foreach (qw(dop_table lfield)){
					$self->param_default($_ => $self->stash->{$_} );
				}
				$self->stash->{flag_win} = 0 unless $self->stash->{index};
				
				my $settings = 	$self->lkey( name => $self->stash->{lfield} )->{settings};

				my $win_settings = {
					height	=> $settings->{win_height} || 135,
					scroll	=> $settings->{win_scroll} || 0,
				};

				$self->stash->{win} = $win_settings;
				
				$params{render_html} = 1;
				$self->stash->{not_init} = 1;
				
				delete $params{noget};
			}
						
			my %template_blocks = (
						 w => "anketa_edit".$win,
						 r => "anketa_info".$win,
						 f => "anketa_filter",
						 d => "anketa_delete".$win
						 );			
			
			my $access = $params{access};
			$params{template} ||= $template_blocks{ $access };
			
			$self->stash->{template_dir} = $params{template_dir} ? $params{template_dir} : 'Admin/AnketForm/';
			$self->stash->{key_shablon}	= $params{key_shablon} ? $params{key_shablon} : $params{access};
			$self->stash->{access_flag} = $params{access};
			
			$params{keys} ||= [];
			$params{keys_hashref} = {};
			foreach (@{$params{keys}}){
				$params{keys_hashref}->{$_} = 1; 
			}
			my $keys = delete $params{keys};   			
			
			   if  ($access eq "w") {$self -> def_listfield_write( content => $params{content}, table => $params{table}, access => $access, keys => $params{keys_hashref});}
			elsif  ($access eq "r") {$self -> def_listfield_read(table => $params{table}, access => $access, keys => $params{keys_hashref});}
			elsif  ($access eq "f") {$self -> def_listfield_filter(table => $params{table}, access => $access);}
			elsif  ($access eq "d") {$self -> def_listfield_delete(table => $params{table}, access => $access);}
			
			if ($self->stash->{index} and $params{table}) {
				$params{where} ||= '';
				$params{where} = "`ID`='".$self->stash->{index}."' $params{where}";

				if (!$params{noget} && !$self->getArraySQL(from => $params{table}, where => $params{where}, stash => 'anketa')) {
					$self->stash->{no_access} = 1;
				}
				if ($access eq "d") {
					foreach my $k ($self->dbi->getKeysSQL(from => $params{table})) {
						$self->{$k} =~ s/"/&quote;/g if $self->{$k};
					}
				}
			}
			unless($self->stash->{page_name}){
				if($self->stash->{index}){
					$self->stash->{page_name}  = '['.$self->stash->{index}."]" if $self->stash->{index};
					$self->stash->{page_name} .= " «".$self->stash->{anketa}->{name}."»" if $self->stash->{anketa}->{name};
					$self->stash->{page_name} .= " (".$params{table}.")";
				} else {
					$self->stash->{page_name} = "Добавление новой записи в таблицу «".$params{table}."»";
				}
			}
			$self->stash->{win_name} = $self->stash->{page_name};
			$self->stash->{name} = $self->stash->{index} ? "Редактирование: ".$self->stash->{anketa}->{name} : " Добавление новой записи ";
			
			if($access eq "r" or $access eq "w" and $self->stash->{index} and $self->stash->{group} == 1){
				my $history_name = $self->stash->{history}->{name} || $self->stash->{anketa}->{name};
				$history_name = " «$history_name» " if $history_name;
				$self->save_history(name => '['.$self->stash->{index}."]$history_name (".$params{table}.")");
			}
			
			if ($params{access} eq "r") {
        		my (@tablist);
        		foreach my $gr (@{$self->app->program->{groupname}}) {
            		$gr =~ s/[\n\r]+//;
            		push(@tablist, "'$gr'");
        		}
        		$self->stash->{group_total} = $#{$self->app->program->{groupname}} + 1;
        		$self->stash->{group_name_list} = join(",",  @tablist);
    		}
			
			if($params{render_html}){
				$self->render( template	=> $self->stash->{template_dir}.$params{template})

			} else {
				my $body = $self->render_partial(	template	=> $self->stash->{template_dir}.$params{template});

				my $init_inems = 'init_'.$template_blocks{$params{access}};
						
				$self->render_json({
					content	=> $body,
					items	=> $self->get_init_items( init => $init_inems),
				});
			}
		}
	);

	$app->helper(
		def_listfield_write => sub {
			my $self = shift;
			my %params = @_;

			my @anketa_keys  = ();
			
			my $lkeys = $self->lkey;
			my $group = $self->stash->{group};
			my $template_dir = $self->stash->{template_dir};
			my $key_shablon = $self->stash->{key_shablon};
			my $keys = delete $params{keys} || {};
			my $exist_keys = keys %$keys || 0;
			my $access = $self->sysuser->access->{lkey};
			my $sys_user = $self->sysuser->sys;
			
			
			my $dir = $self->param('dir') || $self->stash->{anketa}->{dir};
			no strict "refs";
			no warnings;
			
			#use Data::Dumper;
			#die Dumper $lkeys;
			
			foreach my $k (sort {$$lkeys{$a}{settings}{rating} <=> $$lkeys{$b}{settings}{rating}} grep { $_ == $_ } keys %$lkeys) {
					
				my $lkey = $self->lkey(name => $k);
				# set file and dir views
				if(!$lkey->{settings}->{fileview} && !$lkey->{settings}->{dirview}){
					$lkey->{settings}->{fileview} = 1;
				}
				
				if($dir){
					$self->sysuser->access->{lkey}->{$k}->{w} = 0 if !$lkey->{settings}->{dirview};
				} else {
					$self->sysuser->access->{lkey}->{$k}->{w} = 0 if !$lkey->{settings}->{fileview};
				}

				$lkey->{settings}->{group} ||= 1;
				if ((!$exist_keys && $self->dbi->exists_keys(from => $params{table}, lkey => $k) or ($exist_keys && exists($keys->{$k})))
				&& (defined $lkey->{settings}->{group})
				&& ($access->{$k}->{$params{access}} || $sys_user)
				&& !$lkey->{settings}->{sys}){
					
					$self->stash->{'group_access_'.$lkey->{settings}->{group}} = 1;
				}
			}
			
			foreach my $k (sort {$$lkeys{$a}{settings}{rating} <=> $$lkeys{$b}{settings}{rating}} grep { $_ == $_ } keys %$lkeys) {

				my $lkey = $self->lkey(name => $k);
				
				$lkey->{settings}->{group} = 1 if $params{content};
				my $lkey_settings = $lkey->{settings};

				if ((!$exist_keys && $self->dbi->exists_keys(from => $params{table}, lkey => $k) or ($exist_keys && exists($keys->{$k})))
					&& (defined $lkey_settings->{group} &&  $group==$lkey_settings->{group})
					&& ($access->{$k}->{$params{access}} || $access->{$k}->{r} || $sys_user)
					&& !$lkey_settings->{sys}
					) {
					
					push @anketa_keys, $k;

					# Для совместимости с GG 8+
					$lkey->{settings}->{"template_".$key_shablon} ||= $lkey_settings->{"shablon_".$key_shablon} if $lkey_settings->{"shablon_".$key_shablon};
										
					# Если режим редактирование но есть права только на чтения, показываем эти поля в режиме чтения
					
					if((!$access->{$k}->{$params{access}} && !$sys_user) &&  $access->{$k}->{r}){
						$lkey->{settings}->{"template_".$key_shablon} = $templates->{r}->{$lkey_settings->{type}} if $templates->{r}->{$lkey_settings->{type}};
					}
					
					
					unless($lkey_settings->{"template_".$key_shablon}) {
						$lkey->{settings}->{"template_".$key_shablon} = $templates->{$params{access}}->{$lkey_settings->{type}} ? $templates->{$params{access}}->{$lkey_settings->{type}} : "field_input"; 
					}
					
					$lkey->{settings}->{"template_dir_".$key_shablon} ||= $template_dir;
					
					$self->def_doptable(lkey => $k, access => $params{access}, key_shablon => $key_shablon) if($lkey->{settings}->{type} eq 'table');
				}				
				
			}
			use strict "refs";
			use warnings;
			
			$self->stash->{listfield} = \@anketa_keys;
		}
	);
	
	$app->helper(
		def_listfield_doptable => sub {
			my $self = shift;
			my %params = (
				lkey	=> '',
				@_
			);
			
			my $lfield = delete $params{lkey};
			my $lkey_settings = $self->lkey(name => $lfield)->{settings};
			my $lkey_dop_table = $$lkey_settings{table};

			my @list_keys 				= split(/,/, $lkey_settings->{table_fields});
			my (@table_list_keys, @table_list_keys_header);
			push(@table_list_keys, "`$lkey_dop_table`.`ID`");
			push(@table_list_keys_header, "ID") unless $lkey_settings->{table_noindex};
			
			my $sch = 1;
			my @list_from_key = ();
			foreach my $k (@list_keys) {
				if ($self->dbi->exists_keys(from => $lkey_dop_table, lkey => $k) and ($self->app->sysuser->access->{lkey}->{$k}->{r} or ($$lkey_settings{sys} || $self->app->sysuser->sys))) {
					my $lkey = $self->lkey(name => $k );
					
					push @table_list_keys, "`".$lkey_dop_table."`.`$k`";
					push @table_list_keys_header, $k;
					if ($lkey->{type} eq "tlist") {
						if (!$lkey->{list_from_key}) {
							$self->stash->{"table_list_dp_$lfield"}->{table_from} .= " LEFT JOIN ".$lkey->{settings}->{list}." AS `tb".$sch."` ON ${lkey_dop_table}.`$k` = tb".$sch.".`ID`";
							push(@table_list_keys, "tb".$sch.".`name` AS `".$k."_name`");
							$sch++;
						} else {
							push @list_from_key, $k;
						}
					}
				}
			}
			$self->stash->{list_from_key} = \@list_from_key;
					
			$self->stash->{"total_col_list_dp_".$lfield}  += $#table_list_keys_header;
			$self->stash->{"listfield_dp_".$lfield} 		= \@table_list_keys;
			$self->stash->{"listfield_header_dp_".$lfield} = \@table_list_keys_header;			
		}
	);	
	
	$app->helper(
		def_doptable => sub {
			my $self = shift;
			my %params = (
				lkey	=> '',
				@_
			);
		
			#my $lkeys = $self->lkeys;
			my $lkey = delete $params{lkey};
			my $lkey_settings = $self->lkey( name => $lkey)->{settings};
			if($lkey_settings->{type} eq 'table' && $lkey_settings->{table} && $lkey_settings->{table_svf}){
				$self->lkey(name => $lkey)->{settings}->{table_fields} ||= 'ID,name';
				$self->stash->{"table_list_dp_$lkey"}->{table_from} = $lkey_settings->{table};
				my $sv  = "$$lkey_settings{table}.`$$lkey_settings{table_svf}`";
				my $svi = $self->stash->{ $$lkey_settings{table_svf} } || $self->stash->{'index'} ;
				
				#$self->get_keys(no_global => 1, type => ['lkey'], tbl => $lkey_settings->{table}, controller => $self->app->program->{key_razdel}, validator => 0);# if ($params{access} eq "w");
				$self->def_listfield_doptable(lkey => $lkey);
				
				my  $where  = "($sv = $svi OR ($sv LIKE '$svi=%' OR $sv LIKE '%=$svi=%' OR $sv LIKE '%=$svi'))";
		   			$where .= $lkey_settings->{where} if $lkey_settings->{where};
		   			if ($$lkey_settings{table_sortfield}){
			   			$where .= " ORDER BY $$lkey_settings{table}.`$$lkey_settings{table_sortfield}`";
			   			$where .= " $$lkey_settings{table_asc}" if $$lkey_settings{table_asc};
		   			}

		   		$self->def_tablelist_param( key => "pcol_doptable", lkey => $lkey, default => 25);
				$self->def_tablelist_param( key => "page_doptable", lkey => $lkey, default => 1);
				
				$self->stash->{total} = $self->dbi->getCountCol( from => $$lkey_settings{table}, where => "1 AND $where");
				$self->def_text_interval( total_vals => $self->stash->{total}, cur_page => $self->stash->{page_doptable}, col_per_page => $self->stash->{pcol_doptable}, postfix => $lkey );
				my $npage = $self->stash->{pcol_doptable} * ($self->stash->{page_doptable} - 1);
				
				if($self->stash->{'total_page_'.$lkey} < $self->stash->{page_doptable}){
					$self->send_params->{page_doptable} = 1;
					$self->def_tablelist_param( key => "page_doptable", lkey => $lkey, default => 1);
					$self->def_text_interval( total_vals => $self->stash->{total}, cur_page => $self->stash->{page_doptable}, col_per_page => $self->stash->{pcol_doptable}, postfix => $lkey );
					$npage = $self->stash->{pcol_doptable} * ($self->stash->{page_doptable} - 1);
				}
			
				$where .= " LIMIT $npage,".$self->stash->{pcol_doptable};

				my $items = $self->getHashSQL(
							select	=> join(",", @{$self->stash->{"listfield_dp_".$lkey}}),
							from	=> $self->stash->{"table_list_dp_".$lkey}->{table_from},
							where	=> "$$lkey_settings{table}.`ID` > 0 AND $where",
							stash 	=> "items_dp_$lkey", 
				);

				foreach my $k (@{$self->stash->{list_from_key}}) {

					$self->lkey(name => $k )->{type} = "s";
#					foreach my $item (@$items){
#						$self -> getArraySQL(select => "`name` AS `name_tmp`", from => $item->{$$self{lkeys}{$k}{list_from_key}}, where => $$self{"vals"."_dp_$params{lkey}"}{$id}{$k});
#					}
#					foreach my $id (@{$self{"get_id_array_dp_".$params{lkey}}}) {
#						$self -> getArraySQL(select => "`name` AS `name_tmp`", from => $$self{"vals"."_dp_$params{lkey}"}{$id}{$$self{lkeys}{$k}{list_from_key}}, where => $$self{"vals"."_dp_$params{lkey}"}{$id}{$k});
#						$$self{"vals"."_dp_$params{lkey}"}{$id}{$k} = $$self{name_tmp};
#					}
				}
				my (@buttons_key)  = split(/,/, $lkey_settings->{"table_buttons_key_".$params{access}});
				$self->stash->{"buttons_key_dp_".$lkey} = \@buttons_key;
				$self->stash->{confirm_delete} = "Вы действительно хотите удалить запись?";				
				
			}
		}
	);
	
	$app->helper(
		def_listfield_read => sub {
			my $self = shift;
			my %params = @_;
			
			my $lkeys = $self->lkey;	
			my $group = $self->stash->{group};
			my $template_dir = $self->stash->{template_dir};
			my $key_shablon = $self->stash->{key_shablon};
			my $sys_user = $self->sysuser->sys;
			my $access = $self->sysuser->access->{lkey};
			
			foreach my $k (sort {$$lkeys{$a}{settings}{rating} <=> $$lkeys{$b}{settings}{rating}} grep { $_ == $_ } keys %$lkeys) {
					
				my $lkey = $self->lkey(name => $k);
				$lkey->{settings}->{group} ||= 1;
				if ((!$params{keys_hashref} && $self->dbi->exists_keys(from => $params{table}, lkey => $k) or ($params{keys_hashref} && exists($params{keys_hashref}->{$k})))
				&& (defined $lkey->{group})
				&& ($access->{$k}->{$params{access}} || $sys_user)
				&& !$lkey->{settings}->{sys}){
					my $group = $lkey->{settings}->{group};
					
					push( @{ $self->stash->{'listfield_'.$group} }, $k );
					
					$lkey->{settings}->{"template_".$key_shablon} ||= $lkey->{settings}->{"shablon_".$key_shablon} if $lkey->{settings}->{"shablon_".$key_shablon};
					unless($lkey->{settings}->{"template_".$key_shablon}) {
						$lkey->{settings}->{"template_".$key_shablon} = $templates->{$params{access}}->{$lkey->{settings}->{type}} ? $templates->{$params{access}}->{ $lkey->{settings}->{type} } : "field_input"; 
					}
					
					$lkey->{settings}->{"template_dir_".$key_shablon} ||= $template_dir;
					
					$self->def_doptable(lkey => $k, access => $params{access}, key_shablon => $key_shablon) if($lkey->{settings}->{type} eq 'table');
				}				
			}
		}
	);
	
	$app->helper(
		def_listfield_filter => sub {
			my $self = shift;
			my %params = @_;
			
			my $lkeys = $self->lkey;	
			my $group = $self->stash->{group};
			my $template_dir = $self->stash->{template_dir};
			my $key_shablon = $self->stash->{key_shablon};
			
			my @anketa_keys  = ();
			
			foreach my $k (sort {$$lkeys{$a}{settings}{rating} <=> $$lkeys{$b}{settings}{rating}} grep { $_ == $_ } keys %$lkeys) {
				my $lkey = $self->lkey(name => $k);
				
				if ($self->dbi->exists_keys(from => $params{table}, lkey => $k)
				&& $lkey->{settings}->{filter}
				&& ($self->sysuser->access->{lkey}->{$k}->{r} || $lkey->{settings}->{sys} || $self->sysuser->sys)){
					push(@anketa_keys, $k);
					
					$lkey->{settings}->{"template_".$key_shablon} ||= $lkey->{settings}->{"shablon_".$key_shablon} if $lkey->{settings}->{"shablon_".$key_shablon};
					unless($lkey->{settings}->{"template_".$key_shablon}) {
						$lkey->{settings}->{"template_".$key_shablon} = $templates->{$params{access}}->{$lkey->{settings}->{type}} ? $templates->{$params{access}}->{$lkey->{settings}->{type}} : "field_input"; 
					}
					
					$lkey->{settings}->{"template_dir_".$key_shablon} ||= $template_dir;
				}				
			}
			$self->stash->{listfield} = \@anketa_keys;

		}
	);	

	$app->helper(
		def_listfield_delete => sub {
			my $self = shift;
			my %params = @_;
			
			my $lkeys = $self->lkey;
			my @anketa_keys  = ();
			no strict "refs";
			no warnings;
			
			foreach my $k (sort {$$lkeys{$a}{settings}{rating} <=> $$lkeys{$b}{settings}{rating}} grep { $_ == $_ } keys %$lkeys) {
				if ($self->dbi->exists_keys(from => $params{table}, lkey => $k)){
					push(@anketa_keys, $k);
				
				}
			}
			$self->stash->{listfield} = \@anketa_keys;

			use strict "refs";
			use warnings;	
		}
	);	

	$app->helper(
		lfield_folder => sub {
			my $self = shift;
			my %params = (
				lfield	=> '',
				folder	=> '',
				@_
			);
			return '' unless $params{lfield};
			
			my $folder = $params{folder} || '';
			
			#use Data::Dumper;
			#die Dumper $self->app->lkeys;
			#die $self->app->lkeys->{$self->stash->{controller}}->{'pict'};
			unless($folder){
				$folder = $self->lkey(name => $params{lfield}, %params )->{settings}->{folder};
				if(my $mini = $self->lkey(name => $params{lfield}, %params )->{settings}->{mini}){
					my @first_mini = split(',', $mini);
					$first_mini[0] =~ s{~[\w]+$}{};
					$folder .= $first_mini[0].'_';
				}
				
				$folder ||= $self->stash->{folder} if $self->stash->{folder};
			}
			
			return $folder;
		}
	);	
	
	$app->helper(
		backup_doptable => sub {
			my $self = shift;
			my %params = @_;
			return unless $self->stash->{dop_table};
			
			$self->stash->{list_table_backup} = $self->stash->{list_table};
			return $self->stash->{list_table} = $self->stash->{dop_table};
		}
	);	

	$app->helper(
		restore_doptable => sub {
			my $self = shift;
			return unless $self->stash->{list_table_backup};
			
			my $lfield = $self->stash->{lfield};
			$self->stash->{index_old} = $self->stash->{index}; 
			
			$self->stash->{index} = $self->stash->{ $self->lkey( name => $lfield )->{settings}->{table_svf} };
			return $self->stash->{list_table} = $self->stash->{list_table_backup};
		}
	);		
}

1;