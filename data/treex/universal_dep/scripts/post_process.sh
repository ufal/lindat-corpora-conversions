#!/bin/bash

sed -i -n -e '/<doc id=".*train">/,$p;/<doc id=".*train"/,$!H;${x;p};' $1 # order of parts: train, dev, test
sed -i -e '/^$/d; s/^<doc /<data /; s/<\/doc>/<\/data>/' $1   # rename doc to part so that newdoc can be renamed to doc
perl -i'.orig' -e '
          use feature qw(switch say);
          my $wasdoc; my $waspar;
          my $docline; my $parline;
          my $lastdocline; 
          while (<>) {
            s/^(<data id=").*-(?=train|dev|test)/\1/;
            if (s/newdoc(="[^"]*")\s*//) {   ## new document
              $docline = "<doc id$1>\n";
              $lastdocline = "<doc id$1>\n";
              if ($waspar == 1) { 
                say "</par>"
              } 
              if ($wasdoc == 1) { say "</doc>" }
              $wasdoc = 1; $waspar = 0;
            } elsif ($_=~m/^<s /) {
              if ($wasdoc == 2) {  ## special case: first sentence in new data division which does not start a new document belongs to a continuation of the last document from the previous division
                $docline = $lastdocline;
                $wasdoc = 1;
              }
            } 
            if (s/newpar(="[^"]*")\s*//) {
              $parline = "<par id$1>\n";
              $lastparline = "<par id$1>\n";
              if ($waspar) { say "</par>" }
              $waspar = 1;
            }
            if (m@</data>@) {
              if ($waspar) { say "</par>"; $waspar = 0; }
              if ($wasdoc) { say "</doc>"; $wasdoc = 2; }
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
