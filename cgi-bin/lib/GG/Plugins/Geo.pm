package GG::Plugins::Geo;

use utf8;

use Mojo::Base 'Mojolicious::Plugin';

our $VERSION = '1';

sub register {
	my ( $self, $app, $opts ) = @_;

	$opts ||= {};


	$app->helper( geoLoadData => sub {
		my $self 	= shift;
		my $record 	 = shift;

		my $result = {};
		my @cities = ();
		open IN, "<../GEO/cities_utf.txt" or die "Could not open cities.txt!";
		while (my $kuku = <IN>) {
			chomp($kuku);
			my @mas = split /\t/, $kuku;
			$cities[$mas[0]]->{'city'} = $mas[1];
			$cities[$mas[0]]->{'region'} = $mas[2];
			$cities[$mas[0]]->{'district'} = $mas[3];
			$cities[$mas[0]]->{'coordinates'} = $mas[4].",".$mas[5];
		}
		close IN;		

		my @inetnums = ();
		my $i = 0;

		open IN, "<../GEO/cidr_optim_utf.txt" or die "Could not open cidr_optim.txt!";
		while (my $kuku = <IN>) {
			chomp($kuku);
			my @mas = split /\t/, $kuku;
			$inetnums[$i]->{'start'} = $mas[0];
			$inetnums[$i]->{'stop'} = $mas[1];
			$inetnums[$i]->{'inetnum'} = $mas[2];
			$inetnums[$i]->{'country'} = $mas[3];
			$inetnums[$i]->{'cityid'} = $mas[4];
			$i++;
		}
		close IN;

		$record =~ s/\s//gs;
		my $ADDRESS = ip_to_number($record);
		if (defined($ADDRESS)) {
			my $MAXINDEX = $i;
			my $MININDEX = 0;
			my $isfinded = 0;
			my $cc       = 0;  # Iterations counter
			my $CURRENTINDEX;
			while ($MININDEX < $MAXINDEX) {
				$cc++;
				$CURRENTINDEX = int(($MININDEX + $MAXINDEX)/2);
				if ($ADDRESS < $inetnums[$CURRENTINDEX]->{'start'}) {
					$MAXINDEX = $CURRENTINDEX;
					next;
				}
				if ($ADDRESS > $inetnums[$CURRENTINDEX]->{'stop'}) {
					$MININDEX = $CURRENTINDEX + 1;
					next;
				}
				if (($inetnums[$CURRENTINDEX]->{'start'} <= $ADDRESS) && ($ADDRESS <= $inetnums[$CURRENTINDEX]->{'stop'})) {
					$isfinded = 1;
					last;
				}
			}
			if ($isfinded) {
				$result->{range} = $inetnums[$CURRENTINDEX]->{'inetnum'};
				$result->{country} = $inetnums[$CURRENTINDEX]->{'country'};
				if ($inetnums[$CURRENTINDEX]->{'cityid'} ne "-") {
					my $id = $inetnums[$CURRENTINDEX]->{'cityid'};
					$result->{city} = $cities[$id]->{'city'};
					$result->{region} = $cities[$id]->{'region'};
					$result->{distinct} = $cities[$id]->{'district'};
					$result->{coord} = $cities[$id]->{'coordinates'};

				} 		
			}

		}
		return $result;
	});


}

sub ip_to_number {
	my $ip = shift;
	
	unless($ip) {return undef;}
	$ip =~ s/\s//gs;
	$ip =~ s/\,/\./g; 
	if ($ip =~ /^((([01]?\d{1,2})|(2([0-4]\d|5[0-5])))\.){3}(([01]?\d{1,2})|(2([0-4]\d|5[0-5])))$/) {
		my @bits = split /\./, $ip;
		my $ADDRESS = $bits[0]*256*256*256 + $bits[1]*256*256 + $bits[2]*256 + $bits[3];
		return $ADDRESS;
	} else {
		return undef;
	}

}

1;