ssh stargate
scp kontext-dev:~/corpora/conversions/data/all/vyhlasky/input/raw/raw_input.txt /net/cluster/TMP/vernerova/kontext/vyhlasky/input
scp kontext-dev:~/corpora/conversions/data/all/vyhlasky/scripts/Makefile_parsetreex /net/cluster/TMP/vernerova/kontext/vyhlasky/scripts/Makefile    ### note the rename!!!
ssh lrc1    ### I ran this on the cluster because Treex actually works there, while it does not work on stargate
            ### but I should add some "submit job" step because now make runs directly on lrc1
cd /net/cluster/TMP/vernerova/kontext/vyhlasky/scripts/
make parse   
scp /net/cluster/TMP/vernerova/kontext/vyhlasky/output/raw_input.vert kontext-dev:~/corpora/conversions/data/all/vyhlasky/input/raw_input_parsed.txt
ssh kontext-dev
#manually correct broken HTML elements (h,doc,sup including their closing variants) in raw_input_parsed
cd ../scripts
make compile  ### note that this is using a different Makefile than the "make parse" above
              ### the Makefile for "make parse" is called "Makefile_parsetreex in the conversions repo
    
    
