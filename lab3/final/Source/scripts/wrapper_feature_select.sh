PATHTOWEKA="$1"
featuresfolder="../features/"
a_v="act val"
sixseven="67"

echo "Selecting the most prominent features..."

for av in $a_v
do	
	for sx_cv in $sixseven
	do
		trainfile="${featuresfolder}arff_files_5_fold/features${sx_cv}_${av}.arff"
		resultstrainfile="${featuresfolder}wrapper_extracted_features/features${sx_cv}_${av}.arff"

		java -cp "$PATHTOWEKA" weka.filters.supervised.attribute.AttributeSelection 
		-E "weka.attributeSelection.WrapperSubsetEval -B weka.classifiers.functions.SMO -F 5 -T 0.01 -R 1 -- -C 1.0 -L 0.001 -P 1.0E-12 -N 0 -V -1 -W 1 -K \"weka.classifiers.functions.supportVector.PolyKernel -C 250007 -E 1.0\"" \
		-S "weka.attributeSelection.BestFirst -D 1 -N 5" \
		-c "last" -i "${trainfile}" -o "${resultstrainfile}"


		#java -cp "$PATHTOWEKA" weka.filters.unsupervised.attribute.PrincipalComponents \
		#-R 0.95 -A ${conf} -M 1 -c "last" -i "${trainfile}" -o "${resultstrainfile}" -r "${testfile}" -s "${resultstestfile}"
		#  -E "weka.attributeSelection.PrincipalComponents -R 0.95 -A 5" \
		#  -S "weka.attributeSelection.Ranker -T -1.7976931348623157E308 -N -1"
	done 
done 
