# Запуск и проверка результата:
    php RussianPost.php ../bigmatrix  | perl -ne '/Symbol (\d) at /; print $1; END {print "\n"}' > result
    diff result ../pi1000000.txt


# Запуск для pc1.conf

    ➜ time php RussianPost.php ../bigmatrix > /dev/null                                                         
    php RussianPost.php ../bigmatrix > /dev/null  105,17s user 0,90s system 99% cpu 1:46,18 total
    ➜ time php RussianPost.php ../bigmatrix > /dev/null
    php RussianPost.php ../bigmatrix > /dev/null  106,45s user 1,00s system 99% cpu 1:47,55 total
    ➜ time php RussianPost.php ../bigmatrix > /dev/null
    php RussianPost.php ../bigmatrix > /dev/null  105,22s user 0,89s system 99% cpu 1:46,21 total

    Потребляемая память примерно в пике 2.577GiB =~ 4687MB
