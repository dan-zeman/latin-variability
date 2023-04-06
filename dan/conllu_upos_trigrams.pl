#!/usr/bin/env perl
# Reads CoNLL-U. Counts UPOS trigrams.
# Copyright © 2023 Dan Zeman <zeman@ufal.mff.cuni.cz>
# License: GNU GPL

use utf8;
use open ':utf8';
binmode(STDIN, ':utf8');
binmode(STDOUT, ':utf8');
binmode(STDERR, ':utf8');

my %hash;
my $upos1 = '<s>';
my $upos2 = '<s>';
my $n = 0;
while(<>)
{
    my $upos;
    if(m/^\s*$/)
    {
        $upos = '<s>';
    }
    elsif(m/^[0-9]+\t/)
    {
        my @f = split(/\t/, $_);
        $upos = $f[3];
    }
    else
    {
        next;
    }
    $n++;
    my $trigram = "$upos2 $upos1 $upos";
    $hash{$trigram}++;
    $upos2 = $upos1;
    $upos1 = $upos;
}
my @trigrams = sort {my $r = $hash{$b} <=> $hash{$a}; unless($r) {$r = $a cmp $b} $r} (keys(%hash));
foreach my $trigram (@trigrams)
{
    my $p = $hash{$trigram}/$n;
    printf("$trigram\t$hash{$trigram}\t%.6f\n", $p);
}
