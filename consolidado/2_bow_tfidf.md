# **Módulo 2 — Matrizes Bag-of-Words (BoW) e TF-IDF**

📄 Script: [`estrutura/scriptsR/2_bow_tfidf.R`](https://github.com/Megalonnix/proj_ivan_gustavo_jorge_PI3/blob/main/estrutura/scriptsR/2_bow_tfidf.R)

## Objetivo
Converter o corpus pré-processado em representações matriciais (termos × documentos), base para o cálculo de similaridade do cosseno no Módulo 3.

## Implementação

- **100% nativa em R.** Sem `tm`, `quanteda`, `text2vec`, `tidytext` ou qualquer biblioteca de vetorização.
- Cada **documento** vira uma **coluna**; o vocabulário forma as **linhas**.

## Parâmetros

- `aplicar_stopwords = TRUE` — remove stopwords PT (repassado ao Módulo 1).
- `usar_stemming = TRUE` — usa `processar_texto()` (pipeline de **produção**, com stemming). Quando `FALSE`, usa `remove_stopwords()` (pipeline **didático**, sem stemming).

## Funções

### `get_processed_tokens(texts, aplicar_stopwords = TRUE, usar_stemming = TRUE)`
Aplica o pipeline escolhido em cada documento do corpus e devolve uma lista de vetores de tokens.

### `get_BOW_matrix(texts, aplicar_stopwords = TRUE, usar_stemming = TRUE)`
Retorna `list(matrix, df)` com a matriz de contagens (Bag-of-Words).

### `get_TFIDF_matrix(texts, aplicar_stopwords = TRUE, usar_stemming = TRUE)`
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

Isso faz com que cada vetor tenha comprimento 1 — passo essencial para que a similaridade do cosseno se reduza a um simples produto interno (Módulo 3).

---

## Testes

Os blocos de teste abaixo ficam comentados no fim do `.R` e podem ser executados descomentando-os.

### Teste 1 — Corpus mínimo em inglês, sem stemming (bate com sklearn)

Corpus: `["I love you", "Love"]`, stopwords **desativadas**, sem stemming.

**BoW**

```r
textos <- list("I love you", "Love")

get_BOW_matrix(textos,
               aplicar_stopwords = FALSE,
               usar_stemming     = FALSE)$matrix
```

|       | i love you | love |
|-------|------------|------|
| i     | 1          | 0    |
| love  | 1          | 1    |
| you   | 1          | 0    |

**TF-IDF (após normalização L2)**

```r
get_TFIDF_matrix(textos,
                 aplicar_stopwords = FALSE,
                 usar_stemming     = FALSE)$matrix
```

|       | i love you | love |
|-------|------------|------|
| i     | 0.631668   | 0    |
| love  | 0.449436   | 1    |
| you   | 0.631668   | 0    |

Esses valores batem com `sklearn.TfidfVectorizer` (defaults) — âncora de regressão para garantir que a fórmula e a normalização continuam corretas.

### Teste 2 — Corpus PT pequeno, pipeline de produção (stemming ON)

```r
docs <- list(
  "O gato comeu o peixe",
  "O gato comeu a carne",
  "O cachorro late"
)

get_BOW_matrix(docs)$matrix
```

Espera-se uma matriz 3 colunas (uma por documento). Os radicais de `"gato"` e `"comeu"` aparecem nas **duas primeiras** colunas; `"cachorro"` e `"late"` só na terceira.

### Teste 3 — Mesmo corpus, pipeline didático (sem stemming)

```r
get_BOW_matrix(docs, usar_stemming = FALSE)$matrix
```

Comparar com o Teste 2: aqui os termos aparecem **inteiros** (`"gato"`, `"comeu"`, `"peixe"`, ...) em vez dos radicais. O vocabulário também é maior.

---

## Observações

- A escolha do IDF `sklearn-style` (com suavização e `+1` no final) foi uma decisão de projeto registrada na Fase 0. A fórmula clássica do professor é `log(N/df)`; as duas produzem a **mesma ordem de ranking** na maioria dos casos, mas a suavizada evita divisão por zero e IDF negativo.
- O parâmetro `usar_stemming = FALSE` existe para os testes do Módulo 2 baterem com sklearn (que não faz stemming). Em produção, os módulos 3 e 4 chamam com `usar_stemming = TRUE`.