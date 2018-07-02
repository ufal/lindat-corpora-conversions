#!/usr/bin/python3
# -*- coding: utf-8 -*-
import string
import re
import glob
import os
import sys


filename = sys.argv[1]
type = sys.argv[2]
fileprefix = filename.split(".")[0]
fileprefix = re.sub(r'input','input_divided',fileprefix)
n=0
with open(filename, 'r') as f:
	bunch = []
	outfile = fileprefix+"__unset_id.conllu"
	o = open(outfile, 'a')
	for line in f:
		bunch.append(line)
		if type=="doc" and re.match(r'^# newdoc',line):
			if re.match(r'^# newdoc.* =',line):
				id = re.split(r'\s*=\s*',line)[-1].rstrip()
				id = re.sub(r' ','_',id)
			else:
				n=n+1
				id="doc"+str(n)
			outfile = fileprefix+"__"+id+".conllu"
			o.close()
			o = open(outfile, 'a')
		elif type=="sentid" and re.match(r'^# sent_id',line):
			id = line.rstrip()
			id = re.sub(r'^.*sent_id *(= *)?','',id)
			id = re.sub(r'[.s:-_]*[0-9]+(.xml)?$','',id)
			id = re.sub(r' ','_',id)
			if id=="":
				id="sentences"
			outfile = fileprefix+"__"+id+".conllu"
			o.close()
			o = open(outfile, 'a')
		if line=='\n':
			o.write("".join(bunch))
			bunch = []
o.close()
