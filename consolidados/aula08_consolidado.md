# Consolidado — PI III — Aula 08 — 2026-11-10
*guia versão 2 · tutora: Antigravity · sessão individual (teoria) · motor08*  
**Alunos:** Ivan Guimarães dos S. da Silva, Jorge Sugano Suzart e Gustavo Geminiano

## 1. O que foi passado
- **M1 — Dois estágios: recuperar muitos, reordenar poucos:** Arquitetura *retrieve & rerank*, onde o estágio 1 (modelo barato como BM25, LSA ou híbrido) pontua todos os $N$ documentos para entregar os $k$ candidatos com alto *recall* no top-$k$, e o estágio 2 (modelo caro e mais preciso) relê apenas esses $k$ candidatos para refinar a precisão no topo, mantendo a cauda intacta. No corpus do curso (`"modelo de recuperacao"`), com limiar $2$, os relevantes são `d3` ($1.^\circ$) e `d2` ($3.^\circ$): $\text{R@}2 = 0{,}5$ e $\text{R@}3 = 1{,}0$. Com limiar $1$ (`d1`, `d2`, `d3`, `d6`), $\text{R@}3 = 0{,}75$ e o menor $k$ que entrega todos ao estágio 2 é $k = 6$.
- **M2 — Pontuar cada lado separado × ler o par:** Demonstração experimental do caráter *bag of words* (saco de palavras) do BM25 e do LSA: ao inverter completamente a ordem dos tokens de `d2` (`rev(ix$tokens$d2)`), o escore do BM25 permanece inalterado (`1,687`). Contraste entre modelos que preparam pesos/vetores antes da consulta (BM25 e matriz `D` do LSA) e reordenadores que leem o par $(q, d)$ lado a lado (avaliando ordem e distância a um custo de $k$ leituras por consulta).
- **M3 — Um reordenador que lê os dois juntos: a proximidade ordenada:** Formulação matemática e implementação de `proximidade(qt, dt, janela = 3)` com `outer()`, `min()`, `&&` e laços aninhados:
  $$\text{prox}(q, d) = \sum_{\substack{i < j \\ t_i \neq t_j}} \frac{1}{\min \{\, p_j - p_i \;:\; 1 \le p_j - p_i \le w \,\}}$$
  Cálculo manual na consulta `"modelo de recuperacao"`: `d2` obtém $\text{prox} = 1{,}0$ (par `modelo` em $2$ e `de` em $3$, distância $1$), `d3` obtém $\text{prox} = 0{,}5$ (`modelo` em $4$ e `de` em $6$ e $8$, menor distância dentro da janela $w=3$ igual a $2 \to \frac{1}{2}$), e `d1` obtém $\text{prox} = 0{,}0$ (ordem invertida `recuperacao de`, distância $-1$). No `d2` embaralhado, a proximidade cai para $0$. Na consulta `"modelo de texto"`, `d3` soma $\frac{1}{2} + \frac{1}{1} = 1{,}5$ contra $1{,}0$ de `d2`.
- **M4 — Reordenar o top-$k$ e medir: o estágio 1 limita o estágio 2:** Implementação de `reordenar(rk, k, sc)` usando `order(-sc[top], seq_along(top))` (preservando a ordem do estágio 1 em caso de empate) e índice negativo `names(rk)[-(1:k)]` para manter a cauda intacta. Com $k = 2$, `d2` (em $3.^\circ$) fica fora da cabeça e o ranking não muda ($\text{AP} = 0{,}833$); com $k = 3$, `d2` entra na cabeça e sobe para $1.^\circ$ (`d2 d3 d1 d4 d8 d6 d5 d7`), elevando $\text{AP}$ de $0{,}833$ para $1{,}000$ e $\text{nDCG}_{\text{grad}}$ de $0{,}951$ para $0{,}982$.
- **M5 — Os limites do brinquedo e os reordenadores neurais:** Análise das limitações da proximidade literal em `"vetores de documentos"` (`d2`, que diz *"documentos como vetores"*, recebe $0$ e cai para $3.^\circ$ atrás de `d1` e `d6`, que empatam com $0{,}333$) e `"documentos busca"` (todos com $0$). Conceito de *cross-encoders* neurais, que leem o par $(q, d)$ conjuntamente e aprendem flexões (`ordena` $\times$ `ordenar`), sinônimos e inversões sintáticas a partir de milhões de pares rotulados, sendo restritos ao estágio 2 pelo alto custo computacional por par.
- **M6 — Latência × qualidade: $k$ é hiperparâmetro:** Análise do *trade-off* entre custo (número de leituras do par $k$) e qualidade ($\text{AP}$): de $k = 3$ a $k = 8$ o $\text{AP}$ permanece em $1{,}000$, demonstrando que aumentar $k$ além do necessário multiplica o custo e expõe o topo a promoções indevidas de documentos da cauda. $k$ e janela $w$ são hiperparâmetros escolhidos no conjunto de desenvolvimento (`dev`) e relatados uma única vez no `teste`.

## 2. Como foi o aprendizado — opinião da tutora
O aluno realizou todos os cálculos manuais de posição e distância com exatidão antes de executar os blocos no R. Compreendeu de imediato a diferença estrutural entre representações pré-computadas por documento (BM25 e LSA) e escores que dependem da interação direta entre os tokens da consulta e do documento, identificando corretamente que distâncias negativas correspondem à inversão da ordem dos termos (`d1`) e que apenas a menor distância positiva dentro da janela $w$ contribui para cada par distinto da consulta. No Módulo 4, aplicou corretamente a regra de desempate pela posição original do estágio 1 (`seq_along(top)`) no Checkpoint 4 (`d1 d6 d2 d5 d3 d8 d4 d7`) e diagnosticou com clareza o limite léxico da proximidade ordenada frente a paráfrases e flexões verbais.

**Teste final:** Acertou M1, M2, M3, M4, M5 e M6 — 100% de aproveitamento:
- M1: O relevante permanece em $80.^\circ$, pois está na cauda intacta fora do top-$50$ e o estágio 2 nunca o lê.
- M2: A entrada do reordenador é o par $(q, d)$, cujo escore depende das posições relativas dos termos da consulta em cada documento, não existindo vetor estático de documento pré-calculável.
- M3: Para `"modelo vetorial"` em `d2`, $5 - 2 = 3 \le 3 \to \frac{1}{3} \approx 0{,}333$; para `"vetorial modelo"`, a distância é $-3 < 0 \to 0$.
- M4: Com $k = 3$, o ranking final é `B C A D E` (B e C empatam com $0{,}9$ mantendo a ordem do estágio 1; D tem escore $5$, mas está na posição $4$ fora da cabeça).
- M5: `"informacao recuperacao"` em `d1` resulta em $0$ pela inversão da ordem literal; um *cross-encoder* treinado reconhece a equivalência semântica e posiciona `d1` no topo.
- M6: Escolhe-se $k = 10$ (mesmo $\text{MAP} = 0{,}64$ que $k = 20$ com metade do custo de leitura); não se pode consultar o conjunto de teste para desempatar.

## 3. Observações para a frente
- **Revisar antes da Aula 09:** Como combinar múltiplos sinais de ranqueamento (BM25, LSA e proximidade ordenada) em um modelo linear de *learning to rank* com pesos ajustados a partir dos julgamentos de relevância.
- **Para a próxima tutora:** Aluno com excelente domínio de indexação vetorial e manipulação de funções de ordem superior em R base.
- **Perguntas guardadas:** Como combinar escore léxico (BM25) e escore de proximidade sem depender apenas de reordenação pura do topo — encaminhada para a Aula 09 (*Learning to Rank*).
- **Produzido:** Funções `proximidade()` e `reordenar()`; ranking do BM25 reordenado com $k = 3$: `d2 d3 d1 d4 d8 d6 d5 d7`.
- **Parte D (sessão de grupo):** Aplicada ao corpus real da Baixada Santista ($N = 132$) com atualização da ficha do projeto e do `config.R`.

---

<!-- estado-R:inicio -->
## Estado do R ao fim da sessão
*gerado por `anexar_estado()` em 2026-11-10 11:17 · R version 4.6.1 (2026-06-24 ucrt) · motor08 v2 2026-10-22 · não edite à mão*

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
| `cfg$modelo` | character | 1 | bm25 |
| `cfg$lsa_k` | numeric | 1 | 2 |
| `cfg$rrf_c` | numeric | 1 | 60 |
| `docs` | character, nomeado | 8 | d1 recuperacao de informacao o..., d2 o modelo de espaco vetorial..., d3 bm25 e um modelo probabilis..., d4 aprendizado estatistico fun..., d5 o indice invertido acelera ..., d6 embeddings capturam a seman..., ... |
| `docs2` | character, nomeado | 8 | d1 recuperacao de informacao o..., d2 vetores como documentos rep..., d3 bm25 e um modelo probabilis..., d4 aprendizado estatistico fun..., d5 o indice invertido acelera ..., d6 embeddings capturam a seman..., ... |
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
| `ix2$tokens` | list | 8 | elementos: d1, d2, d3, d4, d5, d6, d7, d8 |
| `ix2$vocab` | character | 45 | a, acelera, aprendizado, avaliacao, bm25, busca, ... |
| `ix2$tf` | matrix | 45 × 8 | linhas: a, acelera, aprendizado, ... \| colunas: d1, d2, d3, d4, ... |
| `ix2$N` | integer | 1 | 8 |
| `ix2$df` | numeric, nomeado | 45 | a 4, acelera 1, aprendizado 1, avaliacao 1, bm25 1, busca 2, ... |
| `ix2$idf_tfidf` | numeric, nomeado | 45 | a 0.6931, acelera 2.079, aprendizado 2.079, avaliacao 2.079, bm25 2.079, busca 1.386, ... |
| `ix2$w` | matrix | 45 × 8 | linhas: a, acelera, aprendizado, ... \| colunas: d1, d2, d3, d4, ... |
| `ix2$wn` | matrix | 45 × 8 | linhas: a, acelera, aprendizado, ... \| colunas: d1, d2, d3, d4, ... |
| `ix2$postings` | list | 45 | elementos: recuperacao, de, informacao, ordena, documentos, por, relevancia, vetores, ... |
| `ix2$dl` | numeric, nomeado | 8 | d1 7, d2 9, d3 9, d4 6, d5 9, d6 8, ... |
| `ix2$avgdl` | numeric | 1 | 8 |
| `ix2$idf_bm25` | numeric, nomeado | 45 | a 0.6931, acelera 1.792, aprendizado 1.792, avaliacao 1.792, bm25 1.792, busca 1.281, ... |
| `MOTOR_VERSAO` | character | 1 | motor08 v2 2026-10-22 |
| `px` | numeric, nomeado | 8 | d1 0, d2 1, d3 0.5, d4 0, d5 0, d6 0, ... |
| `qt` | character | 3 | modelo, de, recuperacao |
| `r$rel` | integer | 8 | 1, 0, 1, 0, 0, 0, ... |
| `r$g` | numeric | 8 | 2, 1, 2, 0, 0, 1, ... |
| `r$R` | integer | 1 | 2 |
| `r1$rel` | integer | 8 | 1, 1, 1, 0, 0, 1, ... |
| `r1$g` | numeric | 8 | 2, 1, 2, 0, 0, 1, ... |
| `r1$R` | integer | 1 | 4 |
| `rb` | numeric, nomeado | 8 | d3 1.873, d1 1.869, d2 1.687, d4 1.427, d8 0.519, d6 0.4925, ... |

### Funções definidas

`anexar_estado`, `ap`, `bm25`, `bm25_doc`, `busca_AND`, `busca_booleana`, `cfg_aula`, `cosseno`, `dcg`, `docs_aula`, `estado`, `gabarito_aula`, `idf_bm25`, `idf_classico`, `indice_invertido`, `kappa_cohen`, `kappa_matriz`, `ler_qrels`, `limpar`, `lsa`, `matriz_tf`, `metricas`, `montar`, `ndcg`, `norm_cols`, `precisao_k`, `preparar`, `prf`, `proximidade`, `ranking_bm25`, `ranking_cosseno`, `ranking_lsa`, `ranking_vetor`, `recall_k`, `relevancia`, `reordenar`, `residual`, `rocchio`, `rr`, `rrf`, `saturacao`, `sem_stop`, `stopwords_aula`, `tokenizar`, `vetor_consulta`
<!-- estado-R:fim -->

