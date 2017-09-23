#!/bin/bash
workspace="/home/thymios/Desktop/NTUA/9th_Semester/Pattern_Recognition/lab3/Results/"
a_v="act val"
for av in ${a_v}
do
trainpath="${workspace}features_${1}_${av}.libsvm"
trainscaledpath="${workspace}trainsc"
modelpath="${workspace}svm.model"
outpath="${workspace}svm.out"
svm-scale $trainpath > $trainscaledpath

#linear kernel as the baseline paper supposed to be the best one
svm-train -t 0 -q -v 5 $trainscaledpath $modelpath
echo "Linear SVM ${av}"
#svm-predict $testscaledpath $modelpath $outpath

#poly kernel as the baseline paper supposed to be the best one
svm-train -t 1 -d 3 -q -v 5 $trainscaledpath $modelpath
echo "Poly3 SVM ${av}"
#svm-predict $testscaledpath $modelpath $outpath

svm-train -c 6 -q -v 5 $trainscaledpath $modelpath
#evaluate
echo "RBF SVM ${av}"
#svm-predict $testscaledpath $modelpath $outpath
done


