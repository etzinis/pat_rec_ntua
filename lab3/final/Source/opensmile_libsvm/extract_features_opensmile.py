import os, sys, random

# define train percentage
trainp = 1.0
testp = 0.0
try:
	trainp = float(sys.argv[1])
	testp = 1.0 - trainp
except Exception as e:
	pass

# if you want in silent mode
silentarg = ""
try:
	if (sys.argv[2] == "silent"):
		silentarg = "-noconsoleoutput"
except Exception as e:
	pass

# if you want to prepare features for WEKA classifiers or LibSVM
conf_type = "arff"
try:
	if (sys.argv[3] == "libsvm"):
		conf_type = "libsvm"
except Exception as e:
	pass

#select the features with underscore
masterconf = "MFCC_Energy_F0_ZCR_LPC"
try:
	masterconf = sys.argv[4] 
except Exception as e:
	pass

#Example of call: python Berlin_extract_classes.py 0.9 silent libsvm MFCC_Energy_F0

# Assuming that you have already installed Opensmile
# Change all the paths and then run "export PATH=$PATH:/path/to/opensmile_bin/"
workspacepath = "/home/thymios/Desktop/NTUA/9th_Semester/Pattern_Recognition/lab3/"
rworkspacepath = "/home/thymios/Desktop/My_Research/Workspace/"
datapath = workspacepath + "Data/"
respath = workspacepath + "Results/"
resending = "."+conf_type
opensmilepath = rworkspacepath+"Opensmile/opensmile-2.3.0/"
configpath = rworkspacepath+"Config/Opensmile/"
configfilename = masterconf + "_"+conf_type+".conf" 



def make_class_dict(wavs):
	act = open("activation","r")
	val = open("valence","r")
	actlines = act.readlines()
	vallines = val.readlines()
	dic1 = {}
	dic2 = {}
	for wav in wavs:
		if "wav" in wav:
			line = wav.split(".wav")[0]
			line = line.split("file")[1]
			linen = int(line) - 1 
			anumber = float(actlines[linen].split("\n")[0])
			vnumber = float(vallines[linen].split("\n")[0])
			#print anumber
			#print vnumber
			if (not anumber == 3.0):
				dic1[wav] = str(int(anumber>3.0))
			if (not vnumber == 3.0):
				dic2[wav] = str(int(vnumber>3.0)) 
	act.close()
	val.close()
	return (dic1,dic2)


def find_features(wavs,dic,train_or_test):
	k = 0
	for i in range(len(wavs)):
		if (wavs[i] in dic):
			inputpath = datapath + wavs[i]
			#print "Processing... " + inputpath
			resfilename = "features_" + masterconf + "_" + train_or_test
			resfilepath = respath + resfilename + resending

			command = "SMILExtract " + silentarg +" -C "+ configpath + \
						configfilename + " -I " + \
						inputpath + " -O " + resfilepath \
						+ " -classlabel " + dic[wavs[i]] \
						+ " -append " + str(int(k>0)) 

			#print "Result file path: "+resfilepath
			#print command + "\n\n\n"			
			os.system( command )
			print "Processing: " + str(k) + "/" + str(len(dic))
			k += 1
			'''
			if (i % 40 == 0):
				print '\x1b[2K\r',
				print "Processing: " + str(round(float((i+1)*100/len(wavs)),0)) + "%",
			'''

def split_random(wavs):
	trainset = random.sample(wavs, int(trainp * float(len(wavs)) ))
	testset = []
	for wav in wavs:
		if wav not in trainset:
			testset.append(wav)

	return (trainset,testset)
	

def main():
	wavs = os.listdir( datapath )

	(trainset,testset) = split_random(wavs)

	(dictact,dictval) = make_class_dict(trainset)	
	print "Activation Instances: " + str(len(dictact))
	print "Valence Instances: " + str(len(dictval))

	#print configfilename
	find_features(wavs,dictact,"act")
	find_features(wavs,dictval,"val")

main()