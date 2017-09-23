#java -cp "/home/thymios/weka-3-8-0/weka.jar" weka.classifiers.trees.RandomForest -t train26040.arff -T test26040.arff -p 10 -distribution -P 100 -I 100 -num-slots 1 -K 0 -M 1.0 -V 0.001 -S 1 > random_tree_conf
#java -cp "/home/thymios/weka-3-8-0/weka.jar" weka.classifiers.lazy.IBk -t train26040.arff -T test26040.arff -p 10 -distribution -K 1 -W 0 -A "weka.core.neighboursearch.LinearNNSearch -A \"weka.core.EuclideanDistance -R first-last\"" > 1NN_conf

#java -cp "/home/thymios/weka-3-8-0/weka.jar" weka.classifiers.trees.RandomForest -t train28020.arff -T test28020.arff -p 10 -distribution -P 100 -I 100 -num-slots 1 -K 0 -M 1.0 -V 0.001 -S 1 > random_tree_conf
#java -cp "/home/thymios/weka-3-8-0/weka.jar" weka.classifiers.lazy.IBk -t train28020.arff -T test28020.arff -p 10 -distribution -K 1 -W 0 -A "weka.core.neighboursearch.LinearNNSearch -A \"weka.core.EuclideanDistance -R first-last\"" > 1NN_conf

#java -cp "/home/thymios/weka-3-8-0/weka.jar" weka.classifiers.trees.RandomForest -t train28020.arff -T test.arff -p 10 -distribution -P 100 -I 100 -num-slots 1 -K 0 -M 1.0 -V 0.001 -S 1 > random_tree_conf
#java -cp "/home/thymios/weka-3-8-0/weka.jar" weka.classifiers.lazy.IBk -t train28020.arff -T test.arff -p 10 -distribution -K 1 -W 0 -A "weka.core.neighboursearch.LinearNNSearch -A \"weka.core.EuclideanDistance -R first-last\"" > 1NN_conf

#java -cp "/home/thymios/weka-3-8-0/weka.jar" weka.classifiers.trees.RandomForest -t train26040.arff -T test26040.arff -p 10 -distribution -P 100 -I 100 -num-slots 1 -K 0 -M 1.0 -V 0.001 -S 1 > random_tree_conf
#java -cp "/home/thymios/weka-3-8-0/weka.jar" weka.classifiers.lazy.IBk -t train26040.arff -T test26040.arff -p 10 -distribution -K 1 -W 0 -A "weka.core.neighboursearch.LinearNNSearch -A \"weka.core.EuclideanDistance -R first-last\"" > 1NN_conf

java -cp "/home/thymios/weka-3-8-0/weka.jar" weka.classifiers.trees.RandomForest -t train26040.arff -T test.arff -p 10 -distribution -P 100 -I 100 -num-slots 1 -K 0 -M 1.0 -V 0.001 -S 1 > random_tree_conf
java -cp "/home/thymios/weka-3-8-0/weka.jar" weka.classifiers.lazy.IBk -t train26040.arff -T test.arff -p 10 -distribution -K 1 -W 0 -A "weka.core.neighboursearch.LinearNNSearch -A \"weka.core.EuclideanDistance -R first-last\"" > 1NN_conf

