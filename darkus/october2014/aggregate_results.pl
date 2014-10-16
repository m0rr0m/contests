#!/usr/bin/perl -w
use strict;

my $root = '.';

opendir DIR, $root;
my @dir = grep { /^[^\.]/ } grep { -d "$root/$_" } readdir(DIR);
closedir DIR;

# 0:00.66elapsed
my $pat = qr/(\d+):(\d+\.\d+)elapsed/;
my @n = (4, 6);

my %h;
foreach my $dir (@dir){
    foreach my $n (@n){
        $h{$dir}{$n} = extract_time($dir, $n);
    }
}

my @table = (['N', @n]);
push(@table, ['-', map { '--' } @n]);
foreach my $dir (@dir){
    my @res = map { $h{$dir}{$_} } @n;
    push(@table, [$dir, @res]);
}

print (join "\n", map { '|' . (join '|', @$_) . '|' } @table);

sub extract_time {
    my ($user, $n) = @_;
    local $/ = undef;
    open(FILE, '<', "$user/time$n") or return '-';
    my $str = <FILE>;
    close FILE;

    return unless  $str =~ $pat;
    my ($m, $s) = ($1, $2);

    return $m*60 + $s;
}
