# !/bin/bash

echo "Введите выражение для вычисления в строку без пробелов"

factorial() {
    if [ $1 -eq 0 ]; then
        echo 1
    else
        local i=$1
        local result=1
        while [ $i -gt 0 ]; do
            result=$(($result * $i))
            i=$(($i - 1))
        done
        echo $result
    fi
}