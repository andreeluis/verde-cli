#!/bin/bash

# Author: Thomas Neuenschwander
# GitHub: https://github.com/thomneuenschwander

GITIGNORE_FILE="./.gitignore"
REPO_URL="https://github.com/icei-pucminas/aeds2"

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
    local_dir="$selected_directory/ex$counter_formatted"
    mkdir -p "$local_dir"

    # Codifica o nome do subdiretório para a URL
    encoded_subdir=$(urlencode "$subdir")

    # Define as URLs dos arquivos a serem baixados
    pub_in_url="https://raw.githubusercontent.com/icei-pucminas/aeds2/master/$DIR_PATH/$encoded_subdir/pub.in"
    pub_out_url="https://raw.githubusercontent.com/icei-pucminas/aeds2/master/$DIR_PATH/$encoded_subdir/pub.out"

    # Tenta baixar o arquivo pub.in
    echo "Baixando $pub_in_url"
    http_code=$(curl -s -o "$local_dir/pub.in" -w "%{http_code}" "$pub_in_url")
    if [ "$http_code" -ne 200 ]; then
        echo "❌ Parece que esse TP ainda não está disponível. 😔"
        rm -rf "$selected_directory"  # Remove o diretório pai
        exit 1
    fi

    # Tenta baixar o arquivo pub.out
    echo "Baixando $pub_out_url"
    http_code=$(curl -s -o "$local_dir/pub.out" -w "%{http_code}" "$pub_out_url")
    if [ "$http_code" -ne 200 ]; then
        echo "❌ Parece que esse TP ainda não está disponível. 😔"
        rm -rf "$selected_directory"  # Remove o diretório pai
        exit 1
    fi
}




# Função para baixar arquivos CSV
download_csv_files() {
    for csv_file in $csv_files; do
        local csv_url="https://raw.githubusercontent.com/icei-pucminas/aeds2/master/$DIR_PATH/$csv_file"
        echo "Baixando $csv_url"
        curl -L -o "$selected_directory/$csv_file" "$csv_url" || echo "Arquivo $csv_file não encontrado"
    done
}

prepare_for_github() {
    if ! command -v git &> /dev/null; then
        echo "Git não está instalado. Por favor, instale o Git para continuar."
        exit 1
    fi

    if [ ! -f "$GITIGNORE_FILE" ]; then
        echo "Criando arquivo \"$GITIGNORE_FILE\". 💪🏼"
        printf "*.class\n*.sh\n" > "$GITIGNORE_FILE"
    fi

    if [ ! -d ".git" ]; then
        echo "Inicializando repositório Git. 📝"
        git init
        if [ $? -ne 0 ]; then
            echo "Falha ao inicializar o repositório Git. ❌"
            exit 1
        fi

        git branch -m "main"

        echo "Adicionando arquivos ao repositório Git. 📂"
        git add .
        if [ $? -ne 0 ]; then
            echo "Falha ao adicionar arquivos ao índice do Git. ❌"
            exit 1
        fi

        echo "Fazendo commit dos arquivos. 📝"
        git commit -m "init"
        if [ $? -ne 0 ]; then
            echo "Falha ao fazer commit dos arquivos. ❌"
            exit 1
        fi
        git remote | grep origin &> /dev/null
        if [ $? -ne 0 ]; then
            echo "🍵 Se ainda não fez, crie um repositório remoto no seu GitHub para os Trabalhos Práticos de AEDS II"
            read -p "Digite a URL do repositório GitHub: " repo_url
            echo "Configurando repositório remoto. 🌐"
            git remote add origin "$repo_url"
            if [ $? -ne 0 ]; then
                echo "Falha ao adicionar o repositório remoto. ❌"
                exit 1
            fi
        fi

        echo "Fazendo push para o repositório remoto. 🚀"
        git push -u origin main
        if [ $? -ne 0 ]; then
            echo "Falha ao fazer push para o repositório remoto. ❌"
            exit 1
        fi

        echo "Diretório preparado e enviado para o GitHub com sucesso. 🎉"
    else
        echo "🛑 O git ja foi inicializado nesse diretorio. $PWD/.git."
    fi
}




main() {
    echo "⭐ Selecione o número do TP atual 🤔:"
    PS3="👉 "
    select selected_directory in tp01 tp02 tp03 tp04;
    do
       echo "Montando ${selected_directory^^} 🤓🚀..."
       break
    done

    # Caminho para o diretório que contém os subdiretórios de interesse
    DIR_PATH="tps/entrada%20e%20saida/$selected_directory"

    # URL da API para listar os arquivos no diretório
    API_URL="https://api.github.com/repos/icei-pucminas/aeds2/contents/$DIR_PATH"

    mkdir -p "$selected_directory"

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

# Processa os argumentos da linha de comando
while getopts ":g" opt; do
    case ${opt} in
        g)
            prepare_for_github
            exit 0
            ;;
        \?)
            echo "Opção inválida: -$OPTARG" >&2
            exit 1
            ;;
    esac
done

# Executa a função main se nenhum argumento for passado
main