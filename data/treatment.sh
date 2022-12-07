#!/bin/bash


#echo "Make sure the program age_separator.py is in the WD."

if [ -d "$PWD/data_by_age" ];
then
rm -r data_by_age
mkdir data_by_age
else
mkdir data_by_age
fi

shopt -s extglob

# ordering data by age 
order(){
	echo "Name of the fasta file (raw data) :"
	read filename
	echo "Ordering data..."
	python3 age_separator.py $filename
	mv !("$filename"|!(*".fasta")) data_by_age/
}

order