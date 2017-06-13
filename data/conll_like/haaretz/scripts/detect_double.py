#!/usr/bin/python
# -*- coding: utf-8 -*-

#think of some hack to find (and for now delete) the sentences that are not aligned 1-1

import xml.etree.ElementTree as et
import sys
import re
from os.path import basename
import itertools
import numpy as np
from StringIO import StringIO


def process_block(block):
    #print(block)
    text = []
    ones=0
    for sent in block:
        if not sent in ['\n']:
            attributes=sent.split()
            if (attributes[0]=="1"):
                ones = ones + 1
            text.append(attributes)
        new_sentence = []
    
    if text:
        print ("<align>")
        for sentence in text:
            print '\t'.join(sentence)
        print("</align>")

def read_corpus_conllu(filename):
    with open(filename) as f:
        data=[]
        while True:
            line = f.readline()
            if not line:
                if data:
                    process_block(data)
                break
            if data and line.startswith("1\tDELETEIT"):
                process_block(data)
                data = []
            else:
                data.append(line)

        
def main():
    argv = sys.argv
    if len(argv) != 2:
        print 'USAGE: %s <parsed corpus in conllu format>' % (argv[0])
        sys.exit(0)
    corpus_filename = argv[1]
    read_corpus_conllu(corpus_filename)

if __name__ == "__main__":
    main()
