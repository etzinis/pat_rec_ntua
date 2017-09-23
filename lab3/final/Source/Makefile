WEKAPATH := "/home/thymios/weka-3-8-0/weka.jar"

full_run:
	make feature_preparation
	make steps_12_13_14
	make steps_15_16_17
	make opensmile_steps

feature_preparation:
	make prepare_features_matlab
	make extract_features_matlab
	make prepare_for_weka

steps_12_13_14:
	make weka_pca
	make weka_knn
	make weka_naive_bayes
	make graph_knn_bayes

steps_15_16_17:
	make wrapper_feature_selection
	make weka_mlp
	make weka_svm
	make weka_random_forest
	make final_diagrams

opensmile_steps:
	make extract_features_opensmile
	make validate_opensmile_model

prepare_features_matlab:
	matlab -nodisplay -nodesktop -r "run lab3_preparation.m; exit(0);"

extract_features_matlab:
	matlab -nodisplay -nodesktop -r "run lab3.m; exit(0);"	

prepare_features_for_weka:
	cd scripts; bash prepare_for_weka.sh

weka_knn:
	cd scripts; bash call_weka_knn.sh $(WEKAPATH)

weka_naive_bayes:
	cd scripts; bash call_weka_naive_bayes.sh $(WEKAPATH)

graph_knn_bayes:
	matlab -nodesktop -r "run make_graphs.m; exit(0);"	

weka_pca:
	cd scripts; bash pca.sh $(WEKAPATH)

weka_mlp:
	cd scripts; bash mlp_evaluate.sh $(WEKAPATH)

weka_svm:
	cd scripts; bash call_weka_svm.sh $(WEKAPATH)

weka_random_forest:
	cd scripts; bash call_weka_random_forest.sh $(WEKAPATH)

wrapper_feature_selection:
	cd scripts; bash wrapper_feature_select.sh $(WEKAPATH)

final_diagrams:
	cd scripts; python evaluation_step16_mlp_svm_randomforest.py

mlp_all_configurations_and_plot:
	mlp_all_configurations_wrapper
	mlp_all_configurations_no_wrapper
	mlp_all_configurations_find_best_and_prepare_plots
	mlp_all_configurations_plot

mlp_all_configurations_no_wrapper:
	cd scripts; bash mlp_all_configurations.sh $(WEKAPATH)

mlp_all_configurations_with_wrapper:
	cd scripts; bash mlp_all_configurations_wrapper.sh $(WEKAPATH)

mlp_all_configurations_find_best_and_prepare_plots:
	cd scripts; python mlp_select_best_configuration.py

mlp_all_configurations_plot:
	cd scripts; bash plot_mlp_plots.sh $(WEKAPATH)

extract_features_opensmile:
	make opensmile_emobase
	make opensmile_emobase2010

opensmile_emobase:
	cd opensmile_libsvm; 
	python extract_features_opensmile.py 1 silent libsvm emobase2010;
	sh call_svm.sh emobase

validate_opensmile_model:
	cd opensmile_libsvm; 
	python extract_features_opensmile.py 1 silent libsvm emobase;
	sh call_svm.sh emobase2010
