all:
	gdc-4.8 -O2 -o solution solution.d

run:
	echo $N | time ./solution > /dev/null 2> time$N

check:
	echo $N | ./solution | ./n.pl > result$N
