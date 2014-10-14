N=4

all:
	ghc -O2 -fforce-recomp --make RotatingKey.hs Solution.hs

run:
	time ./Solution $N > /dev/null

check:
	./Solution $N | ./n.pl > result$N
