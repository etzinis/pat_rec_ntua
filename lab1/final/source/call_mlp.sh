TRAIN_FILE=input/smoothed2/"$1".arff
TEST_FILE=input/smoothed2/"$2".arff
RESULT=RF_"$1"_"$2"

# Call the 1NN
sh MLP/train_and_evaluate.sh "$TRAIN_FILE" "$TEST_FILE" MLP/results/"$RESULT"