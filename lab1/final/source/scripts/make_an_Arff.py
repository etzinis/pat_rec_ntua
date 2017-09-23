import os, sys

def make_header(arff_name, data_lines):
	dataout = open(arff_name,"w")
	dataout.write("%Thymios - Kostantinos Pattern Recognition\n")
	dataout.write("@RELATION Digits-Classification\n\n")
	for i in range(1,257):
		dataout.write("@ATTRIBUTE Pixel"+ str(i) + " NUMERIC\n")

	dataout.write("\n@ATTRIBUTE Class {0,1,2,3,4,5,6,7,8,9}\n")
	dataout.write("\n@DATA\n")
	for line in data_lines:
		purel = line.strip()
		chars = purel.split(" ")
		cl = int(round(float(chars[0])))
		for j in range(1,len(chars)):
			dataout.write(str(chars[j])+",")

		dataout.write(str(cl) + "\n")

	dataout.close()

def main():
	ftrain = open("../input/train.txt")
	ftest = open("../input/test.txt")
	traindata = ftrain.readlines()
	testdata = ftest.readlines()
	ftest.close()
	ftrain.close()

	make_header("../input/train.arff",traindata)
	make_header("../input/test.arff",testdata)
	print "Arff files are ready!\n"

main()