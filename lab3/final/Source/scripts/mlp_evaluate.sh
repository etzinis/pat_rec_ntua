#!/bin/bash

DATA_DIR="../features/arff_files_5_fold/"
RESULTS_DIR="../results/mlp_final/"
WRAPPER_DATA_DIR="../features/wrapper_extracted_features/"
WRAPPER_RESULTS_DIR="../results/mlp_final_wrapper/"
WEKA_FOLDS="5"
SX_SV="6 7 67"
wekapath="$1"

echo "Building and Testing on MLP..."

for six_seven in ${SX_SV}
do

	lr=0.9
	i=20
	j=15
	k=5
	java -cp ${wekapath} weka.classifiers.functions.MultilayerPerceptron \
	-L "${lr}" -M 0.2 -N 500 -V 0 -S 0 -E 20 -H "${i}, ${j}, ${k}" \
	-t "${DATA_DIR}features${six_seven}_act.arff" -x "$WEKA_FOLDS" -v \
	| grep -E "TP Rate|Weighted Avg" \
	> "${RESULTS_DIR}mlp_features${six_seven}_act_lr_${lr}_hidden_${i}_${j}_${k}weka.arff"	


	lr=0.8
	i=20
	j=5
	k=15
	java -cp ${wekapath} weka.classifiers.functions.MultilayerPerceptron \
	-L "${lr}" -M 0.2 -N 500 -V 0 -S 0 -E 20 -H "${i}, ${j}, ${k}" \
	-t "${DATA_DIR}features${six_seven}_val.arff" -x "$WEKA_FOLDS" -v \
	| grep -E "TP Rate|Weighted Avg" \
	> "${RESULTS_DIR}mlp_features${six_seven}_val_lr_${lr}_hidden_${i}_${j}_${k}weka.arff"	


done

SX_SV="67"

for six_seven in "${SX_SV}"
do

	lr=0.2
	i=15
	j=20
	k=15
	java -cp ${wekapath} weka.classifiers.functions.MultilayerPerceptron \
	-L "${lr}" -M 0.2 -N 500 -V 0 -S 0 -E 20 -H "${i}, ${j}, ${k}" \
	-t "${WRAPPER_DATA_DIR}features${six_seven}_act.arff" -x "$WEKA_FOLDS" -v \
	| grep -E "TP Rate|Weighted Avg" \
	> "${WRAPPER_RESULTS_DIR}mlp_features${six_seven}_act_lr_${lr}_hidden_${i}_${j}_${k}weka.arff"	


	lr=0.3
	i=20
	j=5
	k=10
	java -cp ${wekapath} weka.classifiers.functions.MultilayerPerceptron \
	-L "${lr}" -M 0.2 -N 500 -V 0 -S 0 -E 20 -H "${i}, ${j}, ${k}" \
	-t "${WRAPPER_DATA_DIR}features${six_seven}_val.arff" -x "$WEKA_FOLDS" -v \
	| grep -E "TP Rate|Weighted Avg" \
	> "${WRAPPER_RESULTS_DIR}mlp_features${six_seven}_val_lr_${lr}_hidden_${i}_${j}_${k}weka.arff"	


done 		


