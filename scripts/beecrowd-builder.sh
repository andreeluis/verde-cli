#!/bin/bash

BEECROWD_BASE_URL="https://www.beecrowd.com.br/repository/UOJ_"
SUPPORTED_LANGS=("Português" "English")
LANG=""
PROBLEM_ID=""
RANDOM_MAX_ID=3484

get_problem() {
	problem_url="${BEECROWD_BASE_URL}${PROBLEM_ID}${LANG}.html"
	local html=$(curl -s "$problem_url")

	problem_title=$(echo "$html" | htmlq --text 'title' | sed 's/bee //')

	problem_description=$(echo "$html" | htmlq --text '.description' | sed '/^\s*$/d' | sed 's/^\s*//g')
	problem_description_images=$(echo "$html" | htmlq -a 'src' '.description img')

	problem_input=$(echo "$html" | htmlq --text 'div.input' | sed '/^\s*$/d' | sed 's/^\s*//g')
	problem_output=$(echo "$html" | htmlq --text 'div.output' | sed '/^\s*$/d' | sed 's/^\s*//g')

	problem_test_cases=$(echo "$html" | htmlq 'table')
}

save_to_md() {
	mkdir -p $PROBLEM_ID
	local md_file="${PROBLEM_ID}/README.md"

	echo "# [$problem_title]($problem_url)" > $md_file
	echo "" >> $md_file
	echo "$problem_description" >> $md_file

	for img in $problem_description_images; do
		echo "" >> $md_file
		echo '<p align="center">' >> $md_file
		echo "  <img src='$problem_description_images' />" >> $md_file
		echo '</p>' >> $md_file
	done

	echo "" >> $md_file
	echo "> ### Input" >> $md_file
	echo "> $problem_input" >> $md_file
	echo "" >> $md_file
	echo "> ### Output" >> $md_file
	echo "> $problem_output" >> $md_file
}

save_test_cases() {
	mkdir -p $PROBLEM_ID
	local total_test_cases=$(echo "$problem_test_cases" | grep '<table>' | wc -l)

	for i in $(seq 1 $total_test_cases); do
		local test_case=$(echo "$problem_test_cases" | htmlq "table:nth-child($i)")

		local input=$(echo "$test_case" | htmlq --text "tbody td.division p" | sed '1{/^\s*$/d}; ${/^\s*$/d}')
		local output=$(echo "$test_case" | htmlq --text "tbody td:not(.division) p" | sed '1{/^\s*$/d}; ${/^\s*$/d}')

		echo "$input" > "${PROBLEM_ID}/pub${i}.in"
		echo "$output" > "${PROBLEM_ID}/pub${i}.out"
	done
}

random_problem() {
	PROBLEM_ID=$(shuf -i 1000-$RANDOM_MAX_ID -n 1)

	local resolved_problems=$(ls -d */ | grep -oE '[0-9]+' | sort -n)
	while [[ $resolved_problems == *$PROBLEM_ID* ]]; do
		PROBLEM_ID=$(shuf -i 1-$RANDOM_MAX_ID -n 1)
	done

	echo "🎲 Exercício aleatório selecionado: $PROBLEM_ID"
	echo ""
}

select_exercise() {
	read -p "Digite o ID do exercício que deseja baixar ou 0 para um exercício aleatório: " PROBLEM_ID

	if [ "$PROBLEM_ID" -eq 0 ]; then
		random_problem
	fi
}

select_language() {
	PS3="🌐 Em qual idioma deseja baixar o exercício? "
  select opt in "${SUPPORTED_LANGS[@]}"; do
    case $opt in
			"Português")
				LANG=""
				break
				;;
			"English")
				LANG="_en"
				break
				;;
			*)
				echo "Opção inválida. Por favor, tente novamente." >&2
		esac
  done
}

menu() {
  echo "Seja bem vindo ao Beecrowd Builder!"
	echo ""

	select_exercise
	select_language
	get_problem
	save_to_md
	save_test_cases

	echo "Exercício $PROBLEM_ID baixado com sucesso! ✅🎉"
}

# clear the screen
clear -x

menu