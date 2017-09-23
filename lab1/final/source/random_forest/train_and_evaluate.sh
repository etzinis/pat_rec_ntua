java -cp "/home/thymios/weka-3-8-0/weka.jar" \
 weka.classifiers.trees.RandomForest \
  -t "$1" -T "$2" \
   -p 10 -distribution -P 100 -I 100 -num-slots 1 -K 0 -M 1.0 -V 0.001 -S 1 \
    > "$3"
