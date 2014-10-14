all:
	ghc -O2 -fforce-recomp --make RotatingKey.hs Solution.hs

run:
	time ./Solution $N > /dev/null 2> time$N

check:
	./Solution $N | ./n.pl > result$N
