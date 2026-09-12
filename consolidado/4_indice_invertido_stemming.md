# **Módulo 4 — Índice Invertido + Stemming + Buscas Booleanas**

📄 Script: [`estrutura/scriptsR/4_indice_invertido_stemming.R`](https://github.com/Megalonnix/proj_ivan_gustavo_jorge_PI3/blob/main/estrutura/scriptsR/4_indice_invertido_stemming.R)

## Objetivo
Construir um índice invertido com pseudo-radicais (via `SnowballC`) e implementar buscas booleanas **AND** e **OR** sobre o corpus.

## Pipeline
Este módulo usa **sempre** `processar_texto()` — o pipeline de **produção**, com stemming ligado e stopwords PT removidas. Não há opção de desligar o stemming aqui: o índice invertido do professor é definido sobre radicais.

## Funções

### `construir_indice_invertido(docs, aplicar_stopwords = TRUE)`
Percorre cada documento, aplica `processar_texto()`, pega os radicais **únicos** de cada documento (evitando duplicatas na lista) e registra o `doc_id` em cada pseudo-radical.

Retorna uma `list()` — os nomes são o **dicionário** e cada elemento é a **lista de postagens** daquele radical.

### `preparar_consulta(texto, aplicar_stopwords = TRUE)`
Aplica o mesmo pré-processamento na consulta. **Regra de ouro:** a consulta precisa passar pelo mesmo pipeline dos documentos, senão `"Documentos"` não casa com `"documentos"`.

### `buscar_AND(consulta, indice, aplicar_stopwords = TRUE)`
`Reduce(intersect, ...)` sobre as listas dos termos da consulta. Retorna documentos que contêm **todos** os termos.

### `buscar_OR(consulta, indice, aplicar_stopwords = TRUE)`
`Reduce(union, ...)`. Retorna documentos que contêm **pelo menos um** termo.

### `tabela_indice(postings)`
`data.frame` com colunas `Radical` / `Frequencia_Docs` / `Documentos`, ordenado alfabeticamente.

---

## Testes

Os blocos de teste abaixo ficam comentados no fim do `.R` e podem ser executados descomentando-os.

### Teste 1 — Corpus mínimo em PT (didático)

```r
docs_teste <- c(
  doc1 = "O gato comeu peixe",
  doc2 = "Os gatos comem peixe",
  doc3 = "O cachorro come carne"
)

postings <- construir_indice_invertido(docs_teste)

postings[["gat"]]
# [1] "doc1" "doc2"     (ambos contêm "gato"/"gatos" → mesmo radical)

postings[["peix"]]
# [1] "doc1" "doc2"

postings[["carn"]]
# [1] "doc3"
```

Note como o stemming colapsa `"gato"` e `"gatos"` no mesmo radical `"gat"` — é exatamente esse o ganho de recall.

### Teste 2 — Buscas booleanas

```r
buscar_AND("peixe gato", postings)
# [1] "doc1" "doc2"   (interseção)

buscar_OR("gato carne", postings)
# [1] "doc1" "doc2" "doc3"   (união)
```

### Teste 3 — Tabela do índice

```r
tabela_indice(postings)
```

```
        Radical Frequencia_Docs       Documentos
cachorr cachorr               1             doc3
carn       carn               1             doc3
com         com               3 doc1, doc2, doc3
gat         gat               2       doc1, doc2
peix       peix               2       doc1, doc2
```

### Teste 4 — Corpus da Aula 01 (8 documentos)

```r
docs_aula01 <- c(
  d1 = "Recuperacao de Informacao: ORDENA documentos, por relevancia!",
  d2 = "O modelo de espaco-vetorial representa documentos (como vetores).",
  d3 = "BM25 e um modelo probabilistico de ranqueamento de texto.",
  d4 = "Aprendizado estatistico fundamenta a recuperacao moderna.",
  d5 = "O indice invertido acelera a busca em muitos documentos.",
  d6 = "Embeddings capturam a semantica de palavras e documentos.",
  d7 = "A avaliacao mede a relevancia dos resultados da busca.",
  d8 = "Ciencia de dados combina estatistica e programacao."
)

postings_aula01 <- construir_indice_invertido(docs_aula01)

buscar_AND("modelo probabilistico", postings_aula01)
# [1] "d3"

buscar_OR("modelo probabilistico", postings_aula01)
# [1] "d2" "d3"

head(tabela_indice(postings_aula01), 10)
```

**Saída esperada (10 primeiros):**

```
          Radical Frequencia_Docs     Documentos
acel         acel               1             d5
aprendiz aprendiz               1             d4
avaliaca avaliaca               1             d7
bm25         bm25               1             d3
busc         busc               2         d5, d7
captur     captur               1             d6
cienc       cienc               1             d8
combin     combin               1             d8
dad           dad               1             d8
document document               4 d1, d2, d5, d6
```

`document` é o radical mais comum (aparece em 4 dos 8 documentos) — é exatamente o termo de menor IDF no corpus. É esse tipo de informação que vai alimentar o BM25 no Módulo 6.

---

## Observações

- O stemming do `SnowballC` para português é agressivo; alguns pseudo-radicais ficam estranhos (ex.: `"terçafeir"`, `"cã"`), o que é normal e esperado.
- A regra de ouro do índice invertido: **a consulta precisa passar pelo mesmo pré-processamento dos documentos**. Se um lado faz stemming e o outro não, nenhum termo casa.
- `Reduce(intersect, listas)` com **uma só lista** retorna ela própria; com lista vazia, retorna `character(0)`. As checagens de `length(termos) == 0` e `length(listas) == 0` cobrem esses casos.
- O índice invertido guarda **quais** documentos contêm o termo, não **quantas vezes**. Essa decisão é intencional: para o BM25 (Módulo 6) a contagem será recuperada diretamente da matriz BoW do Módulo 2, que já tem essa informação.