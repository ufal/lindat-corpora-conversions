#!/usr/bin/python
# -*- coding: utf-8 -*-

import codecs
import re
import sys
from os.path import basename

def parse_line(line):
    parts = re.split('(<[^>]*>)',line)[1:]
    return dict(zip(map(lambda s: s[1:2], parts[::2]),parts[1::2]))

def parse_form(line):
    fields = parse_line(line)
    token = fields['f']
    lemma = re.sub('[-_].+$','',fields['l'])
    pos_tags = fields['t']
    return [token, lemma, pos_tags]

def parse_delim(line):
    fields = parse_line(line)
    token = fields['d']
    lemma = re.sub('[-_].+$','',fields['l'])
    pos_tags = fields['t']
    return [token, lemma, pos_tags]

def fix_corpus((filename, contents)):
    new_corpus = ''
    opened_tags = set()
    corpus = contents.rstrip('\n').split('\n')
    id = re.sub('\.sgml','',basename(filename))
    new_corpus += '<doc id="%s">\n' % id
    opened_tags.add('doc')
    for line in corpus:
        if line[0:1] == '<':
            tag = line[1:2]
            if tag in {'p','s'}:
                if tag == 'p' and 's' in opened_tags:
                    new_corpus += '</s>\n'
                    opened_tags.remove('s')
                if tag in opened_tags:
                   new_corpus += '</%s>\n' % tag
                new_corpus += line + '\n'
                opened_tags.add(tag)
            elif line == '<f>':
                pass
            elif tag == 'f':
               new_corpus += '%s\n' % '\t'.join(parse_form(line))
            elif tag == 'd':
               new_corpus += '%s\n' % '\t'.join(parse_delim(line))
            elif tag == 'D':
                pass
            else:
               new_corpus += '%s\n' % line
    for tag in ['s','p','doc']:
        if tag in opened_tags:
            new_corpus += '</%s>\n' % tag
            opened_tags.remove(tag)
    return new_corpus

def main():
    argv = sys.argv
    if len(argv) != 2:
        print 'USAGE: %s <corpus file>' % (argv[0])
        sys.exit(0)
    corpus_file = argv[1]
    with codecs.open(corpus_file, 'r+','iso-8859-2') as f:
        contents = f.read()
    print fix_corpus((corpus_file, contents)).encode('utf-8')


if __name__ == '__main__':
    main()
