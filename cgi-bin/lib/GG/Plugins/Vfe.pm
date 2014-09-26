package GG::Plugins::Vfe;

# Visual Front-end Editor v. 3
# Code: Nikita Korobochkin
# Date: 18.07.2012

use utf8;

use Mojo::Base 'Mojolicious::Plugin';

use Digest::MD5 qw();

sub register {
	my ($self, $app, $conf) = @_;

	$app->hook(	before_dispatch => sub {
		my ($self) = @_;
		$self->stash->{vfe} = 1 if $self->cookie('vfe');
		$self->stash->{admin_login} = $self->cookie('admin_login') ? $self->cookie('admin_login') : '%undefined%';
		$self->stash->{vfe_salt} = 'gordonfreeman';
	});

	$app->helper(
		vfe_text_block => sub {
			my $self   = shift;
			return unless my $alias  = shift;
      
      return 'vfe block \'$alias\' not found' 
        unless my $block = $self->app->dbi->query("SELECT ID,alias,text FROM `data_vfe_blocks_ru` WHERE `alias`='$alias'")->hash;
        
      my $sha_id = 'blocks'.$block->{ID}.'-'.Digest::MD5::md5_hex('blocks'.$block->{ID}.$self->stash->{vfe_salt});
      
			if ($self->cookie('vfe')){
        my $lang = $self->lang;
				return qq~
        <div id="$$block{ID}-$$block{alias}" data-lang="$lang" class="vfe-editablecontent">
          <ins class="vfe-dummy" data-vfe-textid="$sha_id" style="display:none;"></ins>
          $block->{text}
        </div>
        ~
			} else {
				return $block->{text};
			}
		}
	);

	$app->helper(
		vfe_text_main => sub {
			my $self   = shift;
			my %params = @_;

			return "Не указан alias или ID" if (!$params{alias} && !$params{id});

			$params{id}     = vfe_getIDbyAlias($self, $params{alias}) unless $params{id};
			$params{alias}  = vfe_getAliasByID($self, $params{id}) unless $params{alias};
      return '' unless $params{alias};
      
			my $sha_id = $params{id}.'-'.Digest::MD5::md5_hex($params{id}.$self->stash->{vfe_salt});

			if ($self->cookie('vfe')) {
        my $lang = $self->lang;
				return qq~
        <div id="editablecontent" data-lang="$lang" class="vfe-editablecontent">
          <ins class="vfe-dummy" data-vfe-textid="$sha_id" style="display:none;"></ins>~.
          $self->text_by_alias($params{alias}).
          qq~</div>~
			} else {
				return $self->text_by_alias($params{alias});
			}

		}
	);

	$app->helper(
		vfe_template => sub {

			my $self   = shift;
			my %params = @_;

			return "Указанный шаблон не существует." unless $params{name};

			my $path = $self->app->home->rel_dir("/templates/Vfe/templates/".$params{name}.'.html');

			if (my $data = $self->file_read_data(path => $path)) {

				# Есть ли предыдущии версии? (Для кнопки Undo). Только если администратор.
				my $revisions = 0;
				if ($self->cookie('vfe')) {
					if (opendir (DIR, $self->app->home->rel_dir("/templates/Vfe/backups"))) {
						while (my $file = readdir(DIR)) {
							$revisions++ if $file =~ /$params{name}\__/;
						}
						closedir(DIR);
					}
				}

				my $plugins = $params{plugins} ? $params{plugins} : '';

				my $template = $params{name}.'-'.Digest::MD5::md5_hex($params{name}.$self->stash->{vfe_salt});

				if ($self->cookie('vfe')) {
					return '<ins class="vfe-dummy" data-vfe-template="'.$template.'" data-vfe-revisions="'.$revisions.'" data-vfe-revision="'.($revisions+1).'" data-vfe-plugins="'.$plugins.'" style="display:none;"></ins>'
					.$data;
				} else {
					return $data;
				}
			} else {
				return "Невозможно прочитать указанный шаблон.";
			}

		}
	);

	$app->routes->post("/admin/vfe-text-save")->to( cb => sub{
		my $self   = shift;
		my %params = @_;
		my $vals = {
			error   => '',
		};

		unless ($self->admin_getUser) {
			$vals->{error} = 'Ошибка авторизации.';
			return $self->render( json => $vals );
		}

		my $content = $self->param('content');
		my $id = $self->param('id');
		if ($content && $id) {
      
			# Проверка соли
			unless ($id = vfe_checkTemplate($id,$self->stash->{vfe_salt})) {
				$vals->{error} = "Ай-ай-ай! :)";
				return $self->render( json=>$vals );
			}

			$content =~ s/^\n//;
			$content =~ s/\n\s+$/\n/g;
			$content =~ s/\s+/ /g;
			$content =~ s/\r\n/\n/g;
			chomp($content);
      
      my $lang = $self->param('lang') || 'ru';
			# Load controller
      # vfe content blocks
      if(substr($id, 0, 6) eq 'blocks'){
        my $block_id = substr($id, 6);
        $self->dbi->dbh->do("UPDATE `data_vfe_blocks_$lang` SET text=?,sysuser_id=?,updated_at=NOW() WHERE ID=?", 
          undef, $content, $self->app->sysuser->{ID}, $block_id);
      }
      else {
  			my $e = Mojo::Loader->load('GG::Admin::AdminController');
  			if(!ref $e and !$e){
  				$self->app->dbi->update_hash(
  					'texts_main_'.$lang,
  					{
  					text => $content
  					},
  					"`ID`='$id'"
  				);
  			} else {
  				return $self->render( text => "Ошибка при сохранении: ".$e);
  			}
      }

			return $self->render( text => "Текст успешно сохранен.");

		}

	})->name('vfe-text-save');

	$app->routes->route("admin/vfe-css-read")->to( cb => sub{

		my $self   = shift;
		my %params = @_;

		my $vals = {
			error   => '',
		};

		unless ($self->admin_getUser) {
			$vals->{error} = 'Ошибка авторизации.';
			return $self->render( json=>$vals );
		}

		my $path = $self->app->home->rel_dir("/../css/style.css");

		if (my $data = $self->file_read_data(path => $path)) {
				$vals->{content} = $data;
				return $self->render( json=>$vals );
		} else {
				$vals->{error} = "Невозможно открыть файл со стилями";
				return $self->render( json=>$vals );
		}

	})->name('vfe-css-read');

	$app->routes->route("admin/vfe-undo")->to( cb => sub{

		my $self   = shift;
		my %params = @_;

		my $vals = {
			error   => '',
		};

		unless ($self->admin_getUser) {
			$vals->{error} = 'Ошибка авторизации.';
			return $self->render( json=>$vals );
		}

		my $template = $self->param('template');
		my $revision = $self->param('revision');

		# Проверка соли
		unless ($template = vfe_checkTemplate($template,$self->stash->{vfe_salt})) {
			$vals->{error} = "Ай-ай-ай! :)";
			return $self->render( json=>$vals );
		}

		unless ( opendir (DIR, $self->app->home->rel_dir("/templates/Vfe/backups")) ) {
			$vals->{error} = "Невозможно открыть папку ревизий. Ошибка: ".$!;
			return $self->render( json=>$vals );
		}
		my $revct = 0;
		while (my $file = readdir(DIR)) {
			$revct++ if $file =~ /$template\__/;
		}
		closedir(DIR);

		$revision = $revision ? ($revision-1) : $revct;

		if ($revision > 0) {
			my $path = $self->app->home->rel_dir("/templates/Vfe/backups/".$template."__".$revision.".txt");

			if (my $data = $self->file_read_data(path => $path)) {
				$data =~ s/\r\n/\n/g;
				$vals->{content} = $data;
				$vals->{revision} = $revision;

				my @stat = stat($path);
				my @time = localtime($stat[9]);
				$time[5] += 1900; $time[5] = sprintf("%02d", $time[5] % 100);
				$time[4] = sprintf("%02d", $time[4]); $time[3] = sprintf("%02d", $time[3]); $time[2] = sprintf("%02d", $time[2]);
				$time[1] = sprintf("%02d", $time[1]); $time[0] = sprintf("%02d", $time[0]);
				$vals->{datetime} = qq~$time[3].$time[4].$time[5] $time[2]:$time[1]:$time[0]~;

				return $self->render( json=>$vals );
			} else {
				$vals->{error} = "Невозможно открыть ревизию №".$revision;
				return $self->render( json=>$vals );
			}
		} else {
			$vals->{error} = "Предыдущих состояний не найдено";
			$vals->{error_val} = 1001;
			return $self->render( json=>$vals );
		}

	})->name('vfe-undo');


	$app->routes->route("admin/vfe-redo")->to( cb => sub{

		my $self   = shift;
		my %params = @_;

		my $vals = {
			error   => '',
		};

		unless ($self->admin_getUser) {
			$vals->{error} = 'Ошибка авторизации.';
			return $self->render( json=>$vals );
		}

		my $template = $self->param('template');
		my $revision = $self->param('revision');

		# Проверка соли
		unless ($template = vfe_checkTemplate($template,$self->stash->{vfe_salt})) {
			$vals->{error} = "Ай-ай-ай! :)";
			return $self->render( json=>$vals );
		}

		unless ( opendir (DIR, $self->app->home->rel_dir("/templates/Vfe/backups")) ) {
			$vals->{error} = "Невозможно открыть папку ревизий. Ошибка: ".$!;
			return $self->render( json=>$vals );
		}
		my $revct = 0;
		while (my $file = readdir(DIR)) {
			$revct++ if $file =~ /$template\__/;
		}
		closedir(DIR);

		$vals->{revisions} = $revct;
		$revision = $revision ? ($revision+1) : 0;

		if ($revision && $revision <= $revct) {
			my $path = $self->app->home->rel_dir("/templates/Vfe/backups/".$template."__".$revision.".txt");
			if (my $data = $self->file_read_data(path => $path)) {
				$data =~ s/\r\n/\n/g;
				$vals->{content} = $data;
				$vals->{revision} = $revision;

				my @stat = stat($path);
				my @time = localtime($stat[9]);
				$time[5] += 1900; $time[5] = sprintf("%02d", $time[5] % 100);
				$time[4] = sprintf("%02d", $time[4]); $time[3] = sprintf("%02d", $time[3]); $time[2] = sprintf("%02d", $time[2]);
				$time[1] = sprintf("%02d", $time[1]); $time[0] = sprintf("%02d", $time[0]);
				$vals->{datetime} = qq~$time[3].$time[4].$time[5] $time[2]:$time[1]:$time[0]~;
			} else {
				$vals->{error} = "Невозможно открыть ревизию №".$revision;
			}
		} else {
			$vals->{error} = "Следующих состояний не найдено";
			$vals->{error_val} = 1001;
		}

		return $self->render( json=>$vals );

	})->name('vfe-redo');


	$app->routes->route("admin/vfe-save")->to( cb => sub{

		my $self   = shift;
		my %params = @_;

		my $vals = {
			error   => '',
		};

		unless ($self->admin_getUser) {
			$vals->{error} = 'Ошибка авторизации.';
			return $self->render( json=>$vals );
		}

		my $template = $self->param('template');
		my $content = $self->param('content');

		# Проверка соли
		unless ($template = vfe_checkTemplate($template,$self->stash->{vfe_salt})) {
			$vals->{error} = "Ай-ай-ай! :)";
			return $self->render( json=>$vals );
		}

		my $path = $self->app->home->rel_dir("/templates/Vfe/templates/".$template.'.html');

		if (my $data = $self->file_read_data(path => $path)) {

			$content =~ s/^\n//;
			$content =~ s/\n\s+$/\n/g;
			$content =~ s/\s+/ /g;
			$content =~ s/\r\n/\n/g;
			chomp($content);

			my $revisions = 1;

			# Ревизии
			unless ( -e $self->app->home->rel_dir("/templates/Vfe/backups") ) {
				unless (mkdir($self->app->home->rel_dir("/templates/Vfe/backups"), 0777)) {
					$vals->{error} = "Невозможно создать папку ревизий. Ошибка: ".$!;
					return $self->render( json=>$vals );
				}
			} else {
				unless (opendir (DIR, $self->app->home->rel_dir("/templates/Vfe/backups"))) {
					$vals->{error} = "Невозможно открыть папку ревизий. Ошибка: ".$!;
					return $self->render(json=> $vals );
				}
				while (my $file = readdir(DIR)) {
					$revisions++ if $file =~ /$template\__/;
				}
				closedir(DIR);

				my $ok = $self->file_save_data( data => $data, path => $self->app->home->rel_dir("/templates/Vfe/backups/".$template."__".$revisions.".txt"));

				unless ($ok) {
					$vals->{error} = 'Ошибка при сохранении ревизии.';
					return $self->render( json=>$vals );
				}

				$vals->{revisions} = $revisions;
			}
			# Конец ревизий

			unless ($self->file_save_data( data => $content, path => $path)) {
				$vals->{error} = 'Ошибка при сохранении.';
				return $self->render( json=>$vals );
			}

			$self->render( json=>$vals );

		} else {

			$vals -> {error} = "Ошибка чтения шаблона.";
			return  $self->render( json=>$vals );

		}

	})->name('vfe-save');


}

sub vfe_checkTemplate() {

	my $template = shift;
	my $salt = shift;
	my $sha;

	return 0 unless $template;

	($template, $sha) = split(/-/, $template);

	if ($sha eq Digest::MD5::md5_hex($template.$salt)) {
		return $template;
	} else {
		return 0;
	}

}

sub vfe_getIDbyAlias() {

	my $self   = shift;
	my $alias = shift;

	return 0 unless $alias && $self;

	my $item = $self->app->dbi->query("SELECT `ID` FROM `texts_main_ru` WHERE `alias`='$alias'")->hash;
	return $item ? $item->{ID} : '';

}

sub vfe_getAliasbyID() {

	my $self   = shift;
	my $ID = shift;

	return 0 unless $ID && $self;

	my $item = $self->app->dbi->query("SELECT `alias` FROM `texts_main_ru` WHERE `ID`='$ID'")->hash;
	return $item ? $item->{alias} : '';

}


1;
