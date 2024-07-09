#!/bin/bash

# Author: Thomas Neuenschwander
# GitHub: https://github.com/thomneuenschwander

# Função para converter o nome do diretório para maiúsculas
convert_to_uppercase() {
    uppercase_directory=$(echo "$selected_directory" | tr '[:lower:]' '[:upper:]')
}

# Função para criar diretório local para salvar os arquivos baixados
create_local_directory() {
    mkdir -p "$uppercase_directory"
}

# Função para obter a lista de arquivos e subdiretórios do repositório
get_subdirectories_and_files() {
    response=$(curl -s "$API_URL")
    subdirs=$(echo "$response" | jq -r '.[] | select(.type == "dir") | .name')
    csv_files=$(echo "$response" | jq -r '.[] | select(.type == "file") | .name' | grep '\.csv$')
}

# Função para codificar URL usando jq
urlencode() {
    jq -nr --arg str "$1" '$str | @uri'
}

# Função para baixar arquivos de um subdiretório
download_files() {
    local subdir="$1"
    local counter="$2"

    echo "Subdiretório encontrado: $subdir"
    
    # Formata o contador com dois dígitos
    counter_formatted=$(printf "%02d" $counter)
    
    # Cria um diretório local para cada subdiretório
    local_dir="$uppercase_directory/Q$counter_formatted"
    mkdir -p "$local_dir"

    # Codifica o nome do subdiretório para a URL
    encoded_subdir=$(urlencode "$subdir")

    # Define as URLs dos arquivos a serem baixados
    pub_in_url="https://raw.githubusercontent.com/icei-pucminas/aeds2/master/$DIR_PATH/$encoded_subdir/pub.in"
    pub_out_url="https://raw.githubusercontent.com/icei-pucminas/aeds2/master/$DIR_PATH/$encoded_subdir/pub.out"

    # Baixa os arquivos, verificando se existem
    echo "Baixando $pub_in_url"
    curl -f -o "$local_dir/pub.in" "$pub_in_url" || echo "Arquivo pub.in não encontrado para $subdir"

    echo "Baixando $pub_out_url"
    curl -f -o "$local_dir/pub.out" "$pub_out_url" || echo "Arquivo pub.out não encontrado para $subdir"
}

# Função para baixar o arquivo PDF
download_pdf() {
    # Ajusta o nome do diretório para o formato correto da URL (tp3 em vez de tp03)
    short_selected_directory=$(echo "$selected_directory" | sed 's/tp0/tp/')
    local pdf_url="https://github.com/icei-pucminas/aeds2/raw/master/tps/enunciado/$short_selected_directory.pdf"
    local output_dir="$uppercase_directory"
    
    echo "Baixando $pdf_url"
    curl -L -o "$output_dir/$short_selected_directory.pdf" "$pdf_url" || echo "Arquivo $short_selected_directory.pdf não encontrado"
}

# Função para baixar arquivos CSV
download_csv_files() {
    for csv_file in $csv_files; do
        local csv_url="https://raw.githubusercontent.com/icei-pucminas/aeds2/master/$DIR_PATH/$csv_file"
        echo "Baixando $csv_url"
        curl -L -o "$uppercase_directory/$csv_file" "$csv_url" || echo "Arquivo $csv_file não encontrado"
    done
}

main() {
    echo "⭐ Selecione o número do TP atual 🤔:"
    PS3="▶️ "
    select selected_directory in tp01 tp02 tp03 tp04;
    do
       echo "Montando ${selected_directory^^} 🤓🚀..."
       break
    done
    
    convert_to_uppercase

    # URL do repositório
    REPO_URL="https://github.com/icei-pucminas/aeds2"

    # Caminho para o diretório que contém os subdiretórios de interesse
    DIR_PATH="tps/entrada%20e%20saida/$selected_directory"

    # URL da API para listar os arquivos no diretório
    API_URL="https://api.github.com/repos/icei-pucminas/aeds2/contents/$DIR_PATH"

    create_local_directory
    get_subdirectories_and_files
    download_pdf
    download_csv_files

    counter=1

    while IFS= read -r subdir; do
        download_files "$subdir" "$counter"
        # Incrementa o contador
        counter=$((counter + 1))
    done <<< "$subdirs"

    echo "Download concluído."
}

main
