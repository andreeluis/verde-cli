#!/bin/bash -eu

# Script para correção automática de exercícios de programação

# Recebe parametros: -t -l <linguagem> <lista> <exercicio>
# -t: flag para teste automático
# -l: linguagem de programação do exercício
# <lista>: lista de exercícios
# <exercicio>: exercício a ser corrigido



# Função para ver a diferença de dois arquivos
filesDiff() {
  # Contar o número total de linhas em ambos os arquivos
  lines_arq1=$(wc -l < $1)
  lines_arq2=$(wc -l < $2)

  # Contar o número de linhas diferentes usando git diff
  diff_lines=$(git diff --no-index --stat "$1" "$2" | tail -1 | awk '{print $4}')

  # Verificar se diff_lines está definido e não está vazio
  if [ -z "$diff_lines" ]; then
    echo "Não foi possível calcular a diferença entre os arquivos."
    exit 1
  fi

  # Calcular a porcentagem de diferença
  perc_diff=$(awk "BEGIN { printf \"%.2f\", ($diff_lines / ($lines_arq1 + $lines_arq2)) * 100 }")

  # Calcular a porcentagem de igualdade
  perc_igualdade=$(awk "BEGIN { printf \"%.2f\", 100 - $perc_diff }")

  # Exibir a porcentagem de igualdade
  echo "Porcentagem de igualdade entre os arquivos: $perc_igualdade%"

  # Exibir linhas diferentes
  echo "Linhas diferentes:"
  git diff --no-index --word-diff=color -U0 --color=always "$1" "$2" | tail -n +5
}

# Inicialize as flags e a linguagem
tflag=0
pflag=0
language="java"

# Processar as opções de linha de comando
while getopts 'tpl:' opt; do
  case $opt in
    t) tflag=1 ;;
    p) pflag=1 ;;
    l) language="$OPTARG" ;;
    *) printf "Uso: %s [-t] [-p] [-l linguagem] <lista> <exercicio>\n" "$0" 1>&2; exit 1 ;;
  esac
done
shift $((OPTIND -1))

# Verifique se pelo menos um argumento foi fornecido
if [ $# -lt 1 ]; then
  printf "Uso: %s [-t] [-l linguagem] <lista> <exercicio>\n" "$0" 1>&2
  exit 1
fi

# Se apenas um argumento foi fornecido, assuma que é o nome do arquivo
if [ $# -eq 1 ]; then
  filename="$1"
else
  # Concatene os argumentos em um único caminho
  path=""
  for arg in "$@"; do
    path="$path/$arg"
  done

  # Mude para o diretório do arquivo
  cd "${path#/}"

  # Converta os argumentos para maiúsculas
  filename=""
  for arg in "$@"; do
    arg=$(echo "$arg" | tr '[:lower:]' '[:upper:]')
    filename="$filename$arg"
  done
fi

# Compile e execute o arquivo de acordo com a linguagem
case $language in
  java)
    javac "$filename.java"
    if [ $tflag -eq 1 ]; then
      java "$filename" < "pub.in" > "a.out"

      if [ $pflag -eq 1 ]; then
        filesDiff "a.out" "pub.out"
      fi
    else
      java "$filename"
    fi
    ;;
  c)
    gcc -o "$filename" "$filename.c"
    if [ $tflag -eq 1 ]; then
      "./$filename" < "pub.in" > "a.out"

      if [ $pflag -eq 1 ]; then
        filesDiff "a.out" "pub.out"
      fi
    else
      "./$filename"
    fi
    ;;
  *)
    printf "Linguagem não suportada: %s\n" "$language" 1>&2
    exit 1
    ;;
esac
