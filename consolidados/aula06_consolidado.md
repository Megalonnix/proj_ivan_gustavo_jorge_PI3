# Consolidado — PI III — Aula 06 — 2026-10-13
*guia versão 1 · tutora: Antigravity · sessão individual (teoria) · motor06*  
**Alunos:** Ivan Guimarães dos S. da Silva, Jorge Sugano Suzart e Gustavo Geminiano

## 1. O que foi passado
- **M1 — O ciclo de realimentação:** Análise do ranking base do cosseno com AP $= 0{,}500$; identificação no top-4 dos relevantes $D_r = \{d2, d3\}$ e do não-relevante intrusivo $D_{nr} = \{d4\}$.
- **M2 — A consulta como vetor e centroide:** Projeção da consulta no espaço vetorial TF-IDF de 45 dimensões; cálculo do centroide $\vec{c}_r = \frac{1}{|D_r|}\sum \vec{d}$ via `rowMeans()` com `drop = FALSE` para garantir consistência de matriz.
- **M3 — A fórmula de Rocchio e expansão de consulta:** Aplicação de $\vec{q}_m = \alpha\vec{q}_0 + \beta\vec{c}_r - \gamma\vec{c}_{nr}$ ($\\alpha = 1, \beta = 0{,}75, \gamma = 0{,}15$). Expansão de consulta de 3 para 21 termos; emergência de pesos negativos para os termos de $d_4$ (ex.: `aprendizado`, `estatistico` com peso $-0{,}312$).
- **M4 — O novo ranking vetorial:** Implementação de `ranking_vetor()`; promoção de $d_2$ para o 2º lugar e expulsão de $d_4$ para o último com cosseno negativo ($-0{,}060$). Salto do AP de $0{,}500$ para $1{,}000$ e nDCG graduado para $1{,}000$.
- **M5 — Avaliação na coleção residual:** Exclusão honesta de $D_r \cup D_{nr}$ do ranking e do gabarito. Com limiar 2, $R = 0$ resulta em AP `NA`; com limiar 1, a ordenação dos documentos não vistos empata perfeitamente (AP $= 1{,}000$ em ambos), demonstrando que o salto anterior vinha de reordenar itens já conhecidos.
- **M6 — Pseudo-realimentação (PRF) e query drift:** Realimentação cega automática: com $k = 2$ ($D_r = \{d1, d3\}$), o AP salta para $0{,}833$ sem intervenção humana; com $k = 3$, a inclusão acidental do irrelevante $d_4$ contamina a consulta, gerando *query drift* (AP cai para $0{,}750$).

## 2. Como foi o aprendizado — opinião da tutora
O aluno demonstrou excelente desenvoltura técnica e sólida compreensão algébrica ao longo de toda a sessão. Realizou o cálculo analítico do peso de `modelo` ($2{,}426$) e `recuperacao` ($1{,}178$) sem dificuldades, antecipou com precisão a razão geométrica do cosseno negativo e não caiu na armadilha de considerar o AP $= 1{,}000$ como prova definitiva de eficácia do modelo antes de avaliar a coleção residual. Na análise de pseudo-realimentação, compreendeu de imediato o risco de *query drift*, demonstrando por que valores conservadores de $k$ e $\beta$ são mandatórios na prática.

**Teste final:** Acertou 100% das questões (Módulos 1, 2, 3, 4, 5 e 6). Você domina a mecânica e os limites da realimentação de relevância e expansão de consultas.

## 3. Observações para a frente
- **Revisar antes da Aula 07:** O Rocchio expande consultas apenas com o vocabulário explícito do corpus. A Aula 07 supera essa limitação lexical ao introduzir *embeddings* e representações semânticas densas, conectando sinônimos ausentes no texto de busca.
- **Para a próxima tutora:** Aluno com excelente intuição geométrica, raciocínio rápido para operações matriciais em R e compreensão clara de boas práticas metodológicas de avaliação residual.
- **Perguntas guardadas:** Expansão de consultas via Modelos de Linguagem Neurais (aula futura); testes estatísticos pareados para confirmar ganhos de PRF (Aula 16).
- **Produzido:** Funções `rocchio` e `ranking_vetor`; novo ranking com AP $= 1{,}000$; diagnóstico na coleção residual; experimentação de PRF com $k = 2$, $k = 3$ e $k = 1$.
- **Parte D (sessão de grupo):** A marcar — aplicação do Rocchio e teste de PRF sobre o gabarito real do projeto (`qrels_jorge_2026-10-13.csv`), comparando os ganhos com o baseline e decidindo se a PRF será incorporada ao `config.R`.

<!-- estado-R:inicio -->
<!-- gerado por motor06 v1 2026-10-01 em 2026-10-13 15:48:00 -->
| Objeto | Tipo | Tamanho | Amostra |
|---|---|---|---|
| `docs` | character, nomeado | 8 | d1 recuperacao de informacao ordena..., d2 o modelo de espaco vetorial repre..., d3 bm25 e um modelo probabilistico ..., d4 aprendizado estatistico fundament..., d5 o indice invertido acelera a busc..., d6 embeddings capturam a semantica d..., ... |
| `cfg` | list | 6 | elementos: limpar, acentos, stopwords, k1, b, limiar |
| `ix` | list | 11 | elementos: tokens, vocab, tf, N, df, idf_tfidf, w, wn, postings, dl, avgdl, idf_bm25 |
| `q0` | numeric, nomeado | 45 | de 0.470, modelo 1.386, recuperacao 1.386, ... |
| `qm` | numeric, nomeado | 45 | modelo 2.426, recuperacao 1.178, de 0.999, bm25 0.780, ... |
| `base` | numeric, nomeado | 8 | d1 0.254, d3 0.233, d4 0.215, d2 0.208, d6 0.025, d8 0.023, d5 0.000, d7 0.000 |
| `novo` | numeric, nomeado | 8 | d3 0.650, d2 0.643, d1 0.140, d6 0.055, d8 0.045, d5 0.041, d7 -0.007, d4 -0.060 |
| `r_prf2` | numeric, nomeado | 8 | d3 0.648, d1 0.575, d2 0.175, d4 0.161, d6 0.062, d8 0.047, d7 0.037, d5 0.010 |
<!-- estado-R:fim -->
