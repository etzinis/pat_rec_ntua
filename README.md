# pat_rec_ntua
Labs exercises in NTUA (2016-2017) for the Pattern Recognition course 9th semester  

Contributors: 
- [Efthymios Tzinis](https://github.com/etzinis)  
- [Konstantinos Kallas](https://github.com/angelhof)

## Lab 1: Handwritten-digits-images Recognition

In this work we prepared steps 10 till 16 from the Laboratory Exercise 1. The main purpose of this Exercise includes the implementation of an automatic visual recognition of hand - written digits 0-9. The steps below are presented with
a given explanation for each one and images wherever it is necessary for a better perspective. We endeavored the usage and experimentation of different classifiers and deviant selections of splitting data, training and testing techniques.
We tried to reach the recent state of the art of handwritten digits recognition which is currently around 99:8% as have been stated in [1] which was achieved
through the usage of a Deep Neural Network. Comments in our codes could be quite helpful in further and deeper understanding of our implementation. 

## Lab 2: Spoken-Digits Recognition 

In our work we experimented on a typical digit recognition system from speech data provided by the laboratory exercise files. We implemented our system in
Matlab according to the steps provided by the description of the exercise. The final result is quite remarkable as the evaluation of our model demonstrated
estimable accuracy by using the HMM tool in Matlab. The training and the test data sets are comprised by 15 speakers and 4 speakers respectively, speaking
the digits from 1 to 9. Throughout the exercise we found deviant approaches for further increasing the accuracy of our model which are discussed below. Policies
and assumptions are also described and analyzed. The implemented model is based on the model described by Rabiner in [2].

## Lab 3: Speech Emotion Recognition

In this work we prepared steps 10 till 17 from the Laboratory Exercise 3. The
main purpose of this Exercise includes the implementation of an automatic emotion recognition system which is dedicated to individual emotion classification of
all the song files. We took advantage of the previous results of the preparation
(feature extraction of MFCC’s and also from the application of miremotion()
[3]) and used some files of the first laboratory exercise (k-NN and Naive Bayes
implementation). For the Steps 12-14 we performed the evaluation in k-NN
and Naive Bayes and also performed a PCA analysis of the features working on
WEKA. For steps 15-17 we used exclusively WEKA classifiers and our scripts in
order to acquire the relevant classification results. After that we compared our
selected system for both activation and valence recognition task with an SVM
based classifier system and features extracted automatically using Opensmile
Toolkit [4]. Our proposed system, based on SVM, outperforms the baseline in
both valence and activation recognition with less extracted features. This last
step was not demanded by the exercise but it is essential in order to validate if
our classification results are good.

## Analytic: analytic exercises

Contributor: 
- [Efthymios Tzinis](https://github.com/etzinis)  

References: 

[1] Multi-column Deep Neural Networks for Image Classification, Dan Ciresan Ueli, Meier, Jurgen Schmidhuber, Technical Report No. IDSIA-04-12 

[2] B.H.Juang, R.Rabiner, Hidden Markov Models, Technometrics, Vol. 33, No.3. (Aug., 1991), pp. 251-272.

[3] Tuomas Eerola, Olivier Lartillot, Petri Toiviainen, "Prediction of Multidimensional Emotional Ratings in Music From Audio Using Multivariate Regression Models", International Conference on Music Information Retrieval,
Kobe, 2009.

[4] Eyben, F., Woellmer, M., & Schuller, B. (2010). openSMILE the Munich
open Speech and Music Interpretation by Large Space Extraction toolkit.
Retrieved from http://www.mmk.ei.tum.de
