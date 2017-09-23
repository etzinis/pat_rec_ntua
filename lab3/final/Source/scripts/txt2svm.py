import sys


def convert(f_in, f_out, f_features):
	features = []
	labels = []
	for line in f_in.readlines():
		words = line.strip().split(" ")
		
		labels.append(int(round(float(words[0]))))
		features.append(zip(xrange(1,len(words)+1), words[1:]))
		
	indexes = map(lambda x: int(x)-1, f_features.readline().split())

	for i in xrange(len(features)):
		feature = [features[i][index] for index in indexes]
		label = labels[i]
		features_str = " ".join(map(lambda x: str(x[0])+":"+x[1], feature))

		#print features_str

		f_out.write(str(label) + " " + features_str+"\n")


try:
	train_file_name = sys.argv[1]
	test_file_name = sys.argv[2]
except:
	print "Usage: " + sys.argv[0] + "<train_file.txt> <test_file.txt>"
	print "Please change the source file according to the designated folders"
	exit(1)

sourcedir = "../features/matlab_extracted_features/"
resultdir = "../features/svm_files/"

train_in = open(train_file_name)
train_out = open("svm/data", "w") 
features_file = open("selected_features.txt")
convert(train_in, train_out, features_file)
features_file.close()
train_in.close()
train_out.close()
