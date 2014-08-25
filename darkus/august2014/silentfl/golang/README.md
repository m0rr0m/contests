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

# Пути оптимизации
  * На небольших наборах данных (навроде bigmatrix) имеет смысл сделать "в лоб", отказавшись от каналов;
  * Разбор строк вынести в отдельные горутины
  * Скомпилировать с помощью gccgo
  * Переделать вывод, убрав сортировку результата

