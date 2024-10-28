# Verde CLI
O **Verde CLI** é uma ferramenta de linha de comando desenvolvida para facilitar e automatizar processos de desenvolvimento de códigos. Com o **Verde CLI**, você pode:
- Compilar e executar códigos
- Testar códigos

Também é possível fazer o download automatizado dos arquivos dos [trabalhos práticos de AEDS II](https://github.com/icei-pucminas/aeds2/tree/master/tps), com o **TP Builder**.

Você pode assistir a [apresentação do **Verde CLI**](https://www.youtube.com/watch?v=gBBXjS0McjM) no YouTube clicando na imagem abaixo:

<p align="center">
  <a href="https://www.youtube.com/watch?v=gBBXjS0McjM">
    <img src="https://img.youtube.com/vi/gBBXjS0McjM/maxresdefault.jpg" width="500">
  </a>
</p>

## 📋 Pré-requisitos
Para usar o **Verde CLI**, você precisa estar em um ambiente Linux e ter as seguintes ferramentas instaladas em seu computador:
- [Git](https://git-scm.com/)
- [GCC e G++](https://gcc.gnu.org/) (Compilador de C e C++)
- [Java](https://www.java.com/pt-BR/download/) (Java Development Kit)

E caso você deseje usar o **TP Builder**, você também precisa ter instalado:
- [curl](https://curl.se/)
- [jq](https://stedolan.github.io/jq/)

## 🚀 Como Usar
Para usar o **Verde CLI**, siga os passos abaixo:

### 1. Baixar o Verde CLI
> [!WARNING]
> Você pode escolher o diretório onde irá clonar o repositório do **Verde CLI**, mas lembre-se de **não** excluir a pasta após a instalação.
>
> Caso a pasta seja excluída ou movida, você irá perder o link simbólico que será criado no passo 3.

Primeiramente, você precisa baixar o **Verde CLI** em seu computador. Para isso, você pode fazer um clone do repositório em uma pasta de sua escolha. Basta abrir o terminal no diretório desejado e executar os comandos a seguir:
```sh
git clone https://github.com/andreeluis/verde-cli.git
cd verde-cli
```

### 2. Dar permissão de execução
Depois de baixar o **Verde CLI**, você precisa adicionar permissão de execução para o arquivo `verde.sh`. Para isso, execute o seguinte comando:
```sh
sudo chmod +x verde.sh
```

### 3. Adicionar um link simbólico
Agora você precisa adicionar um link simbólico para que o arquivo `verde.sh` possa ser usado em qualquer diretório do seu computador. Para isso, execute o seguinte comando:
```sh
sudo ln -s "$(pwd)/verde.sh" /usr/local/bin/verde
```

### 4. Usar o Verde CLI
Pronto! Agora o **Verde CLI** está instalado em seu computador e pronto para ser usado. Existem duas formas de usar o **Verde CLI**:
- Utilizando as flags para utilizar as funcionalidades:
  - `verde -c`: Compila e executa o código
  - `verde -t`: Compila, executa e testa o código
  - `verde -b`: Baixa os arquivos dos trabalhos práticos de AEDS II
- Utilizando o menu de opções:
  
  Basta executar o comando `verde` e escolher entre as opções disponíveis.

> [!NOTE]
> O **Verde CLI** suporta o uso de multiplos casos de teste. Para isso, basta adicionar os arquivos de entrada e saída com o padrão de nomenclatura `<nome>.in` e `<nome>.out`, respectivamente.
>
> Por exemplo, para um caso de teste `pub`, os arquivos devem ser nomeados como `pub.in` e `pub.out`.

## 📂 Estrutura de Diretórios
Recomendamos que o seguinte padrão de estrutura de diretórios seja seguido:
```
pastaExercicios/
  ├── exercicio1/
  │   ├── main.*       (Arquivo com o código fonte)
  │   ├── <nome>.in    (Arquivos com as entradas dos testes)
  │   └── <nome>.out   (Arquivos com as saídas esperadas)
  └── exercicio2/
```

> [!NOTE]
> O **Verde CLI** suporta apenas arquivos com extensão `.c`, `.cpp` e `.java`.

## 🔄 Atualizações
Recomendamos que você mantenha o **Verde CLI** sempre atualizado para garantir o melhor desempenho e correção de possíveis bugs.

Para atualizar, basta navegar até a pasta onde o repositório foi clonado e executar o seguinte comando:
```sh
git pull
```

## ⭐ Contribua com o Projeto
Se você deseja contribuir com o **Verde CLI**, fique à vontade para abrir uma [issue](https://github.com/andreeluis/verde-cli/issues/new/choose) ou enviar um [pull request](https://github.com/andreeluis/verde-cli/pulls).

Você também pode nos apoiar deixando uma estrela⭐ no repositório. Isso nos ajuda a saber que estamos no caminho certo e a alcançar mais pessoas.

## 🧩 Colaboradores
| <img src="https://github.com/andreeluis.png" width="100" height="100" alt="André Luís"/> | <img src="https://github.com/thomneuenschwander.png" width="100" height="100" alt="Thomas Neuenschwander"/> |
|:---:|:---:|
| [André Luís](https://github.com/andreeluis) | [Thomas <br> Neuenschwander](https://github.com/thomneuenschwander) |
