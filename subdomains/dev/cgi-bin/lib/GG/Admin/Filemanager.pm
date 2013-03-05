package GG::Admin::Filemanager;

use utf8;

use Mojo::Base 'GG::Admin::AdminController';

#use Libs::API;
use GG::Admin::Filemanager::elFinder;

sub _init{
	my $self = shift;
	
	$self->def_program('texts');
	
}

sub body{
	my $self = shift;
	
	my $do = $self->_init;

	my $host = $self->req->url->{base}->{host};
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

	$self->render_json( $elFinder->{RES} );
}



1;
