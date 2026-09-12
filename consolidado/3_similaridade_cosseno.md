# **Módulo 3 — Similaridade do Cosseno + Recomendação**

📄 Script: [`estrutura/scriptsR/3_similaridade_cosseno.R`](https://github.com/Megalonnix/proj_ivan_gustavo_jorge_PI3/blob/main/estrutura/scriptsR/3_similaridade_cosseno.R)

## Objetivo
Dada uma consulta livre do usuário, ranquear os documentos do corpus pelos mais similares, usando similaridade do cosseno sobre a matriz TF-IDF (Módulo 2).

## Fórmula

$$
\text{cos}(\mathbf{q}, \mathbf{d}) =
\frac{\mathbf{q} \cdot \mathbf{d}}{\|\mathbf{q}\|_2 \, \|\mathbf{d}\|_2}
$$

Como as colunas da matriz TF-IDF já saem normalizadas em L2 (Módulo 2), o cálculo se reduz a um **produto interno** entre vetores.

## Parâmetros

- `aplicar_stopwords = TRUE` — remove stopwords PT (repassado ao Módulo 2).
- `usar_stemming = TRUE` — pipeline de **produção** (stemming ligado). Padrão.

## Funções

### `cosine_similarity_native(m)`
Recebe a matriz termos × documentos e devolve a matriz de similaridade documentos × documentos.

### `getCossine_Similarity_matrix(nonProcessedTexts, tf_idf_matrix, aplicar_stopwords, usar_stemming)`
Atalho:
- Se recebe os **textos**, monta a TF-IDF internamente e calcula a similaridade.
- Se recebe a **matriz pronta**, apenas calcula a similaridade.

### `recomendar_documentos(query, lista_documentos, top_n, aplicar_stopwords, usar_stemming)`
A consulta entra como "documento 0". Retorna os `top_n` documentos mais similares com seus scores.

### `executar_recomendacao_ao_usuario(fonteDocumentos, queryEscritaPeloUsuario, top_n, ...)`
Wrapper de console — imprime o ranking formatado.

---

## Testes

Os blocos de teste abaixo ficam comentados no fim do `.R` e podem ser executados descomentando-os.

### Teste 1 — Matriz de similaridade de um corpus pequeno

```r
textos <- list(
  "Amo comer pizza",
  "Amo comer hamburguer",
  "Odeio lutar"
)

sim <- getCossine_Similarity_matrix(textos)
round(sim, 3)
```

Espera-se:
- Diagonal sempre **1.000** (documento consigo mesmo).
- Texto 1 vs. 2 com score **alto** (compartilham `"amo"` e `"comer"`).
- Texto 3 vs. 1/2 com score **baixo** (nada em comum).

### Teste 2 — Recomendação (corpus de receitas)

```r
receitas <- list(
  "bolo de chocolate",
  "bolo de nozes e chocolate",
  "cafe com chocolate",
  "cookies 'n cream e bolo de chocolate, receita facil",
  "hamburguer vegano com ovos e bacon"
)

executar_recomendacao_ao_usuario(
  fonteDocumentos         = receitas,
  queryEscritaPeloUsuario = "receita de bolo de chocolate",
  top_n                   = 3
)
```

**Saída esperada:**

| Rank | Score | Documento |
|------|-------|-----------|
| 1    | 0.522 | cookies 'n cream e bolo de chocolate, receita facil |
| 2    | 0.469 | bolo de chocolate |
| 3    | 0.297 | bolo de nozes e chocolate |

Os dois primeiros documentos tratam de bolo; `"cafe com chocolate"` fica de fora do top 3 por só compartilhar o termo `"chocolate"`.

### Teste 3 — Corpus da Aula 01 (8 documentos)

```r
docs <- list(
  d1 = "recuperacao de informacao ordena documentos por relevancia",
  d2 = "o modelo de espaco vetorial representa documentos como vetores",
  d3 = "bm25 e um modelo probabilistico de ranqueamento de texto",
  d4 = "aprendizado estatistico fundamenta a recuperacao moderna",
  d5 = "o indice invertido acelera a busca em muitos documentos",
  d6 = "embeddings capturam a semantica de palavras e documentos",
  d7 = "a avaliacao mede a relevancia dos resultados da busca",
  d8 = "ciencia de dados combina estatistica e programacao"
)

executar_recomendacao_ao_usuario(
  fonteDocumentos         = docs,
  queryEscritaPeloUsuario = "modelo de espaco vetorial",
  top_n                   = 3
)
```

**Saída esperada:**

| Rank | Score | Documento |
|------|-------|-----------|
| 1    | 0.731 | o modelo de espaco vetorial representa documentos como vetores |
| 2    | 0.167 | bm25 e um modelo probabilistico de ranqueamento de texto |
| 3    | 0.114 | recuperacao de informacao ordena documentos por relevancia |

`d2` lidera com folga: contém **todos** os termos da consulta. `d3` e `d1` compartilham termos isolados (`"modelo"` e `"documentos"`), produzindo scores baixos.

---

## Observações

- A matriz retornada por `cosine_similarity_native` é **documentos × documentos**, na mesma ordem das colunas da matriz TF-IDF. O índice `[1, ]` corresponde à consulta (que é inserida na posição 1 em `recomendar_documentos`).
- Como as colunas da TF-IDF já saem normalizadas do Módulo 2, a normalização dentro de `cosine_similarity_native` é redundante para documentos, mas **necessária** quando a matriz recebida não foi normalizada — por isso é mantida.
- A função `executar_recomendacao_ao_usuario` aceita `usar_stemming` e `aplicar_stopwords`, permitindo rodar com pipelines diferentes sem duplicar código.