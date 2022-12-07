#!/bin/bash


#echo "Make sure the program age_separator.py is in the WD.blblblblblbl"

shopt -s eglob

# ordering data by age 
order(){
	if [ -d "$PWD/data_by_age" ];
	then
	rm -r data_by_age
	mkdir data_by_age
	else
	mkdir data_by_age
	fi
	echo "Name of the fasta file (raw data) :"
	read filename
	echo "Ordering data..."
	python3 age_separator.py $filename
	mv !("$filename"|!(*".fasta")) data_by_age/
}

sampling(){
	i=$1
	spl=$2
	for file in $PWD/data_by_age/*
	do
		python3 sampling.py $file $spl
	done
	mv data_by_age/*"sampled.fasta" data_by_age_sampled/batch_${i}
}

verif_dir(){
	if [ ! -d "$PWD/data_by_age" ]; then
	echo "Error : data is not ordered by age"
	exit
	fi
	if [ -d "$PWD/data_by_age_sampled" ]; then
	rm -r data_by_age_sampled
	mkdir data_by_age_sampled
	else
	mkdir data_by_age_sampled
	fi
}


PS3='Choose the desired mode : '
mode=("Ordering by age" "Sampling data" "Quit")
select mde in "${mode[@]}"; do
    case $mde in
        "Ordering by age")
            order
			break
            ;;
        "Sampling data")
			verif_dir
			echo "How many batches?"
			read nb_i
			echo "How many sample?"
			read spl
			for ((i=0; i<nb_i; i++))
			do
  				mkdir data_by_age_sampled/batch_${i}
				sampling $i $spl
			done
			break
            ;;
		"Quit")
	    	echo "User requested exit"
	    	exit
	    	;;
        *) echo "Invalid option";;
    esac
done
