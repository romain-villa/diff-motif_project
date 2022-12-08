from collections import Counter 
from Bio import SeqIO
from random import sample
import sys

args=sys.argv[1:]

if("trash" in args[0]):
	exit()

file = open(args[0][:-6]+"_sampled_"+str(args[2])+".fasta", "w") 

with open(args[0]) as f:
	seqs = SeqIO.parse(f, "fasta")
	samps = ((seq.name, seq.seq) for seq in  sample(list(seqs),int(args[1])))
	for samp in samps:
		file.write(">{}\n{}".format(*samp))
		file.write("\n")

file.close()

