package GG::Admin::Filemanager;

use utf8;

use Mojo::Base 'GG::Admin::AdminController';

#use Libs::API;
use GG::Admin::Filemanager::elFinder;

sub _init{
	my $self = shift;

	$self->def_program('filemanager');
	$self->get_keys( type => ['lkey', 'button'], controller => $self->app->program->{key_razdel});

	my $config = {
		controller_name	=> $self->app->program->{name},
	};

	$self->stash($_, $config->{$_}) foreach (keys %$config);
}

sub body{
	my $self = shift;

	my $do = $self->param('do');

	given ($do){

		when('elfinder_popup') 				{ $self->elfinder_popup; }
		when('elfinder') 					{ $self->elfinder; }
		when('mainpage') 					{ $self->mainpage; }

		when('menu_button') 				{
			$self->_init;

			$self->def_menu_button(
				key 		=> $self->app->program->{menu_btn_key},
				controller	=> $self->app->program->{key_razdel},
			);
		}

		default							{

			my $host = $self->host;
			$host .= ':3000' if ($host eq 'localhost');

			my %opts = (
				'URL'           => 'http://'.$host.'/userfiles/',
				'rootAlias'     => 'userfiles',
				'root'			=> $self->app->static->paths->[0].'userfiles',
				'app'			=> $self,
				'DirConf'       => 'Config', # Каталог с конфигурацией
			);

			#my $API = new Libs::API('web.cfg'); # Нужно для выдачи Content-Type для JSON

			my $elFinder = new GG::Admin::Filemanager::elFinder(%opts);

			$elFinder->run(  %{$self->req->params->to_hash} );

			unless( $elFinder->{rendered} ){
				$self->render( json => $elFinder->{RES} );
			}

		}
	}
}

sub elfinder{
	my $self = shift;

	$self->render(
		template	=> 'Admin/Filemanager/elfinder'
	);
}

sub elfinder_popup{
	my $self = shift;

	$self->render(
		template	=> 'Admin/Filemanager/elfinder_popup'
	);
}

sub mainpage{
	my $self = shift;

	$self->_init;

	my $body = <<HEAD;
		<iframe src="/admin/filemanager/body?do=elfinder" style="border:0px;" width="100%" height="100%;"></iframe>
HEAD

	my $content = $self->render_to_string( template => 'Admin/page_admin_main', body => $body);

	my $items = [
		{
			type		=> 'loadjson',
			divid		=> 'menuButton',
			url			=> '/admin/filemanager/body?do=menu_button'
		},
		{
			type		=> 'settabtitle',
			id			=> 'center',
			title		=> 'Файлменеджер'
		}
	];

	my $result = {
		content	=> $body,
		items	=> $items,
	};

	$self->render( json => $result);

}



1;
