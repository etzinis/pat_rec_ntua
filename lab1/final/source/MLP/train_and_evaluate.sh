java -cp "/home/thymios/weka-3-8-0/weka.jar" weka.classifiers.functions.MultilayerPerceptron  \
-t "$1" -T "$2" \
-p 10 -distribution \
-L 0.3 -M 0.2 -N 500 -V 0 -S 0 -E 20 -H a \
 > "$3"