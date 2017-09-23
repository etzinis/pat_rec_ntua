import os, sys

def make_header(arff_name, data_lines):
	dataout = open(arff_name,"w")
	dataout.write("%Thymios - Kostantinos Pattern Recognition\n")
	dataout.write("@RELATION Digits-Classification\n\n")
	for i in range(1,31):
		dataout.write("@ATTRIBUTE Confidence_Score"+ str(i) + " NUMERIC\n")

	dataout.write("\n@ATTRIBUTE Class {0,1,2,3,4,5,6,7,8,9}\n")
	dataout.write("\n@DATA\n")
	for line in data_lines:
		purel = line.strip()
		chars = purel.split(" ")
		cl = int(round(float(chars[0])))
		for j in range(1,len(chars)):
			dataout.write(str(chars[j].split(":")[1])+",")

		dataout.write(str(cl) + "\n")

	dataout.close()

def main():
	suffix = "60_40"
	tr_file_name = "concated_"+suffix+"_0"
	test_file_name = "concated_"+suffix[:2]+"_test_smoothed2_0"
	ftrain = open("../output/"+tr_file_name)
	ftest = open("../output/"+test_file_name)
	traindata = ftrain.readlines()
	testdata = ftest.readlines()
	ftest.close()
	ftrain.close()

	make_header("../output/"+tr_file_name+".arff",traindata)
	make_header("../output/"+test_file_name+".arff",testdata)
	print "Arff files are ready!\n"

main()