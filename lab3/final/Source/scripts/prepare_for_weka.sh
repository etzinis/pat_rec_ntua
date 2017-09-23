echo "Convert features from Matlab To Arff..."
sourcedir="../features/matlab_extracted_features_5_fold/"
resultdir="../features/arff_files_5_fold/"
sourcefile="$(ls $sourcedir)"
converterpath="make_an_Arff.py"
for i in $sourcefile; 
do python $converterpath $i $sourcedir $resultdir; done
sourcedir="../features/matlab_extracted_features/"
resultdir="../features/arff_files/"
sourcefile="$(ls $sourcedir)"
for i in $sourcefile; 
do python $converterpath $i $sourcedir $resultdir; done 

