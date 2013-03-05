package GG::Plugins::Captcha;

use strict;
use warnings;
use File::Temp;
use File::Spec;
use utf8;

use Mojo::Base 'Mojolicious::Plugin';

BEGIN {
	die 'Module Image::Magick not properly installed' unless eval { require Image::Magick; 1 }
}
our $VERSION = 0.2;

my $CAPTCHA;

my $captcha_conf = {};

sub register {
	my ($self,$app,$conf) = @_;
	
	$captcha_conf = {
		'width' => 88,	#ширина изображения
		'height'=> 31,	#высота изображения
		'noise_pixels' => 150 #количество пикселов шума
		%$conf,
	};

	$app->routes->route("/captcha/code.jpg")->to( cb => sub{
		my $self   = shift;
		
		my @letter = (0..9, 'a'..'z');

		my $code = join '', @letter[ map { int rand @letter } 1..5 ]; 
		$CAPTCHA->{lc $code} = 1;
		$self->render_data($self->captcha($code) );	
			
	})->name('captcha_code');

	$app->helper(
		check_captcha => sub {
			my $self = shift;
			my $code = shift;

			return delete $CAPTCHA->{lc $code}; 
		}
	);
					
	$app->renderer->add_helper(
		captcha => sub {
			my ($self,$code) = @_;
			
			$code ||= $self->stash->{code};
			my $img = Image::Magick->new(size => $captcha_conf->{width} . "x" . $captcha_conf->{height});
			my $x; $x = $img->Read($self->app->home->rel_dir('data/captcha.jpg'));

			my %colors = (
						0 => "red",	# Цвет цифр
						1 => "green",
						2 => "lightgreen",
						1 => "lightred",
						2 => "white"
			);

		    # 	выводим пароль с искажением текста
    		my $step_x = 12;
    		my $base_x = 2;
    		my $base_y = $captcha_conf->{height} - 5;
    			
			for my $i(0..4) {
				# сдвиг и вращение буквы
	        	my $sdvig_x = int(rand(4)) + 15;
	        	my $sdvig_y = int(rand(8)) - 10;
	        	my $rotate = int(rand(60)) - 30;
				my $pointsize = int(rand(7));
				my $color = int(rand(2));
				my $letter = substr($code, $i, 1);
	
				$x = $img->Annotate(
								antialias => 'true',
	            		       	#pointsize => 18,
		                         x 			=> $base_x + $sdvig_x,
	    	                     y			=> $base_y + $sdvig_y,
								 text 	  	=> $letter,
	#							 geometry  	=> "$x{$i}+$y",
								 fill 	   	=> $colors{$color},
	#							 gravity   	=> 'North',
								 pointsize 	=> 19 + $pointsize,
								 rotate    	=> $rotate
								 );
				$base_x += $step_x;
				warn $x if $x;
			}

		    # добавляем шум (для затруднения восприятия)
	    	for my $i (1 .. $captcha_conf->{noise_pixels})
	    	{
	        	my $rnd_x = int(rand($captcha_conf->{width}));
	        	my $rnd_y = int(rand($captcha_conf->{height}));
	        	$x = $img->Set("pixel[$rnd_x, $rnd_y]" => "#c8c8c8");
	        	warn $x if $x;
	    	}

			my $body = '';

			{
				my $fh = File::Temp->new(UNLINK => 1, DIR => $ENV{MOJO_TMPDIR} || File::Spec->tmpdir);
				$x = $img->Write('jpeg:' . $fh->filename);
				open $fh, '<', $fh->filename;
				local $/;
				$body = <$fh>;
			}
			return $body;
		}
	);
}
1;