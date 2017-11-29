#!/usr/bin/gawk  -f
BEGIN {FS="\t"; last="";lastsegment="div"}
{  if ($2~"^<[^>]*>$") {
     if ( last!="" ) { 
       print "<"lastsegment" id=\""last"\">"
       last=""
     }
     print $2
   } else {
     if ($1 != "" ) {
       if ( last!="" ) { 
         print "<"lastsegment" id=\""last"\">"
       }
       last=$1
       # now is the right moment to change lastsegment depending on $1
       print "</"lastsegment">"
       print $2
     } else { # $1 == ""
       if ($2 ~ "^<h2>(Článek|Article|Articulus)") {
         if ( last!="" ) { 
           print "<"lastsegment" id=\""last"\">"
         }
         print "</"lastsegment">"
         print $2
         match(last,/(@[I-]* q. [0-9]* a. [0-9]*)/,tmp)
         last=tmp[1]
       } else {
         print $2
       }
     }
   }
}
