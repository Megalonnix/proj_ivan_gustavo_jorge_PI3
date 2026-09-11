# **Módulo 2 — Matrizes Bag-of-Words (BoW) e TF-IDF**

## Objetivo
Converter o corpus pré-processado em representações matriciais
(termos × documentos), base para o cálculo de similaridade.

## Arquivo
`estrutura/scriptsR/2_bow_tfidf.R`

## Implementação

- **100% nativa em R.** Sem `tm`, `quanteda`, `text2vec`, `tidytext`
  ou qualquer biblioteca de vetorização.
- Cada documento vira uma **coluna**; o vocabulário forma as **linhas**.

## Funções

### `get_processed_tokens(nonProcessedTexts, dontRemoveStopWords = FALSE)`
Aplica `remove_stopwords()` do módulo 1 em cada documento do corpus.

### `get_BOW_matrix(nonProcessedTexts, dontRemoveStopWords = FALSE)`
Retorna `list(matrix, df)` com a matriz de contagens (Bag-of-Words).

### `get_TFIDF_matrix(nonProcessedTexts, dontRemoveStopWords = FALSE)`
Retorna `list(matrix, df)` com a matriz TF-IDF.

## Fórmula do IDF suavizado

Equivalente ao `smooth_idf=True` do scikit-learn:

$$
\text{IDF}(t) = \ln\!\left(\frac{1 + N}{1 + n_t}\right) + 1
$$

onde:
- $N$ = número de documentos no corpus
- $n_t$ = número de documentos que contêm o termo $t$

## Normalização L2

Cada **coluna** (documento) é dividida por sua norma L2:

$$
\mathbf{d}_i^{norm} = \frac{\mathbf{d}_i}{\|\mathbf{d}_i\|_2}
$$

Isso faz com que cada vetor tenha comprimento 1 — passo essencial para
que a similaridade do cosseno se reduza a um simples produto interno.

## Teste com corpus mínimo

Corpus: `["I love you", "Love"]`, stopwords **desativadas**.

**BoW**

|       | "i love you" | "love" |
|-------|--------------|--------|
| i     | 1            | 0      |
| love  | 1            | 1      |
| you   | 1            | 0      |

**TF-IDF (após normalização L2)**

|       | "i love you" | "love" |
|-------|--------------|--------|
| i     | 0.631668     | 0      |
| love  | 0.449436     | 1      |
| you   | 0.631668     | 0      |

Esses valores batem com `sklearn.TfidfVectorizer` (defaults).