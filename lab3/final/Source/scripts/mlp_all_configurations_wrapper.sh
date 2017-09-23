#!/bin/bash

A_V="act val"
DATA_DIR="../features/wrapper_extracted_features/"
RESULTS_DIR="../results/mlp/"
WEKA_FOLDS="5"
wekapath="$1"

learningrates="0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9"
comblayers="5 10 15 20"

for ACT_VAL in ${A_V}
do
	for lr in ${learningrates}
	do
		for i in ${comblayers}
		do 
			for j in ${comblayers}
			do

				for k in ${comblayers}
				do 

					java -cp ${wekapath} weka.classifiers.functions.MultilayerPerceptron -L "${lr}" -M 0.2 -N 500 -V 0 -S 0 -E 20 -H "${i}, ${j}, ${k}" -t "${DATA_DIR}features67_${ACT_VAL}.arff" -x "$WEKA_FOLDS" | grep -E "TP Rate|Weighted Avg" > "${RESULTS_DIR}mlp_wrapper_features67_${ACT_VAL}_lr_${lr}_hidden_${i}_${j}_${k}weka.arff"	
					echo "Done ${lr}, ${i}, ${j}, ${k}"
				done 
				java -cp ${wekapath} weka.classifiers.functions.MultilayerPerceptron -L "${lr}" -M 0.2 -N 500 -V 0 -S 0 -E 20 -H "${i}, ${j}" -t "${DATA_DIR}features67_${ACT_VAL}.arff" -x "$WEKA_FOLDS" | grep -E "TP Rate|Weighted Avg" > "${RESULTS_DIR}mlp_wrapper_features67_${ACT_VAL}_lr_${lr}_hidden_${i}_${j}_0weka.arff"	
				echo "Done ${lr}, ${i}, ${j}, 0"
			done
			java -cp ${wekapath} weka.classifiers.functions.MultilayerPerceptron -L "${lr}" -M 0.2 -N 500 -V 0 -S 0 -E 20 -H "${i}" -t "${DATA_DIR}features67_${ACT_VAL}.arff" -x "$WEKA_FOLDS" | grep -E "TP Rate|Weighted Avg" > "${RESULTS_DIR}mlp_wrapper_features67_${ACT_VAL}_lr_${lr}_hidden_${i}_0_0weka.arff"	
			echo "Done ${lr}, ${i}, 0, 0"
		done
			
			
	done
done



