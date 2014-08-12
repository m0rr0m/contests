# Запуск и проверка результата:
    echo $(./pochta-rossii.erl ../bigmatrix | awk '{print $1}' ORS='') > result
    diff result ../pi1000000.txt

# Примеры запуска

## На моем рабочем компьютере:
    ➜ time ./pochta-rossii.erl ../bigmatrix > /dev/null
      real    1m1.799s
      user    0m58.290s
      sys     0m3.638s