## Компиляция и запуск

    ghc -O2 --make -fforce-recomp RoS.hs
    ./RoS ../bigmatrix| ./sortdigits.pl > result
    diff result ../pi1000000.txt

## Запуск на машине с конфигурацией pc1.conf

    ➜ time ./RoS ../bigmatrix > /dev/null
    ./RoS ../bigmatrix > /dev/null  38189,72s user 2,88s system 99% cpu 10:37:07,31 total
