#!/usr/bin/perl -w

sub s2m { [map { [split //] } split /\n/, $_[0]] }
sub m2s { join "\n", map { join '', @$_ } @{$_[0]} }

1;
