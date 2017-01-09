#!/usr/bin/python2.7
#The script converts the conllu format into manatee format. It is a modified version of:
#https://github.com/UniversalDependencies/tools/blob/master/conllu-w2t.py
#For Manatee search the fused tokens should be treated differently, so that a user
#can query both for the whole word and for the parts.

###########input###########
# testfile sent_id  2
#1       Gas     gas     NOUN    S       Gender=Masc     0       root    _       _
#2-3     dalla   _       _       _       _       _       _       _       _
#2       da      da      ADP     E       _       4       case    _       _
#3       la      il      DET     RD      Definite=Def|Gender=Fem|Number=Sing|PronType=Art        4       det     _    _
#4       statua  statua  NOUN    S       Gender=Fem|Number=Sing  1       nmod    _       _
#5       .       .       PUNCT   FS      _       1       punct   _      ~

###########output#############
# testfile sent_id  2
#1       Gas     gas     NOUN    S       Gender=Masc     0       root    _       _
#2       dalla   da|il   ADP+DET E+RD    _+Definite=Def|Gender=Fem|Number=Sing|PronType=Art      3       case+det     _       _+_
#3       statua  statua  NOUN    S       Gender=Fem|Number=Sing  1       nmod    _       _
#4       .       .       PUNCT   FS      _       1       punct   _       _

# The query for the whole word: [word="dalla"], lemmas will be processed as multivalues, so both the queries [lemma="da"] and
#[lemma="il"] are valid.

import sys
import re
import file_util
from file_util import ID,FORM,LEMMA,CPOSTAG,POSTAG,FEATS,HEAD,DEPREL,DEPS,MISC #column index for the columns we'll need
import argparse

interval_re=re.compile("^([0-9]+)-([0-9]+)$")

def get_tokens(wtree):
    """
    Returns a list of tokens in the tree as integer intervals like so:
    [(1,1),(2,3),(4,4),...]

    `tree` is a tree (as produced by trees()) in the word-indexed format
    """
    tokens=[]
    for cols in wtree:
        if cols[ID].isdigit():
            t_id=int(cols[ID])
            #Not covered by the previous interval?
            if not (tokens and tokens[-1][0]<=t_id and tokens[-1][1]>=t_id):
                tokens.append((t_id,t_id)) #nope - let's make a default interval for it
        else:
            match=interval_re.match(cols[ID]) #Check the interval against the regex
            beg,end=int(match.group(1)),int(match.group(2))
            tokens.append((beg,end))
    return tokens

def w2t(wtree):
    tokens=get_tokens(wtree)
    word_ids=[u"0"] #root remains 0
    line_idx=0 #index of the line in wtree we are editing
    for token_idx,(b,e) in enumerate(tokens): #go over all token ranges and produce new IDs for the words involved
        wtree[line_idx][ID]=unicode(token_idx+1) #Renumber the ID field of the token
        if b==e: #token==word
            word_ids.append("%d"%(token_idx+1))
            line_idx+=1
        else:
            #We have a range, renumber the words
            wtree[line_idx][LEMMA]=wtree[line_idx+1][LEMMA]+"|"+wtree[line_idx+2][LEMMA] #concatenate lemmas of the fused tokens so that to allow multivalue search in Manatee
            attributes = [CPOSTAG,POSTAG,FEATS,DEPREL,MISC]
            for index, attr in enumerate(attributes):
                wtree[line_idx][attr]  = wtree[line_idx + 1][attr] + "+" + wtree[line_idx + 2][attr]
            wtree[line_idx][HEAD] = wtree[line_idx + 1][HEAD] # hopefully, all the elements of fused tokens have the same HEAD??
            wtree[line_idx][DEPS] = wtree[line_idx + 1][DEPS]
            line_idx+=1
            for word_idx,_ in enumerate(range(b,e+1)): #consume as many lines as there are words in the token

                word_ids.append("%d.%d"%(token_idx+1,word_idx+1))
                wtree[line_idx][ID]=word_ids[-1]

                line_idx+=1
    #word_ids is now a list with 1-based indexing which has the new ID for every single word
    #the ID column has been renumbered by now
    #now we can renumber all of the HEAD columns
    for cols in wtree:
        if cols[HEAD]==u"_": #token
            continue
        cols[HEAD]=word_ids[int(cols[HEAD])]
        if cols[DEPS]!=u"_": #need to renumber secondary deps
            new_pairs=[]
            for head_deprel in cols[DEPS].split(u"|"):
                head,deprel=head_deprel.split(u":")
                new_pairs.append(word_ids[int(head)]+u":"+deprel)
            cols[DEPS]=u"|".join(new_pairs)
        wtree = [cols for cols in wtree if "." not in cols[ID] ]
    #print wtree
    return wtree

if __name__=="__main__":
    opt_parser = argparse.ArgumentParser(description='Conversion script from word-based CoNLL-U to token-based CoNLL-U. This script assumes that the input is validated and does no checking on its own.')
    opt_parser.add_argument('input', nargs='?', help='Input file name, or "-" or nothing for standard input.')
    opt_parser.add_argument('output', nargs='?', help='Output file name, or "-" or nothing for standard output.')
    args = opt_parser.parse_args() #Parsed command-line arguments

    inp,out=file_util.in_out(args)
    for comments,tree in file_util.trees(inp):
        newtree = w2t(tree)
        file_util.print_tree(comments, newtree,out)
