#!/usr/bin/perl

# For some reason, compilecorp deletes empty structures if they are immediately followed by another structure of the same type.
# At this moment, this happens for some <ref>s (but that should be mostly solved when we move the text="..." attribute back into the vertical text),
# and - more importantly - to some empty <seg>s, which breaks the alignment.
# so we insert the word EMPTY_SEGMENT into these empty segments:
# EMPTY_SEGMENT _ _ _ _ _ _ _ _ _




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

foreach my $filename (@ARGV) {
  open IN, "<:encoding(utf-8)", "$filename";
  my @structures; my @structure_positions;
  my @in = <IN>;
  close IN;
  open OUT, ">:encoding(utf-8)", "$filename";
  for (my $i=0; $i<$#in; $i++) {
    print OUT $in[$i];
    if ($in[$i]=~m@^\<(\w*)@ and $in[$i+1]=~m@\<\/$1\>@) {
      say OUT "EMPTY_SEGMENT\t_\t_\t_\t_\t_\t_\t_\t";
    }
  }
  print OUT $in[-1];
  close OUT;
}


1;
## we need the TRUE value as the last thing to tell Perl that everything went
##   OK when loading the file
## this would be relevant especially if the module contains any code that is not
##   part of any subroutine as such code is executed at the time the module is loaded
## the default return value of loading a module is 0!
## thus a module which only contains subroutines would fail when "require"d or "use"d in another module
