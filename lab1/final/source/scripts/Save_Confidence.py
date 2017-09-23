import os, sys, operator

mlp_confidence = [ 354.0 / (5 + 354) \
				 , 256.0 / (8 + 256) \
				 , 183.0 / (15 + 183) \
				 , 151.0 / (17 + 151) \
				 , 184.0 / (16 + 184) \
				 , 148.0 / (12 + 148) \
				 , 162.0 / (8 + 162) \
				 , 137.0 / (10 + 137) \
				 , 151.0 / (15 + 151) \
				 , 172.0 / (5 + 172)]

onenn_confidence = [ 355.0 / (4 + 355) \
				 , 257.0 / (7 + 257)  \
				 , 186.0 / (12 + 186) \
				 , 153.0 / (15 + 153) \
				 , 183.0 / (17 + 183) \
				 , 146.0 / (14 + 146) \
				 , 165.0 / (5 + 165) \
				 , 141.0 / (6 + 141) \
				 , 151.0 / (15 + 151) \
				 , 170.0 / (7 + 170)]

svm_confidence = [ 354.0 / (5 + 354) \
				 , 257.0 / (7 + 257) \
				 , 185.0 / (13 + 185) \
				 , 152.0 / (14 + 152) \
				 , 188.0 / (12 + 188) \
				 , 150.0 / (10 + 150) \
				 , 162.0 / (8 + 162) \
				 , 139.0 / (8 + 139) \
				 , 156.0 / (10 + 156) \
				 , 172.0 / (5 + 172)]


def ind_max(my_list):
	index = 0
	mini = my_list[0]
	for i in range(1,len(my_list)):
		if (mini < my_list[i]):
			mini = my_list[i]
			index = i 

	return index

def find_recall(dic,act):
	rec1 = 0
	for key in dic:
		if(ind_max(dic[key]) == int(act[key])):
			rec1 = rec1 + 1
	return rec1

def make_the_list(data,matching):
	lista = [0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0]
	j = 0
	for d in data[1:]:
		lista[matching[j]]=float(d)
		j += 1

	return lista


def main():
	try:
		svm_file = sys.argv[1]
		NN_file = sys.argv[2]
		RF_file = sys.argv[3]
		result_file = sys.argv[4]
	except:
		print "Wrong Arguments"
		exit(1)
	
	conf_scores = {}
	matching = {}
	frand = open("../svm/results/"+svm_file)
	dic_lines = frand.readlines()
	frand.close()

	mat = dic_lines[0]
	mat.strip()
	classes = mat.split(" ")
	j = 0
	for num in classes[1:]:
		matching[j] = int(num)
		j += 1

	inst = 0

	
	for line in dic_lines[1:]:
		pure = line.strip()
		data = pure.split(" ")
		inst += 1
		lista = make_the_list(data,matching)
		lista = map(lambda x: float(x) if (not float(x) == 0) else float(x) + 0.000001 , lista)
		better_lista = map(lambda x: x[0] * x[1], zip(svm_confidence, lista))
		conf_scores[inst] = [lista]

	frand = open("../MLP/results/"+RF_file)
	dic_lines = frand.readlines()
	frand.close()

	print mlp_confidence

	inst = 0
	for line in dic_lines[5:-1]:
		pure = line.strip()
		pure = line.split("       ")[-1]
		cscores = pure.split(" ") 
		for cs in cscores:
			if(len(cs)>= 19):
				result = cs
				break

		result = result.replace("*","")
		lista = result.split(",")
		lista = map(lambda x: float(x) if (not float(x) == 0) else float(x) + 0.000001 , lista)
		better_lista = map(lambda x: x[0] * x[1], zip(mlp_confidence, lista))
		inst += 1
		conf_scores[inst].append(lista)

	#take the actual labels
	actual = {}
	inst = 0
	for line in dic_lines[5:-1]:
		pure = line.split("       ")
		for p in pure:
			if (":" in p):
				act_res = p.split(":")[1]
				break
		inst += 1
		actual[inst] = act_res

	frand = open("../1NN/Results/"+NN_file)
	dic_lines = frand.readlines()
	frand.close()

	inst = 0
	for line in dic_lines[5:-1]:
		pure = line.strip()
		pure = line.split("       ")[-1]
		cscores = pure.split(" ") 
		for cs in cscores:
			if(len(cs)>= 19):
				result = cs
				break

		result = result.replace("*","")
		lista = result.split(",")
		lista = map(lambda x: float(x) if (not float(x) == 0) else float(x) + 0.000001 , lista)
		better_lista = map(lambda x: x[0] * x[1], zip(onenn_confidence, lista))
		inst += 1
		conf_scores[inst].append(lista)

	avg_conf_scores = {}
	max_conf_scores = {}
	min_conf_scores = {}
	mul_conf_scores = {}
	for key in conf_scores:
		zipara = zip(*conf_scores[key])
		#sum_conf_scores[key] = map(+,zipara)
		max_conf_scores[key] = map(max,zipara)
		min_conf_scores[key] = map(min,zipara)
		avg_conf_scores[key] = map(lambda x: sum(x)/3,zipara)
		mul_conf_scores[key] = map(lambda x: x[0] * x[1] * x[2],zipara)
		
	#Compute the Recall for everyone above
	avg_right = find_recall(avg_conf_scores,actual)
	max_right = find_recall(max_conf_scores,actual)
	min_right = find_recall(min_conf_scores,actual)
	mul_right = find_recall(mul_conf_scores,actual)
	
	best_assessment = max(avg_right,max_right,min_right,mul_right)

	print "Recalls"
	print "Average: " + str(avg_right*100.0/len(actual))
	print "Maximum: " + str(max_right*100.0/len(actual))
	print "Minimum: " + str(min_right*100.0/len(actual))
	print "Multiplication: " + str(mul_right*100.0/max(actual.keys()))

	fout = open("../output/"+result_file,"w")
	for key in avg_conf_scores:
		fout.write(actual[key])
		for i in range(len(avg_conf_scores[key])):
			fout.write(" "+str(i+1)+":"+str(avg_conf_scores[key][i]))
		fout.write("\n")
	fout.close()
	#print avg_conf_scores
main()