#!/usr/bin/python
import sys
import re
import os
from Cheetah.Template import Template
lang=sys.argv[1]

def get_wiki(lang):
    with open('languages.2010-12-12.wiki', 'r') as wiki:
        for line in wiki.readlines():
            if line.startswith(lang):
                language=line.split("\t")[1]
                lang_shortcut=line.split()[4]
                if (lang_shortcut.isdigit()):
                   return language, lang
                else:
                   return language, lang_shortcut

def get_locale(locales_abbr):
    with open('locale','r') as loc:
        for line in loc.readlines():
            if ( line.startswith(locales_abbr) and 'UTF-8' in line):# & line.startswith(locales_abbr):
                return re.split('\s+', line)[0]
           # else:
           #     return locales_abbr


class PrintTemplates:

    def __init__(self, nameSpace):
        self.nameSpace = nameSpace	

    def printRegistry(self):

        templateDef = """NAME "Web to Corpus - $language"
PATH "/opt/projects/lindat-services-kontext/devel/data/corpora/data/monolingual/W2C/W2C_$lang-w"
VERTICAL "/opt/projects/lindat-services-kontext/devel/data/corpora/vert/monolingual/W2C/W2C_$lang-w"
ENCODING utf-8
INFO "A set of corpora for 120 languages automatically collected from wikipedia and the web."
LANGUAGE "$language"

DOCSTRUCTURE doc

ATTRIBUTE word {
        TYPE "FD_FGD"
        LOCALE "$locale"
}

STRUCTURE doc {
        ATTRIBUTE id
    ATTRIBUTE wordcount
}

STRUCTURE s {
        ATTRIBUTE id
}

MAXCONTEXT 50
MAXDETAIL 50


"""
        templ = Template(templateDef, searchList=[nameSpace])
        return templ

    def printConf(self):
        configDef = """		<corpus id="$registry" sentence_struct="s" features="words only" num_tag_pos="16" keyboard_lang="$keyboard" repo="https://lindat.mff.cuni.cz/repository/xmlui/handle/11858/00-097C-0000-0022-6133-9" />"
"""
        conf = Template(configDef, searchList=[nameSpace])
        return conf

if __name__ == "__main__":
    language, lang_shortcut = get_wiki(lang)
    locale = get_locale(lang_shortcut)
   # keyboard= locale.split("_", 1)[0]
    registry_name = "w2c_" + lang + "_w"
    nameSpace = {'locale': locale, 'language': language, 'lang' : lang, 'keyboard' : lang_shortcut, 'registry' : registry_name}

    registry = PrintTemplates(nameSpace)
    basepath = os.path.dirname(__file__)
    filepath = os.path.abspath(os.path.join(basepath, "..", "templates", registry_name))
    registry_file = open(filepath, "w")
    registry_file.write(str(registry.printRegistry()))

    config_file=open('to_config','a')
    config_file.write(str(registry.printConf()))

