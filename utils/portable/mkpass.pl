#!/usr/bin/perl

use strict;
use warnings;

# cpan experimental
use experimental 'signatures';

sub crange ($start, $end) {
    map { chr $_ }
        ord($start) .. ord($end);
}

sub strarr ($str) {
    map { substr($str, $_, 1) }
        1..length($str);
}

my @chrs = (crange('a','z'),
            crange('A','Z'),
            crange('0','9'),
            strarr('+-_/><,.";:\'!@#$%^&*()'));

my $n = $ARGV[0] // 10;
print join('', map { $chrs[rand(@chrs)] }
                   1..$n);
