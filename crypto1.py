#! python3
#WARNING! Wrote under windows. Not tested on linux.
#dict - matrix storage
d={}
import sys
N=int(sys.argv[1])
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
		d4=(deep+1)%2
		for phi in range(4):
			if d4==1:
				d[deep]=(d[deep][1],N-1-d[deep][0])
			for z in seq_turn(deep+1):
				yield z
			if d4==0:
				d[deep]=(d[deep][1],N-1-d[deep][0])

#Optimized(?) checking matrix wholeness
def check(m):
	for i in range(N2):
		for j in range(N2):
			q0=i*N2+j
			if i==N2-1:
				qr=(j*N2+N2-1)
			else:
				qr=((i+1)*N2+j)
			if j==N2-1:
				qd=((N2-1)*N2+i)
			else:
				qd=(i*N2+j+1)
			if abs(m[q0][0]-m[qr][0])+abs(m[q0][1]-m[qr][1])==1:
				return 1
			if abs(m[q0][0]-m[qd][0])+abs(m[q0][1]-m[qd][1])==1:
				return 1
	return 0

#Simple output matrix
def prettyp(m):
	p("+"*(N+2)+'\n')
	for i in range(N):
		p("+")
		for j in range(N):
			if (i,j) in m.values():
				p("*")
			else:
				p(" ")
		p('+\n')
	p("+"*(N+2)+"\n\n")

#Matrix uniq config counter
und_cnt=0
ald_cnt=0
#Init iterator
qq=seq_turn(1)

#Loop the iterator values
for m in qq:
	ald_cnt+=1
	if check(m)==0:
		und_cnt+=1
		prettyp(m)
#Output Matrix uniq config counter value
p(und_cnt)
