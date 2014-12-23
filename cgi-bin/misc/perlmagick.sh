#!/usr/bin/env bash

# perlbrew instlal perl-5.20.1 -D useshrplib

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
    ./configure --enable-shared --with-jpeg --with-png  --with-jp2 --with-tiff --prefix $TOP \
    --with-perl=$PERL_BIN \
    --enable-shared $THREAD_FLAG

make install

# Test the install
#
#     perl -MImage::Magick -E 'say ${"$Image::Magick::ISA[0]".::VERSION}'
#
#     perl -MImage::Magick -e '$p = Image::Magick->new; $p->Read("magick:rose"); $p->Write("/tmp/test.png")'; display /tmp/test.png