
# Corpora conversion
* [Introduction](#intro)
* [Conversion utilities](#cu)
* [Conversion process](#conv_proc)
 * [PDT to Manatee](#pdt-manatee)
 * [Treex to Manatee](#treex-manatee)
* [Convert and compile UD](#ud-conversion)
* [Corpora compilation](#corp-comp)
* [Finishing touches](#afterwards)
* [Conversion benchmarks](#benchmarks)
* [List of corpora to convert](#corpora_list)

## <a name="intro"></a>Introduction

Conversion of corpora from vertical text to binary format is done by the *compilecorp* tool provided by the manatee package.
Two files are needed for the conversion: the vertical text (i.e. corpus) itself and a corpus configuration file that describes in detail the contents of the corpus.

The vertical text is documented here: https://www.sketchengine.co.uk/documentation/preparing-corpus-text/<br />
The corpus configuration file is documented here: https://www.sketchengine.co.uk/corpus-configuration-file-all-features/<br />
And a bit more about Creating a corpus in general is here: https://www.sketchengine.co.uk/documentation/preparing-a-text-corpus-for-the-sketch-engine-overview/

### Directory structure

On {`kontext-dev`,`kontext`}, the data is situated in a NFS shared directory;
after running `mount`, both of these paths will be available:
```
/export/KONTEXT/kontext-dev/opt/projects/lindat-services-kontext/devel/data/corpora
/export/KONTEXT/kontext/corpora
```

On , both machines the following directories are symlinks to the actual location of the data:
```
/opt/lindat/kontext-data/corpora
/opt/projects/lindat-services-kontext/{devel,production}/data/corpora
```
These symlinks should be used except for copying data between the two machines.

The directory has the following subdirectories:
```
registry       # configuration files (no subdirectories)
data           # compiled corpora
speech         # mp3 files
view_treex     # files in json format for tree visualisation
conc, tags     # ??? to be deleted
```
On `kontext-dev`, additional subdirectoreis are present:
```
conversions    # conversion of corpora (this git repository -- data and scripts)
vert           # vertical text files (corpora data)
```


## <a name="cu"></a>Conversion utilities

This directory contains conversion utilities for converting corpora into LINDAT KonText format.
Corpora utilities are grouped in subdirectories by the input format.

* conll_like - input files have form of a tab delimited columns
* custom - input files have custom formats
* treex - input files are processable by treex perl framework
* vertical - input file are already in output format

### Tools

Conversion of corpora is performed on development environment only and realized by the following tools:

* Makefile
* bash tools (awk, sed)
* treex
* python

## Cluster setup(ufal-internal)

See detailed description of the cluster here: https://wiki.ufal.ms.mff.cuni.cz/grid

Setting up the SGE environment is documented here https://wiki.ufal.ms.mff.cuni.cz/zakladni-nastaveni-sge

#### Disk space

For any conversion create separate directory in `/net/cluster/TMP` (automounted) or `/net/cluster/SSD` (automounted) as there is not enough space elsewhere for large corpora.
Be sure to clean up any files when the conversion is finished.

#### Treex

Install perlbrew on your local computer (your `$HOME` will be available on the cluster as well) as described here: https://wiki.ufal.ms.mff.cuni.cz/perlbrew .
Install Treex from SVN as described here: http://ufal.mff.cuni.cz/treex/install.html, please note that most of the prerequisites are already provided by the perlbrew.

## <a name="conv_proc"></a>Conversion process
Corpora conversion and compilation are realized by the system of Makefiles as follows. 
The corpus specific Makefile is stored in a directory script and it usually contains the conversion steps. 
The common steps - like copying the corpora in vertical format and registry files into the sufficient place
and executing *compilecorp* - are incorporated into common.mk. 

We have disabled the function of automatical downloading because of the security reasons, see the [commit](https://github.com/ufal/lindat-corpora-conversions/commit/cd9a26865fbf970f3aa71bcda5decf7c9fc1eda9#diff-217673f9edaf6c9c1a73a57462e208a8).


**Makefile execution on cluster:**
```bash
# SSH to the cluster:
ssh lrc1
# Use screen
screen
# Create directory in /net/cluster/TMP e.g.:
mkdir -p /net/cluster/TMP/$USER/czeng_1.0
# Change the directory: 
cd /net/cluster/TMP/$USER/czeng_1.0
# Create output directory:
mkdir output
# Copy the input data files to the cluster:
scp -r remote_server:/some/remote/dir/czeng_1.0/input ./
# Copy the scripts to the cluster:
scp -r remote_server:/some/remote/dir/czeng_1.0/scripts ./
# Run the conversion:
cd scripts
make
# Wait until the job finishes
# ...
# Copy the output to the remote server
scp -r /net/cluster/TMP/$USER/czeng_1.0/output remote_server:/some/remote/dir/czeng_1.0/
# Clean up
rm -r /net/cluster/TMP/$USER/czeng_1.0
# Leave screen
exit
# Logout
exit
```
### <a name="pdt-manatee"></a>PDT to Manatee
Conversion of PDT was implemenented in perl as a Block for Treex (Treex::Block::Write::Manatee). This block converts documents in PDT to <doc> structures in vertical files for Manatee.

the following attributes are included in the output:

* word
* lemma
* POS positional tags (16 characters)
* afun

The structure of the output document is as follows:
```xml
<doc id="xyz">
<s id="1">
token    lemma    POS-tag    afun
token    lemma    POS-tag    afun
token    lemma    POS-tag    afun
...
</s>
<s id="2">
token    lemma    POS-tag    afun
token    lemma    POS-tag    afun
token    lemma    POS-tag    afun
...
</s>
...
</doc>
```

Python script was developed to extract metadata from document ID's. Description of ID's structure is provided here: http://ufal.mff.cuni.cz/pdt2.0/doc/pdt-guide/en/html/ch03.html
but is incorrect and incomplete. This is corrected description of ther structure:

Prefixes:

| Code structure | Name | Comments |
|----------------|------|----------|
| lnYYNNN | Lidové noviny | YY - last two digits of the year, NNN - issue number (day of the year excluding Sundays and public holidays) |
| lndYYNNN | Lidové noviny | YY - last two digits of the year, NNN - issue number (day of the year excluding Sundays and public holidays) |
| mfYYMMDD | Mladá fronta Dnes | YY - last two digits of the year, MM - month, DD - day of the month |
| cmprYYNN | Českomoravský Profit |YY - last two digits of the year, NN - issue number (week) |
| vesmYYNN | Vesmír | YY - last two digits of the year, NN - issue number (month) |

Shell script was created to easily convert the whole set of PDT documents to a single corpus.

### <a name="treex-manatee"></a>Treex to Manatee

Conversion of treex files was implemenented in perl as a Block for Treex (Treex::Block::Write::Manatee). This block converts documents in treex to <doc> structures in vertical files for Manatee.

### <a name="treex-view"></a>Tree visualisation
The tree visualisation is implemented using the same mechanism as with audio files, see [issue 9](https://github.com/ufal/lindat-kontext/issues/9). In order for a syntactic tree to be displayed, the json files needed to be generated, which
is done by the script [Treex::Block::Write::ViewJSON](https://github.com/ufal/treex/blob/master/lib/Treex/Block/Write/ViewJSON.pm), once we have a .treex.gz file:
```
treex Read::Treex from=cmpr9406_001.treex.gz bundles_per_doc=1 Write::ViewJSON pretty=1 to=.
```
The IDs of the sentences in the vertical should correspond with the name of a respective json file, all json files
are stored in the directory /opt/lindat/kontext-data/corpora/view_treex/$registry_filename . 

### <a name="conllu-manatee"></a>CoNLL-U to Manatee
As the corpora will be parsed by UD-pipe or a tool alike, there is a need for a common script to convert into Manatee.
The script cloned from the respective block in Treex for Manatee was adjusted to the
needs of UD, and it is still under the development (Treex::Block::Write::ManateeU).

Following the [issue 3](https://github.com/ufal/lindat-corpora-conversions/issues/3) the script to process 
fused tokens was created, but there are still issues to be resolved. 

## <a name="ud-conversion"></a> Whole pipeline of UD processing on the cluster
### Conversion
```bash
# SSH to the cluster:
ssh lrc1 (or troja - in this case all data should be stored in troja)
# Use screen
screen

#Create directory in cluster TMP directory: 
mkdir -p /net/cluster/TMP/$USER/kontext/ud20
mkdir input output scripts input.sample tree-view treex

# Download UD data from the repository (e.g. using wget)

# Chomp some sample into input.sample to test if the script does things correctly (optional), then change paths in ud_convert

# Copy scripts from some older UD version, e.g.:
cp /net/cluster/TMP/kljueva/kontext/ud/scripts . #at least one script should be in theory synchronized with kontext-dev:/opt/projects/lindat-services-kontext/devel/data/corpora/conversions/scripts/ud_convert.sh

# adjust perl block https://github.com/ufal/treex/blob/master/lib/Treex/Block/Write/ManateeU.pm according to which attributes you need to generate 

# Generate vertical, treex (and then jsons from treex)
cd scripts & time ./ud_convert.sh  #generates files into the same directory!! it needs to be changed

# Leave screen
exit
# Move all the data to kontext-dev:

ssh quest & kontext-dev & cd /opt/projects/lindat-services-kontext/devel/data/corpora/conversions/data/treex/universal_dep/
cd input # %TODO change paths in ud_convert.sh, now everything is stored into input folder 

# SCP vertical to kontext-dev:
scp $USER@$MACHINE.ms.mff.cuni.cz:/net/cluster/TMP/$USER/kontext/ud/input/*-train.vert output
cd output &for file in *; do echo $(basename $file); rename 's/(.*?)-ud-train.vert/ud_$1-a/' $(basename $file); done
 # rename vertical files according to what is in registry

# SCP jsons to kontext-dev:
scp -r $USER@$MACHINE.ms.mff.cuni.cz:/net/cluster/TMP/$USER/kontext/ud/input/ud_20_*_a /opt/projects/lindat-services-kontext/devel/data/corpora/view_treex

# Clean up (optional, or at least remove treex folder)
rm -r /net/cluster/TMP/$USER/kontext/ud20
```
### Compilation
1. Adjust registry files in the directory **templates** according to the used attributes. Alternitevely, use generate_templates.py to generate the new ones; this script will also generate XML you have to put to config.xml.
2. The script to process fused tokens [manatee_conllu-w2t.py](https://github.com/ufal/lindat-corpora-conversions/commit/d1fd25464a382820229ebf7ec969236d40971993) can be applied to the corpora, but further testing is needed - see [comment](https://github.com/ufal/lindat-corpora-conversions/issues/3#issuecomment-298621358). This script does not work on cyan (but on quest it does).
3. Adjust process.sh to new version of UD, compile all.
4. For jsons, the treex view functions is UNFORTUNATELY hard-coded into [KonText code](https://github.com/ufal/lindat-kontext/issues/9#issuecomment-308411909) . So you will need to go to /opt/lindat/kontext-0.5 and change templates/view.tmpl
and lib/conclib.py, grunt the files   
For UD, it is already done ($corpname.startswith('ud_')) and corpus_fullname.startswith('ud_'), but for other corpora you will need to change and run grunt. Hopefully, in KonText 0.9 it will be processed better.

## <a name="corp-comp"></a>Corpora compilation
Set MANATEE_REGISTRY environmental variable to the directory with registry files:
```
export MANATEE_REGISTRY=/opt/projects/lindat-services-kontext/devel/data/corpora/registry
```
Compile the corpus:
```
cd $MANATEE_REGISTRY
compilecorp --no-sketches --recompile-corpus <corpus config file>
```
### Troubleshooting

**Corpus config file in MANATEE_REGISTRY must be named in lowercase**

This is probably bug in KonText.

**Corpus config file in MANATEE_REGISTRY must consist only of alphanumerical characters**

The name of the config file is used in the within clause of CQL queries and special characters cause CQL syntax errors.
This happens always when trying to search in two or more parallel corpora at the same time.

**Compilation of large corpora (e.g. syn2013pub) will fail with an error like this:**
```
[20140612-09:47:00] Processed 288000000 lines, 248604749 positions.
[20140612-09:47:04] encodevert error: File too large for FD_FD, use FD_FGD
Writing log to /opt/projects/lindat-services-kontext/devel/data/corpora/data/syn2013pub/log/compilecorp_2014-06-12_0917.log
```
In large corpora the type of basic attributes (word, lemma...) needs to be changed to FD_FGD (see http://www.sketchengine.co.uk/documentation/wiki/SkE/Config/FullDoc#Attributestypes)

**Computing sizes can fail if the doc structure element doesn't contain ATTRIBUTE wordcount:**

You will see the following message at the beginning of compilation:
```
Reading corpus configuration...
corpinfo: CorpInfoNotFound (wordcount)
...
```

Add ATTRIBUTE wordcount to doc structure element.
```
STRUCTURE doc {
    ATTRIBUTE wordcount
}
```
**Compilation of large corpora (e.g. syn2013pub) will fail with an error like this:**
```
[20140612-18:33:28] lexicon (/opt/projects/lindat-services-kontext/devel/data/corpora/data/syn2013pub/s.id) make_lex_srt_file
[20140612-18:33:29] encodevert error: FileAccessError (/opt/projects/lindat-services-kontext/devel/data/corpora/data/syn2013pub/s.id.rev.idx) in ToFile: fopen [Too many open files]
```
In this case the system limits are too low. See the adjust limits section on Installation page.

## <a name="afterwards"></a>Finishing touches
In order to have proper links between KonText, pmltq-web and the lindat repository, the following places need to be edited:
* ~~`/opt/lindat/kontext-config/config.xml`~~ `/opt/lindat/kontext/conf/corplist.xml`   (attributes `repo` and `pmltq` of the `corpus` entry; changes of this file do not require recompilation)
* on the lindat repository, a person with the "service managers" priviledge has to go to "Edit this item -> Services" and fill in the appropriate values; for larger batches of changes, create a file containing repo handles and "key|value" pairs for the `featuredService.kontext` and `featuredService.pmltq` metadata and contact the lindat helpdesk

## <a name="benchmarks"></a>Conversion benchmarks

### Conversion of HamleDT CS
**Data**<br />
Size (in positions/tokens): 1,503,738<br />
Size (in MB): 182<br />
**Local machine (1 process, 1 thread, 8GB RAM, Intel(R) Xeon(R) CPU E5-2640 v2 @ 2.00GHz)**

```
real    41m26.769s
user    41m19.311s
sys    0m5.329s
```

**Cluster**

|number of jobs | 10 | 30 | 50 | 75 | 100 (75 loaded)|
|-------|----|----|----|----|-----|
|processing time | 656.794s| 248.997 | 191.574 | 172.575 | 185.184 |

### Conversion of CzEng CS (first part)

**Data** <br />
Size (in positions/tokens): 20,641,110<br />
Size (in MB): 4761MB

**Cluster (lrc1)**

| number of jobs | 100 |
|-------|-------|
| processing time | 1129.716s |

## <a name="production"></a>Production
**Do not forget to change** *devel* **to** *production* **in the registry files.**

Updating - rsync corpora from kontext-dev to kontext machines can be done by the script:
```
/opt/projects/lindat-services-kontext/production/scripts/update_corpus.sh $registry_filename
```
Still need to add a few lines copying json files for treex view.
It can not update multiple files, so rather use:
```
for file in /a/QUESTDATA/data/kontext-dev/opt/projects/lindat-services-kontext/devel/data/corpora/registry/ud_13_* ; do ./update_corpus.sh $(basename $file); done
```

## <a name="corpora_list"></a>List of corpora to convert

* monolingual
  * HAMLEDT 3.0 (now only obsolete 2.0 version and search for form|lemma|tag|afun only)!!    
  * W2C - Web to corpus - different languages, 55 gb scripts ready; no segmentation into sentences, noisy data
  * BushBank - MUNI
  * Corpus of contemporary blogs (MUNI)
  * Czech Named Entity Corpus
  * ~~Urdu Monolingual Corpus~~
  * ~~Facebook data for sentiment analysis~~ 
  * PDT annotation: Multiword expressions, coreference, lexico-semantic, discourse annotation in PDT??
  * Slovinsky korpus jos100k?
  * ACL RD-TEC 2.0: http://hdl.handle.net/11372/LRT-1661
* parallel
  * Summa Theologica (Latin-Czech) – contact Martin Holub
  * CzEng 1.6: http://ufal.mff.cuni.cz/czeng
  * ~~EnTam:English-Tamil parallel corpus~~
  * ~~English-Slovak parallel corpus~~
  * Indonesian-English parallel corpus 
* speech
  * English corpus of air traffic messages - Taiwanese accent
* External:
  * ACL corpus (https://groups.google.com/forum/#!topic/acl-anthology/GSaU_JhHUZo; see also https://github.com/ufal/lindat-corpora-conversions/issues/6)
  * OPUS (http://opus.lingfil.uu.se)
      * See the OPUS search interfaces. We should serve as an alternative (hopefuly nicer) interface for the same data.

