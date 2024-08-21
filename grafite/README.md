# Grafite CLI
O **Grafite CLI** é uma ferramenta de linha de comando que facilita o download dos arquivos `pub.in` e `pub.out` dos exercícios de programação. Isso facilita a organização e o acesso aos arquivos necessários para os exercícios.

## 📋 Pré-requisitos
Para usar o **Grafite CLI**, você precisa estar em um ambiente Linux e ter os seguintes programas pré-instalados em seu computador:
- [curl](https://curl.se/)
- [jq](https://stedolan.github.io/jq/)

## 🚀 Como Usar
Para usar o **Grafite CLI**, siga os passos abaixo:

### 1. Baixar o Verde CLI
Primeiramente, você precisa baixar o **Grafite CLI** em seu computador. Para isso, você pode clonar o repositório do projeto em sua máquina. Para isso, abra o terminal e execute o seguinte comando:
```sh
git clone https://github.com/andreeluis/verde-cli.git
cd verde-cli/grafite
```

### 2. Dar permissão de execução
Depois de baixar o **Grafite CLI**, você precisa dar permissão de execução para o arquivo `grafite.sh`. Para isso, execute o seguinte comando:
```sh
sudo chmod +x grafite.sh
```

### 3. Adicionar um link simbólico
Agora você precisa adicionar um link simbólico para que o arquivo `verde.sh` possa ser usado em qualquer pasta de exercício. Para isso, execute o seguinte comando:
```sh
sudo ln -s "$(pwd)/grafite.sh" /usr/local/bin/grafite
```

### 4. Usar o Grafite CLI
Pronto! Agora você pode usar o **Grafite CLI** para criar a estrutura de diretórios dos exercícios de programação e baixar os arquivos `pub.in` e `pub.out`. Para isso, basta navegar até a pasta que deseja criar o exercício e executar o comando `grafite`. Por exemplo:
```sh
cd ~aeds2/tps
grafite
```

## 📂 Estrutura de Diretórios
A estrutura de diretórios criada será:
```
pastaExercicios/
  ├── tp01/
  │   ├── ex01/
  │   │   ├── pub.in
  │   │   └── pub.out
  │   ├── ex02/
  │   ⋮
  │   ├── dataset.csv
  │   └── enunciado.pdf
  ├── tp02/