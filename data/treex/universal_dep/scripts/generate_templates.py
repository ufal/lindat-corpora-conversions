#!/usr/bin/python
import sys
import re
import os
from Cheetah.Template import Template
treebankname=sys.argv[1]

def get_fulllang(lang):
    langmap = {'ar': 'Arabic', 'bn': 'Bengali', 'bg': 'Bulgarian', 'ca': 'Catalan', 'cs': 'Czech', 'cu': 'Church Slavonic','da': 'Danish', 'de': 'German', 'el': 'Greek','en': 'English', 'es': 'Spanish', 'et': 'Estonian', 'eu': 'Basque','fa': 'Persian', 'fi': 'Finnish', 'fr': 'French', 'ga': 'Irish', 'gl': 'Galician', 'grc': 'Greek', 'hi': 'Hindi', 'hr': 'Croatian', 'hu': 'Hungarian', 'id': 'Indonesian', 'ja': 'Japanese', 'kk': 'Kazakh', 'la': 'Latin', 'lv': 'Latvian', 'nl': 'Dutch', 'pl': 'Polish', 'pt': 'Portuguese', 'ro': 'Romanian', 'ru': 'Russian', 'sk': 'Slovak',  'sl': 'Slovenian','sv': 'Swedish', 'ta': 'Tamil', 'te': 'Telugu', 'tr': 'Turkish', 'zh':'Chinese'}
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
        has_orig_file = re.compile("la|lv|it")
        templateDef = """NAME "Universal Dependencies 1.3 - $language"
PATH "/opt/projects/lindat-services-kontext/devel/data/corpora/data/monolingual/UD/1.3/ud_$treebankname-a"
VERTICAL "/opt/projects/lindat-services-kontext/devel/data/corpora/vert/monolingual/UD/1.3/ud_$treebankname-a"
ENCODING utf-8
INFO "Universal Dependencies is a project that seeks to develop cross-linguistically consistent treebank annotation for many languages."
LANGUAGE "$language"

TAGSETDOC "http://universaldependencies.github.io/docs/u/feat/index.html"
DOCSTRUCTURE doc
#if $lang=='ar' or $lang=='he' or $lang=='fa':
RIGHTTOLEFT righttoleft
#end if 

ATTRIBUTE word {
        TYPE "FD_FGD"
        LOCALE "$locale"
}

ATTRIBUTE lc {
        DYNAMIC utf8lowercase
        DYNLIB internal
        FUNTYPE s
        ARG1 "$locale"
        FROMATTR word
        TYPE index
        TRANSQUERY yes
}


ATTRIBUTE lemma {
        TYPE "FD_FGD"
        LOCALE "$locale"
}

ATTRIBUTE lemma_lc {
        DYNAMIC utf8lowercase
        DYNLIB internal
        ARG1 "C"
        FUNTYPE s 
        FROMATTR lemma
        TYPE index
        TRANSQUERY yes
}

ATTRIBUTE pos {
        TYPE "FD_FGD"
}

ATTRIBUTE ufeat {
        TYPE "FD_FGD"
        MULTIVALUE y
        MULTISEP "|"
}

ATTRIBUTE deprel {
        TYPE "FD_FGD"
}

ATTRIBUTE ord {
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

ATTRIBUTE p_pos {
        TYPE "FD_FGD"
}

ATTRIBUTE p_ufeat {
        TYPE "FD_FGD"
        MULTIVALUE y
        MULTISEP "|"
}
ATTRIBUTE p_deprel {
        TYPE "FD_FGD"
}
ATTRIBUTE p_ord {
        TYPE "FD_FGD"
}

ATTRIBUTE parent {
        TYPE "FD_FGD"
}

ATTRIBUTE children {
          TYPE "FD_FGD"
          MULTIVALUE y
          MULTISEP "|"
}

STRUCTURE doc {
        ATTRIBUTE id
    ATTRIBUTE wordcount
}

STRUCTURE s {
        ATTRIBUTE id
#if $lang=='ar' or $lang=='ca' or $lang=='cs' or $lang=='es' or $lang=='et' or $treebankname=='la_ittb' or $treebankname=='es_ancora' or $lang=='nl' or $lang=='pl' or $lang=='pt' or $lang=='ta':
        ATTRIBUTE orig_file_sentence
#end if
}


MAXCONTEXT 50
MAXDETAIL 50


"""
        templ = Template(templateDef, searchList=[nameSpace])
        return templ

    def printConf(self):
        configDef = """		<corpus id="$registry" sentence_struct="s" features="morphology, syntax" num_tag_pos="16" keyboard_lang="$keyboard" repo="http://hdl.handle.net/11234/1-1699" pmltq="https://lindat.mff.cuni.cz/services/pmltq/#!/treebank/ud_$lang" />
"""
        conf = Template(configDef, searchList=[nameSpace])
        return conf

if __name__ == "__main__":
    lang = re.split('_', treebankname)[0]
 
    if (lang == 'grc'):
        language = 'Greek'
        locale = 'el_GR.UTF-8'
        keyboard = 'el'
    elif (lang == 'la'):
        language = 'Latin'
        locale = 'en_US.UTF-8'
        keyboard = 'en'
    else:
        language = get_fulllang(lang)
        locale = get_locale(lang)
        keyboard= locale.split("_", 1)[0]
        #print locale

    registry_name = "ud_13_" + treebankname + "_a"
    nameSpace = {'treebankname': treebankname, 'locale': locale, 'language': language, 'lang' : lang, 'keyboard' : keyboard, 'registry' : registry_name}

    registry = PrintTemplates(nameSpace)
    basepath = os.path.dirname(__file__)
    filepath = os.path.abspath(os.path.join(basepath, "..", "templates", registry_name))
    registry_file = open(filepath, "w")
    registry_file.write(str(registry.printRegistry()))

    config_file=open('to_config','a')
    config_file.write(str(registry.printConf()))

