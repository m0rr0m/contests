#!/usr/bin/perl -w
use strict;

my $root = '.';

opendir DIR, $root;
my @dir = grep { /^[^\.]/ } grep { -d "$root/$_" } readdir(DIR);
closedir DIR;

my @n = (4);


