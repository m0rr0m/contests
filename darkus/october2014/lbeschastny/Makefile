all:
	
run:
	time lein run $N > /dev/null 2> time$N

check:
	lein run $N | ./n.pl > result$N
