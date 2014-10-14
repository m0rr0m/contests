#!/usr/bin/perl -w

sub s2m { [map { [split //] } split /\n/, $_[0]] }
sub m2s { join "\n", map { join '', @$_ } @{$_[0]} }

sub rotate90 {
    my ($m) = @_;
    my ($width, $height) = (scalar @{$m->[0]}, scalar @$m);

    my @m2 = map { 
        my $y = $_;
        [ map { my $x = $_; $m->[$x-1]->[$width-$y] } (1..$height) ]
    } (1..$width);

    return \@m2;
}

sub rotate180 { rotate90(rotate90($_[0])) }
sub rotate270 { rotate90(rotate90(rotate90($_[0]))) }

sub rotate {
    my ($s) = @_;
    my $m = s2m($s);
    
    map { m2s($_) } ($m, rotate90($m), rotate180($m), rotate270($m));
}

sub uniq { keys %{{ map { $_ => 1 } @_ }} }
1;
