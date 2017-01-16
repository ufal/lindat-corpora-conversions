#!/usr/bin/python
# -*- coding: utf-8 -*-
#Splitting a treebank into several documents according to the id, relevant for Italian and Bulgarian treebanks, the
#others do not have a doc_id metainformation

import string
import re
import glob
import os
import sys
import StringIO


def PrintToFileIt(bunch):
    filename = 'it-doc-'+bunch[0].split(' ')[1]+'-train'
    f = open(filename, 'a+')
    text = "".join(bunch)
    f.write(text)
    f.close()

def PrintToFileBg(bunch):
    print bunch
    print bunch[2]
#    f = open(filename, 'a+')
#    text = "".join(bunch)
#    f.write(text)
#    f.close()

filename = sys.argv[-1]
with open(filename, 'r+') as f:
    bunch = []
    for line in f:
        bunch.append(line)
        if filename.startswith('it') and line=='\n':
            PrintToFileIt(bunch)
            bunch = []
        if filename.startswith('bg') and line=='\n':
            PrintToFileBg(bunch)
            bunch = []