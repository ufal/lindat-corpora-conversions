
#Corpora conversion
* [Introduction](#intro)
* [Conversion utilities](#cu)
* [Conversion process](#conv_proc)
 * [PDT to Manatee](#pdt-manatee)
 * [Treex to Manatee](#treex-manatee)
* [Corpora compilation](#corp-comp)
* [Conversion benchmarks](#benchmarks)

##<a name="intro"></a>Introduction

Conversion of corpora from vertical text to binary format is done by the compilecorp tool provided by the manatee package.
Two files are needed for the conversion: the vertical text (i.e. corpus) itself and corpus configuration file that describes in detail the contents of the corpus.

The vertical text is documented here: http://www.sketchengine.co.uk/documentation/wiki/SkE/PrepareText<br />
The corpus configuration file is documented here: http://www.sketchengine.co.uk/documentation/wiki/SkE/Config/FullDoc
###Directory structure

The directory structure on kontext-dev (kontext) servers is as follows:
```
/opt/project/lindat-services/$ENVIRONMENT/data/corpora/registry # configuration files (no subdirectories)
/opt/project/lindat-services/$ENVIRONMENT/data/corpora/data # compiled corpora
/opt/project/lindat-services/$ENVIRONMENT/data/corpora/speech # mp3 files
/opt/project/lindat-services/devel/data/corpora/conversion # conversion of corpora (data and scripts)
/opt/project/lindat-services/devel/data/corpora/vert # vertical text files (corpora data)
```

##<a name="cu"></a>Conversion utilities

This directory contains conversion utilities for converting corpora into LINDAT KonText format.
Corpora utilities are grouped in subdirectories by the input format.

* conll_like - input files have form of a tab delimited columns
* custom - input files have custom formats
* treex - input files are processable by treex perl framework
* vertical - input file are already in output format

###Tools

Conversion of corpora is performed on development environment only and realized by the following tools:

* Makefile
* bash tools (awk, sed)
* treex
* python

##Cluster setup(ufal-internal)

See detailed description of the cluster here: https://wiki.ufal.ms.mff.cuni.cz/grid

###SGE (Sun Cluster Engine) setup

Set up the SGE environment as written here https://wiki.ufal.ms.mff.cuni.cz/zakladni-nastaveni-sge

###Disk space

For any conversion create separate directory in /net/cluster/TMP (automounted) or /net/cluster/SSD (automounted) as there is not enough space elsewhere for large corpora.
Be sure to clean up any files when the conversion is finished.

###Treex

Install perlbrew on your local computer (your $HOME will be available on the cluster as well) as described here: https://wiki.ufal.ms.mff.cuni.cz/perlbrew
Install Treex from SVN as described here: http://ufal.mff.cuni.cz/treex/install.html, please note that most of the prerequisites is already provided by the perlbrew.

##<a name="conv_proc"></a>Conversion process
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
###<a name="pdt-manatee"></a>PDT to Manatee
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

###<a name="treex-manatee"></a>Treex to Manatee

Conversion of treex files was implemenented in perl as a Block for Treex (Treex::Block::Write::Manatee). This block converts documents in treex to <doc> structures in vertical files for Manatee.

##<a name="corp-comp"></a>Corpora compilation
Set MANATEE_REGISTRY environmental variable to the directory with registry files:
```
export MANATEE_REGISTRY=/opt/projects/lindat-services-kontext/devel/data/corpora/registry
```
Compile the corpus:
```
cd $MANATEE_REGISTRY
compilecorp --no-sketches --recompile-corpus <corpus config file>
```
###Troubleshooting

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


