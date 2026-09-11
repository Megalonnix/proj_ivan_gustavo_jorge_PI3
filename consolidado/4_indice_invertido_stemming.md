# **Módulo 4 — Índice Invertido + Stemming + Buscas Booleanas**

## Objetivo
Construir um índice invertido com pseudo-radicais (via `SnowballC`) e implementar buscas booleanas **AND** e **OR** sobre o corpus.

## Arquivo
`estrutura/scriptsR/4_indice_invertido_stemming.R`

## Funções

- `construir_indice_invertido(docs)` — percorre cada documento, aplica `processar_texto()` (stemming + stopwords PT) e registra o doc_id em cada pseudo-radical.
- `buscar_AND(consulta, indice)` — `Reduce(intersect, ...)` sobre as listas dos termos da consulta.
- `buscar_OR(consulta, indice)` — `Reduce(union, ...)`.
- `tabela_indice(postings)` — `data.frame` com Radical / Frequência / Documentos, ordenado alfabeticamente.

## Saída completa do script

```
============================================================
FASE 1 — Corpus de teste (gato / peixe / carne)
============================================================

-- Postings --
gat  : doc1 doc2
peix : doc1 doc2
com  : doc1 doc2 doc3

-- Buscas booleanas --
AND ('peixe gato') : doc1 doc2
OR  ('gato comeu') : doc1 doc2 doc3

-- Tabela --
        Radical Frequencia_Docs       Documentos
cachorr cachorr               1             doc3
carn       carn               1             doc3
com         com               3 doc1, doc2, doc3
gat         gat               2       doc1, doc2
peix       peix               2       doc1, doc2

============================================================
FASE 2 — Corpus da Aula 01 (8 documentos do professor)
============================================================

-- Postings --
recuperaca : d1 d4
acel       : d5
captur     : d6

-- Buscas booleanas --
AND ('modelo probabilistico') : d3
OR  ('modelo probabilistico') : d2 d3

-- Tabela (10 primeiros) --
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

============================================================
FASE 3 — Notícias da A Tribuna (opcional)
============================================================

[SKIP] Arquivo não encontrado:
       estrutura/bancoDeDados/noticias_santos.csv
      Rode o módulo 5 (webscraping) para gerar os CSVs,
      ou copie-os do projeto antigo para essa pasta.
```

A FASE 3 só imprimirá os postings reais (`sant`, `funcionari`, etc.) se o CSV estiver presente em `estrutura/bancoDeDados/`.

## Observações

- O stemming do `SnowballC` para português é agressivo; alguns pseudo-radicais ficam estranhos (ex.: `"terçafeir"`, `"cã"`), o que é normal e esperado.
- Vale considerar um filtro de comprimento mínimo de token (≥ 3) em iterações futuras.