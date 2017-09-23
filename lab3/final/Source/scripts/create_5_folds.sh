#!/bin/bash
sourcedir="../features/arff_files_5_fold/"
sourcefile="$(ls $sourcedir)"

for source in $sourcefile
do
    JAR=$1
    FOLDS=5
    FILTER=weka.filters.unsupervised.instance.RemoveFolds
    SEED=1
    
    for ((i = 1; i <= $FOLDS; i++))
    do
      echo "Generating pair $i/$FOLDS..."
    
      OUTFILE="../features/arff_files_5_fold/$source"
      # train set
      java -cp $JAR $FILTER -V -N $FOLDS -F $i -S $SEED -i "$sourcedir$source" -o "${OUTFILE}_train_${i}_of_${FOLDS}.arff"
      # test set
      java -cp $JAR $FILTER    -N $FOLDS -F $i -S $SEED -i "$sourcedir$source" -o "${OUTFILE}_test_${i}_of_${FOLDS}.arff"
    done
done