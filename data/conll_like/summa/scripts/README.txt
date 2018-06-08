#!/bin/bash

r9292:
    source_{cz,en,la}.txt jsou data od Martina Holuba, spojená do jednoho souboru, s několika ručními opravami
    - části jsou označené značkou <pars>, ta odpovídá jak původním souborům, tak dělení Summy na čtyři části
    - všechny soubory mají stejný počet řádků, každý řádek začíná identifikátorem, který končí | (později přepsáno na tab)
    - zjevně existují kusy textu, které přeložené nejsou, minimálně v anglické části chybí celý úvod (na třetím řádku souboru je jen nadpis, v latině tam ale je několik odstavců)
    - naopak v angličtině jsou navíc např. odstavce obsahující jen v závorkách kapitálkami uvedený text o počtu pododdílů, např. (TEN ARTICLES) na řádku 6, a ty zas neodpovídají ničemu v latině
    
    for lang in cz en la; do cat source_$lang.txt | sed -e 's/\([|>]\)[^<]*\(<\|$\)/\1\2/g; s/Článek/Article/; s/Articulus/Article/; s/Otázka/Question/; s/Quaestio/Question/; s/Prooemium/Preamble/; s/Předmluva/Preamble/; s/<I>//g; s@</I>@@g' > tags.$lang; done
    
    OCR chyby
    - v českém textu jsem koukala na místa, kde je naopak malé písmeno po tečce. Jenomže na nahrazení prostým regexpem se mi nezdají, protože v textu je velká spousta zkratek knih - asi v polovině případů je tedy to malé písmeno po tečce správně, a kde správně není, je někdy špatně tečka (má být čárka) a jindy písmeno po ní (má být velké). Nejlépe by se to opravilo asi až podle sentence alignmentu nebo vím já podle čeho, ale v plaintextu úplně nevidím, jak na to.
    Ta místa jsem si ručně prohlížela ve vimu tímto regexpem (tečka po číslovce, ať už latinské nebo římské, mě nezajímala):
    /|.*[^IV0-9]\zs\. [a-z]
    přesněji pro jejich interaktivní nahrazování
    :.,$ s/|.*[^IV0-9]\zs\. \([a-z]\)/, \1/gc
    ale je jich příliš mnoho na to, aby se mi chtělo každý výskyt ručně kontrolovat a rozhodovat, jestli ano nebo ne.

================
sed -e 's/^.*|//;s/<[^>]*>/ /g' source_la.txt > plaintext.la

#zkusíme odhalit podezřelé znaky:
cat plaintext.la | tr -d '.,:?;()' | tr ' ' '\n' | tr -d ' ' | grep -v "^[a-zA-Z \t\n]*$"
cat plaintext.la | grep '[a-zA-Z][.,:?;()][a-zA-Z]'
cat plaintext.la | grep '[a-z][A-Z]'
cat source* | grep '[#&]'

#po následném opravení source_la.txt a novém vytvoření plaintext.la si vygenerujeme slovník:
cat plaintext.la | grep -o '[a-zA-Z]*' | sort -u > words.la
words words.la


#ve vimu nahradit | taby 
#a přesunout "Otázka #" jako <h1> a "Předmluva", "Článek #" jako <h2> až za tab
#(to tu nemám); potom:
paste source_* | awk -F$'\t' '{if ($1==$3 && $1==$5) {print $2"\t"$4"\t"$6"\t"$1} else {print $2"\t"$4"\t"$6"\tBEWARE: "$1"!="$3"!="$5}}' > paste
grep BEWARE paste   #pro kontrolu: po několika drobných úpravách by neměl nic vrátit!


## jak pustit hunalign bez hunalignwrapperu tak, aby uložil "slovník" do output.dic
touch empty.input.dic
/a/LRC_TMP/varis/umc-devel/tools/external/hunalign-1.1/hunalign -realign -autodict=output.dic empty.input.dic /a/LRC_TMP/vernerova/summa.WB3/tmp.la /a/LRC_TMP/vernerova/summa.WB3/tmp.cs > /a/LRC_TMP/vernerova/summa.WB3/hunalignwrap0Pe2/ladder 2> /a/LRC_TMP/vernerova/summa.WB3/hunalignwrap0Pe2/log


## jak pouštím alignment na clusteru
rm DATA/in/*aligned*; for file in DATA/in/*; do qsub -cwd -N $(basename $file) ./make.sh $file; done;
  # make.sh must be run on cluster because of memory requirements
## opakovaně pouštím qstat a neúspěšné joby pustím znovu:
for file in DATA/in/x17; do qsub -cwd -N $(basename $file) ./make.sh $file; done; qstat
## když už jsem spokojená, pustím
qdel '*'
rm x??.[oe]??????
cd DATA/; for lang in en cs; do cat in/x??.aligned.la-$lang > paste.aligned.la-$lang; done
scp paste.aligned.la-?? kontext-dev:~/corpora/conversions/data/conll_like/summa/input

#### !!!! z nějakého důvodu jsou v souboru paste.aligned.la-cs ukončující znaky tagů, které nikde nezačínají,
#### a také tam chybí některé řádky, které ve vstupních souborech byly (jsou to ty, které jsou poslední v některých z 80 souborů, na které jsem si to rozdělila --- ale ne všechny, které jsou poslední, takže nechápu, co se děje :-( )
#### zatím jsem to opravila ručně a je to v souboru paste.aligned.manually-adjusted

==============================
opsano od Dusana:
Latin lemmatization:

git clone https://github.com/CIRCSE/LEMLAT3.git LEMLAT3
cd LEMLAT3
tar xzfv bin/linux_embedded.tar.gz
