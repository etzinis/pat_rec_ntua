estimated_f = open("results")

actual_f = open("test_smoothed2.txt")

output = open("matrix_svm.txt", "w")

shit = estimated_f.readline() 

conf_matrix = [[0 for i in xrange(10)] for i in xrange(10)]

estimated = estimated_f.readline()
actual = actual_f.readline()

while estimated:
	actual1 = actual.strip()
	estimated1 = estimated.strip()
	
	est = int(estimated1.split()[0])
	act = int(round(float(actual1.split()[0])))

	conf_matrix[act][est] += 1

	estimated = estimated_f.readline()
	actual = actual_f.readline()




for i in xrange(10):
 	for j in xrange(10):
 		output.write(str(conf_matrix[i][j]) + " ")
 	output.write("\n")


