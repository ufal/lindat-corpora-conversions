#!/usr/bin/python3
# -*- coding: utf-8 -*-
import string
import re
import glob
import os
import sys

if sys.version_info[0] < 3:
  raise Exception("Must be using Python 3")


### in order to write the output file only in case it is not empty,
### (which is needed for the first auxiliary file __00__unset_id.conllu
### in case that the corpus does not have any content before the first newdoc/sent_id)
### f will be an instance of this class
class MyFile():
    def __enter__(self):
        return self

    def __init__(self, path):
        ''' store the path, but don't actually open the file '''
        self.path = path
        self.file_object = None

    def write(self, s):
        ''' you open the file here, just before appending '''
        if not self.file_object:
            self.file_object = open(self.path, 'a')
        self.file_object.write(self, s)

    def close(self):
        ''' close the file '''
        if self.file_object:
            self.file_object.close()

    def __exit__(self, exc_type, exc_value, exc_traceback):
        self.close()

filename = sys.argv[1]
type = sys.argv[2]
fileprefix = filename.split(".")[0]
fileprefix = re.sub(r'input','input_divided',fileprefix)
n=0; lastid=""
with open(filename, 'r') as f:
	bunch = []
	outfile = fileprefix+"__00000__unset_id.conllu"
	o = MyFile(outfile)
	for line in f:
		bunch.append(line)
		if type=="doc" and re.match(r'^# newdoc',line):
			n = n+1
			if re.match(r'^# newdoc.* =',line):
				id = re.split(r'\s*=\s*',line)[-1].rstrip()
				id = "__"+re.sub(r' ','_',id)
			else:
				id=""
			o.close()
			outfile = fileprefix+"__"+str(n).zfill(5)+id+".conllu"
			o = open(outfile, 'a')
		elif type=="sentid" and re.match(r'^# sent_id',line):
			id = line.rstrip()
			id = re.sub(r'^.*sent_id *(= *)?','',id)
			id = re.sub(r'[.s:-_]*[0-9]+(.xml)?$','',id)
			id = re.sub(r' ','_',id)
			if id!=lastid:
				n = n+1
				lastid=id
				outfile = fileprefix+"__"+str(n).zfill(5)+id+".conllu"
				o.close()
				o = open(outfile, 'a')
		if line=='\n':
			o.write("".join(bunch))
			bunch = []
o.close()


