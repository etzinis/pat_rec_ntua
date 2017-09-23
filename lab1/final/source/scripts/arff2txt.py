
def convert(f_in, f_out):
	features = []
	labels = []
	for line in f_in.readlines():

		words = line.strip().split(",")
		
		if( (not line[0] == '@') and len(words) > 1):

			labels.append(int(round(float(words[-1]))))
			features.append(words[:-1])
		
	
	for i in xrange(len(features)):
		feature = features[i]
		label = labels[i]
		features_str = " ".join(map(lambda x: str(x), feature))

		f_out.write(str(label) + " " + features_str+"\n")

prefix = "6040"
prefix = "8020"

train_in = open("train2"+prefix+".arff")
train_out = open("train_smoothed2"+prefix+".txt", "w") 
convert(train_in, train_out)

test_in = open("test2"+prefix+".arff")
test_out = open("test_smoothed2"+prefix+".txt", "w") 
convert(test_in, test_out)
