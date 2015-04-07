#/bin/bash
INPUT_DIR=../input

for trs in $INPUT_DIR/*.trs; do
	echo "air2manatee $trs"
	./air2manatee.py $trs ../output/Airtraffic_en-w ../tmp/sox.sh
done

