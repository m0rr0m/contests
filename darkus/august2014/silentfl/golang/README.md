# Компиляция

## Простая компиляция
    go build -o silentfl main.go

## Продвинутая компиляция (при наличии gccgo)
    gccgo -o silentfl -static -Ofast -march=native -g main.go

# Запуск и проверка результата:
    ./silentfl ../../bigmatrix 6001 4001 | perl -ne '/Digit (\d)/; print $1; END { print "\n" }' > result
    diff result ../../pi1000000.txt

# Примеры запуска

## Мое решение (простая компиляция)
    ../xtime ./silentfl ../../bigmatrix 6001 4001 > /dev/null
    7.32u 0.23s 7.57r 57532kB ./main ../../bigmatrix 6001 4001
    
## Решение maxim-komar (для сравнения)
    ../silentfl/xtime ./august ../bigmatrix 6001 4001 > /dev/null
    1.51u 0.03s 1.56r 23992kB ./august ../bigmatrix 6001 4001

## Запуск решения на машине с конфигурацией pc1.conf (простая компиляция)

    ➜ time ./silentfl ../../bigmatrix 6001 4001 > /dev/null    
    ./silentfl ../../bigmatrix 6001 4001 > /dev/null  4,80s user 0,13s system 99% cpu 4,945 total
    ➜ time ./silentfl ../../bigmatrix 6001 4001 > /dev/null
    ./silentfl ../../bigmatrix 6001 4001 > /dev/null  4,81s user 0,11s system 99% cpu 4,936 total
    ➜ time ./silentfl ../../bigmatrix 6001 4001 > /dev/null
    ./silentfl ../../bigmatrix 6001 4001 > /dev/null  4,79s user 0,13s system 99% cpu 4,929 total

    максимальная потребляемая память около 100MB


# Пути оптимизации
  * На небольших наборах данных (навроде bigmatrix) имеет смысл сделать "в лоб", отказавшись от каналов;
  * Разбор строк вынести в отдельные горутины
  * Скомпилировать с помощью gccgo
  * Переделать вывод, убрав сортировку результата

