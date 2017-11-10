#!/usr/bin/env perl
use autodie;
use utf8;

my $f = 1;
my $l = 0;
my $h;

my ($dir, $n) = @ARGV;

die ('Usage: ./split_by_n.pl DIR N < input') if (!$dir || !$n);

binmode( STDIN, ':utf8' );

while (<STDIN>){

    if ( $l % $n == 0 ){
        close($h) if ($h);
        my $subdir = $dir . '/' . sprintf("d%03d", int($f/1000));
        if (!(-e $subdir)){
            print STDERR $subdir . "\n";
            mkdir $subdir;
        }
        my $fname = $subdir . '/'. sprintf("f%05d.txt", $f);
        open($h, '>:utf8', $fname );
        $f++;
    }
    print { $h } $_;
    $l++;
}
