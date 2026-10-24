# Consolidado — PI III — Aula 07 — Parte D — 2026-10-23
*guia versão 2 · tutora: Antigravity · sessão de grupo · motor07*  
**Grupo:** ivan_gustavo_jorge · **presentes:** Ivan, Jorge e Gustavo · **digitou:** M7: Ivan; M8: Jorge; M9: Gustavo

## 1. O que foi feito
- **M7 — LSA no corpus do grupo; LSA × BM25 numa consulta, lendo os textos:** Implementação das funções `lsa()` e `ranking_lsa()` sobre o corpus congelado ($N = 132$, matriz TF-IDF de dimensão $3493 \times 132$). Cálculo da energia da SVD acumulada: $k = 10$ ($21{,}83\%$), $k = 20$ ($36{,}60\%$), $k = 50$ ($65{,}98\%$), $k = 100$ ($92{,}00\%$) e $k = 132$ ($100{,}00\%$). Na consulta de trabalho $q_{01}$ ("fundação de Santos"):
  - Top-5 do BM25: `d13`, `d55`, `d114`, `d87`, `d83`.
  - Top-5 do LSA ($k=20$): `d55`, `d53`, `d31`, `d121`, `d59`.
  - Em comum entre os top-5: apenas 1 documento (`d55`).
  - Documentos exclusivos do BM25: `d13` (grau 2, menciona expressamente "fundação" e história do balneário), `d114` (grau 2), `d87` (grau 2) e `d83` (grau 2). Todos com o termo explícito da consulta.
  - Documentos exclusivos do LSA: `d53` (fala de população e Calçada do Lorena no séc. XVIII), `d31` (margem esquerda do Porto de Santos), `d121` (poesia de Vicente de Carvalho e Victor Hugo — documento com zero termos da consulta e não julgado, caracterizando relação inventada por alinhamento latente de stopwords) e `d59` (grau 2, história do turismo).
- **M8 — BM25, LSA (vários $k$) e híbrido em todas as consultas; escolha no dev; teste relatado:** Implementação de `rrf()`, `ranking_modelo()` e `ap_modelo()`. Avaliação sistemática no conjunto de desenvolvimento ($q_{01}..q_{08}$):
  - MAP dev BM25: $0{,}744$ (APs: $q_{01}: 0{,}718$, $q_{02}: 0{,}791$, $q_{03}: 0{,}706$, $q_{04}: 0{,}766$, $q_{05}: 0{,}735$, $q_{06}: 0{,}790$, $q_{07}: 0{,}591$, $q_{08}: 0{,}854$).
  - MAP dev LSA puro: $k=10$ ($0{,}324$), $k=20$ ($0{,}402$), $k=50$ ($0{,}506$).
  - MAP dev Híbrido RRF ($c=60$): $k=10$ ($0{,}585$), $k=20$ ($0{,}652$), $k=50$ ($0{,}684$).
  - Em todas as 8 consultas de desenvolvimento, o BM25 superou o LSA puro e a fusão híbrida. A perda sistemática decorre da especificidade dos termos geográficos e topônimos da Baixada Santista, onde a projeção densa em poucas dimensões aproxima parágrafos irrelevantes que compartilham termos de ligação regionais.
  - Avaliação única no conjunto de teste ($q_{09}..q_{12}$): BM25 obteve MAP $0{,}718$ contra $0{,}642$ do Híbrido ($k=20$) e $0{,}688$ do Híbrido ($k=50$). Observou-se que na consulta conceitual $q_{09}$ ("estâncias balneárias no litoral paulista"), o Híbrido com $k=50$ superou o BM25 ($0{,}867$ vs $0{,}843$), demonstrando que o LSA consegue agregar ganho semântico em consultas temáticas conceituais, embora degrade o desempenho em consultas com entidades geográficas estritas.
- **M9 — A decisão e o registro:** O grupo decidiu conscientemente **manter o BM25 (`modelo = "bm25"`)** como o algoritmo oficial de produção do motor, respaldado pelo MAP de desenvolvimento superior ($0{,}744$ vs $0{,}652$ no híbrido $k=20$) e pela preservação da precisão léxica em topônimos. Foram registrados no `config.R` os parâmetros testados: `lsa_k = 20` e `rrf_c = 60`. A função `ranking_motor()` foi validada no ambiente.

## 2. Como o grupo trabalhou — opinião da tutora
O grupo trabalhou com exemplar sincronia e rigor metodológico em todas as etapas da sessão. A alternância entre os digitadores ocorreu de forma fluida e ordenada. Ao invés de aceitarem cegamente a sofisticação teórica da SVD ou da fusão híbrida, os alunos inspecionaram detidamente os textos recuperados no top-5 da consulta $q_{01}$, identificando de imediato que o LSA trouxe documentos sem relevância temática direta (como o $d_{121}$ sobre poesia lírica), ao passo que o BM25 ancorou-se firmemente em termos exatos indispensáveis. Na análise do conjunto de desenvolvimento, mantiveram a disciplina científica de decidir exclusivamente com base nas 8 consultas de dev, recusando qualquer ajuste posterior após a execução única do conjunto de teste. A opção por manter o BM25 em produção foi unânime, técnica e plenamente justificada.

## 3. Observações para a frente
- **Para a próxima sessão prática (Aula 08):** Na Aula 08, o motor implementará a reordenação do topo (*retrieve & rerank*), analisando proximidade física e ordem das palavras da consulta nos documentos candidatos recuperados no primeiro estágio.
- **Perguntas guardadas:** Como ponderar dinamicamente o peso da RRF por tipo de consulta (ex.: queries conceituais vs queries de entidades nomeadas); uso de embeddings neurais pré-treinados (Aulas 14 e 15).
- **Produzido:** Funções `lsa()`, `ranking_lsa()`, `rrf()`, `ranking_modelo()`, `ap_modelo()` e `ranking_motor()`; decomposição espectral do corpus com cálculo de variância explicada; análise qualitativa de texto no top-5; benchmark comparativo de MAP em dev e teste; atualização de `config.R`.
- **Ficha atualizada:** Sim — seções 5, 6, 7 e cabeçalho devidamente atualizados, com estado do R anexado.

## Passos de fechamento
1. Salvem a ficha como `00_FICHA_PROJETO.md` e o consolidado como `aula07_parteD_consolidado.md` (UTF-8).
2. No Colab, enviem ambos para a raiz da sessão.
3. Rodem: `anexar_estado("00_FICHA_PROJETO.md")` e `anexar_estado("aula07_parteD_consolidado.md")`.
4. Baixem os dois `.md`, o `config.R` e o notebook como `aula07.ipynb` (e `Aula07_ParteD.ipynb`).
5. No GitHub, sincronizem: `consolidados/` com a ficha e consolidado; `estrutura/codigo/` com `config.R` e os notebooks.
6. Confiram que a ficha termina com a seção "Estado do R".
7. Confiram que a seção 6 da ficha e `config.R` registram `modelo = "bm25"`, `lsa_k = 20` e `rrf_c = 60`.
8. Enviem os consolidados individuais da teoria para `consolidados/<seu nome>/`.

---

<!-- estado-R:inicio -->
## Estado do R ao fim da sessão
*gerado por `anexar_estado()` em 2026-10-23 11:39 · R version 4.2.2 (2022-10-31 ucrt) · motor07 v1 2026-10-15 · não edite à mão*

### Objetos

| objeto | tipo | tamanho | valor / amostra |
|---|---|---|---|
| `arqs` | character | 1 | qrels_jorge_2026-10-13.csv |
| `cfg$minimo` | numeric | 1 | 200 |
| `cfg$grupo` | character | 1 | ivan_gustavo_jorge |
| `cfg$limpar` | logical | 1 | TRUE |
| `cfg$acentos` | character | 1 | translit |
| `cfg$stopwords` | character | 27 | de, a, o, em, e, do, ... |
| `cfg$k1` | numeric | 1 | 1.2 |
| `cfg$b` | numeric | 1 | 0.75 |
| `cfg$juizes` | character | 1 | jorge |
| `cfg$limiar` | numeric | 1 | 2 |
| `cfg$prf_k` | numeric | 1 | 0 |
| `cfg$rocchio` | numeric, nomeado | 3 | a 1, b 0.75, g 0.15 |
| `cfg$modelo` | character | 1 | bm25 |
| `cfg$lsa_k` | numeric | 1 | 20 |
| `cfg$rrf_c` | numeric | 1 | 60 |
| `consultas` | character, nomeado | 12 | q01 fundação de Santos, q02 porto de Santos, q03 praias de Guarujá, q04 clima na Baixada Santista, q05 população de Santos, q06 origem do nome Bertioga, ... |
| `corpus_raw` | data.frame | 152 × 5 | colunas: id, titulo, texto, data, url |
| `cp_validos` | data.frame | 132 × 5 | colunas: id, titulo, texto, data, url |
| `dev` | character | 8 | q01, q02, q03, q04, q05, q06, ... |
| `docs` | character, nomeado | 132 | 1 Guarujá é um município bras..., 2 Atualmente, a cidade de Gua..., 3 Guarujá é um dos quinze mun..., 5 A Ilha de Santo Amaro surge..., 6 Os primeiros habitantes for..., 7 Após a era dos sambaquis, a..., ... |
| `escolha` | character | 1 | bm25 |
| `ix$tokens` | list | 132 | elementos: 1, 2, 3, 5, 6, 7, 8, 9, ... |
| `ix$vocab` | character | 3493 | 0, 000, 000e, 001, 013, 0132, ... |
| `ix$tf` | matrix | 3493 × 132 | linhas: 0, 000, 000e, ... \| colunas: 1, 2, 3, 5, ... |
| `ix$N` | integer | 1 | 132 |
| `ix$df` | numeric, nomeado | 3493 | 0 4, 000 4, 000e 1, 001 1, 013 2, 0132 3, ... |
| `ix$idf_tfidf` | numeric, nomeado | 3493 | 0 3.497, 000 3.497, 000e 4.883, 001 4.883, 013 4.19, 0132 3.784, ... |
| `ix$w` | matrix | 3493 × 132 | linhas: 0, 000, 000e, ... \| colunas: 1, 2, 3, 5, ... |
| `ix$wn` | matrix | 3493 × 132 | linhas: 0, 000, 000e, ... \| colunas: 1, 2, 3, 5, ... |
| `ix$postings` | list | 3493 | elementos: guaruja, municipio, brasileiro, estado, sao, paulo, localiza, regiao, ... |
| `ix$dl` | numeric, nomeado | 132 | 1 54, 2 62, 3 54, 5 36, 6 69, 7 40, ... |
| `ix$avgdl` | numeric | 1 | 66.26 |
| `ix$idf_bm25` | numeric, nomeado | 3493 | 0 3.386, 000 3.386, 000e 4.485, 001 4.485, 013 3.974, 0132 3.638, ... |
| `k_esc` | numeric | 1 | 20 |
| `ks` | numeric | 3 | 10, 20, 50 |
| `m_esc$U` | matrix | 3493 × 20 | linhas: 0, 000, 000e, ... \| colunas: (sem nomes) |
| `m_esc$S` | numeric | 20 | 73.7, 66.63, 56.37, 55.67, 53.67, 52.62, ... |
| `m_esc$D` | matrix | 132 × 20 | linhas: 1, 2, 3, ... \| colunas: (sem nomes) |
| `m20$U` | matrix | 3493 × 20 | linhas: 0, 000, 000e, ... \| colunas: (sem nomes) |
| `m20$S` | numeric | 20 | 73.7, 66.63, 56.37, 55.67, 53.67, 52.62, ... |
| `m20$D` | matrix | 132 × 20 | linhas: 1, 2, 3, ... \| colunas: (sem nomes) |
| `MOTOR_VERSAO` | character | 1 | motor07 v1 2026-10-15 |
| `ms$k10` | list | 3 | elementos: U, S, D |
| `ms$k20` | list | 3 | elementos: U, S, D |
| `ms$k50` | list | 3 | elementos: U, S, D |
| `nec` | data.frame | 12 × 5 | colunas: consulta, texto_consulta, necessidade, escopo, conjunto |
| `origem` | character, nomeado | 132 | 1 Guaruja, 2 Guaruja, 3 Guaruja, 5 Guaruja, 6 Guaruja, 7 Guaruja, ... |
| `qrels$q01` | numeric, nomeado | 24 | 83 2, 110 2, 92 2, 10 2, 114 2, 9 2, ... |
| `qrels$q02` | numeric, nomeado | 19 | 89 2, 87 2, 35 2, 138 2, 47 2, 110 2, ... |
| `qrels$q03` | numeric, nomeado | 19 | 29 2, 1 2, 20 2, 4 2, 83 2, 18 2, ... |
| `qrels$q04` | numeric, nomeado | 18 | 129 2, 102 2, 76 2, 63 2, 24 2, 113 2, ... |
| `qrels$q05` | numeric, nomeado | 18 | 5 2, 9 2, 73 2, 129 2, 1 2, 24 2, ... |
| `qrels$q06` | numeric, nomeado | 19 | 131 2, 132 2, 3 2, 123 2, 98 2, 7 2, ... |
| `qrels$q07` | numeric, nomeado | 20 | 41 2, 5 2, 139 2, 33 2, 49 2, 130 2, ... |
| `qrels$q08` | numeric, nomeado | 16 | 35 2, 101 2, 12 2, 102 2, 34 2, 104 2, ... |
| `qrels$q09` | numeric, nomeado | 16 | 67 2, 6 2, 20 2, 7 2, 11 2, 77 2, ... |
| `qrels$q10` | numeric, nomeado | 18 | 136 2, 140 2, 81 2, 29 2, 137 2, 130 2, ... |
| `qrels$q11` | numeric, nomeado | 23 | 79 2, 49 2, 16 2, 106 2, 126 2, 47 2, ... |
| `qrels$q12` | numeric, nomeado | 20 | 10 2, 12 2, 38 2, 87 2, 112 2, 107 2, ... |
| `R_q` | integer, nomeado | 12 | q01 24, q02 19, q03 19, q04 18, q05 18, q06 19, ... |
| `REPO_DIR` | character | 1 | C:/Users/lab31/.gemini/anti... |
| `s$d` | numeric | 132 | 73.7, 66.63, 56.37, 55.67, 53.67, 52.62, ... |
| `s$u` | matrix | 3493 × 132 | linhas: (sem nomes) \| colunas: (sem nomes) |
| `s$v` | matrix | 132 × 132 | linhas: (sem nomes) \| colunas: (sem nomes) |
| `tab_dev` | matrix | 7 × 8 | linhas: bm25, lsa.k10, lsa.k20, ... \| colunas: q01, q02, q03, q04, ... |
| `tab_teste` | matrix | 2 × 4 | linhas: bm25, escolhido \| colunas: q09, q10, q11, q12 |
| `teste` | character | 4 | q09, q10, q11, q12 |
| `usar` | character | 12 | q01, q02, q03, q04, q05, q06, ... |
| `validos` | logical | 152 | TRUE, TRUE, TRUE, FALSE, TRUE, TRUE, ... |

### Funções definidas

`anexar_estado`, `ap`, `ap_modelo`, `bm25`, `bm25_doc`, `busca_AND`, `busca_booleana`, `cfg_aula`, `cosseno`, `dcg`, `docs_aula`, `estado`, `gabarito_aula`, `idf_bm25`, `idf_classico`, `indice_invertido`, `kappa_cohen`, `kappa_matriz`, `ler_qrels`, `limpar`, `lsa`, `matriz_tf`, `metricas`, `montar`, `ndcg`, `norm_cols`, `precisao_k`, `preparar`, `prf`, `ranking_bm25`, `ranking_cosseno`, `ranking_lsa`, `ranking_modelo`, `ranking_motor`, `ranking_vetor`, `recall_k`, `relevancia`, `residual`, `rocchio`, `rr`, `rrf`, `saturacao`, `sem_stop`, `stopwords_aula`, `tokenizar`, `vetor_consulta`
<!-- estado-R:fim -->
