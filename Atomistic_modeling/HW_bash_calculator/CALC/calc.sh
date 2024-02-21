# !/bin/bash
echo "Введите выражение для вычисления.

Поддерживаются такие операции как:
\"+, -, *, /, ()\", а также функции fact_c(), fact_r() (вычисление факториала циклом и рекурсивно соотв.) и fibo()

Операции производятся как с типом int, так и float.
Например, (1+100.1)/10-5*2.2
Чтобы выйти из приложения, введите: exit.
"

while read input_string; do
	if [[ $input_string =~ ^"exit" ]] ;then
		break
	fi

# bc -l functions.bc <<< "$input_string"
printf '%.16f\n' $(bc -l functions.bc <<< "$input_string")

done