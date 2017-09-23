import sys


def parse_matrix(f_name):
	f_in = open(f_name)
	matrix = []
	for line in f_in.readlines():
		words = map(int, line.strip().split(" "))
		matrix.append(words)

	print matrix
	return matrix

def find_difference(mat1, mat2):
	final_mat = []
	for i in xrange(len(mat1)):
		final_mat.append([])
		for j in xrange(len(mat1[0])):
			item1 = mat1[i][j]
			item2 = mat2[i][j]
			final_mat[i].append(item1-item2)

	print final_mat
	return final_mat 

def write_difference(mat, f_result):
	f_out = open(f_result, "w")
	for line in mat:
		for item in line:
			f_out.write(str(item) + "\t")
		f_out.write("\n")
	return

try:
	f_name1 = sys.argv[1]
	f_name2 = sys.argv[2]
	f_result = sys.argv[3]
except:
	print "Usage: " + sys.argv[0] + " <file1> <file2> <result_file>"
	exit(1)

matrix1 = parse_matrix(f_name1)
matrix2 = parse_matrix(f_name2)

difference = find_difference(matrix1, matrix2)

write_difference(difference, f_result)