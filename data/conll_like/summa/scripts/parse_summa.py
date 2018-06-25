import io
import os
import csv
import markup

def change_skip_hashes(lines, j, ret):
    line = lines[j]
    if line.startswith('#'):
        while line.startswith('#'):
            j += 1
            line = lines[j]
        # TODO add id and the whole text?
        # ret.append(u'<s>')
    return j
markup.skip_hashes = change_skip_hashes

def remember_summa_markup(input_file_path, txt_output_path, markup_output_path):
    # FIXME markup csv is not utf-8
    with io.open(input_file_path, 'r', encoding='utf-8') as input, io.open(txt_output_path, 'w+',
                                                                           encoding='utf-8') as \
            output, open(markup_output_path, 'w+') as markup:
        markup_writer = csv.writer(markup, lineterminator='\n')
        text = input.read()
        i = 0; j = 0
        intext = False; openseg = False
        segid = ""; segid_start = j
        while i < len(text):
            c = text[i]
            if c == "\n":
                if openseg:
                    segid = '</seg>'
                    row = [str(j),str(j+5),segid]
                    markup_writer.writerow(row)
                    j += 5
                intext = False; openseg = False
                segid = ""; segid_start = j
            elif c == "\t":
                if not (text[j+1:j+11]=='<pars id="' or text[j+1:j+9]=='</pars>'):
                  segid = '<seg id="'+segid+'">'
                  j += len(segid)
                  segid_stop = j
                  row = [str(segid_start),str(segid_stop),segid]
                  markup_writer.writerow(row)
                  openseg = True
                intext = True
            elif not intext:
                segid += text[i]
            elif intext and c == '<':
                tag_start = j
                tag = c
                i += 1; j += 1
                c = text[i]
                while c != '>':
                    tag += c
                    i += 1; j += 1
                    c = text[i]
                tag += c
                tag_stop = j
                if text[i+1]=="\n":
                    i -= 1; j -= 1
                row = [str(tag_start), str(tag_stop), tag]
                markup_writer.writerow(row)
                if tag=="</p>" or tag=="</h>":
                    i+=1; j+=1
                    output.write(u" ")
            else:
                output.write(c)
            i += 1; j += 1

if __name__ == '__main__':
    #_this_dir = os.path.dirname(os.path.abspath(__file__))
    #output = os.path.join(_this_dir, '..', 'output')
    #markup.remember_markup('../input/source_cz.txt', '../input/plaintext_cz', '../input/markup.cz')
    #markup.remember_markup('../input/source_en.txt', '../input/plaintext_en', '../input/markup.en')
    #markup.remember_markup('../input/source_la.txt', '../input/plaintext_la', '../input/markup.la')
    #os.system("/net/projects/udpipe/bin/udpipe-latest /net/projects/udpipe/models/udpipe-ud-2.0-170801/latin-ittb-ud-2.0-170801.udpipe --immediate --tokenize --tag --parse --outfile=../input/ud_piped.la_ittb ../input/plaintext_la")
    #    print('\n'.join(markup.restore_markup([x for x in conllu.split('\n') if x], '../input/markup.la')))
                   #-e 's@</p>@</p>\\n\\n@g; s@</h>@</h>\\n\\n@g; s@<p>@<p>\\n\\n@g' \
    os.system("cat ../input/tmp | \
               sed -e 's@[<][^>]*[>]@ @g' \
                   -e 's@\\(.*\\)\\t\\(.*\\)$@<seg id=\"\\1\">\\n\\n\\2</seg>\\n\\n@' \
            > ../input/tmp_segs")
    markup.remember_markup('../input/tmp_segs', '../input/tmp_plaintext', '../input/tmp_markup')
    os.system("/net/projects/udpipe/bin/udpipe-latest /net/projects/udpipe/models/udpipe-ud-2.0-170801/latin-ittb-ud-2.0-170801.udpipe --immediate --tokenizer='ranges' --tag --parse --outfile=../input/tmp_ud_piped ../input/tmp_plaintext")
    with open('../input/tmp_ud_piped', 'rb') as file:
        conllu = unicode(file.read())
        print('\n'.join(markup.restore_markup([x for x in conllu.split('\n') if x], '../input/tmp_markup')))
