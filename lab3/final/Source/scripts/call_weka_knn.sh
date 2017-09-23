#!/bin/bash
PATHTOWEKA="$1"


FOLDS=("1" "2" "3")
A_V=("act" "val")
SIX_SEVEN=("6" "7" "67")
NEIGHS=("1" "3" "5" "7" "9" "11")
PCA_CONFS=("5" "10" "15" "25" "50" "100" "167")

DATA_DIR="../features/arff_files/"
PCA_DATA_DIR="../features/pca_processed/"
RESULTS_DIR="../results/knn_for_3_perms/"
PCA_RESULTS_DIR="../results/knn_for_3_perms_pca/"
WEKA_FOLDS="5"

echo "Building and Testing on KNN..."

for ACT_VAL in "${A_V[@]}"
do
	echo "Knn for ${ACT_VAL} :)"
	for SX_SV in "${SIX_SEVEN[@]}"
	do
		for FOLD in "${FOLDS[@]}"		
		do
			for NEIGH in "${NEIGHS[@]}"
			do

java -cp "$PATHTOWEKA" weka.classifiers.lazy.IBk -K "${NEIGH}" -W 0 -A "weka.core.neighboursearch.LinearNNSearch -A \"weka.core.EuclideanDistance -R first-last\"" -t "${DATA_DIR}train_features${SX_SV}_${ACT_VAL}_perm${FOLD}.arff" -T "${DATA_DIR}test_features${SX_SV}_${ACT_VAL}_perm${FOLD}.arff" \
> "${RESULTS_DIR}${NEIGH}nn_for_3_perms_results${SX_SV}_${ACT_VAL}_${FOLD}_of_3.arff"

				for PCA_CONF in "${PCA_CONFS[@]}"
				do

java -cp "$PATHTOWEKA" weka.classifiers.lazy.IBk -K "${NEIGH}" -W 0 -A "weka.core.neighboursearch.LinearNNSearch -A \"weka.core.EuclideanDistance -R first-last\"" -t "${PCA_DATA_DIR}train_features67_${ACT_VAL}_perm${FOLD}_pca${PCA_CONF}.arff" -T "${PCA_DATA_DIR}test_features67_${ACT_VAL}_perm${FOLD}_pca${PCA_CONF}.arff" \
> "${PCA_RESULTS_DIR}${NEIGH}nn_for_3_perms_pca${PCA_CONF}_results67_${ACT_VAL}_${FOLD}_of_3.arff"

				done
			done
		done	
	done
done



