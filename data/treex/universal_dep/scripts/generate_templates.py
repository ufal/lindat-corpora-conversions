#!/usr/bin/python2.7

import sys
import re
import os
from Cheetah.Template import Template
import locale
filename=sys.argv[1]      # e.g. vi_vtb
languagecode=sys.argv[2]  # e.g. vi
language=sys.argv[3]      # e.g. Vietnamese
corpname=sys.argv[4]      # e.g. VTB
dirname=sys.argv[5]       # e.g. UD_Vietnamese-VTB
outfile=sys.argv[6]       # where to put the template
udversionshort=sys.argv[7]# e.g. 23
udversionlong=sys.argv[8] # e.g. 2.3
lindatrepo="http://hdl.handle.net/11234/1-2837"
pmltqprefix=""

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
        templateDef = """NAME "UD $udversionlong - $language $corpname"
PATH "/opt/lindat/kontext-data/corpora/data/monolingual/UD/$udversionlong/ud_$filename-a"
VERTICAL "/opt/lindat/kontext-data/corpora/vert/monolingual/UD/$udversionlong/$dirname"
ENCODING utf-8
INFO "Universal Dependencies is a project that seeks to develop cross-linguistically consistent treebank annotation for many languages."
LANGUAGE "$language"

TAGSETDOC "http://universaldependencies.github.io/docs/u/feat/index.html"
DOCSTRUCTURE data"""
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

ATTRIBUTE parent {
    TYPE "FD_FGD"
    MULTIVALUE y
    MULTISEP "|"
}

ATTRIBUTE deprel {
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

ATTRIBUTE misc {
    TYPE "FD_FGD"
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

STRUCTURE data {
    ATTRIBUTE id
    ATTRIBUTE wordcount
}

STRUCTURE doc {
    ATTRIBUTE id
    ATTRIBUTE wordcount
}

STRUCTURE par {
    ATTRIBUTE id
    ATTRIBUTE wordcount
}

STRUCTURE s {
    ATTRIBUTE id
    ATTRIBUTE text
    ATTRIBUTE orig_file_sentence
}


MAXCONTEXT 50
MAXDETAIL 50


"""
        templ = Template(templateDef, searchList=[nameSpace])
        return templ

    def printConf(self):
        configDef = """		<corpus ident="$registry" keyboard_lang="$keyboard" sentence_struct="s" features="morphology, syntax" repo="$lindatrepo" pmltq="$pmltqlink" />
"""
        conf = Template(configDef, searchList=[nameSpace])
        return conf

if __name__ == "__main__":
    locale = str(get_locale(languagecode)).rstrip()
    keyboard = locale.split("_", 1)[0]

    registry_name = "ud_" + udversionshort + "_" + filename + "_a"
    pmltqlink = pmltqprefix   #TODO: adjust
    nameSpace = {'filename': filename, 'locale': locale, 'language': language, 'languagecode': languagecode, 'keyboard': keyboard, 'registry': registry_name, 'corpname': corpname, 'lindatrepo': lindatrepo, 'pmltqlink': pmltqlink, 'dirname': dirname, 'udversionlong': udversionlong, 'udversionshort': udversionshort}

    registry = PrintTemplates(nameSpace)
    basepath = os.path.dirname(__file__)
    filepath = os.path.abspath(os.path.join(basepath, "..", "templates", registry_name))
    registry_file = open(filepath, "w")
    registry_file.write(str(registry.printRegistry()))

    config_file=open('../to_corplist','a')
    config_file.write(str(registry.printConf()))

