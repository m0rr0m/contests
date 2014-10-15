all:
	ghc -O2 -fforce-recomp --make solution.hs

run:
	time ./solution $N > /dev/null 2> time$N

check:
	./solution $N | ./n.pl > result$N
