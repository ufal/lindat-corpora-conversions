#!/usr/bin/python
import sys
import re
import os
from Cheetah.Template import Template
lang=sys.argv[1]

def get_fulllang(lang):
    langmap = {'ar': 'Arabic', 'bn': 'Bengali', 'ca': 'Catalan', 'cs': 'Czech', 'de': 'German', 'en': 'English', 'es': 'Spanish', 'et': 'Estonian', 'fa': 'Persian', 'grc': 'Greek', 'hi': 'Hindi', 'ja': 'Japan', 'la': 'Latin',  'nl': 'Dutch', 'pl': 'Polish', 'pt': 'Portuguese', 'ro': 'Romanian', 'ru': 'Russian', 'sk': 'Slovak',  'sl': 'Slovenian', 'ta': 'Tamil', 'te': 'Telugu', 'tr': 'Turkish'}
    return langmap[lang]

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

        templateDef = """NAME "HamleDT 3.0 - $language"
PATH "/opt/projects/lindat-services-kontext/devel/data/corpora/data/monolingual/HamleDT/3.0/hamledt_$lang-a"
VERTICAL "/opt/projects/lindat-services-kontext/devel/data/corpora/vert/monolingual/HamleDT/3.0/hamledt_$lang-a"
ENCODING utf-8
INFO "HamleDT 3.0 is a compilation of existing dependency treebanks (or dependency conversions of other treebanks), transformed so that they all conform to the same annotation style."
LANGUAGE "$language"

TAGSETDOC "https://ufal.mff.cuni.cz/pdt/Morphology_and_Tagging/Doc/hmptagqr.html"
DOCSTRUCTURE doc


ATTRIBUTE word {
        TYPE "FD_FGD"
        LOCALE "$locale"
}

ATTRIBUTE lemma {
        TYPE "FD_FGD"
        LOCALE "$locale"
}
ATTRIBUTE tag {
        TYPE "FD_FGD"
}

ATTRIBUTE deprel {
        TYPE "FD_FGD"
}

ATTRIBUTE p_word {
        TYPE "FD_FGD"
        LOCALE "$locale"
}

ATTRIBUTE p_lemma {
        TYPE "FD_FGD"
        LOCALE "$locale"
}
ATTRIBUTE p_tag {
        TYPE "FD_FGD"
}

ATTRIBUTE p_deprel {
        TYPE "FD_FGD"
}

ATTRIBUTE parent {
        TYPE "FD_FGD"
}

ATTRIBUTE pos {
        DYNAMIC getnchar
        DYNLIB  internal
        FUNTYPE i
        ARG1    1
        FROMATTR tag
        TYPE index
}

ATTRIBUTE p_pos {
        DYNAMIC getnchar
        DYNLIB  internal
        FUNTYPE i
        ARG1    1
        FROMATTR tag
        TYPE index
}


ATTRIBUTE   k {
        DYNAMIC getnchar
        DYNLIB  internal
        ARG1    1
        FUNTYPE i
        FROMATTR tag
        TYPE    index
}
ATTRIBUTE   g {
        DYNAMIC getnchar
        DYNLIB  internal
        ARG1    3
        FUNTYPE i
        FROMATTR tag
        TYPE    index
}
ATTRIBUTE   c {
        DYNAMIC getnchar
        DYNLIB  internal
        ARG1    5
        FUNTYPE i
        FROMATTR tag
        TYPE    index
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
        configDef = """		<corpus id="$registry" sentence_struct="s" features="morphology, syntax" num_tag_pos="16" keyboard_lang="$keyboard" repo="http://hdl.handle.net/11234/1-1508" pmltq="https://lindat.mff.cuni.cz/services/pmltq/hamledt_$lang/" />
"""
        conf = Template(configDef, searchList=[nameSpace])
        return conf

if __name__ == "__main__":
 
    if (lang == 'grc'):
        language = 'Greek'
        locale = 'el_GR'
        keyboard = 'el'
    elif (lang == 'la'):
        language = 'Latin'
        locale = 'en_US'
        keyboard = 'en'
    else:
        language = get_fulllang(lang)
        locale = get_locale(lang)
        keyboard= locale.split("_", 1)[0]


    registry_name = "hamledt_30_" + lang + "_a"
    nameSpace = {'locale': locale, 'language': language, 'lang' : lang, 'keyboard' : keyboard, 'registry' : registry_name}

    registry = PrintTemplates(nameSpace)
    basepath = os.path.dirname(__file__)
    filepath = os.path.abspath(os.path.join(basepath, "..", "templates", registry_name))
    registry_file = open(filepath, "w")
    registry_file.write(str(registry.printRegistry()))

    config_file=open('to_config','a')
    config_file.write(str(registry.printConf()))

