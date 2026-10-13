# Consolidado — PI III — Aula 01 — 2026-10-12
*guia versão 4 · tutora: Antigravity · sessão individual (teoria) · motor01*
**Alunos:** Ivan Guimarães dos S. da Silva, Jorge Sugano Suzart e Gustavo Geminiano

## 1. O que foi passado
- M1 — o que é RI; relevância vs. igualdade; lista ordenada vs. conjunto; consulta como aproximação
- M2 — retrieve & rerank; por que R; arquitetura de dois estágios e repositório
- M3 — o corpus canônico de 8 documentos como vetor nomeado (`docs`)
- M4 — tokenização com a função `tokenizar` do motor01; lista de tokens (`tokens`)
- M5 — vocabulário global (45 termos distintos via `unique` e `sort`) e análise de frequências
- M6 — matriz termo-documento $45 \times 8$ com uniformização via `factor(levels = vocab)`
- M7 — busca booleana funcional (`busca_booleana`) e evidência da ausência de ordenação
- M8 — teoria da ponderação: TF, IDF e $\log(N/\text{df})$; prova de que termo em todos os documentos pesa zero
- M9 — implementação do TF-IDF em R com reciclagem vetorial em `tdm * idf`
- M10 — divergência estrutural: regex casa pedaço, motor casa termo; transição para o corpus real e chunking

## 2. Como foi o aprendizado — opinião da tutora
A sessão teórica da Aula 01 foi executada com precisão. O aluno compreendeu as bases conceituais de Recuperação de Informação e a separação clara em relação aos bancos de dados relacionais. A representação vetorial em R foi dominada com agilidade: a geração da Matriz Termo-Documento $45 \times 8$ consolidou a importância de pré-fixar as categorias via `factor(tk, levels = vocab)` para permitir que o `sapply` empilhasse as colunas de forma homogênea. A limitação intrínseca da busca booleana foi identificada prontamente, justificando a transição para a métrica TF-IDF. O entendimento da fórmula $\text{tf}_{t,d} \times \log(N/\text{df}_t)$ foi exato, inclusive ao reconhecer por que termos universais recebem peso nulo ($\log(8/8) = 0$). A multiplicação matricial por reciclagem em `tdm * idf` foi demonstrada e validada matematicamente.

**Teste final:** acertou os módulos 1, 2, 3, 4, 5, 6, 7, 8, 9 e 10 (100% de aproveitamento nas 10 questões avaliadas).

## 3. Observações para a frente
- **Revisar antes da Aula 1,5:** O fundamento de teoria da informação para a presença do logaritmo na fórmula do IDF e a preparação para o espaço vetorial com distância de cosseno na Aula 02.
- **Para a próxima tutora:** Aluno assimila regras de computação vetorial com extrema naturalidade; prefere ver a matriz operando diretamente e comparar números concretos em vez de abstrações.
- **Perguntas guardadas:** Similaridade do cosseno e ranqueamento angular (Aula 02); tratamento de stopwords e lematização/stemming (Aula 03); modelo probabilístico BM25 (Aula 04).
- **Produzido:** Matriz TDM $45 \times 8$; matriz TF-IDF $45 \times 8$; pesos inspecionados para "de", "documentos", "recuperacao", "bm25" e "modelo"; motor de busca booleana testado com `intersect`.
- **Parte D (sessão de grupo):** Pronta para início com a escolha do corpus real da Baixada Santista e a criação da ficha do projeto (`00_FICHA_PROJETO.md`).

---

<!-- estado-R:inicio -->
## Estado do R ao fim da sessão
*gerado por `anexar_estado()` em 2026-10-12 20:28 · R version 4.6.1 (2026-06-24) · motor01 · não edite à mão*

### Objetos

| objeto | tipo | tamanho | valor / amostra |
|---|---|---|---|
| `df` | integer, nomeado | 45 | a 3, acelera 1, aprendizado 1, avaliacao 1, bm25 1, busca 2, ... |
| `docs` | character, nomeado | 8 | d1 recuperacao de informacao o..., d2 o modelo de espaco vetorial..., d3 bm25 e um modelo probabilis..., d4 aprendizado estatistico fun..., d5 o indice invertido acelera ..., d6 embeddings capturam a seman..., ... |
| `freq` | table, nomeado | 45 | de 6, a 5, documentos 4, e 3, busca 2, modelo 2, ... |
| `idf` | numeric, nomeado | 45 | a 0.9808, acelera 2.0794, aprendizado 2.0794, avaliacao 2.0794, bm25 2.0794, busca 1.3863, ... |
| `N` | integer | 1 | 8 |
| `tdm` | matrix | 45 × 8 | linhas: a, acelera, aprendizado | colunas: d1, d2, d3, d4 |
| `tfidf` | matrix | 45 × 8 | linhas: a, acelera, aprendizado | colunas: d1, d2, d3, d4 |
| `tokens` | list | 8 | elementos: d1, d2, d3, d4, d5, d6, d7, d8 |
| `tokens$d1` | character | 7 | recuperacao, de, informacao, ordena, documentos, por, relevancia |
| `tokens$d2` | character | 9 | o, modelo, de, espaco, vetorial, representa, documentos, como, vetores |
| `tokens$d3` | character | 9 | bm25, e, um, modelo, probabilistico, de, ranqueamento, de, texto |
| `tokens$d4` | character | 6 | aprendizado, estatistico, fundamenta, a, recuperacao, moderna |
| `tokens$d5` | character | 9 | o, indice, invertido, acelera, a, busca, em, muitos, documentos |
| `tokens$d6` | character | 8 | embeddings, capturam, a, semantica, de, palavras, e, documentos |
| `tokens$d7` | character | 9 | a, avaliacao, mede, a, relevancia, dos, resultados, da, busca |
| `tokens$d8` | character | 7 | ciencia, de, dados, combina, estatistica, e, programacao |
| `vocab` | character | 45 | a, acelera, aprendizado, avaliacao, bm25, busca, ... |

### Funções definidas

`anexar_estado`, `busca_booleana`, `estado`, `tokenizar`
<!-- estado-R:fim -->
