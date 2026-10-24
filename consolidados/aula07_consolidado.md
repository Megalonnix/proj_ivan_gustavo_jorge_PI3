# Consolidado — PI III — Aula 07 — 2026-10-23
*guia versão 2 · tutora: Antigravity · sessão individual (teoria) · motor07*  
**Alunos:** Ivan Guimarães dos S. da Silva, Jorge Sugano Suzart e Gustavo Geminiano

## 1. O que foi passado
- **M1 — Quando a palavra não bate: o descasamento de vocabulário:** Análise das limitações de modelos léxicos puros (TF-IDF e BM25) quando termos semanticamente equivalentes não coincidem com o vocabulário. Na consulta `"busca"`, apenas $d_5$ e $d_7$ pontuam, deixando $d_1$ ("recuperação de informação...") com escore zero; na consulta `"ranqueamento"`, apenas $d_3$ pontua e $d_1$ ("ordena documentos por relevância") fica com zero.
- **M2 — Esparso × denso, e a ideia de embedding:** Comparação entre o espaço vetorial esparso de 45 termos (onde $d_1$ possui pesos não-nulos em apenas 7 dimensões e termos sinônimos geram ortogonalidade com cosseno zero) e a representação densa contínua via *embeddings* latentes ("You shall know a word by the company it keeps", Firth, 1957).
- **M3 — LSA: a SVD da matriz TF-IDF:** Decomposição em valores singulares $W = U \Sigma V^\top \approx U_k \Sigma_k V_k^\top$ em R base com `svd()`. Com $k = 2$, captura-se $32{,}3\%$ da energia acumulada ($\sum_{i \le k} \sigma_i^2 / \sum_i \sigma_i^2$). Representação dos documentos pela matriz de coordenadas latentes $D = V_k \Sigma_k$ ($8 \times 2$), aproximando espacialmente $d_2$ e $d_3$ pelo termo latente `"modelo"`.
- **M4 — Dobrar a consulta, ranquear e medir; $k$ é hiperparâmetro:** Projeção da consulta no subespaço latente por *folding-in* ($\vec{q}_k = U_k^\top \vec{q}_0$). Implementação de `ranking_lsa()`. Na consulta `"modelo de recuperacao"`, $\vec{q}_k = (-0{,}370;\ 0{,}445)$ alinhou-se perfeitamente com $d_2$ e $d_3$ (top 1 e 2), obtendo $\text{AP} = 1{,}000$ e $\text{nDCG}_{\text{grad}} = 0{,}966$ (superando o AP $= 0{,}833$ do BM25 e $0{,}500$ do cosseno). Demonstração da sensibilidade ao hiperparâmetro $k$ ($k=2 \to 1{,}000$; $k=3 \to 0{,}750$; $k=4 \to 1{,}000$; $k=8 \to 0{,}500$ - retorno ao léxico).
- **M5 — Os limites do LSA:** Identificação do ruído e de relações inventadas em coleções pequenas. Na consulta `"ranqueamento"`, $d_8$ ("ciência de dados...") empata no topo com $d_3$ ($0{,}999$) tendo apenas as stopwords `"e"` e `"de"` em comum, pois a SVD em baixa dimensionalidade comprime ruídos coocorrentes. Aumento de $k=4$ restaura $d_3$ no topo ($0{,}998$).
- **M6 — Busca híbrida: a fusão RRF:** Implementação de Reciprocal Rank Fusion ($\text{RRF}(d) = \sum_r \frac{1}{c + \text{pos}_r(d)}$, $c = 60$). A RRF independe das escalas heterogêneas de escore. A fusão do ranking léxico BM25 com o ranking denso LSA ($k=2$) manteve $\text{AP} = 1{,}000$, $\text{RR} = 1{,}000$ e atingiu a maior pontuação global de $\text{nDCG}_{\text{grad}} = 0{,}990$, posicionando o documento relevante graduado $d_1$ no 3º lugar.

## 2. Como foi o aprendizado — opinião da tutora
O aluno demonstrou domínio conceitual e algébrico exemplar em todos os módulos da sessão teórica. Compreendeu perfeitamente o cálculo manual do *folding-in* de $\vec{q}_k$ e a geometria do cosseno em coordenadas com valores negativos. Não hesitou diante da aparente discrepância de sinais decorrente de reflexões de base ortogonal da SVD e identificou com precisão cirúrgica o mecanismo que gera relações inventadas em corpus diminuto. A implementação da RRF e a resolução do teste final transcorreram de forma impecável, estabelecendo base sólida para a transposição ao corpus real do projeto.

**Teste final:** Acertou 100% das questões (Módulos 1, 2, 3, 4, 5 e 6).
- M1: Resposta correta (vetor nulo, descasamento léxico entre "aprendizagem" e "aprendizado").
- M2: Resposta correta (35 zeros no TF-IDF esparso; 3 coordenadas no LSA com $k=3$).
- M3: Resposta correta ($36/42 = 0{,}857$, direção dominante concentrando $85{,}7\%$ da energia).
- M4: Resposta correta ($d_6$ tem cosseno maior pois ambas as coordenadas compartilham os sinais da consulta dobrada).
- M5: Resposta correta (poucas frases não separam contexto temático de palavras funcionais; $k=8$ sem compressão isola $d_3$).
- M6: Resposta correta (documento B fica à frente com escore $\text{RRF} = 0{,}0313$ vs $0{,}0307$ de A).

## 3. Observações para a frente
- **Revisar antes da Aula 08:** Compreender como a fusão RRF atenua discrepâncias e como a perda de ordem das palavras no LSA/BM25 motiva a reordenação local (*retrieve & rerank*).
- **Para a próxima tutora:** Aluno com excelente raciocínio matemático, facilidade com álgebra linear em R base e rigor na interpretação de métricas de avaliação.
- **Perguntas guardadas:** Reordenação do topo (Aula 08); arquiteturas neurais densas e RAG (Aulas 14 e 15).
- **Produzido:** Funções `lsa()`, `ranking_lsa()`, `rrf()`; cálculo da decomposição SVD e variância explicada; fusão de rankings híbrida no exemplo canônico.
- **Parte D (sessão de grupo):** Aplicação de LSA e busca híbrida no corpus real da Baixada Santista ($N=132$), avaliação em dev/teste e decisão dos parâmetros para `config.R`.

---

<!-- estado-R:inicio -->
## Estado do R ao fim da sessão
*gerado por `anexar_estado()` em 2026-10-23 11:39 · R version 4.2.2 (2022-10-31 ucrt) · motor07 v1 2026-10-15 · não edite à mão*

### Objetos

| objeto | tipo | tamanho | valor / amostra |
|---|---|---|---|
| `cfg$limpar` | logical | 1 | TRUE |
| `cfg$acentos` | character | 1 | manter |
| `cfg$stopwords` | character | 0 |  |
| `cfg$k1` | numeric | 1 | 1.2 |
| `cfg$b` | numeric | 1 | 0.75 |
| `cfg$limiar` | numeric | 1 | 2 |
| `cfg$prf_k` | numeric | 1 | 0 |
| `cfg$rocchio` | numeric, nomeado | 3 | a 1, b 0.75, g 0.15 |
| `docs` | character, nomeado | 8 | d1 recuperacao de informacao o..., d2 o modelo de espaco vetorial..., d3 bm25 e um modelo probabilis..., d4 aprendizado estatistico fun..., d5 o indice invertido acelera ..., d6 embeddings capturam a seman..., ... |
| `g` | numeric, nomeado | 8 | d1 1, d2 2, d3 2, d4 0, d5 0, d6 1, ... |
| `ix$tokens` | list | 8 | elementos: d1, d2, d3, d4, d5, d6, d7, d8 |
| `ix$vocab` | character | 45 | a, acelera, aprendizado, avaliacao, bm25, busca, ... |
| `ix$tf` | matrix | 45 × 8 | linhas: a, acelera, aprendizado, ... \| colunas: d1, d2, d3, d4, ... |
| `ix$N` | integer | 1 | 8 |
| `ix$df` | numeric, nomeado | 45 | a 4, acelera 1, aprendizado 1, avaliacao 1, bm25 1, busca 2, ... |
| `ix$idf_tfidf` | numeric, nomeado | 45 | a 0.6931, acelera 2.079, aprendizado 2.079, avaliacao 2.079, bm25 2.079, busca 1.386, ... |
| `ix$w` | matrix | 45 × 8 | linhas: a, acelera, aprendizado, ... \| colunas: d1, d2, d3, d4, ... |
| `ix$wn` | matrix | 45 × 8 | linhas: a, acelera, aprendizado, ... \| colunas: d1, d2, d3, d4, ... |
| `ix$postings` | list | 45 | elementos: recuperacao, de, informacao, ordena, documentos, por, relevancia, o, ... |
| `ix$dl` | numeric, nomeado | 8 | d1 7, d2 9, d3 9, d4 6, d5 9, d6 8, ... |
| `ix$avgdl` | numeric | 1 | 8 |
| `ix$idf_bm25` | numeric, nomeado | 45 | a 0.6931, acelera 1.792, aprendizado 1.792, avaliacao 1.792, bm25 1.792, busca 1.281, ... |
| `m` | matrix | 5 × 3 | linhas: P_at_k, AP, RR, ... \| colunas: (sem nomes) |
| `m2$U` | matrix | 45 × 2 | linhas: a, acelera, aprendizado, ... \| colunas: (sem nomes) |
| `m2$S` | numeric | 2 | 5.602, 5.313 |
| `m2$D` | matrix | 8 × 2 | linhas: d1, d2, d3, ... \| colunas: (sem nomes) |
| `MOTOR_VERSAO` | character | 1 | motor07 v1 2026-10-15 |
| `q0` | numeric, nomeado | 45 | a 0, acelera 0, aprendizado 0, avaliacao 0, bm25 0, busca 0, ... |
| `qk` | matrix | 2 × 1 | linhas: (sem nomes) \| colunas: (sem nomes) |
| `r2` | numeric, nomeado | 8 | d2 1, d3 0.9596, d8 0.9596, d6 0.8999, d5 0.4736, d1 0.3971, ... |
| `rb` | numeric, nomeado | 8 | d3 1.873, d1 1.869, d2 1.687, d4 1.427, d8 0.519, d6 0.4925, ... |
| `REPO_DIR` | character | 1 | C:/Users/lab31/.gemini/anti... |
| `rh` | numeric, nomeado | 8 | d3 0.03252, d2 0.03227, d1 0.03128, d8 0.03126, d6 0.03078, d4 0.03055, ... |

### Funções definidas

`anexar_estado`, `ap`, `bm25`, `bm25_doc`, `busca_AND`, `busca_booleana`, `cfg_aula`, `cosseno`, `dcg`, `docs_aula`, `estado`, `gabarito_aula`, `idf_bm25`, `idf_classico`, `indice_invertido`, `kappa_cohen`, `kappa_matriz`, `ler_qrels`, `limpar`, `lsa`, `matriz_tf`, `metricas`, `montar`, `ndcg`, `norm_cols`, `precisao_k`, `preparar`, `prf`, `ranking_bm25`, `ranking_cosseno`, `ranking_lsa`, `ranking_vetor`, `recall_k`, `relevancia`, `residual`, `rocchio`, `rr`, `rrf`, `saturacao`, `sem_stop`, `stopwords_aula`, `tokenizar`, `vetor_consulta`
<!-- estado-R:fim -->
