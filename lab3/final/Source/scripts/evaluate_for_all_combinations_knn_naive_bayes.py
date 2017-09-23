import sys, os, re

def extract_results(filename):
	f_in = open(filename)
	text = f_in.read()
	f_in.close()	
	results = re.findall('^Weighted Avg\..*$', text, flags=re.MULTILINE)
	try:
		test_line = results[-1].split()
		accuracy = float(test_line[2])
		f_measure = float(test_line[6])			
	except:
		print "No match for file: " + filename
	return (accuracy, f_measure)

def average(listy):
	return float(sum(listy)) / len(listy)

def find_best_config(dic, index):
	maximum = -1
	max_key = ""	
	for key in dic:
		value = dic[key][index]
		if value > maximum:
			maximum = value
			max_key = key
	return (max_key, maximum)

def average_for_perms(file_prefix, file_suffix, perms):
	temp_results = []
	for perm in xrange(1,perms+1):
		final_file = file_prefix + str(perm) + file_suffix
		temp_results.append(extract_results(final_file))
				
	temp_accs = map(lambda x: x[0], temp_results)
	temp_fs = map(lambda x: x[1], temp_results)
	print file_prefix, temp_accs, temp_fs
	return (average(temp_accs), average(temp_fs))

def write_to_file(filename, dic):

	dic = {k.split("/")[-1]: v  for k, v in dic.items()}	
		
	f_out  = open(filename + "-acc", "w")
	for key in sorted(dic.keys()):
		val = dic[key]
		f_out.write(key + " - " + str(round(val[0],4)) + "\n")
	f_out.close()
	
	f_out  = open(filename + "-f_measure", "w")
	for key in sorted(dic.keys()):
		val = dic[key]
		f_out.write(key + " - " + str(round(val[1],4)) + "\n")
	f_out.close()

	f_out  = open(filename + "-matlab", "w")
	for key in sorted(dic.keys()):
		val = dic[key]
		f_out.write(str(round(val[0],4)) + "," + str(round(val[1],4)) + "\n")
	f_out.close()


	

def main():

	# Directories	
	knn_results_dir = "../results/knn_for_3_perms/"
	knn_pca_results_dir = "../results/knn_for_3_perms_pca/"
	knn_out = "../results/knn_averages/"
	bayes_results_dir = "../results/naive_bayes/"
	bayes_pca_results_dir = "../results/naive_bayes_pca/"
	bayes_out = "../results/naive_bayes_averages/"

	# Configurations
	act_or_val = ["act", "val"]
	six_or_seven = ["6", "7", "67"]
	neighbours = ["1", "3", "5", "7", "9", "11"]
	pca_confs = ["5", "10", "15", "25", "50", "100", "167"]

	
	
	# Bayes
	for a_v in act_or_val:		

		accuracy_and_f_measure = {}	
		file_suffix = "_of_3.arff"
		# All features		
		for sx_sv in six_or_seven:
			file_prefix = bayes_results_dir + "naive_bayes_results" + sx_sv + "_" + a_v + "_"
			accuracy_and_f_measure[file_prefix] = average_for_perms(file_prefix, file_suffix, 3)
		

		# PCA
		for pca_c in pca_confs:
			file_prefix = bayes_pca_results_dir + "naive_bayes_pca" + pca_c + "_results67_" + a_v + "_"
			accuracy_and_f_measure[file_prefix] = average_for_perms(file_prefix, file_suffix, 3)
			print 	accuracy_and_f_measure[file_prefix]
				
		print find_best_config(accuracy_and_f_measure,0)
		print find_best_config(accuracy_and_f_measure,1)
		#print accuracy_and_f_measure
		
		file_out = bayes_out + "naive_bayes_" + a_v
		write_to_file(file_out, accuracy_and_f_measure)


	# KNN
	for a_v in act_or_val:		

		accuracy_and_f_measure = {}			
		file_suffix = "_of_3.arff"
		# All features		
		for sx_sv in six_or_seven:
			for neigh in neighbours:						
				file_prefix = knn_results_dir + neigh + "nn_for_3_perms_results" + sx_sv + "_" + a_v + "_"
				accuracy_and_f_measure[file_prefix] = average_for_perms(file_prefix, file_suffix, 3)
		

		# PCA
		for pca_c in pca_confs:
			for neigh in neighbours:						
				file_prefix = knn_pca_results_dir + neigh + "nn_for_3_perms_pca" + pca_c + "_results67_" + a_v + "_"
				accuracy_and_f_measure[file_prefix] = average_for_perms(file_prefix, file_suffix, 3)
					
		print find_best_config(accuracy_and_f_measure,0)
		print find_best_config(accuracy_and_f_measure,1)
		#print accuracy_and_f_measure
		
		file_out = knn_out + "knn_" + a_v
		write_to_file(file_out, accuracy_and_f_measure)



main()
