#!/usr/bin/perl -w
use strict;
require '../common.pl';

# 
# X _ _ _ 
# _ _ _ _ 
# X _ X _ 
# _ X _ _ 

undef $/;
my @res = sort { $a cmp $b } uniq (map { s/^\n//; s/ //g; tr/_/./; rotate($_) } split /\n\n/, <>);
print join "\n\n", @res;
