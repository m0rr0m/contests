Run & print:
```
lein trampoline run IN
```

## Запуск на машине с конфигурацией pc1.conf

    ➜ time lein trampoline run ../bigmatrix > /dev/null 
    lein trampoline run ../bigmatrix > /dev/null  95,79s user 0,54s system 106% cpu 1:30,28 total
    ➜ time lein trampoline run ../bigmatrix > /dev/null
    lein trampoline run ../bigmatrix > /dev/null  95,65s user 0,61s system 106% cpu 1:30,69 total
    ➜ time lein trampoline run ../bigmatrix > /dev/null
    lein trampoline run ../bigmatrix > /dev/null  93,95s user 0,48s system 106% cpu 1:28,46 total

    Максимальное потребление памяти около 921MB
