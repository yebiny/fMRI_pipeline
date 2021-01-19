#!/bin/bash
source globals.sh
mkdir -p inter_output/regression
for mask in {1,2}; do
	for inputType in {tstat,filtered}; do
		python scripts/regression.py $SUBJ $mask $inputType
	done
done
python scripts/get_test_latentMat.py $SUBJ