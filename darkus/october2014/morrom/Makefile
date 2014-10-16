all:
	

run:
	echo $N | time ./crypto0.py > /dev/null 2> time$N

check:
	echo $N | ./crypto0.py | ./n.pl > result$N
