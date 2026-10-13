# Consolidado — PI III — Aula 00 — 2026-10-12
*guia versão 3 · tutora: Antigravity · sessão individual (teoria) · sem motor*
**Aluno:** Ivan Guimarães dos S. da Silva, Jorge Sugano Suzart e Gustavo Geminiano 

## 1. O que foi passado
- M1 — Colab em R confirmado (`1 + 1` → `[1] 2`); `<-`, o corpus `docs` como vetor de 8; `[1]` como índice; R começa em 1; `docs[0]` devolve vetor vazio, não erro; vetorização
- M2 — nomes; `[ ]` preserva o nome, `[[ ]]` não; `==` e o nome que "gruda" no `TRUE`
- M3 — `nchar` versus `length` (58 vs 1); `toupper`/`tolower`; `substr`; `paste`/`paste0`/`collapse`
- M4 — `strsplit` (lista), `unlist`; a simetria `strsplit` + `paste(collapse)`
- M5 — funções; última expressão devolvida; escreveu `tokenizar`, `maiuscula` e `dobro`
- M6 — `lapply` (lista) e `sapply` (tenta simplificar); `sum`, `list`; `tokens`
- M7 — `table`; `factor(levels = …)` fixa categorias e zeros; `sort`; `%in%`, `!` e o filtro
- M8 — matriz por coluna; reciclagem em `m * peso`; o warning de múltiplo
- M9 — regex I: `grep`/`grepl`, `^ $ | [ ] +`; pedaço não é palavra (`grep("de", docs)`)
- M10 — regex II: `sub`/`gsub`, `. * {n} {n,} [^ ]`, `trimws`, o pipeline de limpeza; `tokenizar` com `\s+`
- M11 — o mapa da Aula 01

## 2. Como foi o aprendizado — opinião da tutora
O aluno realizou a transição de Python para R de forma integral. A apreensão dos conceitos centrais foi imediata: compreendeu a indexação base-1, a mecânica de vetores nomeados e a distinção fundamental entre contagem de caracteres (`nchar`) e comprimento de vetores (`length`). Na manipulação funcional, dominou a simetria entre `strsplit` e `unlist`, assim como a regra de simplificação do `sapply` versus `lapply`. A reciclagem matricial por colunas em `m * peso` e a fixação de vocabulário com zeros através de `factor(levels = vocab)` foram assimiladas com total clareza. Na análise de texto por expressões regulares, assimilou o princípio de que regex avalia pedaços sequenciais e não palavras isoladas, consolidando a necessidade do pipeline de higienização de 4 passos.

**Teste final:** acertou M1, M2, M3, M4, M5, M6, M7, M8, M9, M10 e M11 (100% de aproveitamento nas 11 questões).

## 3. Observações para a frente
- **Revisar antes da Aula 01:** A construção da matriz termo-documento via `sapply` empilhando tabelas com categorias pré-fixadas por `factor(levels = vocab)` e o produto matricial com reciclagem (`tdm * idf`).
- **Para a próxima tutora:** Perfil com sólida intuição analítica; assimilação direta através de código executável com previsões assertivas. Não requer explicações conceituais prolixas.
- **Perguntas guardadas:** Ponderação IDF e matriz termo-documento formal (Aula 01); tratamento sistemático de acentos, plurais e stopwords (Aula 03).
- **Produzido:** Corpus canônico `docs`; funções `tokenizar` (versão `\s+`), `maiuscula` e `dobro`; objetos `tokens`, `vocab`, `m`, `peso` e o pipeline de higienização em 4 etapas. Previsões certas: 35 de 35.
- **Parte D (frases próprias + Colab e GitHub):** Pronta para execução.

---

<!-- estado-R:inicio -->
## Estado do R ao fim da sessão
*gerado por `anexar_estado()` em 2026-10-12 20:16 · R version 4.6.1 (2026-06-24) · sem motor · não edite à mão*

### Objetos

| objeto | tipo | tamanho | valor / amostra |
|---|---|---|---|
| `docs` | character, nomeado | 8 | d1 recuperacao de informacao o..., d2 o modelo de espaco vetorial..., d3 bm25 e um modelo probabilis..., d4 aprendizado estatistico fun..., d5 o indice invertido acelera ..., d6 embeddings capturam a seman..., ... |
| `frase` | character | 1 | recuperacao de informacao |
| `m` | matrix | 2 × 2 | linhas: de, modelo | colunas: d1, d2 |
| `peso` | numeric | 2 | 1, 10 |
| `tokens` | list | 8 | elementos: d1, d2, d3, d4, d5, d6, d7, d8 |
| `tokens$d1` | character | 7 | recuperacao, de, informacao, ordena, documentos, por, relevancia |
| `tokens$d2` | character | 9 | o, modelo, de, espaco, vetorial, representa, documentos, como, vetores |
| `tokens$d3` | character | 9 | bm25, e, um, modelo, probabilistico, de, ranqueamento, de, texto |
| `tokens$d4` | character | 6 | aprendizado, estatistico, fundamenta, a, recuperacao, moderna |
| `tokens$d5` | character | 9 | o, indice, invertido, acelera, a, busca, em, muitos, documentos |
| `tokens$d6` | character | 8 | embeddings, capturam, a, semantica, de, palavras, e, documentos |
| `tokens$d7` | character | 9 | a, avaliacao, mede, a, relevancia, dos, resultados, da, busca |
| `tokens$d8` | character | 7 | ciencia, de, dados, combina, estatistica, e, programacao |
| `vocab` | character | 3 | de, modelo, busca |
| `x_limpo` | character | 1 | o modelo de espaco vetorial |

### Funções definidas

`anexar_estado`, `dobro`, `estado`, `maiuscula`, `tokenizar`
<!-- estado-R:fim -->
