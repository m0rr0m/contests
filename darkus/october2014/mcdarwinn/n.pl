#!/usr/bin/perl -w
use strict;
require '../common.pl';

# 1000
# 0000
# 1100
# 0100

undef $/;

my @res = sort { $a cmp $b } uniq (map { tr/10/X./; rotate($_) } split /\n\n/, <>);
print join "\n\n", @res;
