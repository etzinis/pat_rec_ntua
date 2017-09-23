TRAIN_FILE=input/smoothed2/"$1".txt
TEST_FILE=input/smoothed2/"$2".txt
RESULT="svm_results"_"$1"_"$2"

# Call the txt2svm to transform the files in the correct format
python scripts/txt2svm.py "$TRAIN_FILE" "$TEST_FILE"

# Call the svm 
cd svm
sh train_and_predict.sh "$RESULT"