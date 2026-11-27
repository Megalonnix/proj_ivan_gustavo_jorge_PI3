# Consolidado — PI III — Aula 08 — Tema 7 (combinar escores) — 2026-11-26
*guia do tema 7 versão 1 · tutora: Gemini 4 Hydrogen · motor09*
**Aluno / grupo:** ivan_gustavo_jorge (Ivan Guimarães dos S. da Silva, Gustavo Geminiano e Jorge Sugano Suzart)

## 1. O que foi passado
- **M1 — Notas em escalas diferentes e o min-max:** O BM25 ($[0;\, 1{,}873]$) e o cosseno do LSA ($[-0{,}039;\, 1{,}000]$) operam em escalas incompatíveis; somados crus, quem tem amplitude maior domina (`d4` fica em $4.^\circ$ com $1{,}523$). A normalização *min-max* projeta cada lista em $[0, 1]$ dentro da consulta, alinhando os vetores pelo vetor de nomes `d`. À mão para `d1` em `"modelo de recuperacao"`, obtivemos $\text{mm}_{\text{BM25}} = 0{,}998$, $\text{mm}_{\text{LSA}} = 0{,}420$ e $S(\text{d1}) = 1{,}417$. Nos 8 documentos, a fusão elevou $\text{AP}$ de $0{,}833$ para $1{,}000$ e $\text{nDCG}_{\text{grad}}$ para $0{,}990$. No Checkpoint 1 (`"ranqueamento"`), conferimos $S(\text{d2}) = 0{,}963$ e $S(\text{d3}) = 2{,}000$.
- **M2 — *z-score*, LSA negativo e normalização por consulta:** O *z-score* mede desvios-padrão acima da média da consulta ($z(s_d) = (s_d - \mu)/\sigma$), mantendo cossenos negativos apenas como valores abaixo da média (sem zerar antes de normalizar). Em `"modelo de recuperacao"`, `d3` soma $1{,}090 + 0{,}875 = 1{,}965$ e `d7` fica em $-2{,}715$. Mostrou-se que min, max, $\mu$ e $\sigma$ dependem estritamente da consulta e do conjunto normalizado, e que consultas fora do vocabulário exigem a guarda `if (max(s) == min(s)) return(s * 0)` contra `NaN`. No Checkpoint 2, o acerto isolado ($3{,}0$ contra sete zeros) atingiu $z = 2{,}475$ contra $1$ do *min-max*, pesando mais no *z-score*.
- **M3 — Notas $\times$ posições e os pesos:** Com os 8 documentos e o gabarito, *min-max*, *z-score* e RRF empatam ($\text{AP} = 1{,}000$, $\text{nDCG}_{\text{grad}} = 0{,}990$). A diferença surge em empates no zero: em `"ranqueamento"`, a RRF coloca `d1` em $3.^\circ$ ($1/62 + 1/66 = 0{,}0313$) pela posição arbitrária do corpus, enquanto a fusão por notas mantém os empatados iguais e o deixa em $6.^\circ$ ($0{,}325$ do LSA). Com `fundir(..., alfa)`, variamos $\alpha \in \{0, 0{,}2, 0{,}5, 0{,}8, 1\}$ e reforçamos que $\alpha$ não se escolhe em uma única consulta.
- **M4 — Experimento no corpus do grupo:** Feito sobre os $N = 132$ parágrafos da Baixada Santista com o estágio 1 homologado (`cfg$modelo = "bm25"`, `cfg$lsa_k = 20`). No desenvolvimento ($q_{01}..q_{08}$), o BM25 puro obteve $\text{MAP}_{\text{dev}} = 0{,}744$ ($\text{nDCG}_{\text{grad}} = 0{,}940$). Na grade com $k = 10$, obtivemos para $\alpha = 0{,}2$ ($0{,}738$ no *min-max*; $0{,}739$ no *z-score*), $\alpha = 0{,}5$ ($0{,}743$ em ambos) e $\alpha = 0{,}8$ ($0{,}743$ em ambos), perdendo em $q_{04}$ (*"clima na Baixada Santista"*: $\text{AP}$ caiu de $0{,}766$ para $0{,}761$). No conjunto de teste ($q_{09}..q_{12}$), o estágio 1 `bm25` manteve $\text{MAP}_{\text{teste}} = 0{,}718$ ($\text{nDCG}_{\text{grad}} = 0{,}927$).

## 2. Como foi o aprendizado — opinião da tutora
Conduzi os quatro módulos na ordem prevista, conferindo as contas à mão e validando os alinhamentos por nome (`[d]`) para evitar soma posicional silenciosa. Ficou consolidado por que uma única consulta não serve para fixar $\alpha$, por que o "1" do *min-max* não é comparável entre consultas e por que o empate no zero expõe a diferença entre RRF e fusão por escores. No experimento do grupo, a escolha conservadora pelo conjunto de desenvolvimento confirmou que o BM25 puro supera a fusão com LSA ($k = 20$), mantendo a coerência com as decisões anteriores do projeto.

**Teste final:** acertou M1, M2, M3 e M4; a revisar nenhum.

## 3. Observações para a frente
- **Revisar:** verificar se a reordenação por notas com $\alpha$ mais alto ($0{,}85$–$0{,}95$) ou outro $k$ de LSA altera o empate no desenvolvimento sem degradar $q_{04}$.
- **Perguntas guardadas:** Como aprender os pesos $\alpha$ automaticamente a partir de atributos de consulta e documento? — Aula 09 (*learning to rank*).
- **Produzido:** `minmax`, `zscore`, `fundir`; no corpus do grupo (`bm25` como estágio 1, `lsa_k = 20`), nenhuma combinação na grade de desenvolvimento superou o BM25 puro ($\text{MAP}_{\text{dev}} = 0{,}744$ contra $0{,}743$ em $\alpha \in \{0{,}5, 0{,}8\}$ e $0{,}738$–$0{,}739$ em $\alpha = 0{,}2$), mantendo-se `bm25` em produção ($\text{MAP}_{\text{teste}} = 0{,}718$).

---

<!-- estado-R:inicio -->
## Estado do R ao fim da sessão
*gerado por `anexar_estado()` em 2026-11-27 02:01 · R version 4.6.1 (2026-06-24) · motor08 v2 2026-10-22 · não edite à mão*

### Objetos

| objeto | tipo | tamanho | valor / amostra |
|---|---|---|---|
| `antes$q01` | numeric, nomeado | 132 | 13 5.12, 55 4.268, 114 0.8364, 87 0.8257, 83 0.8167, 99 0.8124, ... |
| `antes$q02` | numeric, nomeado | 132 | 87 3.9, 89 3.314, 31 3.188, 88 3.188, 47 3.175, 58 3.013, ... |
| `antes$q03` | numeric, nomeado | 132 | 2 5.958, 20 5.268, 19 4.654, 6 3.874, 18 3.738, 29 2.96, ... |
| `antes$q04` | numeric, nomeado | 132 | 63 5.531, 148 5.377, 129 5.315, 85 4.893, 76 4.824, 70 4.743, ... |
| `antes$q05` | numeric, nomeado | 132 | 129 3.492, 40 3.394, 53 3.31, 78 3.303, 50 3.101, 57 2.85, ... |
| `antes$q06` | numeric, nomeado | 132 | 132 10.83, 10 4.694, 131 4.649, 50 4.461, 42 3.49, 139 3.158, ... |
| `antes$q07` | numeric, nomeado | 132 | 79 4.624, 130 4.329, 46 3.954, 61 3.891, 38 3.873, 41 3.133, ... |
| `antes$q08` | numeric, nomeado | 132 | 19 7.221, 33 6.053, 102 5.734, 104 5.253, 138 5.004, 150 4.855, ... |
| `base_raw` | character | 1 | https://raw.githubuserconte... |
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
| `cfg$rerank_k` | numeric | 1 | 0 |
| `cfg$janela` | numeric | 1 | 3 |
| `consultas` | character, nomeado | 12 | q01 fundação de Santos, q02 porto de Santos, q03 praias de Guarujá, q04 clima na Baixada Santista, q05 população de Santos, q06 origem do nome Bertioga, ... |
| `cp` | data.frame | 132 × 5 | colunas: id, titulo, texto, data, url |
| `dev` | character | 8 | q01, q02, q03, q04, q05, q06, ... |
| `docs` | character, nomeado | 132 | 1 Guarujá é um município bras..., 2 Atualmente, a cidade de Gua..., 3 Guarujá é um dos quinze mun..., 5 A Ilha de Santo Amaro surge..., 6 Os primeiros habitantes for..., 7 Após a era dos sambaquis, a..., ... |
| `grade` | matrix | 3 × 2 | linhas: 0.2, 0.5, 0.8 \| colunas: minmax, zscore |
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
| `m$U` | matrix | 3493 × 20 | linhas: 0, 000, 000e, ... \| colunas: (sem nomes) |
| `m$S` | numeric | 20 | 73.7, 66.63, 56.37, 55.67, 53.67, 52.62, ... |
| `m$D` | matrix | 132 × 20 | linhas: 1, 2, 3, ... \| colunas: (sem nomes) |
| `MOTOR_VERSAO` | character | 1 | motor08 v2 2026-10-22 |
| `nec` | data.frame | 12 × 5 | colunas: consulta, texto_consulta, necessidade, escopo, conjunto |
| `ok09` | logical | 1 | FALSE |
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
| `teste` | character | 4 | q09, q10, q11, q12 |
| `usar` | character | 12 | q01, q02, q03, q04, q05, q06, ... |

### Funções definidas

`anexar_estado`, `ap`, `bm25`, `bm25_doc`, `busca_AND`, `busca_booleana`, `cfg_aula`, `cosseno`, `dcg`, `docs_aula`, `estado`, `estagio1`, `fundir`, `fusao`, `gabarito_aula`, `idf_bm25`, `idf_classico`, `indice_invertido`, `kappa_cohen`, `kappa_matriz`, `ler_qrels`, `limpar`, `lsa`, `matriz_tf`, `medir`, `metricas`, `minmax`, `montar`, `ndcg`, `norm_cols`, `precisao_k`, `preparar`, `prf`, `ranking_bm25`, `ranking_cosseno`, `ranking_lsa`, `ranking_vetor`, `recall_k`, `relevancia`, `reordenar`, `residual`, `rocchio`, `rr`, `rrf`, `saturacao`, `sem_stop`, `stopwords_aula`, `tokenizar`, `vetor_consulta`, `zscore`
<!-- estado-R:fim -->

