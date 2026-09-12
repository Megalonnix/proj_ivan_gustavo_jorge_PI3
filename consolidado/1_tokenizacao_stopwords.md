# **Módulo 1 — Tokenização + Remoção de Stopwords + Stemming**

📄 Script: [`estrutura/scriptsR/1_tokenizacao_stopwords.R`](https://github.com/Megalonnix/proj_ivan_gustavo_jorge_PI3/blob/main/estrutura/scriptsR/1_tokenizacao_stopwords.R)

## Objetivo
Pré-processar textos (títulos, parágrafos, corpus de teste) para alimentar as etapas posteriores: BoW, TF-IDF, similaridade do cosseno e índice invertido.

O módulo expõe **duas famílias de funções**, com propósitos distintos:

- **`remove_stopwords()` — didática.** Tokeniza, remove pontuação e remove stopwords. **Sem** stemming. Serve para inspecionar o passo a passo nos notebooks.
- **`processar_texto()` — produção.** Mesma base, **com stemming** (`SnowballC`, português). É o pipeline que os módulos 2, 3 e 4 usam de verdade.

## Parâmetro unificado
Todas as funções usam `aplicar_stopwords = TRUE` (**TRUE = aplica** a remoção).

Isso elimina a ambiguidade dos nomes antigos (`desligado`, `dontRemoveStopWords`, `cancelStopWordRemoval`), que tinham semântica trocada entre módulos — em um, `TRUE` significava "remove"; em outro, `TRUE` significava "não remove".

## Stopwords
Apenas **português**, fonte `snowball`.

A versão anterior misturava PT + EN, o que só poluía o vocabulário do corpus real (todo em PT).

## Funções

### `remove_punctuation(txt)`
Converte para minúsculas e remove pontuação (`[[:punct:]]`).

### `tokenize_txt(txt)`
Quebra a string em tokens (vetor de palavras), descartando strings vazias.

### `remove_stopwords(txt, aplicar_stopwords = TRUE)` — **didática**
Pipeline: tokenização + remoção de pontuação + remoção de stopwords PT.

**Não** faz stemming. Usada em demonstrações e notebooks.

### `processar_texto(txt, aplicar_stopwords = TRUE)` — **produção**
Mesmo pipeline da anterior + `SnowballC::wordStem(tokens, language = "portuguese")`.

Usada pelos módulos 2, 3 e 4.

---

## Testes

Os blocos de teste abaixo ficam comentados no fim do `.R` e podem ser executados descomentando-os.

### Teste 1 — Tokenização crua

```r
tokenize_txt("O gato pulou na mesa")
# [1] "o"    "gato"  "pulou" "na"    "mesa"
```

### Teste 2 — `remove_stopwords` (didática)

```r
remove_stopwords("O gato pulou na mesa", aplicar_stopwords = FALSE)
# [1] "o"    "gato"  "pulou" "na"    "mesa"

remove_stopwords("O gato pulou na mesa", aplicar_stopwords = TRUE)
# [1] "gato"  "pulou" "mesa"
```

Com `aplicar_stopwords = TRUE`, os termos `"o"` e `"na"` são removidos.

### Teste 3 — `processar_texto` (produção, com stemming)

```r
processar_texto("Os gatos estão comendo peixes na mesa",
                aplicar_stopwords = TRUE)
# [1] "gat"  "com"  "peix" "mes"
```

Cada token é reduzido ao seu pseudo-radical. O stemming do português é agressivo: `"mesa"` vira `"mes"`, `"comendo"` vira `"com"`, `"gatos"` vira `"gat"`.

### Teste 4 — Contraste lado a lado

```r
remove_stopwords("documentos ranqueamento relevancia", TRUE)
# [1] "documentos"    "ranqueamento"  "relevancia"

processar_texto("documentos ranqueamento relevancia", TRUE)
# [1] "document"      "ranqueament"   "relev"
```

Mesmo corpus, dois pipelines. A diferença é exatamente o que o stemming faz.

---

## Observações

- O stemming do `SnowballC` para português é agressivo; alguns pseudo-radicais ficam estranhos (ex.: `"terçafeir"`, `"cã"`), o que é normal e esperado.
- O parâmetro `aplicar_stopwords = FALSE` é útil para comparar cenários com e sem stopwords — foi o que permitiu reproduzir os valores do `sklearn.TfidfVectorizer` no Módulo 2.
- Ambas as funções são vetorizadas em R base; nenhuma biblioteca de vetorização (`tm`, `quanteda`, `text2vec`, `tidytext`) é usada.