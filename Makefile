all:

run:
	time ./crypto0.py $N > /dev/null 2> time$N

check:
	./crypto0.py $N > result$N
