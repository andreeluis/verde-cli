#!/bin/bash

SUP_EXS=("AEDS II (tp-builder)")
SELECTED_EXS=""
DIR=$(readlink $(which grafite) | xargs dirname)

# Escolher o exercício
# PS3="Selecione o exercício (1-${#SUP_EXS[@]}): "
# select ex in "${SUP_EXS[@]}"; do
#   if [ -n "$ex" ]; then
#     SELECTED_EXS="$ex"
#     break
#   else
#     echo "Opção inválida. Por favor, tente novamente." >&2
#   fi
# done

# Executar o script do exercício selecionado
bash $DIR/tp-builder.sh

# case $SELECTED_EXS in
#   "AEDS II (tp-builder)")
#     bash $DIR/aeds2.sh
#     ;;
# esac