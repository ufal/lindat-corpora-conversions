#!/usr/bin/python
# -*- coding: utf-8 -*-

import xml.etree.ElementTree as et
import sys
import re
from os.path import basename

source_mapping = {
               'ln': u'Lidové noviny',
               'lnd': u'Lidové noviny',
               'cmpr': u'Českomoravský Profit',
               'mf': u'Mladá fronta Dnes',
               'vesm': u'Vesmír',
               }

source_mapping = {
               'ln': u'Lidové noviny',
               'lnd': u'Lidové noviny',
               'cmpr': u'Českomoravský Profit',
               'mf': u'Mladá fronta Dnes',
               'vesm': u'Vesmír',
               }

title_cache = dict()
issue_cache = dict()

def create_title_name(title_id):
    assert source_mapping.has_key(title_id), 'Unknown issue_title_id: %s' % title_id
    return source_mapping[title_id]

def create_issue_year(issue_title_id, s):
    return '19' + s[:2]

def create_issue_date(issue_title_id, s):
    res = ''
    if issue_title_id == 'mf':
        res = '%d.%d.19%s' % (int(s[4:6]), int(s[2:4]), s[:2])
    return res

def create_article_number(issue_title_id, s):
   # res = re.sub('^.*_', '', s)
    res = re.sub('^.*_', '', s)
    res = re.sub('#.*', '',res)
    if res:
        res = str(int(res))
    return res

def create_issue_number(issue_title_id, s):
    res = ''
    if issue_title_id != 'mf':
        res = str(int(re.sub('_.*', '', s[2:])))
    return res

def create_issue_name(issue_title_id, attributes):
    res = ''
    if issue_title_id == 'mf':
        res =  '%s, %s' % ( attributes['title_name'], attributes['issue_date'] )
    else:
        res =  u'%s, %s, č. %s' % ( attributes['title_name'], attributes['issue_year'], attributes['issue_number'])
    return res

def create_issue_id(issue_title_id, s):
    res = re.sub('_.*', '', s)
    return res

def parse_id(id):
    m = re.search('^([a-z]*)(.*)$', id)
    assert m, 'Invalid id: %s' % (id)
    title_id = m.group(1)
    tail = m.group(2)
    attributes = dict()
    if (title_id.startswith("cmpr") or title_id.startswith("ln") or title_id.startswith("lnd") or title_id.startswith("mf") or title_id.startswith("vesm")):
        attributes['article_id'] = id
        attributes['title_name'] = create_title_name(title_id)
        attributes['issue_year'] = create_issue_year(title_id, tail)
        attributes['issue_date'] = create_issue_date(title_id, tail)
        attributes['article_number'] = create_article_number(title_id, tail)
        attributes['issue_number'] = create_issue_number(title_id, tail)
        attributes['issue_id'] = create_issue_id(title_id, id)
        attributes['issue_name'] = create_issue_name(title_id, attributes)
 

    return attributes

def store(doc, attributes):
    issue_id = attributes['issue_id']
    if not issue_cache.has_key(issue_id):
        issue = et.Element('issue')
        issue.set('id', issue_id)
        issue.set('name', attributes['issue_name'])
        issue.set('year', attributes['issue_year'])
       # issue.set('date', attributes['issue_date'])
        issue.set('article_number', attributes['article_number'])
        issue.set('number', attributes['issue_number'])
        issue.set('title_name', attributes['title_name'])
        issue_cache[issue_id] = issue
    issue = issue_cache[issue_id]
    issue.append(doc)
    del doc.attrib["id"]
    doc.set('id', attributes['issue_name'])

def fix_corpus(corpus):
    root = et.fromstring(corpus)
    corpus = et.Element('corpus')
    for doc in root.findall('doc'):
        for s in doc.findall('s'):
            attributes = parse_id(s.attrib['orig_file_sentence'])
            store(doc, attributes)
    for issue_id in issue_cache:
        issue = issue_cache[issue_id]
        title_name = issue.attrib['title_name']
        del issue.attrib['title_name']
        if not title_cache.has_key(title_name):
            title = et.Element('title')
            title.set('name', title_name)
            title_cache[title_name] = title
        title = title_cache[title_name]
        title.append(issue)
    for title_name in title_cache:
        title = title_cache[title_name]
        corpus.append(title)
    return corpus

def read_corpus(filename):
    corpus_id = basename(filename)
    data = '<corpus>\n'# % corpus_id
    with open (filename, "r") as myfile:
        data += myfile.read()
    data += '</corpus>'
    data = data.replace('&', '&amp;')
    data = data.replace('<\t', '&lt;\t')
    return data

def main():
    argv = sys.argv
    if len(argv) != 2:
        print 'USAGE: %s <corpus>' % (argv[0])
        sys.exit(0)
    corpus_filename = argv[1]
    corpus = read_corpus(corpus_filename)
#    print corpus
    new_corpus = fix_corpus(corpus)
    text = et.tostring(new_corpus, encoding='utf-8')
    text = text.replace('><', '>\n<')
    text = text.replace('&amp;', '&')
    text = text.replace('&lt;', '<')
    text = text.replace('<corpus>\n','')
    text = text.replace('\n</corpus>','')
    print text
if __name__ == "__main__":
    main()
