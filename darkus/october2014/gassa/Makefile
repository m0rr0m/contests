N=4

all:
	gdc-4.8 -O2 -o solution solution.d

run:
	time (echo $N | ./solution > /dev/null)

check:
	echo $N | ./solution | ./n.pl > result$N
