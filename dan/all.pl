#!/usr/bin/env perl
# Computes klcpos3 for all the Latin treebanks.
# Copyright © 2023 Dan Zeman <zeman@ufal.mff.cuni.cz>
# License: GNU GPL

use utf8;
use open ':utf8';
binmode(STDIN, ':utf8');
binmode(STDOUT, ':utf8');
binmode(STDERR, ':utf8');

my $udpath = 'C:/Users/Dan/Documents/Lingvistika/Projekty/universal-dependencies';
my @treebanks = qw(Perseus PROIEL UDante ITTB LLCT);
my @distributions = ();
foreach my $tbk (@treebanks)
{
    my $tcode = lc($tbk);
    foreach my $part (qw(train dev test))
    {
        my $ipath = "$udpath/UD_Latin-$tbk/la_$tcode-ud-$part.conllu";
        if(-f $ipath)
        {
            my $opath = "la_$tcode-ud-$part-upos3.txt";
            print("perl conllu_upos_trigrams.pl $ipath > $opath\n");
            system("perl conllu_upos_trigrams.pl $ipath > $opath");
            if($part ne 'dev')
            {
                push(@distributions, $opath);
            }
        }
    }
}
my %kl;
foreach my $tgt (@distributions)
{
    foreach my $src (@distributions)
    {
        print("perl $udpath/tools/klcpos3.pl $tgt $src\n");
        my $klcpos3 = `perl $udpath/tools/klcpos3.pl $tgt $src`;
        $klcpos3 =~ s/^KLcpos3 = //;
        $klcpos3 =~ s/\r?\n$//;
        if($tgt =~ m/test/ && $src =~ m/train/)
        {
            $kl{"$tgt | $src"} = $klcpos3;
        }
    }
}
my @keys = sort {$kl{$b} <=> $kl{$a}} (keys(%kl));
foreach my $key (@keys)
{
    print("$key\t$kl{$key}\n");
}
