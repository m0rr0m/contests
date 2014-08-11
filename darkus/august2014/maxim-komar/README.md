# Компиляция
    gcc -O2 august.c -o august

# Запуск и проверка результата:
    ./august ../bigmatrix 6001 4001 | perl -ne '/Digit (\d)/; print $1; END { print "\n" }' > result
    diff result ../pi1000000.txt

# Примеры запуска

## На моем рабочем компьютере (gcc 4.7.3, Intel Core i3-4130):
    ➜ time ./august ../bigmatrix 6001 4001 > /dev/null 
    ./august ../bigmatrix 6001 4001 > /dev/null  0,59s user 0,01s system 99% cpu 0,605 total
    ➜ time ./august ../bigmatrix 6001 4001 > /dev/null
    ./august ../bigmatrix 6001 4001 > /dev/null  0,60s user 0,00s system 98% cpu 0,607 total
    ➜ time ./august ../bigmatrix 6001 4001 > /dev/null
    ./august ../bigmatrix 6001 4001 > /dev/null  0,59s user 0,01s system 98% cpu 0,609 total

## Минимальный инстанс digitalocean (512MB):
    ➜  time ./august ../bigmatrix 6001 4001 > /dev/null                                                     
    ./august ../bigmatrix 6001 4001 > /dev/null  1.70s user 0.01s system 99% cpu 1.708 total
    ➜  time ./august ../bigmatrix 6001 4001 > /dev/null
    ./august ../bigmatrix 6001 4001 > /dev/null  1.69s user 0.03s system 99% cpu 1.724 total
    ➜  time ./august ../bigmatrix 6001 4001 > /dev/null
    ./august ../bigmatrix 6001 4001 > /dev/null  1.74s user 0.02s system 99% cpu 1.768 total
