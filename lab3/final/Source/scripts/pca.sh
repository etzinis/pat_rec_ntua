featuresfolder="../features/"
PATHTOWEKA="$1"

Configurations="5 10 15 25 50 100 167"
a_v="act val"
perms="1 2 3"
sixseven="67"

echo "Performing Principal Component Analysis..."

for conf in $Configurations
do
	for av in $a_v
	do	
		for perm in $perms
		do	
			for sx_cv in $sixseven
			do
				trainfile="${featuresfolder}arff_files/train_features${sx_cv}_${av}_perm${perm}.arff"
				testfile="${featuresfolder}arff_files/test_features${sx_cv}_${av}_perm${perm}.arff"
				resultstrainfile="${featuresfolder}pca_processed/train_features${sx_cv}_${av}_perm${perm}_pca${conf}.arff"
				resultstestfile="${featuresfolder}pca_processed/test_features${sx_cv}_${av}_perm${perm}_pca${conf}.arff"

				java -cp "$PATHTOWEKA" weka.filters.unsupervised.attribute.PrincipalComponents \
				 -R 0.95 -A ${conf} -M ${conf} -c "last" -b -i "${trainfile}" -o "${resultstrainfile}" -r "${testfile}" -s "${resultstestfile}"
				#  -E "weka.attributeSelection.PrincipalComponents -R 0.95 -A 5" \
				#  -S "weka.attributeSelection.Ranker -T -1.7976931348623157E308 -N -1"
			done 
		done 
	done 
done 
  