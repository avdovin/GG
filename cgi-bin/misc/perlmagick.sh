#!/usr/bin/env bash

# perlbrew install perl-5.20.1 -D useshrplib

# See <http://perltricks.com/article/57/2014/1/1/Shazam-Use-Image-Magick-with-Perlbrew-in-minutes>

# may need to have the perl configured with -Duseshrplib
#
#     perl -V | grep -- '-Duseshrplib'

# compile perl with perlbrew:
#
#     perlbrew install $PERL_VERSION_HERE -D useshrplib
#
# may need to --force
#
# see <https://github.com/gugod/App-perlbrew/issues/131>

# Ubuntu packages
# JPEG - libjpeg62-dev
# PNG - libpng-dev

#sudo apt-get update
#sudo apt-get install libjpeg62-dev
#sudo apt-get install libpng-dev
#sudo apt-get install libfreetype6-dev
#sudo apt-get install libtiff5-dev
#sudo apt-get install liblcms1-dev

TOP="$HOME/local"

if [ -n "$1" ]; then
	TOP=$1
fi

mkdir -p $TOP
cd "$TOP"
wget -c http://www.imagemagick.org/download/ImageMagick.tar.gz
tar xzvf ImageMagick.tar.gz
cd ImageMagick* # this isn't exactly clean


PERL_CORE=$(perl -e 'print grep { -d } map { "$_/CORE" } @INC')
PERL_BIN=$(which perl)

PERL_THREADS=$(perl -V | grep -c 'useithreads=define')

THREAD_FLAG="--with-threads"

if [ $PERL_THREADS = 0 ]; then
	THREAD_FLAG="--without-threads"
fi

LDFLAGS=-L$PERL_CORE \
    ./configure --with-jpeg=yes --with-png=yes  --with-jp2=yes --prefix $TOP \
    --with-perl=$PERL_BIN --with-gslib --with-fontconfig=yes \
    --with-freetype=yes --with-webp=yes --with-ghostscript=yes --with-jasper=yes --with-librsvg=yes --with-libtiff=yes \
    --enable-shared $THREAD_FLAG

make install

# Test the install
#
#     perl -MImage::Magick -E 'say ${"$Image::Magick::ISA[0]".::VERSION}'
#
#     perl -MImage::Magick -e '$p = Image::Magick->new; $p->Read("magick:rose"); $p->Write("/tmp/test.png")'; display /tmp/test.png