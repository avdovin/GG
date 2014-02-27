package GG::Content::Faq;

use utf8;

use Mojo::Base 'GG::Content::Controller';

sub list{
	my $self = shift;
	my %params = (
		limit 	=> $self->get_var(name => 'faq_limit', controller => 'faq') || 5,
		page	=> $self->param('page') || 1,
		@_
	);
	
	my $where = " `active`='1' ORDER BY `rdate` DESC ";
	
	if($params{limit}){
		my $count = $self->dbi->getCountCol(from => 'data_faq', where => $where);
		$self->def_text_interval( total_vals => $count, cur_page => $params{page}, col_per_page => $params{limit} );
		$params{npage} = $params{limit} * ($params{page} - 1);
		$where .= " LIMIT $params{npage},$params{limit} "; 
	}
	
	my $items = $self->dbi->query("SELECT * FROM `data_faq` WHERE $where")->hashes;
	
	my %FORM = ();

	# Добавление нового отзыва
	if($self->req->method eq 'POST'){
		$self->get_keys( type => ['lkey'], key_program => 'faq');

		my $send_params = $self->app->send_params;
		my $lkeys = $self->app->lkeys->{'faq'};
		
		delete @{$self->stash}{ qw(form_error) };

		foreach (keys %$lkeys){
	    	if($lkeys->{$_}->{settings}->{saveform}){
	    		my $lkey = $lkeys->{$_}->{lkey};
	
	    		$FORM{ $lkey } = {
	    			value	=> '',
	    			error	=> ''
	    		};
	    		
	    		if($send_params->{ $lkey }){
	    			$FORM{ $lkey }->{value} = $send_params->{ $lkey };
	
	    		} elsif($lkeys->{$_}->{settings}->{obligatory} && !$send_params->{ $lkey }){
					$FORM{ $lkey }->{error} = 'Не заполнено обязательное поле';
					$self->stash('form_error', 1);
					    			
	    		}
	    	}
	    }
	    
	    if(!$self->stash('form_error')){
	    	$self->save_info(table => 'data_faq');
	    	$self->stash->{success} = 1;

			my $email_body = 	$self->render_mail(	form		=> \%FORM,
		   											template	=> "Faq/user" );
		  	
		  	eval{										
				$self->mail(
			    	to      => $self->get_var(name => 'email_admin', controller => 'global', raw => 1),,
		    		subject => 'Получен новый вопрос с сайта '.$self->get_var(name => 'site_name', controller => 'global', raw => 1),,
		    		data    => $email_body,
		  		);
		  	};	
	    }		    
	    
	}
	
	$self->render(
					items		=> $items,
					form		=> \%FORM,
					template	=> 'Faq/list',
	);	
}

1;
