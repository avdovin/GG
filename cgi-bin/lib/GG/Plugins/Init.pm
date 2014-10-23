package GG::Plugins::Init;

use utf8;

use Mojo::Base 'Mojolicious::Plugin';

sub register {
	my ($self, $app) = @_;

	$app->helper(_setup_inc => sub {
		my $self = shift;
		my $perl5lib = shift;

		return unless $perl5lib;

		push @INC, $_ for (ref $perl5lib eq 'ARRAY' ? @{$perl5lib} : $perl5lib);
	});

	$app->plugin( charset => { charset => 'UTF-8' } );

	# Add new MIME type
	$app->types->type(xls => 'application/vnd.ms-excel');
	# Add secret
	$app->secrets(['It is a good day to die ...']);

	my $conf = $app->plugin('Config', {	file      => 'config', 	default   => {} });
	$app->static->paths([$conf->{static_path}]);

  $app->_setup_inc($conf->{perl5lib});

	$app->plugin('util_helpers');
	$app->plugin('http_cache');
	$app->plugin('crypt');
	$app->plugin('dbi', $conf );

	# Load plugins from config
	foreach (@{$conf->{plugins}}){
		$app->plugin($_, $conf);
	}

	$app->plugin('vfe') if $conf->{'vfe_enabled'};

	if ($conf->{'mail_type'} eq 'smtp'){
		$app->plugin(mail => {
			from     => $conf->{mail_from_addr},
			encoding => 'base64',
			how      => 'smtp',
			howargs  => [
				$conf->{'smtp_server'},
				Port 	 		=> $conf->{'smtp_port'} || '587',
				AuthUser 	=> $conf->{'smtp_login'},
				AuthPass 	=> $conf->{'smtp_password'},
        	],
			type	 => 'text/html;charset=utf-8',
		});
	}else{
		$app->plugin(mail => {
			from     => $conf->{mail_from_addr},
			encoding => 'base64',
			how      => 'sendmail',
			howargs  => [ '/usr/sbin/sendmail -t' ],
			type	 => 'text/html;charset=utf-8',
		});
	};

	# языковые версии сайта
	if($conf->{langs}){
		$app->plugin('I18N' =>  {
			support_url_langs 	=> $conf->{lang_supported},
			default 			=> $conf->{lang_default},
			namespace 			=> 'GG::I18N',
			no_header_detect 	=> 1,
			exclude_contains 	=> [qw(admin)],
		});
	}

	$ENV{MOJO_MAX_MESSAGE_SIZE} = $conf->{upload_maxchanksize};

	# Pipeline assets
	$app->plugin('AssetPack', {
		minify 			=> $conf->{pipeline_minify} && $app->mode eq 'production',
	});

	$app->hook(before_dispatch => sub {
		my $self = shift;

		# Ignore static files
		return if $self->res->code;

		$self->stash->{lang} ||= $conf->{lang_default};

    if($self->app->mode eq 'development'){
      $self->app->log->level('debug');
      BEGIN {
        $ENV{'MOJO_I18N_DEBUG'} = 1;
        #$ENV{'MOJO_ASSETPACK_DEBUG'} = $ENV{'MOJO_ASSETPACK_NO_CACHE'} = 1;
      };
    }
    else {
      $self->app->log->level('error');
      BEGIN {
        $ENV{'MOJO_I18N_DEBUG'} = 0;
        #$ENV{'MOJO_ASSETPACK_DEBUG'} = $ENV{'MOJO_ASSETPACK_NO_CACHE'} = 0;
      };
    }

    # if(my $mode = $self->get_var( name => 'mode', controller => 'global', raw => 1 )){
    #   $self->app->mode( $ENV{MOJO_MODE} = $mode );
    #
    #   if($mode eq 'development'){
    #     $self->app->log->level('debug');
    #     BEGIN {
    #       $ENV{MOJO_I18N_DEBUG} = 0
    #     };
    #   }
    #   else {
    #     $self->app->log->level('error');
    #     BEGIN {
    #       $ENV{MOJO_I18N_DEBUG} = 1
    #     };
    #   }
    # }

		# --- SEO 301 redirect to none www domain ---------
		my $url = $self->req->url->clone;
		my $host = $url->base->host || '';

		if( !$conf->{'www_prefix'} && $host =~ /^www\./ or $conf->{'www_prefix'} && $host !~ /^www\./ ){
			$host =~ s{^www\.}{};

			$url->base->host($host);
			my $res = $self->res;
			$res->code(301);
			$res->headers->location($url->to_abs);
			$res->headers->content_length(0);
			$self->rendered;
			return;
		}
		# --- END OF SEO MODULE --------------------------

		# remove url trailing slash - /about/ => /about
		if( $self->req->url->path->trailing_slash ){
			next if $self->req->url->path->contains('/admin');

			my $path = $self->req->url->path->to_string;
			$path =~ s{\/$}{}gi;

			$self->res->code(301);
			return $self->redirect_to($path);
		}

		# --- REDIRECT MODULE ---------------------------------
		my $path = $url->to_string;
		#$path =~ s{\/$}{}gi if( $url->path->trailing_slash );
    # Ignore static files
    unless( $self->res->code ){
  		if (
  			my $redirect_path = Mojo::Path->new($self->dbi->query("SELECT `last_url` FROM `data_redirects` WHERE `source_url` LIKE '$path' LIMIT 0,1")->list)->to_string
  				){
				my %qs=();
				if ($redirect_path =~ /\%3F(\S*)/){
					foreach (split('\&',$1)){
						my ($name,$val) = split('=',$_);
						$qs{$name} = $val;
					}
					$redirect_path =~ s/\%3F$1//;
				}
				$self->res->code(301);
				return $self->redirect_to($self->url_for($redirect_path)->query(\%qs) );
  		}
    }
		# --- END OF REDIRECT MODULE --------------------------



		$self->req->url->base( Mojo::URL->new(q{/}) );
		$self->req->url->scheme($conf->{'protocol'});

		foreach my $k (keys %{$conf->{pipeline_assets}}){
			if($conf->{pipeline}){
				$self->asset($k => @{ $conf->{pipeline_assets}->{$k} } );
				#$self->asset($k => $conf->{pipeline_assets}->{$k} );
			}
			else {
				foreach my $sources (@{ $conf->{pipeline_assets}->{$k} }){
					$sources =~ /^(.+)\.(\w+)$/;
					$self->css_files("$1.$2") if $2 eq 'css';
					$self->js_files("$1.$2") if $2 eq 'js';
				}
			}
		}

		if( my $cck = $self->app->sessions_check( cck => $self->session('cck') || '', user_id => $self->cookie('user_id') || 0 ) ){
		  $self->session( cck => $cck );
		}
	});

	$app->hook(after_render => sub {
		my ($self, $output, $format) = @_;

		if($conf->{minify_html} && $self->app->mode eq 'production'){
			eval("use HTML::Packer");
			my $packer = HTML::Packer->init();
			$$output = $packer->minify( $output, {
				remove_comments 	=> 1
			});
		}
	});

	$app->hook(before_render => sub {
		my ($self, $args) = @_;

		#return unless my $template = $args->{template};

		#$self->js_controller() if ($template eq '_footer');
	});
};

1;