# Запуск и проверка результата:
    chmod u+x ./silentfl.erl
    ./silentfl.erl ../../bigmatrix 6001 4001 | perl -ne '/Digit (\d)/; print $1; END { print "\n" }' > result
    diff result ../../pi1000000.txt

## Результаты запуска на машине с конфигурацией pc1.conf

    ➜ time ./silentfl.erl ../../bigmatrix 6001 4001 > /dev/null 
    ./silentfl.erl ../../bigmatrix 6001 4001 > /dev/null  21997,84s user 2145,88s system 110% cpu 6:03:11,43 total

