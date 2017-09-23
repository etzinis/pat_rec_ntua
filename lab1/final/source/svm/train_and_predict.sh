#!/bin/bash

# Accuracy 94.6687%
# svm-train -t 1 data > /dev/null 

# Accuracy 94.2202%
# svm-train -t 1 -d 2 data > /dev/null 

# Accuracy as semi-multi 8020 95.3662
#svm-train -t 1 -d 1 -c 3.5 -g 0.5 data > /dev/null 

# Accuracy as semi-multi 6040 95.0673
# svm-train -t 1 -d 1 -c 13 -g 0.5 data > /dev/null 

# Accuracy 95.416%
# svm-train -t 1 -c 10 data > /dev/null 

# Accuracy with smoothed2 95.5157%
# Accuracy as multi 6040 93.2735%
svm-train -b 1 -t 1 -c 15 data > /dev/null 

# Accuracy 95.4659%
# svm-train -t 1 -c 5 data > /dev/null 

# Accuracy with smoothed 95.6153%
# svm-train -t 1 -c 20 data > /dev/null 

# Accuracy 93.6721%
# svm-train -t 1 -d 5 data > /dev/null 

# Accuracy 92.5262%
# Accuracy as multi 6040 94.868%
# Accuracy as semu-multi 8020 95.3164% 
# svm-train -t 0 data > /dev/null 

# Accuracy 91.43%
# Accuracy as multi 6040 94.569%
# svm-train -t 3 data > /dev/null 

# Accuracy 93.87%
# svm-train -t 2 data > /dev/null 

# Accuracy 91.92%
# svm-train -t 3 data > /dev/null 


# Accuracy as multi 6040 94.868%
# svm-train -t 2 -c 30 -g 0.05 data > /dev/null 


svm-predict -b 1 data.t data.model results/"$1"
