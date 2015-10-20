# file for Carton (aka bundler)
# http://search.cpan.org/~miyagawa/Carton-v1.0.12/lib/Carton.pm
#
# carton install
#       or
# cpanm -L extlib --installdeps .

requires 'perl', '5.10.1';

requires 'JavaScript::Minifier::XS'   => '>=0.11';
requires 'Socket'                     => '>2.00';
requires 'IO::Socket::IP'             => '>=0.37';
requires 'CSS::Minifier::XS'          => '>=0.09';
requires 'Crypt::Eksblowfish::Bcrypt' => '>=0.009';

#requires 'Plack'                      => 0;
#requires 'Starman'                    => 0;
