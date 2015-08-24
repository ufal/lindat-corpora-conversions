#!/usr/bin/python
# -*- coding: utf-8 -*-
#Processing treebanks with fused tokens.
#The following nodes:
# 2-3	dalla	_	_	_	_	_	_	_	_
#2	da	da	ADP	E	_	4	case	_	_
#3	la	il	DET	RD	Definite=Def|Gender=Fem|Number=Sing|PronType=Art	4	det	_	_
#Will be merged into:
#2 	dalla 	dalla 	ADP+DET 	E+RD 	_+Definite=Def|Gender=Fem|Number=Sing|PronType=Art 	4 	case+det 	_+_ 	_+_

import string
import re
import glob
import os
import sys
import StringIO

def IfTreeFused(tree):
    for node in tree:
        if (node[0].isdigit() and node[2] == "-") or (node[0].isdigit() and node[1] == "-"):
            #print "True"
            return True

#id, form, lemma, cpostag, postag, feats, head, deprel, deps, misc
def ProcessTreeWithFused(tree, number_of_fused):
    length = len(tree)
    for i in range(length):
        if ( tree[i][2] != "-" and tree[i][1] != "-"):
            print tree[i].strip()
        else:
            fields = re.split(r'\t', tree[i])
            id_line = fields[0]
            first_id, second_id = id_line.split('-')
            corrected_id = int(first_id) - number_of_fused
            full_lemma = fields[1]
            fields_line2 = re.split(r'\t', tree[i + 1].strip())
            fields_line3 = re.split(r'\t', tree[i + 2])
            print str(corrected_id)+"\t"+full_lemma+"\t"+full_lemma+"\t"+fields_line2[3]+"+"+fields_line3[3]+"\t"+fields_line2[4]+"+"+fields_line3[4]+"\t"+fields_line2[5]+"+"+fields_line3[5]+"\t"+fields_line2[6]+"\t"+fields_line2[7]+"+"+fields_line3[7]+"\t"+fields_line2[8]+"+"+fields_line3[8]+"\t"+fields_line2[9]+"+"+fields_line3[9].strip()
            tree_i3 = tree[i+3:]
            number_of_fused +=1
            for k in range(0, len(tree[i+3:])-1):
                (tree_id, rest) = (tree[i+3:][k]).split("\t", 1) #tree[i+3][k].split('\t', 1)
                if '-' not in tree_id:
                    print str(int(tree_id)-number_of_fused)+"\t"+rest.strip()
                    tree_i3.pop(0)
                else: #if fusion occured in the tree more than once
                    ProcessTreeWithFused(tree_i3, number_of_fused)
                    break
            break

filename = sys.argv[-1]
with open(filename, 'r+') as f:
    bunch = []
    for line in f:
        bunch.append(line)
        if line=='\n':
            if IfTreeFused(bunch):
                ProcessTreeWithFused(bunch, 0)
                print "\n"
                bunch = []
            else:
                print "".join(bunch)
                #print "\n"
                bunch = []