#!/bin/bash

sed -i -n -e '/<doc id=".*train.*">/,/<\/doc>/p;/<doc id=".*train.*"/,$!H;${x;p};' $1 # order of parts: train, dev, test
sed -i -e '/^$/d; s/^<doc /<data /; s/<\/doc>/<\/data>/' $1   # rename doc to part so that newdoc can be renamed to doc
perl -i'.orig' -e '
          use feature qw(switch say);
          my $wasdoc; my $waspar;
          my $docline; my $parline;
          while (<>) {
            if (s/newdoc(="[^"]*")\s*//) {
              $docline = "<doc id=$1>\n";
              if ($waspar) { say "</par>" }
              if ($wasdoc) { say "</doc>" }
              $wasdoc = 1; $waspar = 0;
            } 
            if (s/newpar(="[^"]*")\s*//) {
              $parline = "<par id=$1>\n";
              if ($waspar) { say "</par>" }
              $waspar = 1;
            }
            if (m@</data>@) {
              if ($waspar) { say "</par>" }
              if ($wasdoc) { say "</doc>" }
              $wasdoc = 0; $waspar = 0;
            }
            print "$docline$parline$_";
            $docline = ""; $parline = "";
          }' $1


### not working attempt to treat newdoc and newpar without ids:
#sed -i -e '/newdoc/ { s/^\(<s .*\)newdoc\(="[^"]*" \?\)/<doc id\2>\n\1/;
#                      P;D;
#                      s/^\(<s .*\)newpar\(="[^"]*" \?\)/<par id\2>\n\1/;
#                      s/^\(<s .*\)newpar/<par>\n\1/}
#           /newdoc/ { s/^\(<s .*\)newdoc/<doc>\n\1/;
#                      P;D;
#                      s/^\(<s .*\)newpar\(="[^"]*" \?\)/<par id\2>\n\1/;
#                      s/^\(<s .*\)newpar/<par>\n\1}
#           s/^\(<s .*\)newpar\(="[^"]*" \?\)/<par id\2>\n\1/
#           s/^\(<s .*\)newpar/<par>\n\1/
#
