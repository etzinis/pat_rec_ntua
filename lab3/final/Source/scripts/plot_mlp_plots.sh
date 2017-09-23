echo "Plotting all MLP graphs..."
sourcedir="../mlp_plots/"
resultdir="../mlp_images/"
sourcefile="$(ls $sourcedir)"


for file in $sourcefile; do
	file_no_und="$( echo ${file} | sed 's/_/\ /g')" 

    gnuplot <<- EOF
        set xlabel "Learning Rate"
        set ylabel "Neurons in Layer"
        set title "${file_no_und}"  
        set key off 
        set term png
        set dgrid3d 4,10
		set hidden3d
        set output "${resultdir}${file}.png"
        splot "${sourcedir}${file}" using 1:2:3 with lines
EOF
done