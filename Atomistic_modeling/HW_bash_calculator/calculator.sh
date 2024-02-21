# !/bin/bash

set -f

function lower_precedence() {
	local o_1="${1}" 
	local o_2="${2}" 

	array_1=( '+', '*', '!')
	array_2=( '-', '/',)

	index_1=-1
	index_2=-1

	for (( j=0; j<${#array_1[@]}; j++ ));
	do
		if [[ "${array_1[$j]}" =~ "$o_1" ]];then
			index_1=$j
		fi

		if [[ "${array_1[$j]}" =~ "$o_2" ]];then
			index_2=$j
		fi
	done

	for (( j=0; j<${#array_2[@]}; j++ ));
	do
		if [[ "${array_2[$j]}" =~ "$o_1" ]];then
			index_1=$j
		fi

		if [[ "${array_2[$j]}" =~ "$o_2" ]];then
			index_2=$j
		fi
	done

	if (( $index_1 < $index_2 ));then
		echo 1
	fi
	
	echo 0
}


function factorial_recursive() {
	local num="${1}" 
    	if (( $num <= 1 )); then
      	echo 1
    	else
      	last=$(factorial_recursive $(( $num - 1 )))
      	echo $(( $num * last ))
    	fi
}


function factorial_cycle() {
	local num="${1}" 
    	if (( $num <= 1 )); then
      	echo 1
    	else
		res=1
		for (( j=2; j<=$num; j++ ));
		do
      		res=$(( $res * $j ))
    		done
		echo $res
	fi
}


# 1. Split expression str to array of numbers and operands 
# 2. Convert to RPN 
# 3. Calculate RPN


#TEST
#msg="(1+3)-4*6!*9/60.056"
#msg="3+4*2/(5-1)!*9"
#msg="1+3"


echo "Enter your expression without spaces between the symbols. 
For example, \"(1+3)-4*6!*9/60.056\".
To leave an application use the command \"exit()\"."

while read msg; do # чтение файла построчно
	if [[ $msg =~ ^"exit()" ]] ;then
		break
	fi

out=( $(grep -Eo "(?:[[:digit:]]\.*)+|[^[:digit:]]" <<< "$msg") )

length=${#out[@]}
re_number='[[:digit:]]+\.*[[:digit:]]*'
re_operator='\+|\-|\*|\/|!'

output_queue=()
operator_stack=()
for (( j=0; j<${length}; j++ ));
do
	if [[ ${out[$j]} =~ $re_number ]]; then
		output_queue+=(${out[$j]})
	fi

	if [[ ${out[$j]} =~ $re_operator ]]; then
		while :
		do
			operator_length=${#operator_stack[@]}
			if [[ $operator_length == 0 ]];then
				break
			fi
			satisfied="false"
			o_2=${operator_stack[$operator_length-1]}
			if ! [[ "$o_2" =~ ^'('  || "$o_2" =~ ^')' ]]; then
				var="$(lower_precedence "$o_2" "${out[$j]}")"
				if [[ $var == 0 ]]; then
					satisfied="true"	
				fi
			fi
			#echo "${satisfied}"
			if ! [[ "${satisfied}" =~ "true" ]];then
				break
			fi	

			output_queue+=($o_2)
			unset 'operator_stack[${#operator_stack[@]}-1]'
				
		done
		operator_stack+=(${out[$j]})
		
	fi

	if [[ "${out[$j]}" =~ ^'(' ]]; then
		operator_stack+=(${out[$j]})
	fi

	if [[ "${out[$j]}" =~ ^')' ]]; then 
		while :
		do
			operator_length=${#operator_stack[@]}
			if (( $operator_length == 0 ));then
				break
			fi

			o_2=${operator_stack[$operator_length-1]}
			if  [[ "$o_2" =~ ^'(' ]];then
				break
			fi

			output_queue+=($o_2)
			unset 'operator_stack[${#operator_stack[@]}-1]'	
			
			operator_length=${#operator_stack[@]}
			o_2=${operator_stack[$operator_length-1]}
			
	done

		if [[ $operator_length != 0 &&  "$o_2" =~ ^'(' ]]
		then
			unset 'operator_stack[${#operator_stack[@]}-1]'		
		fi
	fi
done

operator_length=${#operator_stack[@]}
for (( j=0; j<${operator_length}; j++ ));
do
	output_queue+=(${operator_stack[$operator_length-j-1]})
done	

final_stack=()
for (( j=0; j<${#output_queue[@]}; j++ ));
do
	if [[ ${output_queue[$j]} =~ $re_number ]]; then
		final_stack+=(${output_queue[$j]})
	elif [[ ${output_queue[$j]} =~ ^'!' ]]; then
		n=${final_stack[${#final_stack[@]}-1]}
		unset 'final_stack[${#final_stack[@]}-1]'
		final_stack+=($(factorial_recursive $n))
		
	else
		n1=${final_stack[${#final_stack[@]}-1]}
		unset 'final_stack[${#final_stack[@]}-1]'

		n2=${final_stack[${#final_stack[@]}-1]}
		unset 'final_stack[${#final_stack[@]}-1]'

		if [[ "${output_queue[$j]}" =~ ^'+' ]];then
			final_stack+=($(awk '{print $1+$2}' <<<"${n2} ${n1}"))

		elif [[ "${output_queue[$j]}" =~ ^'-' ]];then
			final_stack+=($(awk '{print $1-$2}' <<<"${n2} ${n1}"))

		elif [[ "${output_queue[$j]}" =~ ^'*' ]];then
			final_stack+=($(awk '{print $1*$2}' <<<"${n2} ${n1}"))

		elif [[ "${output_queue[$j]}" =~ ^'/' ]];then
			final_stack+=($(awk '{print $1/$2}' <<<"${n2} ${n1}"))
		fi		
	
	fi
done	

echo "${final_stack[0]}"

done






