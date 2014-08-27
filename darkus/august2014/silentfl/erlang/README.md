# Запуск и проверка результата:
    chmod u+x ./silentfl.erl
    ./silentfl.erl ../../bigmatrix 6001 4001 | perl -ne '/Digit (\d)/; print $1; END { print "\n" }' > result
    diff result ../../pi1000000.txt
