## Conversion in general
The treebanks from a CoNLLU format are transformed into a vertical format with a
treex script: https://github.com/ufal/treex/blob/master/lib/Treex/Block/Write/ManateeU.pm, printing the following information: 
form lemma pos ufeatures deprel parent_form parent_lemma parent_pos parent_ufeatures parent_deprel left/right immediate/distant
After the new version of KonText will be released, we will be able to use global conditions and search for attributes 
of a parent via its id. More, see issue [11](https://github.com/ufal/lindat-corpora-conversions/issues/11)

## Autogenerate registry

Because there are multiple templates, the script generate_templates.py was
created to automatically generate registry files (templates). 

## Splitting to documents
Some treebanks, like Italian and Bulgarian, have document name meta-information.
Use the script **split_to_docs.py** before convertions. 
Should we include it into UD, and thus those treebanks will be inconsistent with others?
   

## Process fused tokens

The following treebanks have fused tokens:
de,it,cs,es,fa,fi,fr,he, e.g. 2-3 and 5-6 in Spanish, example in conllu:
```
1       Producto        _       NOUN    _       _       15      nmod    _       _
2-3     del     _       _       _       _       _       _       _       _
2       de      _       ADP     _       _       4       case    _       _
3       el      _       DET     _       _       4       det     _       _
4       fin     _       NOUN    _       _       1       nmod    _       _
5-6     del     _       _       _       _       _       _       _       _
5       de      _       ADP     _       _       7       case    _       _
6       el      _       DET     _       _       7       det     _       _
7       imperio _       NOUN    _       _       4       nmod    _       _
8       y       _       CONJ    _       _       7       cc      _       _
9       las     _       DET     _       _       10      det     _       _
10      invasiones      _       NOUN    _       _       7       conj    _       
```
There are several ways to handle this problem, as suggested by Dan Zeman:

1. Postprocess treex output. Ignore 2-3 lines. If we leave them as they are, the nodes 2-3 containing the actual word form will be ignored by treex. We can put the wordform *del* into the position of wordform *2 de* and
concatenate other features, e.g. *ADP+DET*. Lemma can be either a wordform or *de+el*.The wordform
in line 3 will be empty to preserve original text: 
```
del     del     ADP+DET _       case+det        fin     _+_     NOUN    _       nmod    right   distant
        _       DET     _       det     fin     _       NOUN    _       nmod    right   immediate
fin     _       NOUN    _       nmod    Producto        _       NOUN    _       nmod    left    distant
```
Two major drawbacks. It will leave a phantom node with no wordform and other attributes. In the above example, *de* and *el* have a parent *fin*, but the third not is immediate to the parent whereas
the second is distant.

2. Preprocess before treex (process_fusion.py in data/treex/universal_dep/scripts). Merge the lines 2 and 3 into one line, shift the ids of subsequent tokens:
```
1       Producto        _       NOUN    _       _       15      nmod    _       _
2     del     del       ADP+DET       _+_       _+_       4       case+det       _+_       _+_
3       fin     _       NOUN    _       _       1       nmod    _       _
```
The problem with distant and position or phantom nodes will not occur. So far the algorithm
does not do the shift of heads whereas doing the shift of ids. If this solution is acceptable, 
I will fix it.

3. Think of some more complicated way to handle the problem so that all information from UD will
be in KonText.

