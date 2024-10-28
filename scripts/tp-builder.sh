#!/bin/bash

API_URL="https://api.github.com/repos/icei-pucminas/aeds2/contents"
DOWNLOAD_URL="https://raw.githubusercontent.com/icei-pucminas/aeds2/master/"
SELECTED_TP=""
EXERCISES_LIST=()

# encode string to URL
url_encode() {
  jq -nr --arg str "$1" '$str | @uri'
}

select_tp() {
  # get all available TPs
  local response=$(curl -s "${API_URL}/tps/entrada%20e%20saida")
  local tps_response=$(echo "$response" | jq -r '.[] | select(.type == "dir") | .name' | grep '^tp')
  local tps_list=()

  for tp in $tps_response; do
    tps_list+=("$tp")
  done

  PS3="Selecione o TP desejado (1-${#tps_list[@]}): "
  select SELECTED_TP in "${tps_list[@]}"; do
    if [ -z "$SELECTED_TP" ]; then
      echo "Opção inválida!"
      exit 1
    else
      break
    fi
  done

  mkdir -p "$SELECTED_TP"
}

# get exercises from selected TP
get_exercises() {
  local response=$(curl -s "${API_URL}tps/entrada%20e%20saida/$SELECTED_TP")
  mapfile -t EXERCISES_LIST < <(echo "$response" | jq -r '.[] | select(.type == "dir") | .name')
}

download_exercises() {
  echo "Baixando exercícios..."
  local cont=1

  for exercise in "${EXERCISES_LIST[@]}"; do
    echo "Baixando exercício: $exercise"

    local encoded_exercise=$(url_encode "$exercise")
    local url="${DOWNLOAD_URL}tps/entrada%20e%20saida/$SELECTED_TP/${encoded_exercise}"

    mkdir -p "$SELECTED_TP/ex$(printf "%02d" $cont)"

    curl -f -s -o "$SELECTED_TP/ex$(printf "%02d" $cont)/pub.in" "$url/pub.in"
    curl -f -s -o "$SELECTED_TP/ex$(printf "%02d" $cont)/pub.out" "$url/pub.out"

    cont=$((cont+1))
  done
}

# Função para baixar o arquivo PDF
download_enunciado() {
  echo "Baixando enunciado..."

  local short_selected_tp=$(echo "$SELECTED_TP" | sed 's/tp0/tp/')

  curl -f -s -o "$SELECTED_TP/enunciado.pdf" "${DOWNLOAD_URL}tps/enunciado/$SELECTED_TP.pdf" || curl -f -s -o "$SELECTED_TP/enunciado.pdf" "${DOWNLOAD_URL}tps/enunciado/$short_selected_tp.pdf" || echo "Enunciado não encontrado."
}

# Função para baixar arquivos CSV
download_dataset() {
  echo "Baixando dataset..."

  local response=$(curl -s "${API_URL}tps/entrada%20e%20saida")
  local dataset=$(echo "$response" | jq -r '.[] | select(.type == "file") | .name' | grep '\.csv$')

  if [ -n "$dataset" ]; then
    curl -f -s -o "$SELECTED_TP/$dataset" "${DOWNLOAD_URL}tps/entrada%20e%20saida/$dataset"
  fi
}

menu() {
  echo "Seja bem vindo ao TP Builder!"

  select_tp
  get_exercises
  download_exercises
  download_enunciado
  download_dataset
}

# clear the screen
clear -x

menu
