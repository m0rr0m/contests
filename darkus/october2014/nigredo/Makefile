all:
	ghc -O2 -fforce-recomp --make solution.hs

run:
	echo $N | time ./solution > /dev/null 2> time$N

check:
	echo $N | ./solution | ./n.pl > result$N
