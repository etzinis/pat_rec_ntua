#!/bin/bash
wekapath="$1"

FOLDS=("1" "2" "3" "4" "5")
A_V=("act" "val")
SIX_SEVEN=("6" "7" "67")

DATA_DIR="../features/arff_files_5_fold/"
RESULTS_DIR="../results/svm/"
WRAPPER_DATA_DIR="../features/wrapper_extracted_features/"
WRAPPER_RESULTS_DIR="../results/svm_wrapper/"
WEKA_FOLDS="5"

echo "Building and Testing on SVM..."


for ACT_VAL in "${A_V[@]}"
do
	for SX_SV in "${SIX_SEVEN[@]}"
	do
# Alternatively
java -cp ${wekapath} weka.classifiers.functions.SMO -C 1.0 -L 0.001 -P 1.0E-12 -N 0 -V -1 -W 1 -K "weka.classifiers.functions.supportVector.PolyKernel -C 250007 -E 1.0" -t "${DATA_DIR}features${SX_SV}_${ACT_VAL}.arff" -x "$WEKA_FOLDS" \
> "${RESULTS_DIR}svm_results${SX_SV}_${ACT_VAL}_weka.arff"		
	
	done

java -cp ${wekapath} weka.classifiers.functions.SMO -C 1.0 -L 0.001 -P 1.0E-12 -N 0 -V -1 -W 1 -K "weka.classifiers.functions.supportVector.PolyKernel -C 250007 -E 1.0" \
-t "${WRAPPER_DATA_DIR}features67_${ACT_VAL}.arff" -x "$WEKA_FOLDS" \
> "${WRAPPER_RESULTS_DIR}svm_results67_${ACT_VAL}_weka.arff"
	
done



