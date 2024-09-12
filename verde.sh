#!/bin/bash -eu

# Script para correção automática de exercícios de programação
# Recebe parametros:
#   -t : flag para teste automático (pub.in e pub.out necessários)

DIR=$(readlink $(which verde) | xargs dirname)
SUP_LANGS=(java c cpp)
CODE_FILES=()
CODE_FILE=""
CODE_LANG=""
TEST_FLAG=0
COMPILE_FLAG=0

# Processar as flags
while getopts 'ct' opt; do
  case $opt in
    c) COMPILE_FLAG=1 ;;
    t) TEST_FLAG=1 ;;
    *) printf "Uso: %s [-c -t]\n" "$0" 1>&2; exit 1 ;;
  esac
done

# Se nenhuma flag foi passada, executar o script grafite.sh
if [ $OPTIND -eq 1 ]; then
  # Escolher o que executar
  PS3="Selecione a opção desejada: "
  select opt in "Executar código" "Corrigir exercício" "TP Builder"; do
    case $opt in
      "Executar código")
        COMPILE_FLAG=1
        break
        ;;
      "Corrigir exercício")
        TEST_FLAG=1
        break
        ;;
      "TP Builder")
        bash $DIR/grafite/grafite.sh
        exit 0
        ;;
      *)
        echo "Opção inválida. Por favor, tente novamente." >&2
        ;;
    esac
  done
fi


for lang in "${SUP_LANGS[@]}"; do
  # Usar globbing para encontrar arquivos com a extensão atual da iteração
  for file in *."$lang"; do
    # Verificar se o arquivo realmente existe (necessário caso não haja arquivos para uma das extensões)
    if [ -f "$file" ]; then
      CODE_FILES+=("$file")
    fi
  done
done

if [ ${#CODE_FILES[@]} -eq 0 ]; then
  # Se nenhum arquivo foi encontrado, exibir uma mensagem de erro e sair
  echo "Nenhum arquivo de código-fonte encontrado" >&2
  exit 1
elif [ ${#CODE_FILES[@]} -eq 1 ]; then
  # Se apenas um arquivo foi encontrado, não é necessário selecionar
  CODE_FILE="${CODE_FILES[0]}"
else
  PS3="Selecione um arquivo de código-fonte (1-${#CODE_FILES[@]}): "
  select file in "${CODE_FILES[@]}"; do
    if [ -n "$file" ]; then
      CODE_FILE="$file"
      break
    else
      echo "Opção inválida. Por favor, tente novamente." >&2
    fi
  done
fi

CODE_LANG="${CODE_FILE##*.}"


# Função para ver a diferença de dois arquivos
filesDiff() {
  # Contar o número total de linhas em ambos os arquivos
  lines_arq1=$(wc -l < $1)
  lines_arq2=$(wc -l < $2)

  # Contar o número de linhas diferentes usando git diff
  diff_lines=$(git diff --ignore-cr-at-eol --no-index --stat "$1" "$2" | tail -1 | awk '{print $4}')

  # Verificar se diff_lines está definido e não está vazio
  if [ -z "$diff_lines" ]; then
    echo -e $(tput setaf 3)$(tput bold)"\n | Nota: 100% \U0001F389 \n" $(tput sgr0)
    exit 1
  else
    # Calcular a porcentagem de diferença
    perc_diff=$(awk "BEGIN { printf \"%.2f\", ($diff_lines / ($lines_arq1 + $lines_arq2)) * 100 }")

    # Calcular a porcentagem de igualdade
    perc_igualdade=$(awk "BEGIN { printf \"%.2f\", 100 - $perc_diff }")

    # Exibir a porcentagem de igualdade
    echo -e $(tput setaf 3)$(tput bold)"\n | Nota: $perc_igualdade%$(tput sgr0)\n"

    # Exibir linhas diferentes
    echo -e $(tput setaf 4)$(tput bold)" | \U000026A0 Diferenças:\n"$(tput sgr0)

    git diff --ignore-cr-at-eol --no-index --line-prefix="   " --word-diff=color -U0 --color=always "$1" "$2" | tail -n +5
  fi
}

# Compilar o arquivo de acordo com a linguagem
case $CODE_LANG in
  java)
    javac "$CODE_FILE"
    ;;
  c)
    gcc -o "${CODE_FILE%.*}" "$CODE_FILE"
    ;;
  cpp)
    g++ -o "${CODE_FILE%.*}" "$CODE_FILE"
    ;;
esac

executar_java() {
  # Executar o arquivo compilado
  if [ $TEST_FLAG -eq 1 ]; then
    if [ -f "pub.in" ] && [ -f "pub.out" ]; then
      java "${CODE_FILE}" < "pub.in" > "a.out"
      filesDiff "a.out" "pub.out"
    else
      echo "Arquivos de teste não encontrados" >&2
    fi
  else
    java "${CODE_FILE}"
  fi
}

# Executar o arquivo compilado
if [ $TEST_FLAG -eq 1 ]; then
  if [ -f "pub.in" ] && [ -f "pub.out" ]; then
    if [ $CODE_LANG == "java" ]; then
      executar_java
    elif [ $CODE_LANG == "c" ] || [ $CODE_LANG == "cpp" ]; then
      ./"${CODE_FILE%.*}" < "pub.in" > "a.out"
      filesDiff "a.out" "pub.out"
    fi
  else
    echo "Arquivos de teste não encontrados" >&2
  fi
else
  if [ $CODE_LANG == "java" ]; then
    executar_java
  else
    ./"${CODE_FILE%.*}"
  fi
fi
