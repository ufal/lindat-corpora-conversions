
#Corpora conversion
* [Conversion utilities](#cu)
* [Conversion process](#conv_proc)
 * [PDT to Manatee](#pdt-manatee)
 * [Treex to Manatee](#treex-manatee)
* [Corpora compilation](#corp-comp)

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
```
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
```
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
