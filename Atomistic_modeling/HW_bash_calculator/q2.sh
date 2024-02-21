# !/bin/bash
echo "Введите выражение для вычисления.
Поддерживаются такие операции как:
\"+, -, *, /, ().\"
Операции производятся как с типом int, так и float.
Например, (1+100.1)/10-5*2.2
Чтобы выйти из приложения, введите: exit.
"

# export BC_ENV_ARGS="fac.bc $HOME/.config/.bcrc"
export BC_ENV_ARGS="fac.bc $HOME/.config/.bcrc"

while read input_string; do
	if [[ $input_string =~ ^"exit" ]] ;then
		break
	fi

bc -l <<< "$input_string"

done