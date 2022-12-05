import sys
import os

def create(prefix,lines):
    with open(prefix[:-6]+'_'+which(lines)+".fasta",'a') as ipt:
        for i in range(len(lines)) :
            ipt.write(lines[i])

def which(lines):
    if 'Mammalia' in lines[0] :
        return 'mamm'
    if 'Eutheria' in lines[0]:
        return 'euth'
    if 'Theria' in lines[0]:
        return 'ther'
    if 'Amniota' in lines[0]:
        return 'amnt'
    if 'Tetrapoda' in lines[0]:
        return 'tetr'
    if 'Sarcopterygii' in lines[0]:
        return 'spgi'
    if 'Boreoeutheria' in lines[0]:
        return 'breu'
    return 'trash'
    
    
def main():
    args = sys.argv[1:]
    lines = []
    with open(args[0],'r',encoding='utf-8') as ipt :
        line = ipt.readline()
        while line != '':
            lines.append(line)
            line = ipt.readline()
            if '>' in line :
                create(args[0],lines)
                lines = []
            if line == '' :
                lines.append('\n')
                create(args[0],lines)
                break             
  
if __name__=="__main__":
    main()
