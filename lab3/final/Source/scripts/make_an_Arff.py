import os, sys


def make_header(arff_name, data_lines):
	dataout = open(arff_name,"w")
	dataout.write("%Thymios - Kostantinos Pattern Recognition\n")
	dataout.write("@RELATION Music_Emotion_Recognition\n\n")
	for i in range(1,len(data_lines[0].split(","))):
		dataout.write("@ATTRIBUTE Feature"+ str(i) + " NUMERIC\n")

	dataout.write("\n@ATTRIBUTE Class {-1,1}\n")
	dataout.write("\n@DATA\n")
	
	for line in data_lines:
		dataout.write(line)

	dataout.close()

try:
	txtfile = sys.argv[1]
	sourcepath = sys.argv[2]
	resultpath = sys.argv[3]
except Exception as e:
	print "Usage: " + sys.argv[0] + " <feature_file.txt> "
	print "Please change the paths according to your designated folders"

def main():
	fin = open(sourcepath + txtfile)
	inputdata = fin.readlines()
	fin.close()
	make_header(resultpath + txtfile.replace('.txt','') + ".arff",inputdata)
	print "Arff file: " + resultpath + txtfile.replace('.txt','') + ".arff" + " is ready!\n"

main()