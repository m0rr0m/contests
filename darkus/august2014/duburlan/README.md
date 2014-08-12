# Запуск и проверка результата:
    php RussianPost.php ../bigmatrix  | perl -ne '/Symbol (\d) at /; print $1; END {print "\n"}' > result
    diff result ../pi1000000.txt
