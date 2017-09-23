import os,sys,operator
mlp_dir="../results/mlp/"
out_dir="../results/mlp_aggregated/"

def pass_metrics(lines):
	useful = lines[-(len(lines)-2):]
	#print lines
	if not useful == []:
		useful = useful[1].split()
		return useful[2:8]
	else:
		return ["0","0","0","0","0","0","0"]


def create_dicts():
	dic={"vnw":{}, "vw":{}, "anw":{}, "aw":{}}
	inputs = os.listdir(mlp_dir)
	for inp in inputs:
		#mlp_wrapper_features67_act_lr_0.9_hidden_20_10_10weka
		useful=(inp.split("lr_")[1]).split("weka")[0]
		lr=float(useful.split("_")[0])
		conf = useful.split("hidden_")[1]
		confs = conf.split("_")
		configuration = [str(lr)]+[confs[x] for x in range(len(confs))]
		#print configuration
		if "act" in inp and "wrapper" in inp:
			dicsel = "aw"
		elif "act" in inp and "wrapper" not in inp:
			dicsel = "anw"
		if "val" in inp and "wrapper" in inp:
			dicsel = "vw"
		elif "val" in inp and "wrapper" not in inp:
			dicsel = "vnw"

		filepath = mlp_dir+inp
		fin = open(filepath,"r")
		lines = fin.readlines()
		dic[dicsel][useful]=configuration + pass_metrics(lines)
		fin.close()
	return dic

def find_max(diction, f1_or_acc):
	if f1_or_acc == "f1":
		metric_ind = 8
	else:
		metric_ind = 4
	maxim = 0.0 
	maxim_conf = "Nobody"
	for el in diction:
		if maxim < float(diction[el][metric_ind]):
			maxim = float(diction[el][metric_ind])
			maxim_conf = el
	return (maxim, maxim_conf)

def all_confs(dic,layers, f1_or_acc):
	data = []
	if f1_or_acc == "f1":
		metric_ind = 8
	else:
		metric_ind = 4

	for el in dic:
		lr=el.split("_")[0]
		useful = el.split("hidden_")[1]
		true_l = useful.split("_")
		layer_param = "Nobody"
		if layers == 1:
			if true_l[1] == "0" and true_l[2] =="0":
				layer_param = true_l[0]
		elif layers == 2:
			if true_l[0] == "15" and true_l[2]=="0":
				layer_param = true_l[1]
		else:
			if true_l[0] == "15" and true_l[1]=="20":
				layer_param = true_l[2]
		if not layer_param == "Nobody" and not layer_param == "0":
			data.append(lr+" "+layer_param+" "+dic[el][metric_ind])

		#print data	

	return data


def hidden_layer_plot(dic,title,layers, f1_or_acc):


	datafile = "../mlp_plots/"+title
	fpl=open(datafile,"w")
	fpl.write("# X Y Z\n")
	data = all_confs(dic, layers, f1_or_acc)
	for dlines in data:
		fpl.write(dlines+"\n")
	fpl.close()
	#command = "gnuplot -e \"plot \""+datafile+"\" u 1:2:3 with lines \""
	#print command
	#os.system(command)

def print_best_mlp_results(dic):
	printdic={"vnw":"Valence all Features","vw":"Valence with Wrapper", "anw":"Activation all Features", "aw":"Activation with Wrapper"}
	#print dic
	#print [val[1][4] for val in sort_dic(dic["vw"],"f1")]
	#print dicaw
	#print dicanw
	print "\n======================================================"
	print "Best MLP Configurations"
	print "Activation/Valence - (Best F1 Score, Configuration)"
	for subdic in dic:
		print str(printdic[subdic])+ " - " +str(find_max(dic[subdic],"f1"))
	print "\n"
	print "Activation/Valence - (Best Accuracy, Configuration)"
	for subdic in dic:
		print str(printdic[subdic])+ " - " +str(find_max(dic[subdic],"acc"))
	print "======================================================\n"


def main():
	dic={"vnw":{}, "vw":{}, "anw":{}, "aw":{}}
	dic=create_dicts()

	print_best_mlp_results(dic)
	printdic={"vnw":"Valence_all_Features","vw":"Valence_with_Wrapper", "anw":"Activation_all_Features", "aw":"Activation_with_Wrapper"}

	for el in dic:
		for layer in [1,2,3]:
			for f1_or_acc in ["acc","f1"]:
				if layer == 1:
					conf_title = "One_Layer"
				elif layer == 2:
					conf_title = "H1_15"
				else:
					conf_title = "H1_15_H2_20"
				hidden_layer_plot(dic[el],printdic[el]+"_Configuration_"+conf_title+"_Metric_"+f1_or_acc,layer, f1_or_acc)
	print "Graph files Done"
	'''
	for el1 in dic:
		for el in dic[el1]:
			if "15_20" in el and float(dic[el1][el][4]) > 0.82:
				print el + str(dic[el1][el])
	'''
main()