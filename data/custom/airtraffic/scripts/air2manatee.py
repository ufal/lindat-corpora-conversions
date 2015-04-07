#!/usr/bin/python

import xml.etree.ElementTree as ET
import sys
import re
import os
import lxml.etree

def tokenize_text(text):
    #text = re.sub(r'(\w+)', r'\1\n',text.strip(),0,re.UNICODE|re.MULTILINE)
    text = re.sub(r'\]',r']\n',text,0,re.MULTILINE).strip() #handling "[unintelligible_|]Scandinavian[|_unintelligible]"
    text = re.sub(r'\[',r'\n[',text,0,re.MULTILINE).strip()
    text = re.sub(r'[\s\n]+',r'\n',text,0,re.MULTILINE).strip()
    tokens = text.split('\n')
    return tokens

def create_speech_filename(filename, start_time, end_time):
    st=re.sub('\.','_',start_time)
    et=re.sub('\.','_',end_time)
    return '%s-%s-%s.mp3' % (filename, st, et)

def create_sox_command(input_filename, output_filename, start_time, end_time):
    length = float(end_time)-float(start_time)
    return 'sox input/%s.wav output/speech/%s trim %f %f' % (input_filename, output_filename, float(start_time), length)

def create_segment_header(speech_filename):
    return '<seg soundfile="%s">' % speech_filename

#def create_turn_header(speakers, speaker_map):
#    speakers = "|".join([speaker_map[speaker] if speaker in speaker_map else '' for speaker in speakers.split(' ')])
#    return '<turn speakers="%s">' % speakers

def segmentate_texts(turn):
    doc = lxml.etree.fromstring(ET.tostring(turn))
    segments = []
    text = ''
    start_time = turn.attrib['startTime']
    end_time = None
    for node in doc.xpath('child::node()'):
        if isinstance(node, lxml.etree._ElementStringResult) or isinstance(node, lxml.etree._ElementUnicodeResult):
            text += node
        elif isinstance(node, lxml.etree._Element):
            if node.tag == 'Sync':
                time = node.attrib['time']
                end_time = time
                segments.append((start_time, end_time, text))
                start_time = time
                end_time = None
                text = ''
    end_time = turn.attrib['endTime']
    segments.append((start_time, end_time, text))
    return segments

def process_segment(filename,segment):
    (start_time, end_time, text) = segment
    tokens = tokenize_text(text)
    speech_filename = create_speech_filename(filename, start_time, end_time)
    sox = create_sox_command(filename, speech_filename, start_time, end_time)
    buf = ''
    buf += '%s\n' % create_segment_header(speech_filename)
    buf += '\n'.join(tokens) + '\n'
    buf += '</seg>\n'
    return [buf, sox]


def proces_turn(filename,turn):
    segments = filter(lambda (s,e,t): not re.match(r'^[\n\s]+$', t) ,segmentate_texts(turn))
    #speaker = turn.attrib['speaker']
    commands = []
    buf = ''
    #buf += '%s\n' % create_turn_header(speaker, speaker_map)
    for segment in segments:
        [mybuf,mysox] = process_segment(filename, segment)
        buf += mybuf
        commands.append(mysox)
    #buf += '</turn>\n'
    return [buf,commands]

def print_buffer(corpus_filename, buf):
    with open(corpus_filename, 'a') as f:
        f.write(buf.encode('utf-8'))

def print_commands(sox_commands_filename, commands):
    with open(sox_commands_filename, 'a') as f:
        f.write("\n".join(commands) + "\n")

def process_tree(filename,tree,corpus_filename,sox_commands_filename):
#    speakers = tree.findall('.//Speaker')
#    speaker_map = {}
#    for speaker in speakers:
#        speaker_map[speaker.attrib['id']] = speaker.attrib['name']
    turns = tree.findall('.//Turn')
    commands = []
    buf = ''
    buf += '<doc id="'
    buf += filename
    buf += '">\n'
    for turn in turns:
        [mybuf, mycommands] = proces_turn(filename,turn)
        buf += mybuf
        commands += mycommands
    buf += '</doc>\n'
    print_buffer(corpus_filename, buf)
    print_commands(sox_commands_filename, commands)

def main():
    argv = sys.argv
    if len(argv) != 4:
        print "USAGE: %s <input trs file> <corpus file> <sox commands file>" % argv[0]
        return
    trs_filename = argv[1]
    corpus_filename = argv[2]
    sox_commands_filename = argv[3]
    basename = os.path.splitext(os.path.basename(trs_filename))[0]
    tree = ET.parse(trs_filename)
    process_tree(basename,tree,corpus_filename,sox_commands_filename)

if __name__ == "__main__":
    main()

