# **Módulo 1 — Tokenização + Remoção de Stopwords + Stemming**

## Objetivo
Pré-processar textos (títulos de notícias, corpus da Aula 01, corpora de
teste) para alimentar as etapas posteriores: BoW, TF-IDF, similaridade
do cosseno e índice invertido.

## Arquivo
`estrutura/scriptsR/1_tokenizacao_stopwords.R`

## Funções

### `remove_punctuation(txt)`
Converte para minúsculas e remove pontuação (`[[:punct:]]`).

### `tokenize_txt(txt)`
Quebra a string em tokens (vetor de palavras), descartando strings vazias.

### `remove_stopwords(txt, desligado = FALSE)`
Executa tokenização + remoção de pontuação + remoção de stopwords
(português + inglês, fonte `snowball`).

O parâmetro `desligado = TRUE` **desativa** a remoção — útil para
comparar cenários com e sem stopwords.

### `processar_texto(txt)`
Versão com **stemming** (`SnowballC::wordStem`, idioma português).
Usada no módulo 4 (índice invertido).

## Exemplo

```r
remove_stopwords("O gato pulou na mesa.", desligado = TRUE)
# [1] "o"     "gato"  "pulou" "na"    "mesa"

remove_stopwords("O gato pulou na mesa.", desligado = FALSE)
# [1] "gato"  "pulou" "mesa"

processar_texto("Os gatos estão comendo peixes na mesa")
# [1] "gat"  "com"  "peix" "mes"