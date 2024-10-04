# Verde CLI
O **Verde CLI** é uma ferramenta de linha de comando desenvolvida para facilitar a correção de código de exercícios. Com ela, é possível compilar e executar o código de um exercício, além de testá-lo com os testes do arquivo `pub.in` e comparar com o arquivo `pub.out`.

Adicionalmente, oferecemos o [Grafite CLI](./grafite/) para automatizar o download dos arquivos `pub.in` e `pub.out` para os estudantes matriculados na disciplina de **AEDS II** - Algoritmos e Estruturas de Dados II, na PUC Minas.

Você pode assistir a [apresentação do **Verde CLI**](https://www.youtube.com/watch?v=gBBXjS0McjM) no YouTube clicando na imagem abaixo:

<p align="center">
  <a href="https://www.youtube.com/watch?v=gBBXjS0McjM">
    <img src="https://img.youtube.com/vi/gBBXjS0McjM/maxresdefault.jpg" width="500">
  </a>
</p>

## 📋 Pré-requisitos
Para usar o **Verde CLI**, você precisa estar em um ambiente Linux e ter os seguintes programas pré-instalados em seu computador:
- [Git](https://git-scm.com/)
- [GCC e G++](https://gcc.gnu.org/) (Compilador de C e C++)
- [Java](https://www.java.com/pt-BR/download/) (Java Development Kit)

## 🚀 Como Usar
Para usar o **Verde CLI**, siga os passos abaixo:

### 1. Baixar o Verde CLI
> [!WARNING]
> Você pode escolher a pasta onde irá clonar o repositório do **Verde CLI**, mas lembre-se de não excluir a pasta após a instalação.
> Caso a pasta seja excluída ou movida, você irá perder o link simbólico que será criado no passo 3.

Primeiramente, você precisa baixar o **Verde CLI** em seu computador. Para isso, você pode clonar o repositório do projeto em sua máquina. Para isso, abra o terminal e execute o seguinte comando:
```sh
git clone https://github.com/andreeluis/verde-cli.git
cd verde-cli
```

### 2. Dar permissão de execução
Depois de baixar o **Verde CLI**, você precisa dar permissão de execução para o arquivo `verde.sh`. Para isso, execute o seguinte comando:
```sh
sudo chmod +x verde.sh
```

### 3. Adicionar um link simbólico
Agora você precisa adicionar um link simbólico para que o arquivo `verde.sh` possa ser usado em qualquer pasta de exercício. Para isso, execute o seguinte comando:
```sh
sudo ln -s "$(pwd)/verde.sh" /usr/local/bin/verde
```

### 4. Usar o Verde CLI
Pronto! Agora você pode usar o **Verde CLI** para compilar e executar o código de um exercício. Para isso, basta navegar até a pasta do exercício e executar o comando `verde`. Por exemplo:
```sh
cd ~/exercicios/exercicio1
verde
```

Para testar o código com os testes do arquivo `pub.in` e comparar com o arquivo `pub.out`, você pode usar o comando `verde -t`. Por exemplo:
```sh
verde -t
```
> [!NOTE]
> O arquivo `pub.in` deve conter os testes de entrada e o arquivo `pub.out` deve conter os testes de saída esperados.

## 📂 Estrutura de Diretórios
A estrutura dos diretórios de exercícios deve seguir o seguinte padrão:
```
exercicio1/
  ├── main.*    (Arquivo com o código fonte)
  ├── pub.in    (Arquivo com os testes de entrada)
  └── pub.out   (Arquivo com as saídas esperadas)
```

> [!NOTE]
> O **Verde CLI** suporta apenas arquivos com extensão `.c`, `.cpp` e `.java`.

## 🔄 Atualizações
Para atualizar o **Verde CLI** em seu computador, basta navegar até a pasta onde o repositório foi clonado e executar o seguinte comando:
```sh
git pull
```
Dessa forma, você terá a versão mais recente do **Verde CLI** em seu computador.

## ⭐ Contribua com o Projeto
Se você deseja contribuir com o **Verde CLI**, fique à vontade para abrir uma [issue](https://github.com/andreeluis/verde-cli/issues/new/choose) ou enviar um [pull request](https://github.com/andreeluis/verde-cli/pulls).

Você também pode nos apoiar deixando uma ⭐ no repositório.

## 🧩 Colaboradores
| <img src="https://github.com/andreeluis.png" width="100" height="100" alt="André Luís"/> | <img src="https://github.com/thomneuenschwander.png" width="100" height="100" alt="Thomas Neuenschwander"/> |
|:---:|:---:|
| [André Luís](https://github.com/andreeluis) | [Thomas <br> Neuenschwander](https://github.com/thomneuenschwander) |
