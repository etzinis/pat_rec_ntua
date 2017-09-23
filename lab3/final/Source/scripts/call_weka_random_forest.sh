#!/bin/bash
wekapath="$1"

FOLDS=("1" "2" "3" "4" "5")
A_V=("act" "val")
SIX_SEVEN=("6" "7" "67")

DATA_DIR="../features/arff_files_5_fold/"
RESULTS_DIR="../results/random_forest/"
WRAPPER_DATA_DIR="../features/wrapper_extracted_features/"
WRAPPER_RESULTS_DIR="../results/random_forest_wrapper/"
WEKA_FOLDS="5"

echo "Building and Testing on Random Forest..."

for ACT_VAL in "${A_V[@]}"
do
	for SX_SV in "${SIX_SEVEN[@]}"
	do

# Alternatively
java -cp ${wekapath} weka.classifiers.trees.RandomForest -I 100 -K 0 -S 1 -t "${DATA_DIR}features${SX_SV}_${ACT_VAL}.arff" -x "$WEKA_FOLDS" \
> "${RESULTS_DIR}random_forest_results${SX_SV}_${ACT_VAL}_weka.arff"		
	done

java -cp ${wekapath} weka.classifiers.trees.RandomForest -I 100 -K 0 -S 1 \
-t "${WRAPPER_DATA_DIR}features67_${ACT_VAL}.arff" -x "$WEKA_FOLDS" \
> "${WRAPPER_RESULTS_DIR}random_forest_results67_${ACT_VAL}_weka.arff"
done



