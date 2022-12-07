#!/bin/bash


#echo "Make sure the program age_separator.py is in the WD."

shopt -s extglob

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


PS3='Choose the desired mode : '
mode=("Ordering by age" "Sampling data" "Quit")
select mde in "${mode[@]}"; do
    case $mde in
        "Ordering by age")
            order
			break
            ;;
        "Sampling data")
			if [ ! -d "$PWD/data_by_age" ]; then
			echo "Error : data is not ordered by age"
			exit
			fi	
            ## sampling
			break
            ;;
		"Quit")
	    	echo "User requested exit"
	    	exit
	    	;;
        *) echo "Invalid option";;
    esac
done