from collections import defaultdict

# function to write matrix dictionnary motif/family
def wfile(d):
	with open('tf_family.txt','w', encoding='utf-8') as otp:
		for i in d:
			for j in i:
				otp.write(j+'\t')
			otp.write('\n')

# navigate the file to retrieve family data and TF name, store data in a dictionnary
with open("JASPAR2022_CORE_vertebrates_non-redundant_pfms_transfac.txt",'r') as ipt:
	line = ' '
	dic = {}
	nb = 0
	while line:
		line = ipt.readline()
		if 'ID' in line :
			nb=nb+1
			name = line.split()[1]
			while 'tf_family' not in line:
				line = ipt.readline()
			fam = line.split(':')[1][:-1]
			if ';' in fam:
				fam = fam.split(';')[1]
			if (fam and fam[0] == ' '):
				fam = fam[1:]
		else :
			continue
		dic[name] = fam
		sorted_dic = sorted(dic.items(), key=lambda x:x[1])

wfile(sorted_dic)