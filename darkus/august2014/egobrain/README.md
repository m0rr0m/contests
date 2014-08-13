# Запуск и проверка результата:
    echo $(./pochta-rossii.erl ../bigmatrix | awk '{print $1}' ORS='') > result
    diff result ../pi1000000.txt

# Примеры запуска

## На моем рабочем компьютере:
    ➜ time ./pochta-rossii.erl ../bigmatrix > /dev/null
      real    1m1.799s
      user    0m58.290s
      sys     0m3.638s

## Результаты запуска на компьютере с конфигурацией pc1.conf

    ➜ time ./pochta-rossii.erl ../bigmatrix > /dev/null  
    ./pochta-rossii.erl ../bigmatrix > /dev/null  24,72s user 1,02s system 105% cpu 24,371 total
    ➜ time ./pochta-rossii.erl ../bigmatrix > /dev/null 
    ./pochta-rossii.erl ../bigmatrix > /dev/null  24,62s user 1,05s system 105% cpu 24,323 total
    ➜ time ./pochta-rossii.erl ../bigmatrix > /dev/null 
    ./pochta-rossii.erl ../bigmatrix > /dev/null  24,73s user 1,18s system 105% cpu 24,475 total

    Потребляемая память около 32MB
