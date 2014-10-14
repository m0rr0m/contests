#!/usr/bin/perl -w
use strict;
require '../common.pl';

# [[[0,0,0,0],[0,0,0,0],[0,0,1,0],[0,1,1,1]], ...]
my @res = sort uniq map { 
    rotate(join "\n", map { s/[\[,\]]//g; tr/01/.X/; $_ } split /\],\[/)
} <> =~ /\[\[.+?\]\]/g;

print join "\n\n", @res;
