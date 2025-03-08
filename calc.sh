#! /usr/bin/bash

# store ANS and HIST
VAR_FILE="ANS.txt"
HIST_FILE="HIST.txt"

# func to get absolute value
abs() {
    echo $(echo "$1" | awk '{print ($1 < 0) ? -$1 : $1}')
}

# func to compare with 0
compareWZero(){
	num="$1"
	if (( $(echo "$num > 0" | bc -l) ))
	then
		echo 1
	elif (( $(echo "$num < 0" | bc -l) ))
	then
		echo 1
	else
		echo 0
	fi
}

# func to check integer
isNotInt() {
	local num="$1"
	if [[ "$num" =~ ^-?[0-9]+(\.0+)?$ ]]; then
		echo 0
	else
		echo 1
	fi
}

# func to check input format, no need check EXIT and HIST, it is checked already down there
validate_input(){
	local input="$1"

	# valid format: "<num1> <operator> <num2>"
	local regex='^([0-9]+([.][0-9]+)?|ANS) [-+x/%] ([0-9]+([.][0-9]+)?|ANS)$'

	if [[ "$input" =~ $regex ]]
	then
		return 0  # valid
	fi
	return 1 # invalid
}

# func to calculate the result based on operator (only check MATH ERROR bcs SYNTAX ERROR is checked above)
calculate(){
	# normalize number
	if [[ $(isNotInt "$1") == 0 ]]
	then
		num1=$(printf "%.0f" $1)
	else
		num1=$1
	fi
	if [[ $(isNotInt "$3") == 0 ]]
	then
		num2=$(printf "%.0f" $3)
	else
		num2=$2
	fi

	local operator=$2
	local result=0

	# test for math error (divide 0)
	if [[ "$operator" == "/" || "$operator" == "%" ]] && [[ $(compareWZero "$num2") == 0 ]]
	then
		echo "MATH ERROR"
		return 1
	fi

	# test for modulu with real num
	if [[ "$operator" == "%" ]] && [[ $(isNotInt "$num1") == 1 || $(isNotInt "$num2") == 1 ]]
	then
		echo "MATH ERROR"
		return 1
	fi

	# process based on operator
	case $operator in
		"+") result=$(echo "scale=2; $num1 + $num2" | bc);;
		"-") result=$(echo "scale=2; $num1 - $num2" | bc);;
		"x") result=$(echo "scale=2; $num1 * $num2" | bc);;
		"/") result=$(echo "scale=2; $num1 / $num2" | bc);;
		"%") result=$(( $num1 % $num2 ));;
	esac

	# eliminate the missing of zero of .xx when encounter 0.xx
	abs_result=$(abs "$result")
	if (( $(echo "$abs_result > 0 && $abs_result < 1" | bc -l) ))
	then
		result=$(printf "%.2f" $result)
	fi

	# echo result and return 0 (success)
	echo "$result"
	return 0
}

# func to save calculation to history
save_to_history() {
    local content="$1"
    echo "$content" >> "$HIST_FILE"

    # keep 5 lines only
    tail -n 5 "$HIST_FILE" > temp.txt && mv temp.txt "$HIST_FILE"
}

# main begin here

# check if var has been saved before
if [[ -f "$VAR_FILE" ]]; then
    ANS=$(cat "$VAR_FILE")  # read
else
    ANS=0  # if not, = 0
fi

# calculator
while true ; do
	# read input
	read -p ">> " input

	# check for special input
	if [[ "$input" == "EXIT" ]]
	then
		break
	fi
	if [[ "$input" == "HIST" ]]
	then
		# show last 5 history
		if [[ -s "$HIST_FILE" ]]
		then
            		cat "$HIST_FILE"
		else
			echo "No History"
		fi
		continue
	fi

	# check input format
	if ! validate_input "$input"
	then
		echo "SYNTAX ERROR"
		# wait to press any button
		read -n 1 -s -r

		# note: clear input buffer to ignore unexpected error
		read -r -d '' -t 0.1
		clear # here we clear display and move to next input
		continue
	fi

	# process normal input
	IFS=' ' read num1 operator num2 <<< $input

	# case enter ANS
	if [[ "$num1" == "ANS" ]]
	then
		num1=$ANS
	fi
	if [[ "$num2" == "ANS" ]]
	then
		num2=$ANS
	fi

	# do calculation
	output=$(calculate "$num1" "$operator" "$num2")

	# save if no error
	if [ $? -eq 0 ]
	then
		# save and update ANS
		ANS=$output
		echo "$ANS" > "$VAR_FILE" 

		# update history
		save_to_history "$input = $output"

		# check no exceed 5
		if [[ ${#fiveHistory[@]} -gt 5 ]]
		then
			# remove oldest element
			fiveHistory=("${fiveHistory[@]:1}")
		fi
	fi

	# print with carriage return (\r)
	echo -e "$output\r"

	# wait, clear 
	read -n 1 -s -r
	read -r -d '' -t 0.1
	clear
done