#!/usr/bin/python
# -*- coding: utf-8 -*-

import sys
import string
import re

def ProcessLargeFile():
    bunchsize = 1000000
    bunch = []
    with open("plain.articles_shuffled.txt.bak", "r") as r, open("plain_concatenated","w") as w:
        next(r)
        for line in r:
            bunch.append(line.rstrip('\n'))
            if len(bunch) == bunchsize:
                joined = ' '.join(bunch).replace(' <s> ','\n')
                w.writelines(joined)
                bunch = []
        w.writelines(' '.join(bunch).replace(' <s> ','\n'))

ProcessLargeFile()


