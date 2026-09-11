# **Módulo 3 — Similaridade do Cosseno + Recomendação**

## Objetivo
Dada uma consulta livre do usuário, ranquear os documentos do corpus
pelos mais similares, usando similaridade do cosseno sobre a matriz
TF-IDF.

## Arquivo
`estrutura/scriptsR/3_similaridade_cosseno.R`

## Fórmula

$$
\text{cos}(\mathbf{q}, \mathbf{d}) =
\frac{\mathbf{q} \cdot \mathbf{d}}{\|\mathbf{q}\|_2 \, \|\mathbf{d}\|_2}
$$

Como as colunas da matriz TF-IDF já saem normalizadas em L2 (módulo 2),
o cálculo se reduz a um **produto interno** entre vetores.

## Funções

### `cosine_similarity_native(m)`
Recebe a matriz termos × documentos e devolve a matriz de similaridade
documentos × documentos.

### `getCossine_Similarity_matrix(nonProcessedTexts, tf_idf_matrix, cancelStopWordRemoval)`
Atalho: se recebe os textos, monta a TF-IDF internamente e calcula a
similaridade. Se recebe a matriz pronta, apenas calcula.

### `recomendar_documentos(query, lista_documentos, top_n)`
A consulta entra como "documento 0". Retorna os `top_n` documentos mais
similares com seus scores.

### `executar_recomendacao_ao_usuario(fonteDocumentos, queryEscritaPeloUsuario, top_n)`
Wrapper de console — imprime o ranking formatado.

## Exemplos de resultado

### Corpus simulado (receitas)

**Consulta:** `"Receita de bolo de chocolate com cookies'n cream"`

| Rank | Score | Documento |
|------|-------|-----------|
| 1    | 0.522 | cookies 'n cream e bolo de chocolate, receita fácil |
| 2    | 0.469 | bolo de chocolate |
| 3    | 0.297 | bolo de nozes e chocolate |

### Corpus da Aula 01 (8 documentos)

**Consulta:** `"modelo de espaco vetorial para documentos."`

| Rank | Score | Documento |
|------|-------|-----------|
| 1    | 0.731 | o modelo de espaco vetorial representa documentos como vetores |
| 2    | 0.167 | bm25 e um modelo probabilistico de ranqueamento de texto |
| 3    | 0.114 | recuperacao de informacao ordena documentos por relevancia |

Os scores batem exatamente com os do notebook original.