TRAIN_FILE=input/smoothed2/"$1".arff
TEST_FILE=input/smoothed2/"$2".arff
RESULT=1NN_"$1"_"$2"

# Call the 1NN
sh 1NN/train_and_evaluate.sh "$TRAIN_FILE" "$TEST_FILE" 1NN/results/"$RESULT"