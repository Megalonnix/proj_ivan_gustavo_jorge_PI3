# Consolidado — PI III — Aula 02 — 2026-10-13
*guia versão 3 — tutora: Antigravity — sessão individual (teoria) — motor02*  
**Alunos:** Ivan Guimarães dos S. da Silva, Jorge Sugano Suzart e Gustavo Geminiano

## 1. O que foi passado
- **M1 — Por que somar pesos não ordena:** Favorece documentos longos e repetições vazias sem medir proximidade angular.
- **M2 — Espaço vetorial:** Termos como dimensões ortogonais e documentos como vetores com pesos TF-IDF.
- **M3 — Produto escalar:** Mede sobreposição de termos entre consulta e documento, mas ainda sofre com a escala e tamanho do documento.
- **M4 — Norma Euclidiana:** Comprimento vetorial $\sqrt{\sum w_i^2}$. $d_1$ possui a maior norma ($13{,}82$) entre os documentos da aula devido a termos de alto IDF.
- **M5 — Similaridade do Cosseno:** Normalização pelo produto das normas $\frac{\mathbf{q} \cdot \mathbf{d}}{\|\mathbf{q}\| \|\mathbf{d}\|}$, variando entre 0 e 1 para pesos não-negativos.
- **M6 — Matriz com colunas unitárias (`wn`):** Normalização prévia de cada coluna por sua norma euclidiana, reduzindo o cálculo do cosseno a uma única multiplicação matricial direta `t(wn) %*% qw / norm(qw)`.
- **M7 — Vetor da consulta:** Ponderação dos termos da consulta multiplicando suas contagens pelo IDF correspondente da coleção.
- **M8 — Ranking por similaridade:** Ranqueamento contínuo dos documentos por score de cosseno decrescente.

## 2. Decisões do aluno e justificativas
- **Uso do Cosseno:** O modelo vetorial de cosseno resolve a distorção de tamanho documental sem penalizar termos relevantes raros.
- **Colunas Unitárias:** Normalizar a matriz TF-IDF previamente otimiza a latência computacional do ranqueamento.

## 3. Próximos passos
- Conectar o modelo vetorial de cosseno ao corpus do grupo na Parte D e validar nas 3 consultas de trabalho.

<!-- estado-R:inicio -->
<!-- gerado por motor02 v1 2026-10-01 em 2026-10-13 14:00:00 -->
| Objeto | Tipo | Tamanho | Amostra |
|---|---|---|---|
| `docs` | character, nomeado | 8 | d1 recuperacao de informacao ordena..., d2 o modelo de espaco vetorial repre..., d3 bm25 e um modelo probabilistico ..., d4 aprendizado estatistico fundament..., d5 o indice invertido acelera a busc..., d6 embeddings capturam a semantica d..., ... |
| `cfg` | list | 0 | elementos: |
| `ix` | list | 7 | elementos: tokens, vocab, tf, N, df, idf_tfidf, w |
| `w` | matrix | 36 × 8 | linhas: a, acelera, aprendizado... \| colunas: d1, d2, d3, d4... |
| `wn` | matrix | 36 × 8 | linhas: a, acelera, aprendizado... \| colunas: d1, d2, d3, d4... |
| `normas` | numeric, nomeado | 8 | d1 13.82, d2 12.11, d3 12.45, d4 11.20, d5 11.85, d6 11.90, ... |
| `s` | numeric, nomeado | 8 | d1 0.415, d4 0.285, d7 0.120, d2 0.000, d3 0.000, d5 0.000, ... |
<!-- estado-R:fim -->
