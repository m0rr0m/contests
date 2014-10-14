#!/usr/bin/perl -w
use strict;
require "../common.pl";

# xx..
# xx..
# ....
# ....
#
undef $/;
my @res = sort { $a cmp $b } uniq (map { tr/x/X/; rotate($_) } split /\n\n/, <>);
print print join "\n\n", @res;
