# Verde CLI
O **Verde CLI** é uma ferramenta de linha de comando desenvolvida para facilitar a correção de código de exercícios. Com ela, é possível compilar e executar o código de um exercício, além de testá-lo com os testes do arquivo `pub.in` e comparar com o arquivo `pub.out`.

Adicionalmente, oferecemos o [tp-builder](./tp-builder/) para automatizar o download dos arquivos `pub.in` e `pub.out` para os estudantes matriculados na disciplina de **AEDS II** - Algoritmos e Estruturas de Dados II, na PUC Minas.

## 📋 Pré-requisitos
Para usar o **Verde CLI**, você precisa estar em um ambiente Linux e ter os seguintes programas pré-instalados em seu computador:
- [Git](https://git-scm.com/)
- [GCC e G++](https://gcc.gnu.org/) (Compilador de C e C++)
- [Java](https://www.java.com/pt-BR/download/) (Java Development Kit)

## 🚀 Como Usar
Para usar o **Verde CLI**, siga os passos abaixo:

### 1. Baixar o Verde CLI
Primeiramente, você precisa baixar o **Verde CLI** em seu computador. Para isso, você pode clonar o repositório do projeto em sua máquina. Para isso, abra o terminal e execute o seguinte comando:
```sh
  git clone https://github.com/andreeluis/verde-cli.git
  cd verde-cli   # Entrar na pasta do repositório clonado
```

### 2. Dar permissão de execução
Depois de baixar o **Verde CLI**, você precisa dar permissão de execução para o arquivo `verde.sh`. Para isso, execute o seguinte comando:
```sh
  sudo chmod +x verde.sh
```

### 3. Adicionar um link simbólico
Agora você precisa adicionar um link simbólico para que o arquivo `verde.sh` possa ser usado em qualquer pasta de exercício.. Para isso, execute o seguinte comando:
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
**⚠️Obs:** O arquivo `pub.in` deve conter os testes de entrada e o arquivo `pub.out` deve conter os testes de saída esperados.

## 📂 Estrutura de Diretórios
A estrutura dos diretórios de exercícios deve seguir o seguinte padrão:
```
  exercicio1/
    ├── main.*    (Arquivo com o código fonte)
    ├── pub.in    (Arquivo com os testes de entrada)
    └── pub.out   (Arquivo com as saídas esperadas)
```
**⚠️Obs:** O arquivo `main.*` pode ser um arquivo com extensão `.c`, `.cpp` ou `.java`.

## 🧩 Colaboradores
| <img src="https://github.com/andreeluis.png" width="100" height="100" alt="André Luís"/> | <img src="https://github.com/thomneuenschwander.png" width="100" height="100" alt="Thomas Neuenschwander"/> |
|:---:|:---:|
| [André Luís](https://github.com/andreeluis) | [Thomas <br> Neuenschwander](https://github.com/thomneuenschwander) |
