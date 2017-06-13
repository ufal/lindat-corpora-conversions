Haaretz corpus was kindly provided by Shuly Wintner to make some experiments with multiword expressions.
It was processed and put to the (only development version, not production) KonText. 
The data was deleted due to copyright policies. The processed version of the corpus in vertical format plus
the registry file was send to the authors of Haaretz.

The scripts to process and convert Haaretz can be applied to any other bi-parallel corpus:
1. **parse_hen.sh** Pre-process (insert NEWLINE flag so that the original segmentation of sentence stays the same) and parse by UDPIPE
2. **detect_double.py** Insert <align> tags according to the original alignment ignoring UDPIPE segmentation. In case n-m alignment, the
parsed output will not be very helpful as the dependencies enumeration will be wrong:
```
ENG:
<align>
1       This    this    PRON    DT      Number=Sing|PronType=Dem        4       nsubj   _       _
2       is      be      VERB    VBZ     Mood=Ind|Number=Sing|Person=3|Tense=Pres|VerbForm=Fin   4       cop     _       _
3       the     the     DET     DT      Definite=Def|PronType=Art       4       det     _       _
4       man     man     NOUN    NN      Number=Sing     0       root    _       _
5       we      we      PRON    PRP     Case=Nom|Number=Plur|Person=1|PronType=Prs      6       nsubj   _       _
6       knew    know    VERB    VBD     Mood=Ind|Tense=Past|VerbForm=Fin        4       acl:relcl       _       _
7       -       -       PUNCT   ,       _       4       punct   _       _
8       an      a       DET     DT      Definite=Ind|PronType=Art       9       det     _       _
9       adventurer      adventurer      NOUN    NN      Number=Sing     4       appos   _       _
10      and     and     CONJ    CC      _       9       cc      _       _
11      a       a       DET     DT      Definite=Ind|PronType=Art       12      det     _       _
12      man     man     NOUN    NN      Number=Sing     9       conj    _       _
13      who     who     PRON    WP      PronType=Rel    14      nsubj   _       _
14      causes  cause   VERB    VBZ     Mood=Ind|Number=Sing|Person=3|Tense=Pres|VerbForm=Fin   9       acl:relcl       _       _
15      rifts   rift    NOUN    NNS     Number=Plur     14      dobj    _       SpaceAfter=No
16      .       .       PUNCT   .       _       4       punct   _       _
<\align>


HEB:
<align>
1       אז      _       ADV     ADV     _       3       advmod  _       _
2       זה      _       PRON    PRON    Gender=Masc|Number=Sing|Person=3        3       nsubj   _       _
3       נגמר    _       VERB    VERB    Gender=Masc|HebBinyan=NIFAL|Number=Sing|Person=1,2,3|VerbForm=Part      0       root    _       _
4       רע      _       ADJ     ADJ     Gender=Masc|Number=Sing 3       amod    _       _
5       ,       _       PUNCT   PUNCT   _       3       punct   _       _
6       עכשיו   _       ADV     ADV     _       8       advmod  _       _
7       זה      _       PRON    PRON    Gender=Masc|Number=Sing|Person=3        8       nsubj   _       _
8       מתחיל   _       VERB    VERB    Gender=Masc|Number=Sing|Person=1,2,3|VerbForm=Part      3       conj    _       _
9       רע      _       ADJ     ADJ     Gender=Masc|Number=Sing 8       dobj    _       SpaceAfter=No
10      .       _       PUNCT   PUNCT   _       3       punct   _       _
1       זהו     _       PRON    PRON    Gender=Masc|Number=Sing|Person=3|PronType=Dem   0       root    _       _
2-3     האיש    _       _       _       _       _       _       _       _
2       ה       _       DET     DET     PronType=Art    3       det:def _       _
3       איש     _       NOUN    NOUN    Gender=Masc|Number=Sing 1       nsubj   _       _
4       שהכרנו  _       PROPN   PROPN   _       3       appos   _       _
5       .       _       PUNCT   PUNCT   _       1       punct   _       _
</align>


``` 
This needs more accurate solution or proper testing.

3. **merge_all.sh** Merge all into one document

4. Compile as usual


