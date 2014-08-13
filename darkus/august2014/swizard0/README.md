# Компиляция
    sbcl --no-userinit --load make.lisp

# Запуск и проверка результата:
    cat ../bigmatrix | ./pochta | perl -ne'/^;; found \[ (\d) \] @ \(\d+, \d+\)$/||die$_;print $1}{print"\n"' > result
    diff result ../pi1000000.txt

# Примеры запуска

## На тестовых данных:
    time cat ../bigmatrix | ./pochta > /dev/null
    cat ../bigmatrix  0,00s user 0,08s system 0% cpu 1:53,87 total
    ./pochta > /dev/null  107,33s user 6,82s system 99% cpu 1:54,21 total
    
## На 100gb мусора:
    head -c 107374182400 /dev/random | pv | ./pochta > /dev/null


## Результаты работы на машине с конфигурацией pc1.conf

    ➜ time cat ../bigmatrix | ./pochta > /dev/null
    cat ../bigmatrix  0,00s user 0,07s system 0% cpu 1:47,39 total
    ./pochta > /dev/null  104,29s user 3,31s system 99% cpu 1:47,70 total
    ➜ time cat ../bigmatrix | ./pochta > /dev/null
    cat ../bigmatrix  0,00s user 0,07s system 0% cpu 1:47,57 total
    ./pochta > /dev/null  104,56s user 3,22s system 99% cpu 1:47,89 total
    ➜ time cat ../bigmatrix | ./pochta > /dev/null
    cat ../bigmatrix  0,00s user 0,07s system 0% cpu 1:49,95 total
    ./pochta > /dev/null  107,09s user 3,05s system 99% cpu 1:50,26 total

    Максимальная потребляемая память около 93MB
