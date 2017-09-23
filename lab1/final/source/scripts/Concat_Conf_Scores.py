import os, sys, operator

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
		#lista = map(lambda x: float(x) if (not float(x) == 0) else float(x) + 0.000001 , lista)

		conf_scores[inst] = [lista]

	frand = open("../MLP/results/"+RF_file)
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
		#lista = map(lambda x: float(x) if (not float(x) == 0) else float(x) + 0.000001 , lista)
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

	frand = open("../1NN/results/"+NN_file)
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
		#lista = map(lambda x: float(x) if (not float(x) == 0) else float(x) + 0.000001 , lista)
		inst += 1
		conf_scores[inst].append(lista)
	'''
	fout = open("../output/"+result_file+"_withoutRF0","w")
	for key in conf_scores:
		fout.write(actual[key])
		for i in range(len(conf_scores[key])):
			if (i==1):
				continue
			nlist = 0
			for elem in conf_scores[key][i]:
				fout.write(" "+str(nlist + (i//2)*10 +1)+":"+str(elem))
				nlist += 1
		fout.write("\n")
	fout.close()
	'''
	fout = open("../output/"+result_file+"_0","w")
	for key in conf_scores:
		fout.write(actual[key])
		for i in range(len(conf_scores[key])):
			nlist = 0
			for elem in conf_scores[key][i]:
				fout.write(" "+str(nlist + i*10 +1)+":"+str(elem))
				nlist += 1
		fout.write("\n")
	fout.close()
	
	#print avg_conf_scores
main()