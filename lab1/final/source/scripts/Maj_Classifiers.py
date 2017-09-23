import os
import sys
import re

vote_res = {}

def majority_voting(votes, actdic):
	wrong_by_all = 0
	wrong_by_2 = 0
	wrong_general = 0
	for line in votes:
		temp = {'0':0, '1':0, '2':0, '3':0, '4':0, '5':0, '6':0, '7':0, '8':0, '9':0}
		decisions = votes[line]
		for dec in decisions:
			temp[dec] += 1

		flag = 0

		for vt in temp:
			if (temp[vt] > 1):
				vote_res[line] = vt
				flag = 1
				break

		if not (flag == 1):
			vote_res[line] = decisions[1]

		if (not (actdic[line] == vote_res[line])):
			if(len(filter(lambda x: x != actdic[line] , decisions))==3):
				wrong_by_all += 1
			elif(len(filter(lambda x: x != actdic[line], decisions)) == 2):
				wrong_by_2 += 1
			wrong_general +=1	
			print str(decisions) + "||" + actdic[line] 

	print len(votes)
	print "Wrong general: ", wrong_general
	print "Wrong by all: ", wrong_by_all
	print "Wrong by 2: ", wrong_by_2

def main():
	right_inst = 0
	dic = {}
	actdic = {}	
	frand = open("./MLP/results/RF_train_smoothed2_test_smoothed2")
	dic_lines = frand.readlines()
	frand.close()

	for line in dic_lines:
		pure = re.sub(' +', ' ', line.strip())
		data = pure.split(" ")

		if(data[0].isdigit()):
			inst = int(data[0])
			act = data[1].split(":")[1]
			est = data[2].split(":")[1]
			dic[inst] = [est]
			actdic[inst] = act			



	frand = open("./svm/results/svm_results_train_smoothed2_test_smoothed2")
	dic_lines = frand.readlines()
	frand.close()

	inst = 0
	
	for line in dic_lines[1:]:
		pure = line.strip()
		data = pure.split(" ")
		inst += 1
		est = data[0]
		dic[inst].append(est)

	frand = open("./1NN/Results/1NN_train_smoothed2_test_smoothed2")
	dic_lines = frand.readlines()
	frand.close()

	inst = 0

	for line in dic_lines:
		pure = re.sub(' +', ' ', line.strip())
		data = pure.split(" ")

		if(data[0].isdigit()):
			print data
			inst = int(data[0])
			act = data[1].split(":")[1]
			est = data[2].split(":")[1]
			dic[inst].append(est)


	majority_voting(dic,actdic)

	#Compute Total Recall
	for line in vote_res:
		if (vote_res[line] == actdic[line]):
			right_inst += 1

	total_rec = (right_inst * 100.0) / len(vote_res)
	print total_rec
main()