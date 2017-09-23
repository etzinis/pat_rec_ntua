import os, sys

res_dic={"SVM": "../results/svm/", "SVM_wrapper": "../results/SVM_WRAPPER/", 
"MLP": "../results/mlp_final/", "MLP_wrapper": "../results/mlp_final_wrapper/", 
"RandomForest": "../results/random_forest/", "RandomForest_wrapper": "../results/random_forest_wrapper/"}

def get_from_files(path, features, act_or_val):
	files = os.listdir(path)

	for file in files:
		if features in file and act_or_val in file:
			fin = open(path+file,"r")
			lines = fin.readlines()
			useful=[]
			for line in lines:
				if "Weighted Avg" in line:
					useful = line.split()

			#print useful
			(acc,fmeas) = (useful[2],useful[6])
			fin.close()

	return [acc,fmeas]

def unfold(dic_el):
	result = ""
	for t in dic_el:
		result = result + dic_el[t] + " "
	return result

def main():
	plot_dic={"act_acc_wrapper":{}, "val_acc_wrapper":{}, "act_f1_wrapper":{}, "val_f1_wrapper":{},
				"act_acc_67_":{}, "val_acc_67_":{}, "act_f1_67_":{}, "val_f1_67_":{},
				"act_acc_6_":{}, "val_acc_6_":{}, "act_f1_6_":{}, "val_f1_6_":{},
				"act_acc_7_":{}, "val_acc_7_":{}, "act_f1_7_":{}, "val_f1_7_":{},}
	for res in res_dic:
		if "wrapper" in res:
			for act_or_val in ["act", "val"]:
				acc_and_f1 = get_from_files(res_dic[res],"67_",act_or_val)
				plot_dic[act_or_val+"_acc_wrapper"][res.split("_")[0]] = acc_and_f1[0]
				plot_dic[act_or_val+"_f1_wrapper"][res.split("_")[0]] = acc_and_f1[1]

		else:
			for act_or_val in ["act", "val"]:
				for features in ["6_","7_","67_"]:
					acc_and_f1 = get_from_files(res_dic[res],features,act_or_val)
					plot_dic[act_or_val+"_acc_"+features][res.split("_")[0]] = acc_and_f1[0]
					plot_dic[act_or_val+"_f1_"+features][res.split("_")[0]] = acc_and_f1[1]

	translator={"6_":0,"7_":1,"67_":2,"wrapper":3}
	resultdir={"acc_act":[0,0,0,0], "acc_val":[0,0,0,0], "f1_act":[0,0,0,0], "f1_val":[0,0,0,0]}

	for acc_or_f1 in ["acc","f1"]:
		for act_or_val in ["act","val"]:
			for el in plot_dic:
				if acc_or_f1 in el and act_or_val in el:
					temp = plot_dic[el]
					for tr in translator:
						if tr in el:
							resultdir[acc_or_f1 + "_" + act_or_val][translator[tr]] = unfold(temp)

	final_dir = {}
	for t in resultdir:
		stringos = ""
		for st in range(len(resultdir[t])):
			stringos = stringos + resultdir[t][st] + "; "
		final_dir[t] = stringos.strip(" ; ")

	translator = {"acc_act":"Accuracy Activation", "acc_val":"Accuracy Valence", "f1_act":"F1-Measure Activation", "f1_val":"F1-Measure Valence"}
	for t in final_dir:
		param = "[" + final_dir[t] + "]"
		name = "'" + translator[t] + "'"

		os.system("matlab -nodesktop -r \"data = "+ param +"; name=" + name + "; run '../final_plots.m'; exit(0);\"")





main()