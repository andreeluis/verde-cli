#!/bin/bash

API_URL="https://api.github.com/repos/icei-pucminas/aeds2/contents"
DOWNLOAD_URL="https://raw.githubusercontent.com/icei-pucminas/aeds2/master/"
TPS_LIST=()
EXERCISES_LIST=()

# Função para codificar URL usando jq
urlencode() {
  jq -nr --arg str "$1" '$str | @uri'
}

select_tp() {
  # Buscar os TP's disponíveis
  response=$(curl -s "${API_URL}/tps/entrada%20e%20saida")
  tps=$(echo "$response" | jq -r '.[] | select(.type == "dir") | .name' | grep '^tp')

  for tp in $tps; do
    TPS_LIST+=("$tp")
  done

  # Selecionar o TP
  PS3="Selecione o TP (1-${#TPS_LIST[@]}): "
  select selected_tp in "${TPS_LIST[@]}";
  do
    if [ -n "$selected_tp" ]; then
      break
    else
      echo "Por favor, selecione uma opção válida."
    fi
  done

  mkdir -p "$selected_tp"
}

# Função para obter a lista de exercícios do TP selecionado
get_exercises() {
  response=$(curl -s "${API_URL}tps/entrada%20e%20saida/$selected_tp")
  exercises=$(echo "$response" | jq -r '.[] | select(.type == "dir") | .name')

  # Salva o IFS atual e depois muda para newline
  OLD_IFS="$IFS"
  IFS=$'\n'

  for exercise in $exercises; do
    EXERCISES_LIST+=("$exercise")
  done

  # Restaura o IFS original
  IFS="$OLD_IFS"
}

download_exercises() {
  echo "Baixando exercícios..."
  cont=1

  for exercise in "${EXERCISES_LIST[@]}"; do
    echo "Baixando exercício: $exercise"

    encoded_exercise=$(urlencode "$exercise")
    url="${DOWNLOAD_URL}tps/entrada%20e%20saida/$selected_tp/${encoded_exercise}"

    mkdir -p "$selected_tp/ex$(printf "%02d" $cont)"

    curl -f -s -o "$selected_tp/ex$(printf "%02d" $cont)/pub.in" "$url/pub.in"
    curl -f -s -o "$selected_tp/ex$(printf "%02d" $cont)/pub.out" "$url/pub.out"

    cont=$((cont+1))
  done
}

# Função para baixar o arquivo PDF
download_enunciado() {
  short_selected_tp=$(echo "$selected_tp" | sed 's/tp0/tp/')

  curl -f -s -o "$selected_tp/enunciado.pdf" "${DOWNLOAD_URL}tps/enunciado/$selected_tp.pdf" || curl -f -s -o "$selected_tp/enunciado.pdf" "${DOWNLOAD_URL}tps/enunciado/$short_selected_tp.pdf" || echo "Enunciado não encontrado."
}

# Função para baixar arquivos CSV
download_dataset() {
  response=$(curl -s "${API_URL}tps/entrada%20e%20saida/$selected_tp")
  dataset=$(echo "$response" | jq -r '.[] | select(.type == "csv") | .name')

  if [ -n "$dataset" ]; then
    curl -f -s -o "$selected_tp/$dataset" "${DOWNLOAD_URL}tps/entrada%20e%20saida/$selected_tp/$dataset"
  fi
}

# tp-builder
echo "Seja bem vindo ao TP Builder!"
echo "Selecione o TP que deseja baixar:"

select_tp
get_exercises
download_exercises
download_enunciado
download_dataset
