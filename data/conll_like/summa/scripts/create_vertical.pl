#!/usr/bin/perl
use strict;
use warnings;
#use diagnostics;
use locale;    # sorts natural text, not binary data:
# _0123456789aAbBcCdDeEfFgGhHiIjJkKlLmMnNoOpPqQrRsStTuUvVwWxXyYzZ
#no locale;     # sorts as binary data:
# 0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ_abcdefghijklmnopqrstuvwxyz
use POSIX qw(locale_h);    # Import locale-handling tool set from POSIX module; necessary for use of setlocale
setlocale(LC_ALL, qw(cs_CZ.UTF8));   # for the time being, set locale to Czech UTF-8; affects what is considered alphanumeric character in regexp, e.g. "\w"
## you can change the locale at runtime, e.g.:
#$old_locale = setlocale(LC_CTYPE); setlocale(LC_CTYPE, qw(cs_CZ.UTF8));
## restore the old locale with
#setlocale(LC_CTYPE, $old_locale);
setlocale(LC_NUMERIC, qw(en_EN.UTF8));   # influnces decimal comma/point
setlocale(LC_COLLATE, qw(cs_CZ.UTF8));   # ordering

use utf8;                      # now you may use UTF-8 in the source code!
binmode STDOUT, ':encoding(utf8)';
binmode STDIN, ':encoding(utf8)';
use feature 'unicode_strings';  # full internal Unicode support: interpret internal representation of strings as utf8 (but does not change the internal representation!)

use Encode qw(encode decode);     # for handling input and output (including command-line arguments): en/decode('utf8',$string)

### Encode is also useful with the CGI module and UTF-8 input, because in the following case, $x is not considered tainted:
## #!/usr/bin/perl -T
## use CGI qw(:standard -utf8);   # the -utf8 switch causes $x to be untainted
## my $x=param('x');
## open(OUT, ">$x");
## print OUT "$x";

### while in the following case, $x is considered tainted and running the script throws an error
## #!/usr/bin/perl -T
## use CGI qw(:standard);
## use Encode qw(decode);
## my $x=param('x');
## $param = decode('UTF-8', $param);
## open(OUT, ">$x");
## print OUT "$x";


use feature qw(switch say);

# Debuging...
my $debug = 1;
sub _debug {
  if ($debug) { say join "\n", @_; }
}
#sub _debug {
#  my $debug = shift; # == 1   -> output (add_line)
#                     # == 2   -> main (reading of the vallex.txt file)
#  if ($debug>1) { 
#    if ( defined((caller(1))[3]) ) { 
#      print STDERR "\n\n", (caller(1))[3], ":\n", @_; 
#    } else {
#      print STDERR "\n\n", "main:\n", @_; 
#    }
#  }
#}

foreach my $filename (@ARGV) {
  open XML, "<:encoding(utf-8)", "$filename.xml_positions";
  my @structures; my @structure_positions;
  while (<XML>) {
    my @line = split /\t/;
    push @structures, $line[0];
    push @structure_positions, $line[1];
  }
  
  open CONLLU, "<:encoding(utf-8)", "$filename.parsed";
  open VERTICAL, ">:encoding(utf-8)", "$filename.vertical";
  my $insentence = 0;
  while (<CONLLU>) {
    chomp;
    if (m/^# sent_id/) {
      if ($insentence==1) { say VERTICAL "</s>"; $insentence = 2 }
    } elsif (m/TokenRange=(\d*):\d*/) {
      my $token_start=$1;
      my @line = split /\t/, $_, 3;
      while ($structure_positions[0] <= $token_start) {
        shift @structure_positions;
	my $element = shift @structures;
	say VERTICAL $element;
      }
      if ($insentence!=1) {
	say VERTICAL "<s>"; $insentence = 1
      }
      say VERTICAL "$line[1]\t$line[2]\t$line[0]";
    }
  }
  say VERTICAL "</s>" if $insentence==1;
  while (shift @structure_positions) {
    my $element = shift @structures;
    say VERTICAL $element;
  }
}


1;
## we need the TRUE value as the last thing to tell Perl that everything went
##   OK when loading the file
## this would be relevant especially if the module contains any code that is not
##   part of any subroutine as such code is executed at the time the module is loaded
## the default return value of loading a module is 0!
## thus a module which only contains subroutines would fail when "require"d or "use"d in another module
