## Conversion in general

The treebanks from a CoNLLU format are transformed into a vertical format with a
treex script [`Block::Write::ManateeGeneral.pm`](https://github.com/ufal/treex/blob/CoNLL2Manatee/lib/Treex/Block/Write/ManateeGeneral.pm),
printing the following information: 
```
form lemma upos xpos feats parent deprel p_word p_lemma p_upos p_xpos p_feats p_deprel deps misc id p_id
```
## File dependencies and the order in which they are used
ud_convert.sh
  - run_treex.sh
      wrapper for a single treex job because when I submitted treex directly, it did not find the Treex blocks
  = run this script on cluster to *convert conllu to vertical (Manatee) format*
    (this requires checking out the directory universal_dep and whole Treex to the cluster, and possibly adjusting the paths in ud_convert and run_treex
    some jobs may fail, so after running ud_convert, run "grep err run_treex.sh.o*" and "grep 'Out of mem' run_treex.sh.o*" to find out which ones had problems

process.sh
  - post_process.sh 
      changes the order of the data to be train, dev, test
      extracts documents and paragraphs into separate structures (if marked in the data)
  - python generate_templates.py
      works only on kontext-dev because I was too lazy to install Cheetah (a python templating module) on cluster or another machine
      - with open('locale','r')
  = run this script on kontext-dev to *create the registry files* and *compile the vertical files*


## Hints

if treex complains of missing modules, first check that you are using at least version 5.18.2 of perl

if not, run
source /net/work/projects/perlbrew/init

and see if it helps
(after running it, cpanm -i will install to shared directories, which is what you probably want)

## Whole conversion pipeline on the cluster (outdated?)

```bash
# SSH to the cluster:
ssh lrc1 (or troja - in this case all data should be stored in troja)
# Use screen
screen

#Create directory in cluster TMP directory: 
mkdir -p /net/cluster/TMP/$USER/kontext/ud22
mkdir input output scripts input.sample 

# Download UD data from the repository (e.g. using wget)

# Chomp some sample into input.sample to test if the script does things correctly (optional),
# then change paths in ud_convert

# Get the scripts from the git repo

# adjust the perl block 
# https://github.com/ufal/treex/blob/master/lib/Treex/Block/Write/ManateeU.pm 
# according to which attributes you need to generate 

# Generate vertical
cd scripts & time ./ud_convert.sh  
# TODO change paths in ud_convert.sh, now everything is stored into input folder 

# Leave screen
exit

# Move all the data to kontext-dev:
ssh quest & kontext-dev & cd /opt/projects/lindat-services-kontext/devel/data/corpora/conversions/data/treex/universal_dep/
cd input 

# SCP vertical to kontext-dev:
scp $USER@$MACHINE.ms.mff.cuni.cz:/net/cluster/TMP/$USER/kontext/ud/input/*-train.vert output
cd output &for file in *; do echo $(basename $file); rename 's/(.*?)-ud-train.vert/ud_$1-a/' $(basename $file); done
# rename vertical files according to what is in registry

# Clean up (optional, or at least remove treex folder)
rm -r /net/cluster/TMP/$USER/kontext/ud22
```
