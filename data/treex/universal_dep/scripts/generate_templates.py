#!/usr/bin/python
import sys
import re
import os
from Cheetah.Template import Template
import locale
filename=sys.argv[1]      # e.g. vi_vtb
languagecode=sys.argv[2]  # e.g. vi
language=sys.argv[3]      # e.g. Vietnamese
corpname=sys.argv[4]      # e.g. VTB

def get_locale(langcode):
    if (langcode == 'cu'):   ## Old Church Slavonic
        return 'ru_RU.UTF-8'   ## when cu_RU (Church Slavic) locale becomes available, it probably should be used; but really, I have no idea even whether the corpus is in Cyrillic or Glagolitic script - either way, the language uses characters that are not present in current Russian
    elif (langcode == 'grc'):    ## Ancient Greek
        return 'el_GR.UTF-8'
    elif (langcode == 'la'):     ## Latin, we could rely on the default of en_US, but anyway
        return 'en_US.UTF-8'
    elif (langcode == 'fro'):    ## Old French
        return 'fr_FR.UTF8'
    elif (langcode == 'kmr'):    ## Kurmanji = Northern Kurdish
        return 'ku_TR.UTF8'
    elif (langcode == 'sme'):    ## North Sami, also can be coded as se
        return 'se_NO.utf8';
    else:
      with open('locale','r') as loc:
        for line in loc.readlines():
            if ( line.startswith(langcode + "_")):
                return line
#alllocale = locale.locale_alias
#for k in alllocale.keys():
#    print 'locale[%s] %s' % (k, alllocale[k])    



class PrintTemplates:

    def __init__(self, nameSpace):
        self.nameSpace = nameSpace	

    def printRegistry(self):
        templateDef = """NAME "UD 2.2 - $language $corpname"
PATH "/opt/lindat/kontext-data/corpora/data/monolingual/UD/2.2/ud_$filename-a"
VERTICAL "/opt/lindat/kontext-data/corpora/vert/monolingual/UD/2.2/ud_$filename-a"
ENCODING utf-8
INFO "Universal Dependencies is a project that seeks to develop cross-linguistically consistent treebank annotation for many languages. This is version 2.2, the training and development data released in April 2018 for the UD Shared Task."
LANGUAGE "$language"

TAGSETDOC "http://universaldependencies.github.io/docs/u/feat/index.html"
DOCSTRUCTURE doc"""
        if languagecode=='ar' or languagecode=='he' or languagecode=='fa' or languagecode=='ur':
          templateDef += """
RIGHTTOLEFT righttoleft"""
        templateDef +="""

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
        LOCALE "$locale"
}


ATTRIBUTE lemma {
        TYPE "FD_FGD"
        LOCALE "$locale"
        MULTIVALUE y
        MULTISEP "|"
}

ATTRIBUTE upos {
        TYPE "FD_FGD"
        MULTIVALUE y
        MULTISEP "|"
}

ATTRIBUTE xpos {
        TYPE "FD_FGD"
        MULTIVALUE y
        MULTISEP "|"
}

ATTRIBUTE feats {
        TYPE "FD_FGD"
        MULTIVALUE y
        MULTISEP "|"
}

ATTRIBUTE deprel {
        TYPE "FD_FGD"
        MULTIVALUE y
        MULTISEP "|"
}

ATTRIBUTE parent {
        TYPE "FD_FGD"
        MULTIVALUE y
        MULTISEP "|"
}

ATTRIBUTE p_word {
          TYPE "FD_FGD"
          LOCALE "$locale"
        MULTIVALUE y
        MULTISEP "|"
}

ATTRIBUTE p_lemma {
        TYPE "FD_FGD"
        LOCALE "$locale"
        MULTIVALUE y
        MULTISEP "|"
}

ATTRIBUTE p_upos {
        TYPE "FD_FGD"
        MULTIVALUE y
        MULTISEP "|"
}

ATTRIBUTE p_xpos {
        TYPE "FD_FGD"
        MULTIVALUE y
        MULTISEP "|"
}

ATTRIBUTE p_feats {
        TYPE "FD_FGD"
        MULTIVALUE y
        MULTISEP "|"
}

ATTRIBUTE p_deprel {
        TYPE "FD_FGD"
        MULTIVALUE y
        MULTISEP "|"
}

ATTRIBUTE deps {
        TYPE "FD_FGD"
        MULTIVALUE y
        MULTISEP "|"
}

ATTRIBUTE id {
        TYPE "FD_FGD"
        MULTIVALUE y
        MULTISEP "-"
}
ATTRIBUTE p_id {
        TYPE "FD_FGD"
        MULTIVALUE y
        MULTISEP "|"
}


ATTRIBUTE misc {
        TYPE "FD_FGD"
}


STRUCTURE doc {
        ATTRIBUTE id
    ATTRIBUTE wordcount
}

STRUCTURE s {
        ATTRIBUTE id
#if $languagecode=='ar' or $languagecode=='ca' or $languagecode=='cs' or $languagecode=='es' or $languagecode=='et' or $filename=='la_ittb' or $filename=='es_ancora' or $languagecode=='nl' or $languagecode=='pl' or $languagecode=='pt' or $languagecode=='ta':
        ATTRIBUTE orig_file_sentence
#end if
}


MAXCONTEXT 50
MAXDETAIL 50


"""
        templ = Template(templateDef, searchList=[nameSpace])
        return templ

    def printConf(self):
        configDef = """		<corpus id="$registry" sentence_struct="s" features="morphology, syntax" num_tag_pos="16" keyboard_lang="$keyboard" repo="http://hdl.handle.net/11234/1-1699" pmltq="https://lindat.mff.cuni.cz/services/pmltq/#!/treebank/ud$languagecode$filename" />
"""
        conf = Template(configDef, searchList=[nameSpace])
        return conf

if __name__ == "__main__":
    locale = str(get_locale(languagecode)).rstrip()
    keyboard = locale.split("_", 1)[0]

    registry_name = "ud_22_" + filename + "_a"
    nameSpace = {'filename': filename, 'locale': locale, 'language': language, 'languagecode' : languagecode, 'keyboard' : keyboard, 'registry' : registry_name, 'corpname': corpname}

    registry = PrintTemplates(nameSpace)
    basepath = os.path.dirname(__file__)
    filepath = os.path.abspath(os.path.join(basepath, "..", "templates", registry_name))
    registry_file = open(filepath, "w")
    registry_file.write(str(registry.printRegistry()))

    config_file=open('to_config','a')
    config_file.write(str(registry.printConf()))

