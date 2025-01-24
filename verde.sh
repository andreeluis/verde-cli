#!/bin/bash -eu

DIR=$(readlink $(which verde) | xargs dirname)
SCRIPTS_DIR="$DIR/scripts"
SUPPORTED_LANGUAGES=("c" "cpp" "java")
CODE_FILE=""
CODE_LANGUAGE=""
TEST_CASES=()

# get source code file
get_source_code() {
  local code_files=()

  for language in "${SUPPORTED_LANGUAGES[@]}"; do
    for file in *."$language"; do
      if [ -f "$file" ]; then
        code_files+=("$file")
      fi
    done
  done

  if [ ${#code_files[@]} -eq 0 ]; then
    echo "Nenhum arquivo de código-fonte encontrado" >&2
    exit 1
  elif [ ${#code_files[@]} -eq 1 ]; then
    CODE_FILE="${code_files[0]}"
  else
    PS3="Selecione um arquivo de código-fonte (1-${#code_files[@]}): "
    select file in "${code_files[@]}"; do
      if [ -n "$file" ]; then
        CODE_FILE="$file"
        break
      else
        echo "Opção inválida. Por favor, tente novamente." >&2
      fi
    done
  fi

  CODE_LANGUAGE="${CODE_FILE##*.}"
}

# get test cases files (.in and .out)
get_test_cases() {
  for file in *.in; do
    if [ -f "$file" -a -f "${file%.*}.out" ]; then
      TEST_CASES+=("${file%.*}")
    fi
  done

  if [ ${#TEST_CASES[@]} -eq 0 ]; then
    echo "Nenhum caso de teste encontrado" >&2
    exit 1
  fi
}

# compare two files and show differences
get_files_diff() {
  local file1=$1
  local file2=$2

  # get number of lines of each file
  local lines_arq1=$(wc -l < "$file1")
  local lines_arq2=$(wc -l < "$file2")

  # get number of different lines
  local diff_lines=$(git diff --ignore-cr-at-eol --no-index --stat "$file1" "$file2" | tail -1 | awk '{print $4}')

  # check if files are equal or different
  if [ -z "$diff_lines" ]; then
    echo -e "$(tput setaf 3)$(tput bold)\n Nota: 100% \U0001F389 \n$(tput sgr0)"
  else
    # calculate difference percentage
    local diff_perc=$(awk "BEGIN { printf \"%.2f\", ($diff_lines / ($lines_arq1 + $lines_arq2)) * 100 }")

    # calculate equality percentage
    local equal_perc=$(awk "BEGIN { printf \"%.2f\", 100 - $diff_perc }")

    # show equality percentage
    echo -e "$(tput setaf 3)$(tput bold)\n Nota: $equal_perc%$(tput sgr0)\n"

    # show different lines
    echo -e "$(tput setaf 1)$(tput bold) \U000026A0 Diferenças:$(tput sgr0)"

    git diff --ignore-cr-at-eol --no-index --line-prefix="  " --word-diff=color -U0 --color=always "$file1" "$file2" | tail -n +5
    echo
  fi
}

# compile code
compile() {
  case $CODE_LANGUAGE in
    "java")
			find . -name "*.class" -delete
      javac "$CODE_FILE"
      ;;
    "c")
      gcc -o "${CODE_FILE%.*}" "$CODE_FILE"
      ;;
    "cpp")
      g++ -o "${CODE_FILE%.*}" "$CODE_FILE"
      ;;
    *)
      echo "Linguagem não suportada" >&2
      exit 1
      ;;
  esac
}

# execute code
execute() {
  case $CODE_LANGUAGE in
    "java")
      java "${CODE_FILE%.*}"
    ;;
    "c")
      ./"${CODE_FILE%.*}"
    ;;
    "cpp")
      ./"${CODE_FILE%.*}"
    ;;
    *)
      echo "Linguagem não suportada" >&2
      exit 1
      ;;
  esac
}

# test code with all test cases
test_code() {
  get_test_cases

  for test_case in "${TEST_CASES[@]}"; do
    case $CODE_LANGUAGE in
      "java")
        java "${CODE_FILE%.*}" < "$test_case.in" > "$test_case.res.out"
        ;;
      "c")
        ./"${CODE_FILE%.*}" < "$test_case.in" > "$test_case.res.out"
        ;;
      "cpp")
        ./"${CODE_FILE%.*}" < "$test_case.in" > "$test_case.res.out"
        ;;
      *)
        echo "Linguagem não suportada" >&2
        exit 1
        ;;
    esac

    echo -e "$(tput setaf 6)$(tput bold)> Caso de teste: $(tput smul)$test_case.in$(tput sgr0)"

    get_files_diff "$test_case.res.out" "$test_case.out"
  done
}

# compile and execute code
compile_and_execute() {
  get_source_code

  compile
  execute
}

# compile, execute and test code
execute_tests() {
  get_source_code

  compile
  test_code
}

# menu options
menu() {
  echo "Bem-vindo ao Verde CLI!"

  PS3="Selecione a opção desejada: "
  select opt in "Compilar e executar código" "Executar casos de teste" "TP Builder" "Beecrowd Builder"; do
    case $opt in
      "Compilar e executar código")
        compile_and_execute
        break
        ;;
      "Executar casos de teste")
        execute_tests
        break
        ;;
      "TP Builder")
        bash "$SCRIPTS_DIR/tp-builder.sh"
        exit 0
        ;;
			"Beecrowd Builder")
				bash "$SCRIPTS_DIR/beecrowd-builder.sh"
				exit 0
				;;
      *)
        echo "Opção inválida!"
        exit 1
        ;;
    esac
  done
}

builders_menu() {
	echo "Bem-vindo ao Verde CLI!"

	PS3="Selecione o builder que deseja utilizar: "
	select opt in "TP Builder" "Beecrowd Builder"; do
		case $opt in
			"TP Builder")
				bash "$SCRIPTS_DIR/tp-builder.sh"
				exit 0
				;;
			"Beecrowd Builder")
				bash "$SCRIPTS_DIR/beecrowd-builder.sh"
				exit 0
				;;
			*)
				echo "Opção inválida!"
				exit 1
				;;
		esac
	done
}

# clear screen
clear -x

# process flags
while getopts 'hctb' opt; do
  case $opt in
    c)
      compile_and_execute
      exit 0
      ;;
    t)
      execute_tests
      exit 0
      ;;
    b)
      builders_menu
      exit 0
      ;;
    *)
      echo "Uso: verde [OPÇÃO]"
      echo "Opções:"
      echo "  -h  Mostra esta mensagem de ajuda"
      echo "  -c  Compila e executa seu código"
      echo "  -t  Executa os casos de teste"
      echo "  -b  Menu do Beecrowd Builder e TP Builder"

      exit 0
      ;;
  esac
done

# show menu if no flag is passed
if [ $OPTIND -eq 1 ]; then
  menu
fi