#!/usr/bin/env perl
#
# This file is part of moses.  Its use is licensed under the GNU Lesser General
# Public License version 2.1 or, at your option, any later version.

# Based on Preprocessor written by Philipp Koehn

binmode(STDIN, ":utf8");
binmode(STDOUT, ":utf8");
binmode(STDERR, ":utf8");

use warnings;
use FindBin qw($RealBin);
use strict;

my $mydir = "$RealBin/nonbreaking_prefixes";

my %NONBREAKING_PREFIX = ();
my $language = "en";
my $QUIET = 0;
my $HELP = 0;

while (@ARGV) {
  $_ = shift;
  /^-l$/ && ($language = shift, next);
  /^-q$/ && ($QUIET = 1, next);
  /^-h$/ && ($HELP = 1, next);
  /^-b$/ && ($|++, next); # no output buffering
}

if ($HELP) {
    print "Usage: ./split-sentences.perl (-l [en|de|...]) [-q] [-b] < textfile > splitfile\n";
    print "-q: quiet mode\n";
    print "-b: no output buffering (for use in bidirectional pipes)\n";
    print "  Sentences on input may span over multiple lines.\n";
    print "  Paragraphs on input are delimited by blank lines or <p>.\n";
    print "  Paragraphs on output are delimited by double empty lines.\n";
    print "  Sentences on output are delimited by line breaks.\n";
    exit;
}

my $prefixfile = "$mydir/nonbreaking_prefix.$language";

#default back to English if we don't have a language-specific prefix file
if (!(-e $prefixfile)) {
  $prefixfile = "$mydir/nonbreaking_prefix.en";
  print STDERR "WARNING: No known abbreviations for language '$language', attempting fall-back to English version...\n";
  die ("ERROR: No abbreviations files found in $mydir\n") unless (-e $prefixfile);
}

if (!$QUIET) {
  print STDERR "Sentence Splitter v3\n";
  print STDERR "Language: $language\n";
    print STDERR "Prefixfile: $prefixfile\n";
}

if (-e "$prefixfile") {
  open(PREFIX, "<:utf8", "$prefixfile") or die "Cannot open: $!";
  while (<PREFIX>) {
    my $item = $_;
    chomp($item);
    if (($item) && (substr($item,0,1) ne "#")) {
      if ($item =~ /(.*)[\s]+(\#NUMERIC_ONLY\#)/) {
        $NONBREAKING_PREFIX{$1} = 2;
      } elsif ($item =~ /(.*)[\s]+(\#ABBR\#)/) {
        $NONBREAKING_PREFIX{$1} = 3;
      } else {
        $NONBREAKING_PREFIX{$item} = 1;
      }
    }
  }
  close(PREFIX);
}

my $text = '';
while(my $text=<STDIN>) {
  chomp $text;
  if ($text =~ m/^<[^>]*>/) {
    print "\n$text\n";
  } else {
    print &preprocess($text) if $text;
    #unless ($text =~ /\n\n$/) {
    #  if ($text =~ /\n$/) { print "\n"; } else { print "\n\n"; }
    #}
    #print "\n" unless $text=~/\n$/;
    #add two newlines to create an empty line
  }
}

sub preprocess {
  #this is one paragraph
  my($text) = @_;

  # clean up spaces at head and tail of each line as well as any double-spacing
  $text =~ s/ +/ /g;
  $text =~ s/\n /\n/g;
  $text =~ s/ \n/\n/g;
  $text =~ s/^ //g;
  $text =~ s/ $//g;

  #####add sentence breaks as needed#####

  #non-period end of sentence markers (?!) followed by sentence starters.
  $text =~ s/([?!]) +([\'\"\(\[\¿\¡\p{IsPi}]*[\p{IsUpper}])/$1 \n $2/g;

  #multi-dots followed by sentence starters
  $text =~ s/(\.[\.]+) +([\'\"\(\[\¿\¡\p{IsPi}]*[\p{IsUpper}])/$1 \n $2/g;

  # add breaks for sentences that end with some sort of punctuation inside a quote or parenthetical and are followed by a possible sentence starter punctuation and upper case
  $text =~ s/([?!\.][\ ]*[\'\"\)\]\p{IsPf}]+) +([\'\"\(\[\¿\¡\p{IsPi}]*[\ ]*[\p{IsUpper}])/$1 \n $2/g;

  # add breaks for sentences that end with some sort of punctuation are followed by a sentence starter punctuation and upper case
  $text =~ s/([?!\.]) +([\'\"\(\[\¿\¡\p{IsPi}]+[\ ]*[\p{IsUpper}])/$1 \n $2/g;

    $text =~ s/(\s\p{IsUpper}.{0,6}\.)([0-9]+[\s\p{IsPunctuation}])/$1 $2/g;   # missing space between book name and chapter number
    $text =~ s/  */ /g;

  # special punctuation cases are covered. Check all remaining periods.
  my $word;
  my $i;
  my @words = split(/ /,$text);
  $text = "";
  for ($i=0;$i<(scalar(@words)-1);$i++) {
    if ($words[$i] =~ /([\p{IsAlnum}\.\-]*)([\'\"\)\]\%\p{IsPf}]*)(\.+)$/) {
      #check if $1 is a known honorific and $2 is empty, never break
      my $prefix = $1;
      my $starting_punct = $2;
      if($prefix && $NONBREAKING_PREFIX{$prefix} && $NONBREAKING_PREFIX{$prefix} == 1 && !$starting_punct) {
        #not breaking;
      } elsif ($words[$i] =~ /(\.)[\p{IsUpper}\-]+(\.+)$/) {
        #not breaking - upper case acronym
      } elsif ($words[$i] =~ /^([\dIVXC]+|\p{IsUpper}.{0,6})\.$/ && $words[$i+1] =~ /^\p{IsUpper}.{0,6}\.\p{IsPunctuation}?$/ ) {
                # not breaking inside a sequence of words ending in periods (possibly followed by other punctuation)
      } elsif ($words[$i+1] =~ /^\d*:\d*/) {
        #likely Biblical reference
      } elsif ($words[$i+2] && $words[$i] =~ /^[\dIVXC]+\.$/ && $words[$i+1] =~ /^\p{IsUpper}/ && $words[$i+2] =~ /^[\p{Isupper}\p{Number}]/) {
                # not breaking after ordinal number followed by what might be a book title
      } elsif ($words[$i] =~ /^\p{IsUpper}.{0,6}\.$/ && $words[$i+1] =~ /^[\p{IsNumber}IVXC]+/) {
                # abbreviation followed by a (possibly Roman) number - probably chapter/section number
      } elsif($words[$i+1] =~ /^([ ]*[\'\"\(\[\¿\¡\p{IsPi}]*[ ]*[\p{IsUpper}0-9])/) {
        #the next word has a bunch of initial quotes, maybe a space, then either upper case or a number
        $words[$i] = $words[$i]."\n" unless ($prefix && $NONBREAKING_PREFIX{$prefix} && $NONBREAKING_PREFIX{$prefix} == 2 && !$starting_punct && ($words[$i+1] =~ /^[0-9]+/));
        #we always add a return for these unless we have a numeric non-breaker and a number start
      } elsif($words[$i+2] && $words[$i+1] =~ /^<[^>]*>$/ && $words[$i+2] =~ /^([ ]*[\'\"\(\[\¿\¡\p{IsPi}]*[ ]*[\p{IsUpper}0-9])/) {
        #between this and the next word is a tag AND the next word has a bunch of initial quotes, maybe a space, then either upper case or a number
        $words[$i] = $words[$i]."\n" unless $words[$i+1]=~m@^</[ph][12]?>|</?div.*@;
        #we always add a return for these
      }

    }
    $text = $text.$words[$i]." ";
  }

  #we stopped one token from the end to allow for easy look-ahead. Append it now.
  $text = $text.$words[$i];

  # clean up spaces at head and tail of each line as well as any double-spacing
  $text =~ s/ +/ /g;
  $text =~ s/\n /\n/g;
  $text =~ s/ \n/\n/g;
  $text =~ s/^ //g;
  $text =~ s/ $//g;

  return $text;

}


