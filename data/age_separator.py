import sys

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
    cpt = 0
    with open(args[0],'r',encoding='utf-8') as ipt :
        line = ipt.readline()
        while line : #!= ''
            lines.append(line)
            line = ipt.readline()
            if '>' in line :
                cpt=cpt+1
                create(args[0],lines)
                lines = []
                if cpt%10000 == 0:
                    print(str(cpt)+" treated sequences.")
            if line == '' :
                lines.append('\n')
                create(args[0],lines)
                break
    print("Total sequences : "+str(cpt+1))
       
  
if __name__=="__main__":
    main()