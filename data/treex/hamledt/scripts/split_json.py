#!/usr/bin/python
#by Vincent Kriz#

import json
import sys
import re

prefix = sys.argv[1]
prefix = re.sub('(.*?\/)', '', prefix)
prefix = re.sub('.json', '', prefix)
print "Prefix = %s" % prefix

raw = None
with open(sys.argv[1], "r") as fin:
    raw = fin.read()

data = json.loads(raw)
for (n_tree, tree) in enumerate(data):
    tree_id = n_tree + 1
    output = [tree]
    with open("%s_s%d.json" % (prefix, tree_id), "w") as fout:
        json.dump(output, fout)
