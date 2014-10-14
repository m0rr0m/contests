#!/usr/bin/perl -w
use strict;
require '/tmp/common.pl';
# O _ _ _ 
# _ _ _ _ 
# _ _ O O 
# _ _ O _ 

undef $/;

my @res = sort { $a cmp $b } uniq (map { s/ //g; tr/O_/X./; rotate($_) } split /\n\n/, <>);
print join "\n\n", @res;
