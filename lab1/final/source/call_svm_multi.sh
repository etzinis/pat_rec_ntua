TRAIN_FILE=output/"$1"
TEST_FILE=output/"$2"
RESULT="svm_multi"_"$1"_"$2"

cp "$TRAIN_FILE" svm/data
cp "$TEST_FILE" svm/data.t

# Call the svm 
cd svm
sh train_and_predict.sh "$RESULT"