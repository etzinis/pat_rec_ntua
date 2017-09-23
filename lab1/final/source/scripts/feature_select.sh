#command for calling feature selection in weka
#java -cp "/home/thymios/weka-3-8-0/weka.jar" weka.filters.supervised.attribute.AttributeSelection -E "weka.attributeSelection.CfsSubsetEval -P 1 -E 1" -S "weka.attributeSelection.BestFirst -D 1 -N 5" -b -i train.arff -o train_selected.arff -r test.arff -s test_selected.arff
#java -cp "/home/thymios/weka-3-8-0/weka.jar" weka.classifiers.trees.RandomForest -t train.arff -T test.arff -p 10 -distribution -P 100 -I 100 -num-slots 1 -K 0 -M 1.0 -V 0.001 -S 1 
java -cp "/home/thymios/weka-3-8-0/weka.jar" weka.classifiers.lazy.IBk -t ../input/smoothed2/train_smoothed2.arff -T ../input/smoothed2/test_smoothed2.arff -p 0 -distribution -K 100 -W 0 -I -A "weka.core.neighboursearch.LinearNNSearch -A \"weka.core.EuclideanDistance -R first-last\""
