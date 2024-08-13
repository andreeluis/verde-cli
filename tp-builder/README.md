
---

# AEDS II - TP Builder

![GitHub](https://img.shields.io/github/license/thomneuenschwander/aeds2-tp-downloader)
![Shell](https://img.shields.io/badge/Shell-Bash-blue)

## ✨ Objetivo

O objetivo deste script é automatizar o download dos arquivos `pub.in` e `pub.out` dos Trabalhos Práticos (TPs) de Algoritmos e Estruturas de Dados II (AEDS II) e a criação dos diretórios correspondentes. Isso facilita a organização e o acesso aos arquivos necessários para os trabalhos práticos.

## 📋 Pré-requisitos

- **Bash**: Este script foi escrito para ser executado em um shell Bash.
- **Curl**: Ferramenta de linha de comando para transferir dados com URLs. Instale usando:
  ```bash
  sudo apt install curl
  ```
- **jq**: Ferramenta para processar JSON na linha de comando. Instale usando:
  ```bash
  sudo apt install jq
  ```

## 🚀 Como Usar

Siga os passos abaixo para usar o script e baixar automaticamente os arquivos `pub.in` e `pub.out`:

### 1. Baixe o script

Primeiro, baixe este script para o seu ambiente local:

```bash
curl -o tp-builder.sh https://raw.githubusercontent.com/thomneuenschwander/bash-scripts-collection/main/tp-builder.sh
```

### 2. Dê Permissões de Execução ao Script

Antes de executar o script, certifique-se de que ele tem permissões de execução:

```bash
chmod +x tp-builder.sh
```

### 3. Execute o Script

Agora você pode executar o script:

```bash
./tp-builder.sh
```

### 4. Escolha o TP

Quando solicitado, escolha o TP desejado digitando o número:

- `1` -> `para o tp01`
- `2` -> `para o tp02`
- `3` -> `para o tp03`
- `4` -> `para o tp04`

### 5. Preparar para GitHub

Se desejar preparar o diretório para ser enviado ao GitHub, use a opção -g ao executar o script:

```bash
./tp-builder.sh -g
```

### 📁 Estrutura de Diretórios

A estrutura de diretórios criada será semelhante a:

```
TP01/
├── Q01/
│   ├── pub.in
│   └── pub.out
├── Q02/
│   ├── pub.in
│   └── pub.out
...
├── tp01.pdf
└── example.csv
```

### 📝 Autor

#### Thomas Neuenschwander

[![GitHub](https://img.shields.io/badge/GitHub-000?logo=github&logoColor=white&style=flat-square)](https://github.com/thomneuenschwander)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-0077B5?logo=linkedin&logoColor=white&style=flat-square)](https://www.linkedin.com/in/thomas-neuenschwander-87a568267/)
[![Instagram](https://img.shields.io/badge/Instagram-E4405F?logo=instagram&logoColor=white&style=flat-square)](https://www.instagram.com/puccomp/)

---

### ⚠️ Avisos

- Certifique-se de ter permissões para acessar a internet e fazer download de arquivos.
- Este script foi testado no **Ubuntu**. Pode ser necessário fazer ajustes para outras distribuições ou **sistemas operacionais**.

---
