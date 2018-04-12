#!/usr/bin/env python3

import sys

class Sentence:
    def __init__(self, f):
        self._fused = []          # řádky, které mají id typu n-m
        self._regular = {}        # všechny ostatní řádky s id (hash)
        self._remove = set([])    # id řádků k zahození
        for ln in f:
            self.add_row(Row(ln.strip('\n')))

    def add_row(self, row):
        if row._fused:
            self._fused.append(row)
        else:
            self._regular[row._id] = row

    def process_fused(self):
        for row in self._fused:
            for col in range(2, len(row._data)):  # všechny sloupce kromě id a form
                fused_vals = [self._regular[id][col] for id in range(row._from, row._to+1) if self._regular[id][col] != '_']
                if row._data[col] != '_':    # přidej hodnotu z řádku n-m
                    fused_vals = [row._data[col]] + fused_vals
                if fused_vals:               # některá hodnota byla různá od _
                    row._data[col] = '|'.join(fused_vals)
                else:
                    row._data[col] = '_'     # všechny hodnoty byly _
            self._remove.update(range(row._from, row._to+1))

    def out(self, f):
        out_rows = self._fused + [row for id, row in self._regular.items() if id not in self._remove]
        for row in sorted(out_rows, key=lambda x:x._sort_key):
            f.write(str(row)+'\n')


class Row:
    ID_COL = 0
    def __init__(self, ln):
        self._data = ln.split('\t')
        self._id = self._data[self.ID_COL]
        if '-' in self._id:
            self._fused = True
            self._from, self._to = map(int, self._data[self.ID_COL].strip().split('-'))
            self._sort_key = self._from
        else:
            self._fused = False
            self._id = int(self._id)
            self._sort_key = self._id

    def __getitem__(self, key):
        return self._data[key]

    def __str__(self):
        return '\t'.join(self._data)

sentence_lines = []
comments = []
for ln in sys.stdin:
    if ln.startswith('#'):
        comments.append(ln)
    elif ln.strip():     # vrátí true když je řádka neprázdná (strip zahazuje mezery na začátku a na konci, po zahození je řádek stále neprázný, čili true)
        sentence_lines.append(ln)
    else:
        s = Sentence(sentence_lines)
        s.process_fused()
        sys.stdout.write(''.join(comments))
        s.out(sys.stdout)
        sentence_lines = []
        comments = []
        sys.stdout.write('\n')
