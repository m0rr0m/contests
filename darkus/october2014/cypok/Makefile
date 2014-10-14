N=4

all:
	gcc -std=c99 -O2 -o solution solution.c

run:
	time ./solution $N > /dev/null

check:
	./solution $N | ./n.pl > result$N
