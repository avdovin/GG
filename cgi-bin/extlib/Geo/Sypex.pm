package Geo::Sypex;

# ------------------------------------------------------------------------------
#   Created on: 28.09.2015, 21:27:28
#   Author    : Vsevolod Lutovinov <klopp@yandex.ru>
#   Based on  : Geo::SypexGeo by Andrey Kuzmin
# ------------------------------------------------------------------------------
use strict;
use warnings;
use Exporter;
use base qw/Exporter/;

use Socket qw/inet_aton/;
use Encode qw/decode/;

use vars qw/$VERSION @EXPORT_OK/;
$VERSION   = 'v1.0.13';
@EXPORT_OK = qw/SXGEO_BATCH SXGEO_MEM/;

# ------------------------------------------------------------------------------
use constant ID2ISO => [
    qw/ AP EU AD AE AF AG AI AL AM CW AO AQ AR AS AT AU AW AZ
        BA BB BD BE BF BG BH BI BJ BM BN BO BR BS BT BV BW BY BZ
        CA CC CD CF CG CH CI CK CL CM CN CO CR CU CV CX CY CZ
        DE DJ DK DM DO DZ EC EE EG EH ER ES ET FI FJ FK FM FO FR SX
        GA GB GD GE GF GH GI GL GM GN GP GQ GR GS GT GU GW GY HK HM HN HR HT HU
        ID IE IL IN IO IQ IR IS IT JM JO JP KE KG KH KI KM KN KP KR KW KY KZ
        LA LB LC LI LK LR LS LT LU LV LY
        MA MC MD MG MH MK ML MM MN MO MP MQ MR MS MT MU MV MW MX MY MZ
        NA NC NE NF NG NI NL NO NP NR NU NZ OM
        PA PE PF PG PH PK PL PM PN PR PS PT PW PY QA RE RO RU RW
        SA SB SC SD SE SG SH SI SJ SK SL SM SN SO SR ST SV SY SZ
        TC TD TF TG TH TJ TK TM TN TO TL TR TT TV TW TZ
        UA UG UM US UY UZ VA VC VE VG VI VN VU WF WS YE YT RS
        ZA ZM ME ZW A1 XK O1 AX GG IM JE BL MF BQ SS/
];
use constant VALID_CHARSETS => [qw/utf8 latin1 cp1251/];
use constant HEADER_LENGTH  => 40;
use constant SXGEO_BATCH    => 1;
use constant SXGEO_MEM      => 2;

# ------------------------------------------------------------------------------
sub _bin2int {

    my @n  = split( //, shift );
    my $rc = 0;
    my $n  = 1;
    my $c;

    while ( defined( $c = pop @n ) ) {
        $rc += ord($c) * $n;
        $n *= 256;
    }
    return $rc;
}

# ------------------------------------------------------------------------------
sub _read {
    my ( $self, $length, $offset ) = @_;
    my $buf;

    if ( $self->{mem_mode} ) {
        $self->{offset} = $offset if defined $offset;
        $buf = substr( $self->{filebuf}, $self->{offset}, $length );
        $self->{offset} += $length;
    }
    else {
        seek $self->{fd}, $offset, 0 if defined $offset;
        read $self->{fd}, $buf, $length;
    }
    return $buf;
}

# ------------------------------------------------------------------------------
sub DESTROY {
    return shift->_close();
}

# ------------------------------------------------------------------------------
sub _close {
    my $self = shift;
    close $self->{fd} if $self->{fd};
    undef $self->{fd};
    return $self;
}

# ------------------------------------------------------------------------------
sub new {
    my ( $class, $file, $flags ) = @_;

    $flags ||= 0;

    my $self = bless {}, $class;
    my $header;

    $self->{offset} = 0;

    if ( !open( $self->{fd}, '<', $file ) ) {
        $self->{fatal} = $self->{errstr} = "Can not open file \"$file\": $!";
        return $self;
    }
    binmode $self->{fd}, ':bytes';
    if ( $flags & SXGEO_MEM ) {
        $self->{mem_mode} = 1;
        local $/ = undef;
        my $fd = $self->{fd};
        $self->{filebuf} = <$fd>;
        $self->_close();
    }

    $header = $self->_read(HEADER_LENGTH);

    if ( substr( $header, 0, 3 ) ne 'SxG' ) {
        $self->{fatal} = $self->{errstr} = 'File format is wrong';
        return $self->_close();
    }

    my $info_str = substr( $header, 3, HEADER_LENGTH - 3 );
    my @info = unpack 'CNCCCnnNCnnNNnNn', $info_str;
    if ( $info[4] * $info[5] * $info[6] * $info[7] * $info[1] * $info[8] == 0 )
    {
        $self->{fatal} = $self->{errstr} = 'File header format is wrong';
        return $self->_close();
    }

    $self->{charset} = VALID_CHARSETS->[ $info[3] ];

    if ( !$self->{charset} ) {
        $self->{fatal} = $self->{errstr}
            = sprintf 'Invalid charset detected: %d', $info[3];
        return $self->_close();
    }

    if ( $info[15] ) {
        my $pack = $self->_read( $info[15] );
        $self->{mpack} = [ split /\0/, $pack ];
    }

    $self->{b_idx_str} = $self->_read( $info[4] * 4 );
    $self->{m_idx_str} = $self->_read( $info[5] * 4 );

    $self->{range}      = $info[6];
    $self->{b_idx_len}  = $info[4];
    $self->{m_idx_len}  = $info[5];
    $self->{db_items}   = $info[7];
    $self->{id_len}     = $info[8];
    $self->{block_len}  = 3 + $self->{id_len};
    $self->{max_region} = $info[9];
    $self->{max_city}   = $info[10];

    #    $self->{region_size}  = $info[11];
    #    $self->{city_size}    = $info[12];
    $self->{max_country}  = $info[13];
    $self->{country_size} = $info[14];

    $self->{db_begin}
        = HEADER_LENGTH + $info[15] + ( $info[4] * 4 ) + ( $info[5] * 4 );

    if ( $flags & SXGEO_BATCH ) {
        $self->{batch_mode} = 1;
        @{ $self->{b_idx_arr} } = unpack( 'N*', $self->{b_idx_str} );
        undef $self->{b_idx_str};
        @{ $self->{m_idx_arr} } = unpack( '(a4)*', $self->{m_idx_str} );
        undef $self->{b_idx_str};
    }

    $self->{regions_begin}
        = $self->{db_begin} + $self->{db_items} * $self->{block_len};
    $self->{cities_begin} = $self->{regions_begin} + $info[11];

    return $self;
}

# ------------------------------------------------------------------------------
sub errstr {
    my $self = shift;
    my $e    = $self->{errstr};
    eval { $e = decode( 'utf8', $e ) if $e; };
    return $e;
}

# ------------------------------------------------------------------------------
sub get {
    my ( $self, $ip, @fields ) = @_;

    return if $self->{fatal};

    undef $self->{errstr};

    if ( !$ip ) {
        $self->{errstr} = 'No IP';
        return;
    }

    my $seek = $self->_get_num($ip);
    return unless $seek;

    my %geodata;

    if ( !$self->{max_city} ) {
        %geodata = (
            'country_id'  => $seek,
            'country_iso' => lc ID2ISO->[ $seek - 1 ],
        );
    }
    else {
        $self->_parse_city($seek);

        $self->{rc}->{name_ru}
            = decode( $self->{charset}, $self->{rc}->{name_ru} )
            if $self->{rc}->{name_ru};

        if ( $self->{rc}->{country_id} ) {
            %geodata = (
                'region_id'   => $self->{rc}->{region_seek},
                'country_id'  => $self->{rc}->{country_id},
                'country_iso' => lc ID2ISO->[ $self->{rc}->{country_id} - 1 ],
                'city_id'     => $self->{rc}->{id},
                'lat'         => $self->{rc}->{lat},
                'lon'         => $self->{rc}->{lon},
                'city_ru'     => $self->{rc}->{name_ru},
                'city_en'     => $self->{rc}->{name_en},
            );
        }
        else {
            %geodata = (
                'country_id'  => $self->{rc}->{id},
                'country_iso' => lc ID2ISO->[ $self->{rc}->{id} - 1 ],
                'lat'         => $self->{rc}->{lat},
                'lon'         => $self->{rc}->{lon},
            );
        }
    }

    if (@fields) {
        my %rc;
        for (@fields) {
            $rc{$_} = $geodata{$_} if $geodata{$_};
        }
        return wantarray ? %rc : \%rc;
    }

    return wantarray ? %geodata : \%geodata;
}

# ------------------------------------------------------------------------------
sub _get_num {

    my ( $self, $ip ) = @_;

    my $ip1n = 0;

    $ip =~ /^(\d+)\./ and $ip1n = $1;

    if (  !$ip1n
        || $ip1n == 10
        || $ip1n == 127
        || $ip1n >= $self->{b_idx_len} )
    {
        $self->{errstr} = "Invalid IP: \"$ip\"";
        return;
    }
    my $ipn = unpack( 'N', inet_aton($ip) || 0 );

    unless ($ipn) {
        $self->{error} = "Invalid IP: $ip";
        return;
    }

    my @blocks;
    if ( $self->{batch_mode} ) {
        $blocks[0] = $self->{b_idx_arr}->[ $ip1n - 1 ];
        $blocks[1] = $self->{b_idx_arr}->[$ip1n];
    }
    else {
        @blocks = unpack 'NN',
            substr( $self->{b_idx_str}, ( $ip1n - 1 ) * 4, 8 );
    }

    my $min;
    my $max;

    if ( $blocks[1] - $blocks[0] > $self->{range} ) {
        my $part = $self->_search_idx(
            $ipn,
            int( $blocks[0] / $self->{range} ),
            int( $blocks[1] / $self->{range} ) - 1
        );

        $min = $part > 0 ? $part * $self->{range} : 0;
        $max
            = $part > $self->{m_idx_len}
            ? $self->{db_items}
            : ( $part + 1 ) * $self->{range};

        $min = $blocks[0] if $min < $blocks[0];
        $max = $blocks[1] if $max > $blocks[1];
    }
    else {
        $min = $blocks[0];
        $max = $blocks[1];
    }

    my $len = $max - $min;
    my $buf = $self->_read( $len * $self->{block_len},
        $self->{db_begin} + $min * $self->{block_len} );

    return $self->_search_db( $buf, $ipn, 0, $len - 1 );
}

# ------------------------------------------------------------------------------
sub _search_idx {
    my ( $self, $ipn, $min, $max ) = @_;

    my $offset;

    if ( $self->{batch_mode} ) {
        while ( $max - $min > 8 ) {
            $offset = ( $min + $max ) >> 1;
            if ( $ipn > unpack( 'N', $self->{m_idx_arr}->[$offset] ) ) {
                $min = $offset;
            }
            else {
                $max = $offset;
            }
        }
        while ($ipn > unpack( 'N', $self->{m_idx_arr}->[$min] )
            && $min++ < $max )
        {
        }
    }
    else {
        while ( $max - $min > 8 ) {
            $offset = ( $min + $max ) >> 1;

            if ( $ipn
                > unpack( 'N', substr( $self->{m_idx_str}, $offset * 4, 4 ) ) )
            {
                $min = $offset;
            }
            else {
                $max = $offset;
            }
        }

        while ($ipn > unpack( 'N', substr( $self->{m_idx_str}, $min * 4, 4 ) )
            && $min++ < $max )
        {
        }
    }
    return $min;
}

# ------------------------------------------------------------------------------
sub _search_db {
    my ( $self, $str, $ipn, $min, $max ) = @_;

    if ( $max - $min > 1 ) {

        $ipn = ( $ipn << 8 ) & 0xFFFFFF00;

        my $offset;
        while ( $max - $min > 8 ) {
            $offset = ( $min + $max ) >> 1;

            if ($ipn > unpack(
                    'N', substr( $str, $offset * $self->{block_len}, 3 ) . "\0"
                )
                )
            {
                $min = $offset;
            }
            else {
                $max = $offset;
            }
        }

        while (
            $ipn >= unpack( 'N',
                substr( $str, $min * $self->{block_len}, 3 ) . "\0" )
            && $min++ < $max )
        {
        }
    }
    else {
        return _bin2int( substr( $str, $min * $self->{block_len} + 3, 3 ) );
    }

    return _bin2int(
        substr(
            $str, $min * $self->{block_len} - $self->{id_len},
            $self->{id_len}
        )
    );
}

# ------------------------------------------------------------------------------
sub _parse_city {
    my ( $self, $seek ) = @_;

    my $buf;
    if ( $seek < $self->{country_size} ) {
        $buf = $self->_read( $self->{max_country},
            $seek + $self->{cities_begin} );
        $self->_extended_unpack( $self->{mpack}[0], $buf );
    }
    else {
        $buf = $self->_read( $self->{max_city}, $seek + $self->{cities_begin} );
        $self->_extended_unpack( $self->{mpack}[2], $buf );
    }

    return $self->{rc};
}

# ------------------------------------------------------------------------------
my %T1 = (
    't' => 1,
    'T' => 1,
    's' => 2,
    'n' => 2,
    'S' => 2,
    'm' => 3,
    'M' => 3,
    'D' => 8,
);

# ------------------------------------------------------------------------------
sub _extended_unpack {

    my ( $self, $flags, $val ) = @_;

    my $pos = 0;
    $self->{rc} = {};

    my @flags_arr = split /\//, $flags;

    foreach my $flag_str (@flags_arr) {

        my ( $type, $name ) = split /:/, $flag_str;

        my $flag = substr $type, 0, 1;
        my $num  = substr $type, 1, 1;

        my $len = $num;
        if ( $flag eq 'b' ) {
            $len = index( $val, "\0", $pos ) - $pos;
        }
        else {
            $len = $T1{$flag} || 4;
        }

        my $subval = substr( $val, $pos, $len );

        my $res;

        if ( $flag eq 't' ) {
            $res = ( unpack 'c', $subval )[0];
        }
        elsif ( $flag eq 'T' ) {
            $res = ( unpack 'C', $subval )[0];
        }
        elsif ( $flag eq 's' ) {
            $res = ( unpack 's', $subval )[0];
        }
        elsif ( $flag eq 'S' ) {
            $res = ( unpack 'S', $subval )[0];
        }
        elsif ( $flag eq 'm' ) {
            $res = (
                unpack 'l',
                $subval
                    . ( ord( substr( $subval, 2, 1 ) ) >> 7 ? "\xFF" : "\0" )
            )[0];
        }
        elsif ( $flag eq 'M' ) {
            $res = ( unpack 'L', $subval . "\0" )[0];
        }
        elsif ( $flag eq 'i' ) {
            $res = ( unpack 'l', $subval )[0];
        }
        elsif ( $flag eq 'I' ) {
            $res = ( unpack 'L', $subval )[0];
        }
        elsif ( $flag eq 'f' ) {
            $res = ( unpack 'f', $subval )[0];
        }
        elsif ( $flag eq 'd' ) {
            $res = ( unpack 'd', $subval )[0];
        }
        elsif ( $flag eq 'n' ) {
            $res = ( unpack 's', $subval )[0] / ( 10**$num );
        }
        elsif ( $flag eq 'N' ) {
            $res = ( unpack 'l', $subval )[0] / ( 10**$num );
        }
        elsif ( $flag eq 'c' ) {
            $subval =~ s/\s+$//gs;

            #$res = rtrim $subval;
            $res = $subval;
        }
        elsif ( $flag eq 'b' ) {
            $res = $subval;
            $len++;
        }

        $pos += $len;
        $self->{rc}->{$name} = $res;
    }

    return $self->{rc};
}

# ------------------------------------------------------------------------------

1;

__END__

=head1 NAME

Geo::Sypex - L<Sypex Geo|https://sypexgeo.net/> databases parser

=head1 VERSION

Version v1.0.13

=head1 SYNOPSIS

    use Geo::Sypex qw/SXGEO_BATCH/;

    my $sxgeo = Geo::Sypex->new( 'SxGeo.dat', SXGEO_BATCH );
    my $geodata = $sxgeo->get( '93.191.14.81' ); 
    
=head1 DESCRIPTION

This module parse L<Sypex Geo|http://sypexgeo.net/> databases and allow to get geo information for IP.

Only F<SxGeo.dat> and F<SxGeoCity.dat> supported. 

=head1 SUBROUTINES/METHODS

=encoding UTF-8

=over

=item new( F<$file> [, C<$flags>] )

Valid C<$flags> values: C<SXGEO_BATCH> (for multiple C<get> requests), C<SXGEO_MEM>.  

=item get( C<$ip> [, C<@fields>] )

Return geodata or undef.

    use Data::Printer;
    my $geodata = $sxgeo->get( '93.191.14.81' );
    p $geodata; 

Output:

    \ {
        city_en       "Fryazino",
        city_id       562319,
        city_ru       "Фрязино",
        country_id    185,
        country_iso   "ru",
        lat           55.96056,
        lon           38.04556,
        region_id     10267
    }

You can indicate fields to return:

    my $geodata = $sxgeo->get( '93.191.14.81', 'city_en', 'lat', 'lon' );
    p $geodata; 

Output:

    \ {
        city_en       "Fryazino",
        lat           55.96056,
        lon           38.04556
    }

If no city information found next fields will be returned:

    \ {
        country_id    185,
        country_iso   "ru",
        lat           55.96056, # not mandatory
        lon           38.04556, # not mandatory
        region_id     10267     # not mandatory
    }

For F<SxGeo.dat> only two field avaliable: C<country_id>, C<country_iso>.

=item errstr

Return internal error string. Example:

    my $geodata = $sxgeo->get( '666.356.299.400' ); 
    say $sxgeo->errstr unless $geodata;

=back

=head1 BUGS AND LIMITATIONS

With C<SXGEO_MEM> flag entire file will be loaded into memory!

=head1 LICENSE AND COPYRIGHT

Coyright (C) 2015 Vsevolod Lutovinov.

This program is free software; you can redistribute it and/or modify it under
the same terms as Perl itself. The full text of this license can be found in
the LICENSE file included with this module.

=head1 AUTHOR

Contact the author at klopp@yandex.ru.

=head1 SOURCE CODE

Source code and issues can be found here:
 L<https://github.com/klopp/Geo-Sypex/>

