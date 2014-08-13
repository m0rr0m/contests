## Компиляция и запуск

    ghc -O2 --make -fforce-recomp RoS.hs
    ./RoS ../bigmatrix| ./sortdigits.pl > result
    diff result ../pi1000000.txt

## Запуск на машине с конфигурацией pc1.conf
