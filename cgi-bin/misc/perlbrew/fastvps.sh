#!/usr/bin/env bash

# install perlbrew, perl-5.20.1 cpanm and perl modules on FastVPS

# IMPORTANT! Run only by root user


# Make sure only root can run our script
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

echo "Enter FastVPS user login"
read LOGIN

locale-gen en_US en_US.UTF-8 ru_RU ru_RU.UTF-8
dpkg-reconfigure locales


export PERLBREW_ROOT=/opt/perl5
curl -kL http://install.perlbrew.pl | bash

echo 'source /opt/perl5/etc/bashrc' >>~/.bash_profile
source ~/.bash_profile

perlbrew install perl-5.20.1 -D useshrplib

perlbrew switch perl-5.20.1
perlbrew install-cpanm

apt-get update
apt-get install libmysqlclient-dev
cpanm -f  DBD::mysql

cpanm JSON::XS JavaScript::Minifier::XS CSS::Minifier::XS Crypt::Eksblowfish::Bcrypt


touch "/var/www/$LOGIN/data/.bash_profile"
echo 'export PERLBREW_ROOT=/opt/perl5' >> "/var/www/$LOGIN/data/.bash_profile"
echo 'source ${PERLBREW_ROOT}/etc/bashrc' >> "/var/www/$LOGIN/data/.bash_profile"
