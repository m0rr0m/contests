#dict - matrix storage
d={}
N=int(input('N?'))
print(N)
if N<=0:
	exit()
if N%2!=0:
	exit()
N2=N//2
N22=N2**2
#init dict
for i in range(N2):
	for j in range(N2):
		d[i*N2+j]=(i,j)
#def simple print
def p(*x):
	print(*x, sep='', end='')

#def generator 
def seq_turn(deep):
	if deep>=N22:
		yield d
	else:
		for phi in range(4):
			d[deep]=(d[deep][1],N-1-d[deep][0])
			for z in seq_turn(deep+1):
				yield z
#Matrix uniq config counter
und_cnt=0

#Init iterator
qq=seq_turn(1)

#Loop the iterator values
for m in qq:
	divided=0
#Simple checking matrix wholeness
	for i in range(N22):
		for j in range(i+1,N22):
			if abs(d[i][0]-d[j][0])+abs(d[i][1]-d[j][1])==1:
				divided=1
				break
		if divided==1:
			break
#Simple output solid matrix
	if divided==0:
		und_cnt+=1
		p("+"*(N+2)+'\n')
		for i in range(N):
			p("+")
			for j in range(N):
				if (i,j) in d.values():
					p("*")
				else:
					p(" ")
			p('+\n')
		p("+"*(N+2)+"\n\n")

#Output Matrix uniq config counter value
p(und_cnt)
