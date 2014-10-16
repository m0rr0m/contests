#!/usr/bin/perl -w
use strict;
require '../common.pl';

# ++++++
# +* * +
# +   *+
# +  * +
# +    +
# ++++++
#

undef $/;
my $str = <>;
$str =~ s/\+//g;

my @res = sort { $a cmp $b } uniq (map { s/^\n//; tr/ */.X/; rotate($_) } split /\n\n\n\n/, $str);
print join "\n\n", @res;
