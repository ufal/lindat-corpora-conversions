#!/usr/bin/python
import re
w = open('output', 'w')
f = open('ententen08.vert')

p = re.compile(r'<p>')
doc = re.compile(r'<\/doc>')

def process_doc(lines_d):
    for i in range(len(lines_d)-2):
        if doc.search(lines_d[i]) is not None:
            #print "Doc line: ", lines_d[i]
            if(i < len(lines_d)-2) and (doc.search(lines_d[i+1])):
                lines_d.remove(lines_d[i+1])
    #w.write(''.join(lines_d))
    return lines_d

def process_p(fixed):
    length_fixed = len(fixed)
    for i in range(2,len(fixed)): #does not apply for the first <p>
        if p.search(fixed[i]) is not None and not fixed[i-1].startswith('<doc '):
            #print "Find p: ", fixed[i]
            fixed[i] = '</p>\n' + fixed[i]
            #fixed.insert(i, "<\p>")
            length_fixed += 1
        if doc.search(fixed[i]) is not None:
            fixed[i] = '</p>\n' + fixed[i]
            length_fixed += 1
    w.write(''.join(fixed))


lines = f.readlines()
doc_fixed = process_doc(lines)
process_p(doc_fixed)
#print doc_fixed
#w.write(''.join(process_p(doc_fixed)))