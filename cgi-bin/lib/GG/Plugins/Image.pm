package GG::Plugins::Image;

use utf8;

use Mojo::Base 'Mojolicious::Plugin';
use experimental 'smartmatch';

our $VERSION = '1';

BEGIN {
  die 'Module Image::Magick not properly installed'
    unless eval { require Image::Magick; 1 };
}

my @EXT = qw(png jpg jpeg gif);

sub register {
  my ($self, $app, $opts) = @_;

  my $QUALITY = $app->config->{'images_quality'} || 85;

  $opts ||= {};

  $app->log->debug("register GG::Plugins::Image");

# usage: p (value => 'pict.jpg', size => '320x320',[controller => 'catalog', tbl => 'dtbl_catalog_item_images'])
# return '/image/catalog/items/dopimgs/320x320_pict.jpg'
  $app->helper(
    p => sub {
      my $self   = shift;
      my %params = (
        lkey       => 'pict',
        size       => '',
        value      => '',                               # required
        controller => lc($self->stash('controller')),
        tbl        => '',
        table      => '',
        @_
      );
      $params{table} ||= $params{tbl};

      my $pict = $self->lkey_path(%params);
      unless ($params{value}) {
        return $self->noimage(size => $params{size});
      }

      return $pict if $self->app->mode eq 'production';

      if (-e $self->static_path . $pict && -s $self->static_path . $pict) {
        return $pict;
      }
      else {

        $params{table}
          ||= $self->dbi->query(
          "SELECT `default_table` FROM `sys_program` WHERE `key_razdel`='$params{controller}' LIMIT 0,1"
          )->list
          || '';

        return $self->noimage(size => $params{size}) unless $params{table};
        my $path = $self->lkey_folder(%params) . $params{value};

        unless (-e $self->static_path . $path || -s $self->static_path . $pict)
        {
          return $self->noimage(size => $params{size});
        }
        my ($to, $filename, $ext, $size)
          = $self->file_save(from => $path, to => $pict);
        if ($params{size}) {
          my $mini
            = $self->lkey(name => $params{lkey}, setting => 'mini', %params);

          my $method = 'crop';
          my ($w, $h) = split('x', $params{size});
          foreach (split(',', $mini)) {
            my ($size, $type) = split('~', $_);
            if ($size eq $params{size}) {
              $method = $type;
              last;
            }
          }


          $self->resize_pict(
            file      => $to,
            width     => $w,
            height    => $h,
            $method   => 1,
            retina    => $params{retina},
            watermark => $params{watermark},
          );
        }
        return $self->lkey_path(%params);
      }
    }
  );

  $app->helper(
    noimage => sub {
      my $self   = shift;
      my %params = (
        noimage_path => '/img/core/',
        noimage_name => 'noimage.png',
        size         => '',
        @_
      );

      return '' unless $params{size};
      my $noimage
        = $params{noimage_path} . $params{size} . '_' . $params{noimage_name};

      if (-e $self->static_path . $noimage) {
        return $noimage;
      }
      else {
        my ($w, $h) = split('x', $params{size});
        my ($to, $filename, $ext, $size) = $self->file_save(
          from => $params{noimage_path} . $params{noimage_name},
          to   => $noimage
        );
        $self->resize_pict(
          file      => $to,
          width     => $w,
          height    => $h,
          crop      => 1,
          retina    => $params{retina},
          watermark => $params{watermark},
        );
        return $noimage;
      }
    }
  );

  $app->helper(
    resize_pict => sub {
      my $self   = shift;
      my %params = (
        crop    => 0,
        montage => 0,
        fsize   => ''
        ,   # максимальный размер одной из сторон
        width      => '',
        height     => '',
        file       => '',          # путь к картинке,
        background => '#FFFFFF',
        retina  => 0,        # версия картинок для ретины
        quality => $QUALITY,
        @_
      );

      my $file = delete $params{file};
      $file = $self->image_to_jpg(file => $file);
      my ($width, $height) = (delete $params{width}, delete $params{height});
      if (my $fsize = delete $params{fsize}) {
        ($width, $height) = ($fsize, $fsize);
      }

      $params{background} = 'None' if (($file =~ m/([^.]+)$/)[0] =~ /png/i);

      if (delete $params{retina}) {
        my $file_retina = $self->file_path_retina($file);

        my ($retina_path, $retina_pict, $retina_ext) = $self->file_save(
          from        => $file,
          to          => $file_retina,
          to_abs_path => 0,
          replace     => 1,
        );

        $self->resize_pict(
          %params,
          width  => $width * 2,
          height => $height * 2,
          file   => $retina_path,
          retina => 0,
        );
      }

      if ($params{crop} == 1) {
        $self->image_crop(
          file    => $file,
          width   => $width,
          height  => $height,
          quality => $params{quality}
        );

      }
      elsif ($params{montage}) {

        my $images = Image::Magick->new();
        my $m      = $images->ReadImage($file);
        warn $m if $m;
        $images->set(quality => $params{quality});
        $m = $images->Montage(
          geometry   => qq{$width x $height},
          gravity    => 'Center',
          background => $params{background}
        );
        warn $m if $m;
        $m->Write($file);
        undef $images;

      }
      else {
        my ($img_w, $img_h)
          = $self->image_set(file => $file, quality => $params{quality});

        if ($img_w > $width || $img_h > $height) {
          if ($img_w > $img_h) {
            my $k = $img_w / $width;
            $img_w = $width;
            $img_h = int($img_h / $k);
          }
          else {
            my $k = $img_h / $height;
            $img_h = $height;
            $img_w = int($img_w / $k);
          }
          ($width, $height) = $self->image_set(
            file    => $file,
            width   => $img_w,
            height  => $img_h,
            quality => $params{quality}
          );
        }
      }

      if ($params{watermark}) {
        $self->defWatermark(file => $file, watermark => $params{watermark});
      }

      return ($width, $height);
    }
  );

 # проверяет что файл является изображением.
  $app->helper(
    image_check => sub {
      my $self = shift;
      my $file = shift;

      my $im = Image::Magick->new();
      my ($width, $height, $size, $format) = $im->Ping($file);

      my @avalaible_ext = qw(JPEG JPG GIF PNG);

      return '' unless $format;
      return '' unless ($format ~~ @avalaible_ext);

      return ($width, $height, $size, $format);
    }
  );

  $app->helper(
    image_set => sub {
      my $self = shift;
      my %params
        = (file => '', width => '', height => '', quality => $QUALITY, @_);

      my $image = Image::Magick->new();
      my $x     = $image->Read($params{file});    # открываем файл
      $image->set(quality => $params{quality});
      my ($ox, $oy)
        = $image->Get('width', 'height')
        ;    # определяем ширину и высоту

      if ((!$params{width}) || (!$params{height})) {
        $params{width}  = $ox;
        $params{height} = $oy;
      }

      if (($ox != $params{width}) || ($oy != $params{height})) {
        $image->Resize(
          geometry => "geometry",
          width    => $params{width},
          height   => $params{height}
        );    # Делаем resize
        $x = $image->Write($params{file});
      }

      undef $image;
      return ($params{width}, $params{height});
    }
  );

  $app->helper(
    image_to_jpg => sub {
      my $self = shift;
      my %params = (file => '', @_);

      my $file = delete $params{file};
      my $ext  = ($file =~ m/([^.]+)$/)[0];
      if (!grep(/$ext/, @EXT)) {
        eval {
          my $filename = $file;
          $filename =~ s{\.$ext$}{}e;
          my $image = new Image::Magick(format => $ext);
          my $status = $image->Read(filename => $file);
          warn "Error reading $file: $status" if $status;

          #  Write file as JPEG to STDOUT

          $file = $filename . '.jpg';

          # Convert CMYK to RGB
          $self->_CMYK_to_RGB(\$image);

          $status = $image->Write($file);

          undef $image;
          warn "Error writing $file: $status" if $status;
        };
        if ($@) {
          warn $@;
          return undef;
        }
      }
      return $file;
    }
  );

  $app->helper(
    image_crop_raw => sub {
      my $self = shift;
      my %params
        = (width => 120, height => 120, x => 0, y => 0, quality => $QUALITY,
        @_);

      my $image = Image::Magick->new;
      my $x     = $image->Read($params{file});
      warn $x if $x;

      $image->set(quality => $params{quality});

      $image->Crop(
        x      => $params{'x'},
        y      => $params{'y'},
        width  => $params{'width'},
        height => $params{'height'}
      );
      $x = $image->Write($params{file});
      undef $image;

      return $x ? 0 : 1;
    }
  );

  $app->helper(
    image_crop => sub {
      my $self = shift;
      my %params = (width => 120, height => 120, quality => $QUALITY, @_);

      if (!$params{file}) {
        die
          "Функция image_crop. Отсутствует параметр FILE";
      }

      my ($image, $image_new, $x, $H, $W);    # переменные

      $H = delete $params{height};
      $W = delete $params{width};

      $image = Image::Magick->new;             # новый проект
      $x     = $image->Read($params{file});    # открываем файл
      $image->set(quality => $params{quality});

      my ($ox, $oy)
        = $image->Get('width', 'height')
        ; # определяем ширину и высоту изображения

      unless ($ox == $W and $oy == $H) {

        my $nx = int(($ox / $oy) * $H)
          ; # вычисляем ширину, если высоту сделать $H
        my $ny = int(($oy / $ox) * $W)
          ; # вычисляем высоту, если ширину сделать $W

        # Режем по высоте или по ширине
        if ($nx > $ny) {
          _resize_x(\$image, $W, $H, $nx, $ny);
        }
        else {
          _resize_y(\$image, $W, $H, $nx, $ny);
        }
      }

      # Сохраняем изображение.
      $x = $image->Write($params{file});
      undef $image;
    }
  );

  $app->helper(
    _CMYK_to_RGB => sub {
      my $self = shift;
      my $img  = ${+shift};

      my $type = $img->Get('mime');
      if ($type ne 'image/gif') {
        $img->Set(
          colorspace  => 'RGB',
          compression => 'JPEG',
          quality     => $QUALITY,
        );
      }
      return $img;
    }
  );

  $app->helper(
    defWatermark => sub {
      my $self = shift();
      my %params = (file => '', watermark => '', quality => $QUALITY, @_);

      if (!$params{file} or !$params{watermark}) {
        die
          "Функция pictures::defWatermark. Отсутствует параметр FILE или watermark";
      }

      $params{'x'}
        ||= 10;    # Позиция логотипа на картинке
      $params{'y'} ||= 10;
      $params{'compose'} ||= 'Dissolve'
        ;   # Эффект трансформации - расстворение
      $params{'gravity'} ||= 'SouthEast';    # позиция (left, top, …)
      $params{'opacity'} ||= 25000;          # Прозрачность лого


      my $image = Image::Magick->new;              # новый проект
      my $water = Image::Magick->new;
      my $x     = $image->Read($params{file});     # открываем файл
      my $xx    = $water->Read($params{watermark});
      $image->Set(quality => $params{quality});
      $water->Set(quality => $params{quality});
      my ($image_w, $image_h)
        = $image->Get('width', 'height')
        ;    # определяем ширину и высоту
      my ($water_w, $water_h)
        = $water->Get('width', 'height')
        ;    # определяем ширину и высоту

      if ($water_w > $image_w * 0.2) {
        my $new_water_w = $image_w * 0.2;
        $water_h = int(($water_h / $water_w) * $new_water_w);
        $water_w = $new_water_w;

        $water->Resize(
          geometry => "geometry",
          width    => $water_w,
          height   => $water_h
        );
      }

      $image->Composite(
        image   => $water,              # имидж для лого
        x       => $params{'x'},
        y       => $params{'y'},
        compose => $params{'compose'}
        ,    # растворить - opasity в Photoshop?
        gravity => $params{'gravity'}, # позиция (left, top, …)
        opacity => $params{'opacity'}  # степень прозрачности
      );

      return $image->Write($params{file})
        ;    # Сохраняем изображение
    }
  );
}


sub _resize_x {
  my $image = ${+shift};
  my ($W, $H, $nx, $ny) = @_;

  # Делаем resize

  if ($nx >= $W) {  # Если ширина получилась больше $W
    $image->Resize(
      geometry => qq{$W x $H},
      width    => $nx,
      height   => $H,
      blur     => 1,
    );
    my $nnx = int(($nx - $W) / 2)
      ;             # Вычисляем откуда нам резать
    $image->Crop(
      x => $nnx,
      y => 0,

      # geometry => qq{$W x $H},
      width  => $W,
      height => $H
      )
      ; # Задаем откуда будем резать, c того места вырезаем $Wx$H
  }
  else {
    _resize_y(\$image, $W, $H, $nx, $ny);
  }
}

sub _resize_y {
  my $image = ${+shift};
  my ($W, $H, $nx, $ny) = @_;


  if ($ny >= $H) {  # Если ширина получилась больше $W
    $image->Resize(
      geometry => qq{$W x $H},
      width    => $W,
      height   => $ny,
      blur     => 1,
    );
    my $nny = int(($ny - $H) / 2);
    $image->Crop(
      x => 0,
      y => $nny,

      #geometry => qq{$W x $H},
      width  => $W,
      height => $H
    );
  }
  else {
    _resize_x(\$image, $W, $H, $nx, $ny);
  }
}


1;
