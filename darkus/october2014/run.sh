#!/bin/sh

export N=4
for i in `find . -maxdepth 1 -type d | grep -v '^.$'`; do
    echo $i
    cd $i
    make
    make check
    make run
    cd ..
done

export N=6
for i in `find . -maxdepth 1 -type d | grep -v '^.$' | grep -v darkus`; do
    echo $i
    cd $i
    make
    make check
    make run
    cd ..
done
