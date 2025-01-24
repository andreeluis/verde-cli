#!/bin/bash

BEECROWD_BASE_URL="https://www.beecrowd.com.br/repository/UOJ_"
SUPPORTED_LANGS=("Português" "English")
LANG=""
PROBLEM_ID=""

get_problem() {
	problem_url="${BEECROWD_BASE_URL}${PROBLEM_ID}${LANG}.html"
	local html=$(curl -s "$problem_url")

	problem_title=$(echo "$html" | htmlq --text 'title' | sed 's/bee //')

	problem_description=$(echo "$html" | htmlq --text '.description' | sed '/^\s*$/d' | sed 's/^\s*//g')
	problem_description_images=$(echo "$html" | htmlq -a 'src' '.description img')

	problem_input=$(echo "$html" | htmlq --text 'div.input' | sed '/^\s*$/d' | sed 's/^\s*//g')
	problem_output=$(echo "$html" | htmlq --text 'div.output' | sed '/^\s*$/d' | sed 's/^\s*//g')
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

select_exercise() {
	read -p "Digite o ID do exercício que deseja baixar: " PROBLEM_ID
}

select_language() {
	PS3="Em qual idioma deseja baixar o exercício? "
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

	echo "Exercício $PROBLEM_ID baixado com sucesso!"
}

# clear the screen
clear -x

menu