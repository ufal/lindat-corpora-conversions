## Conversion in general

The treebanks from a CoNLLU format are transformed into a vertical format with a
treex script [`Block::Write::ManateeU.pm`](https://github.com/ufal/treex/blob/master/lib/Treex/Block/Write/ManateeU.pm),
printing the following information: 
```
form lemma pos ufeatures deprel parent_form parent_lemma parent_pos parent_ufeatures parent_deprel left/right immediate/distant
```
After the new version of KonText will be released, we will be able to use global conditions and search for attributes 
of a parent via its id. 
For more, see [#11](https://github.com/ufal/lindat-corpora-conversions/issues/11)

## Autogenerate registry

Because there are multiple templates, the script generate_templates.py was
created to automatically generate registry files (templates). 

## Splitting to documents
Some treebanks, like Italian and Bulgarian, have document name meta-information.
Use the script `split_to_docs.py` before conversions. 
Should we include it into UD, and thus those treebanks will be inconsistent with others?
   

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
 

## File dependencies
split_to_docs
  = split original input files by document name meta-information that is present in some of them

ud_convert.sh
  = run this script on cluster to convert conllu to vertical (Manatee) format

process.sh
  - python generate_templates.py
      - with open('locale','r')
  = run this script on kontext-dev to create templates and move all files to their correct locations


## Hints

if treex complains of missing modules, first check that you are using at least version 5.18.2 of perl

if not, run
source /net/work/projects/perlbrew/init

and see if it helps
(after running it, cpanm -i will install to shared directories, which is what you probably want)
