# Consolidado — PI III — Aula 04 — 2026-10-13
*guia versão 3 · tutora: Antigravity · sessão individual (teoria) · motor04*  
**Alunos:** Ivan Guimarães dos S. da Silva, Jorge Sugano Suzart e Gustavo Geminiano

## 1. O que foi passado
- **M1 — Limites do TF-IDF:** Demonstração dos dois defeitos clássicos: crescimento linear da frequência (10 ocorrências pesando dez vezes uma ocorrência) e viés de comprimento acumulativo sem princípio probabilístico.
- **M2 — A distribuição de Poisson:** Modelagem de contagem discreta de termos raros com taxa média $\lambda$; cálculo da dispersão para $\lambda = 2$ e $\lambda = 3$ via $P(X = f) = \frac{e^{-\lambda}\lambda^f}{f!}$.
- **M3 — Burstiness (Rajadas):** Comprovação empírica de que palavras de conteúdo ocorrem em rajadas; uma Poisson única subestima em $216\times$ a probabilidade de $f = 6$ em relação a um modelo de mistura com população elite.
- **M4 — Eliteness e formulação probabilística:** Dedução da razão de verossimilhanças $w(f) = \log\frac{P(f \mid R)}{P(f \mid \bar{R})}$ sob as classes latentes Elite ($E$) e Não-Elite ($\bar{E}$) ponderadas por $p = P(E \mid R)$ e $q = P(E \mid \bar{R})$.
- **M5 — Saturação assintótica 2-Poisson:** A saturação emerge naturalmente sem ser forçada: cálculo de $w(0) = -0{,}7304$, teto cru $1{,}7918$ e teto normalizado $2{,}5221$. A partir de $f \ge 3$, o ganho marginal de evidência congela no teto.
- **M6 — Aproximação hiperbólica de Robertson:** Demonstração da inviabilidade prática de estimar 4 parâmetros latentes por termo; adoção da curva hiperbólica $w(f) \approx \text{IDF}(t) \cdot \frac{f(k_1+1)}{f+k_1}$, que preserva as 4 propriedades qualitativas fundamentais (nulidade em zero, monotonicidade, concavidade e saturação finita).
- **M7 — A fórmula do BM25 ($k_1$, $b$ e $K$):** Introdução do fator de normalização de tamanho $K = k_1(1 - b + b \frac{|d|}{\text{avgdl}})$; interpolação $b = 0{,}75$ entre verbosidade e escopo documental.
- **M8 — O IDF do BM25:** Formulação da razão de chances suavizada $\text{IDF}(t) = \log\left(\frac{N - \text{df}_t + 0{,}5}{\text{df}_t + 0{,}5} + 1\right)$; papel dos $+0{,}5$ (suavização RSJ) e do $+1$ para impedir pesos negativos em termos frequentes.
- **M9 — Implementação canônica em R (`bm25_doc`):** Construção da função vetorial em R com proteção `if (f == 0) next` para evitar $0/0 = \text{NaN}$; ranking oficial para `"modelo de recuperacao"`: $d_3$ ($1{,}873$) $>$ $d_1$ ($1{,}869$) $>$ $d_2$ ($1{,}687$) $>$ $d_4$ ($1{,}427$) $>$ $d_8$ ($0{,}519$) $>$ $d_6$ ($0{,}492$) $>$ $d_5, d_7$ ($0{,}000$); sensibilidade a $k_1$ e $b$ verificada.

## 2. Como foi o aprendizado — opinião da tutora
O aluno apresentou excelente rigor analítico e sólida fluência matemática ao longo de toda a dedução do BM25. No Módulo 2, calculou rapidamente as probabilidades da Poisson sem hesitação. Ao analisar *burstiness*, compreendeu de imediato a diferença conceitual entre uma distribuição simples e uma mistura populacional. Na conta de saturação do Módulo 5, distinguiu com clareza o teto cru ($1{,}7918$) do teto normalizado ($2{,}5221$), entendendo a necessidade de subtrair $w(0)$ para que a ausência do termo tenha contribuição neutra. No Módulo 6, aceitou com facilidade o compromisso de engenharia da aproximação de Robertson em vez de insistir em derivações algébricas puras. Na implementação em R, deduziu o cálculo manual de $d_2 = 1{,}687$ com precisão na calculadora e identificou prontamente por que a remoção da guarda `if (f == 0) next` gera contaminação por `NaN` no caso limite $k_1 = 0$.

**Teste final:** Acertou 100% das questões (Módulos 1, 2, 3, 4, 5, 6, 7, 8 e 9). Você construiu o BM25 do zero, compreendendo cada termo de sua equação.

## 3. Observações para a frente
- **Revisar antes da Aula 05:** Compreender que o cosseno e o BM25 geram ordenações distintas ($d_1$ lidera no cosseno, enquanto $d_3$ lidera no BM25). A decisão de qual modelo é superior exige a construção de um gabarito de relevância na Aula 05 e avaliação por métricas formais (MAP e nDCG) na Aula 5,5.
- **Para a próxima tutora:** Aluno com excelente base estatística, cálculo analítico ágil e boa percepção das decisões de engenharia de software em R.
- **Perguntas guardadas:** Critérios de avaliação formal de modelos de ranqueamento (Aula 05/5,5); aplicação de BM25 ponderado no índice invertido (Aula 04 Parte D e Aula 05).
- **Produzido:** Ranking oficial BM25 implementado; cálculo de $d_2 = 1{,}687$ conferido analiticamente; análise de sensibilidade com $k_1 = 0{,}5$, $b = 0$ e $k_1 = 0$.
- **Parte D (sessão de grupo):** A marcar — execução do BM25 sobre o corpus real da Baixada Santista (`wikipedia_baixada_santista.csv`), comparação direta com o cosseno nas três consultas de trabalho, e calibração de $k_1$ e $b$ no `config.R`.

<!-- estado-R:inicio -->
<!-- gerado por motor04 v1 2026-10-01 em 2026-10-13 15:18:00 -->
| Objeto | Tipo | Tamanho | Amostra |
|---|---|---|---|
| `docs` | character, nomeado | 8 | d1 recuperacao de informacao ordena..., d2 o modelo de espaco vetorial repre..., d3 bm25 e um modelo probabilistico ..., d4 aprendizado estatistico fundament..., d5 o indice invertido acelera a busc..., d6 embeddings capturam a semantica d..., ... |
| `cfg` | list | 3 | elementos: limpar, acentos, stopwords |
| `ix` | list | 9 | elementos: tokens, vocab, tf, N, df, idf_tfidf, w, wn, postings |
| `dl` | numeric, nomeado | 8 | d1 7, d2 9, d3 9, d4 6, d5 9, d6 8, d7 9, d8 7 |
| `avgdl` | numeric | 1 | 8 |
| `idf_b` | numeric, nomeado | 45 | modelo 1.281, de 0.492, recuperacao 1.281, documentos 0.693, ... |
| `scores` | numeric, nomeado | 8 | d3 1.873, d1 1.869, d2 1.687, d4 1.427, d8 0.519, d6 0.492, d5 0.000, d7 0.000 |
<!-- estado-R:fim -->
