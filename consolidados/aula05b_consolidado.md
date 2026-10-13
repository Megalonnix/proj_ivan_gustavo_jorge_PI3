# Consolidado — PI III — Aula 5,5 — 2026-10-13
*guia versão 3 · tutora: Antigravity · sessão individual (teoria) · motor05b*  
**Alunos:** Ivan Guimarães dos S. da Silva, Jorge Sugano Suzart e Gustavo Geminiano

## 1. O que foi passado
- **M1 — Ranking, gabarito e limiar viram `rel`:** Alinhamento posicional do ranking devolvido pelo sistema com o vetor binário de relevância `rel` a partir do limiar declarado (grau $\ge 2$). Construção exata para o BM25 (`1 0 1 0 0 0 0 0`) e para o Cosseno (`0 1 0 1 0 0 0 0`).
- **M2 — Precisão e Recall:** Formulação analítica das duas perguntas fundamentais: precisão (fração do que foi mostrado que presta, denominador visível ao usuário) e recall (fração do acervo relevante que foi recuperado, dependente do gabarito).
- **M3 — O corte @$k$:** Introdução do ponto de truncamento operacional $k$ para avaliar listas ranqueadas contínuas sem exigir separação rígida de conjunto.
- **M4 — P@$k$ e R@$k$ (o dente de serra):** Computação vetorizada com `cumsum()`. Identificação do perfil em dente de serra na precisão (sobe nos acertos, decai nos falsos positivos) frente ao crescimento estritamente monótono em degraus do recall.
- **M5 — Average Precision (AP) e MAP:** Dedução da precisão média nas posições onde caem documentos relevantes, dividida pelo total de relevantes $R$ do gabarito (o que penaliza omissões). $\text{AP}_{\text{BM25}} = 0{,}833$ vs $\text{AP}_{\text{Cosseno}} = 0{,}500$.
- **M6 — Mean Reciprocal Rank (MRR):** Inverso da posição do primeiro documento relevante via $1 / \text{rank}_1$ com `which()`. $\text{MRR}_{\text{BM25}} = 1{,}000$ (relevante em $k=1$) vs $\text{MRR}_{\text{Cosseno}} = 0{,}500$ (relevante em $k=2$).
- **M7 — nDCG com desconto logarítmico:** Aplicação da penalidade posicional suave $\frac{1}{\log_2(i+1)}$. Cálculo manual de $\text{DCG} = 1{,}500$, $\text{IDCG} = 1{,}631$ e $\text{nDCG}_{\text{bin}} = 0{,}920$ no BM25 (contra $0{,}651$ no cosseno).
- **M8 — nDCG graduado e comparação lado a lado:** Aproveitamento dos graus multiníveis (0, 1 e 2). $\text{nDCG}_{\text{grad}} = 0{,}951$ no BM25 e $0{,}837$ no cosseno. Demonstração de que o nDCG graduado nem sempre supera o binário quando itens de relevância intermediária caem no fim da lista.
- **M9 — Escolha de métricas e as três armadilhas:** Análise crítica sobre a variância amostral de uma única consulta, a baixa capacidade de discriminação em corpora minúsculos de 8 documentos, e a necessidade de testes estatísticos formais (Aula 16) antes de declarar superioridade entre sistemas com pequenas diferenças de MAP.

## 2. Como foi o aprendizado — opinião da tutora
O aluno demonstrou notável precisão analítica e excelente domínio formal de todas as métricas de avaliação de recuperação de informação. Construiu o vetor `rel` sem confundir posições do ranking com identificadores de documentos, calculou P@$k$ e R@$k$ à mão com agilidade e compreendeu de imediato a razão pela qual o AP divide por $R$ e não pela contagem de parcelas não-nulas. Ao calcular o DCG e nDCG, realizou os descontos logarítmicos passo a passo na calculadora sem tropeçar no $+1$ do denominador, e interpretou com maturidade o fato de o nDCG graduado subir no BM25 (ao reconhecer $d_1$ e $d_6$ como grau 1) enquanto penalizaria o sistema caso itens parciais estivessem mal posicionados. Compreendeu plenamente as três armadilhas de avaliação, mantendo ceticismo metodológico diante das notas elevadas obtidas sobre o toy corpus.

**Teste final:** Acertou 100% das questões (Módulos 1, 2, 3, 4, 5, 6, 7, 8 e 9). Você sabe medir e interpretar o desempenho de um ranking com absoluto rigor.

## 3. Observações para a frente
- **Revisar antes da Aula 06:** Compreender a transição em que o gabarito deixa de ser apenas régua externa de avaliação e passa a atuar como entrada do algoritmo de retroalimentação por relevância de Rocchio.
- **Para a próxima tutora:** Aluno com raciocínio matemático rápido, excelente interpretação de código funcional em R (`cumsum`, `seq_along`, `which`) e senso crítico apurado sobre significância estatística.
- **Perguntas guardadas:** Curva contínua de precisão-recall interpolada (fora do escopo da aula); testes de hipótese pareados t de Student / Wilcoxon para comparar sistemas em 50 tópicos (Aula 16).
- **Produzido:** As cinco métricas do BM25 ($\text{P@}3 = 0{,}667$, $\text{AP} = 0{,}833$, $\text{MRR} = 1{,}000$, $\text{nDCG}_{\text{bin}} = 0{,}920$, $\text{nDCG}_{\text{grad}} = 0{,}951$) e do Cosseno ($0{,}333$, $0{,}500$, $0{,}500$, $0{,}651$, $0{,}837$), todas conferidas analiticamente.
- **Parte D (sessão de grupo):** A marcar — leitura dos arquivos `qrels` do grupo com `ler_qrels()`, decisão do limiar no `config.R`, cálculo das 5 métricas nos dois modelos para as consultas reais do projeto e registro formal na ficha.

<!-- estado-R:inicio -->
<!-- gerado por motor05b v1 2026-10-01 em 2026-10-13 15:28:00 -->
| Objeto | Tipo | Tamanho | Amostra |
|---|---|---|---|
| `docs` | character, nomeado | 8 | d1 recuperacao de informacao ordena..., d2 o modelo de espaco vetorial repre..., d3 bm25 e um modelo probabilistico ..., d4 aprendizado estatistico fundament..., d5 o indice invertido acelera a busc..., d6 embeddings capturam a semantica d..., ... |
| `cfg` | list | 5 | elementos: limpar, acentos, stopwords, k1, b |
| `ix` | list | 11 | elementos: tokens, vocab, tf, N, df, idf_tfidf, w, wn, postings, dl, avgdl, idf_bm25 |
| `rel` | integer | 8 | 1, 0, 1, 0, 0, 0, 0, 0 |
| `rel_cos` | integer | 8 | 0, 1, 0, 1, 0, 0, 0, 0 |
| `tabela` | matrix | 2 × 8 | linhas: P_at_k, R_at_k \| colunas: k=1, k=2, k=3, k=4... |
| `ap_bm25` | numeric | 1 | 0.833 |
| `ap_cos` | numeric | 1 | 0.500 |
| `rr_bm25` | numeric | 1 | 1.000 |
| `rr_cos` | numeric | 1 | 0.500 |
| `ndcg_bm25_bin` | numeric | 1 | 0.920 |
| `ndcg_bm25_grad` | numeric | 1 | 0.951 |
| `tabela_final` | matrix | 2 × 5 | linhas: BM25, Cosseno \| colunas: P_at_3, AP, MRR, nDCG_bin, nDCG_grad |
<!-- estado-R:fim -->
