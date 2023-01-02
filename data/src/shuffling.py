import sys
from ushuffle import shuffle, Shuffler
#https://pypi.org/project/ushuffle/

# retrieving program arguments from terminal
args = sys.argv[1:]

# returning sequence with a fasta format with 50 nt/line
def newline(string):
    newstr = list(string)
    cpt=0
    for i in range(len(string)):
        if ((i+1)%50==0):
            cpt=cpt+1
            newstr.insert(i+cpt,'\n')
    newstr.append('\n')
    return ''.join(newstr)

# adding SHUFFLED to the CNE header after sequence id
def modif(line):
    line = line.split(' ',1)
    return line[0]+"\tSHUFFLED\n"

# returning shuffled input sequence using uShuffle library
def shuffle_loc(seq):
    shuffler = Shuffler(seq, 2)
    res = shuffler.shuffle()
    return res.decode('utf-8')

# computing shuffling for all input file
with open(args[0], 'r', encoding='utf-8') as ipt, open(args[0][:-6]+"_shuffled.fasta",'w') as otp:
    seq = ''
    for line in ipt:
        if '>' in line :
            if seq:
                otp.write(newline(shuffle_loc(seq.encode('utf-8'))))
            otp.write(modif(line))
            seq = ''
        else :
            seq = seq+line.strip()
    otp.write(newline(shuffle_loc(seq.encode('utf-8'))))
