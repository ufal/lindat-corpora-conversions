#!/usr/bin/python
# -*- coding: utf-8 -*-

import sys
import re
from os.path import basename
import xml.etree.ElemntTree as ET

def extract_doc_id(filename):
    parts = filename.split('/')
    basename = parts[-1]
    doc_id = re.sub(r'^([a-zA-Z-]*[a-zA-Z])[-].*$','\\1',basename)
    return doc_id


def process_file(filename, docs):
    doc_id=extract_doc_id(filename)
    if not doc_id in docs:
        docs[doc_id] = []
    docs[doc_id].append(filename)
    return docs

def tokenize_sentence(sentence):
    tokens = [ token.decode('utf8').lower() for token in sentence.split(' ')]
    return tokens

def process_sentence(file, sentence, i):
    tokens = tokenize_sentence(sentence)
    soundfile = re.sub(r'^.*?([^/]*)\.wav\.trs$', '\\1.mp3', file)
    print '<sp num="%d">' % i
    print '<seg soundfile="%s">' % soundfile
    #print '<seg soundfile="%s" time=0>' % soundfile
    try:
        print u"\n".join(tokens).encode('utf-8')
    except UnicodeError as e:
        raise Exception(file)
    print "</seg>"
    print "</sp>"


def convert_file(file, i):
    file_fullpath = '../input/'+file 
    with open(file_fullpath) as f:
        sentences = [ line.strip() for line in f.readlines()]
    for sentence in sentences:
        i += 1
        process_sentence(file, sentence,i)
    return i

def process_docs(docs):
    for doc,files in docs.items():
	print '<doc>'
        i=0
        for file in files:
            i = convert_file(file, i)
        print "</doc>"

def process_filelist(filelist_filename):
    docs = dict()
    with open(filelist_filename) as f:
        filenames = [ line.strip() for line in f.readlines()]
    for filename in filenames:
            docs = process_file(filename,docs)
    process_docs(docs)

def main():
    argv = sys.argv
    if len(argv) != 2:
        print 'USAGE: %s <filelist>' % (argv[0])
        sys.exit(0)
    filelist_filename = argv[1]
    process_filelist(filelist_filename)

if __name__ == "__main__":
    main()
