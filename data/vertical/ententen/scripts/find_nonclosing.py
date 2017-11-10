#!/usr/bin/python
import re
from xml.etree import ElementTree as ET

#parser = ET.itparse('10000_new')

for event, element in ET.iterparse('10000_new', events=('start', 'end')):
    if element.tag == 'doc':
        print (element.text)