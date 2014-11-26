package GG::Content::Faq;

use utf8;

use Mojo::Base 'GG::Content::Controller';

sub list{
	my $self = shift;
	my %params = (
		limit 	=> $self->get_var(name => 'faq_limit', controller => 'faq') || 0,
		page	=> $self->param('page') || 1,
		@_
	);

	my $where = " `active`='1' ORDER BY `updated_at` DESC ";

	if($params{limit}){
		my $count = $self->dbi->getCountCol(from => 'data_faq', where => $where);
		$self->def_text_interval( total_vals => $count, cur_page => $params{page}, col_per_page => $params{limit} );
		$params{npage} = $params{limit} * ($params{page} - 1);
		$where .= " LIMIT $params{npage},$params{limit} ";
	}

	my $items = $self->dbi->query("SELECT * FROM `data_faq` WHERE $where")->hashes;
	return $self->render_not_found unless my $item = $self->dbi->query("SELECT * FROM `texts_main_".$self->lang."` WHERE `alias`='faq' AND `viewtext`=1")->hash;
	$self->stash->{'faq_form_errors'} = {};
	# Добавление нового отзыва
	if($self->req->method eq 'POST'){
		my $send_params = $self->req->params->to_hash;
		my $JSON = {};

		my $fields = {
			author_name 		=> {
				label 			=> 'Ваше имя',
				required 		=> 1,
				error_text 	=> 'Укажите Ваше имя',
			},
			email 		=> {
				label 			=> 'Номер телефона',
				required 		=> 1,
				error_text 		=> 'Укажите контактный номер телефона',
			},
			phone 		=> {
				label 			=> 'Электронная почта',
				required 		=> 0,
				error_text 		=> 'Укажите электронную почту',
			},
			name 		=> {
				label 			=> 'Ваш вопрос',
				required 		=> 1,
				error_text 		=> 'Укажите текст сообщения',
			},
		};

		foreach my $f (keys %$fields){
			if( $send_params->{$f} ){
				$self->stash->{ $f } = $send_params->{$f}

			}
			elsif($fields->{ $f }->{required}){
				$self->stash->{'faq_form_errors'}->{$f} = $JSON->{errors}->{$f} = $fields->{ $f }->{'error_text'};
			}
		}

		# check captcha
		if(!$send_params->{captcha} or $send_params->{captcha} != 31){
			$self->stash->{'faq_form_errors'}->{'captcha'} = $JSON->{errors}->{'captcha'} = 'Похоже вы робот';
		}

		if(!keys %{ $self->stash->{'faq_form_errors'} }){
			$self->dbi->insert_hash('data_faq', {
				author_name 	=> $self->stash->{'author_name'},
				email 			=> $self->stash->{'email'},
				phone		 	=> $self->stash->{'phone'},
				name 			=> $self->stash->{'name'},
				created_at 		=> ' NOW() ',
				active 			=> 0,
			});
			my $email_body = 	$self->render_mail(
				template	=> "Faq/_admin"
			);

			eval{
				$self->mail(
					to      => $self->get_var(name => 'email_admin', controller => 'global', raw => 1),,
					subject => 'Получен новый вопрос с сайта '.$self->site_name,
					data    => $email_body,
				);
			};

			$JSON->{message_success} = $self->render_to_string(template => 'Faq/_message_success');
			return $self->render(
					json => $JSON,
				)
		}else{
			$JSON->{message_success} = '';
			return $self->render(
				json => $JSON,
			)
		}
	}

	$self->render(
		items		=> $items,
		item 		=> $item,
		template	=> 'Faq/list',
	);
}

1;
