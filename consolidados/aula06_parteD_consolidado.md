# Consolidado — PI III — Aula 06 — Parte D — 2026-10-13
*guia versão 1 · tutora: Antigravity · sessão de grupo · motor06*  
**Alunos:** Ivan Guimarães dos S. da Silva, Jorge Sugano Suzart e Gustavo Geminiano  
**Grupo:** ivan_gustavo_jorge · **presentes:** Ivan, Jorge e Gustavo · **digitou:** M7: Ivan; M8: Jorge; M9: Gustavo

## 1. O que foi feito
- **M7 — Rocchio no gabarito do grupo: completa × residual:** Aplicação de `rocchio()` e `ranking_vetor()` na consulta de trabalho $q_{02}$ ("porto de Santos"). Na coleção completa, o AP saltou de $0{,}780$ (base) para $0{,}947$ (Rocchio). Na coleção residual realista (removendo os documentos relevantes já inspecionados no top-5, $D_{r\_v} = \{d_{87}, d_{89}, d_{31}, d_{88}, d_{58}\}$), o AP passou de $0{,}649$ para $0{,}498$. O experimento comprovou analiticamente que a avaliação completa é excessivamente otimista por reordenar documentos previamente marcados pelo usuário.
- **M8 — Pseudo-realimentação (PRF) em todas as consultas:** Teste sistemático de PRF no conjunto de desenvolvimento ($q_{01}..q_{08}$). O baseline $k=0$ atingiu MAP de $0{,}653$, superando com folga $k=2$ (MAP $0{,}448$), $k=3$ (MAP $0{,}515$) e $k=5$ (MAP $0{,}551$). Observou-se acentuado *query drift* em consultas como $q_{01}$, $q_{02}$ e $q_{04}$, nas quais termos periféricos do topo contaminaram o vetor da consulta. A verificação única no conjunto de teste ($q_{09}..q_{12}$) confirmou a degradação: o modelo base alcançou MAP de $0{,}612$, enquanto $k=2$ obteve $0{,}487$.
- **M9 — A decisão do grupo e o registro:** O grupo decidiu conscientemente desativar a pseudo-realimentação no motor de busca (`prf_k = 0`), uma vez que a PRF provocou desvio semântico e perda de MAP em ambos os conjuntos (dev e teste). Os pesos canônicos foram registrados em `config.R` (`rocchio = c(a = 1, b = 0.75, g = 0.15)`), e a função `ranking_motor()` foi implementada e validada.

## 2. Como o grupo trabalhou — opinião da tutora
O grupo demonstrou rigor científico exemplar e perfeita sincronia prática na execução dos experimentos. Compreendeu com facilidade por que o salto de AP na coleção completa é ilusório, identificando que o verdadeiro teste de generalização ocorre na coleção residual. Ao analisar o conjunto de desenvolvimento, resistiu à tentação de adotar a pseudo-realimentação cegamente, interpretando corretamente a queda de MAP e inspecionando os termos intrusivos que causaram o *query drift*. A decisão de fixar `prf_k = 0` foi tomada de forma consensual, transparente e estritamente respaldada pelos dados observados. O rodízio dos digitadores funcionou com disciplina e o arquivo `config.R` foi perfeitamente sincronizado.

## 3. Observações para a frente
- **Para a próxima sessão prática (Aula 07):** Na Aula 07, o projeto avançará para representações densas (*embeddings* neurais), superando a barreira puramente lexical do vocabulário e permitindo encontrar sinônimos sem os riscos de contaminação observados na PRF.
- **Perguntas guardadas:** Como combinar pontuações esparsas (BM25) e densas (embeddings) em uma arquitetura híbrida (Aula 07 e 08); testes estatísticos pareados para confirmar a significância das diferenças (Aula 16).
- **Produzido:** Funções `rocchio`, `ranking_vetor`, `residual`, `prf`, `ap_q`, `ranking_motor`; avaliação completa vs residual em $q_{02}$; avaliação comparativa de PRF em dev e teste; `config.R` atualizado com `prf_k = 0` e `rocchio`.
- **Ficha atualizada:** Sim — seções 5, 6, 7, cabeçalho e estado anexado.

## Passos de fechamento
1. Salvem a ficha como `00_FICHA_PROJETO.md` e o consolidado como `aula06_parteD_consolidado.md` (UTF-8).
2. No Colab, enviem ambos para a raiz da sessão.
3. Rodem: `anexar_estado("00_FICHA_PROJETO.md")` e `anexar_estado("aula06_parteD_consolidado.md")`.
4. Baixem os dois `.md`, o `config.R` e o notebook como `Aula06_ParteD.ipynb`.
5. No GitHub, sincronizem: `consolidados/` com a ficha e consolidado; `estrutura/codigo/` com `config.R` e notebook.
6. Confiram que a ficha termina com a seção "Estado do R".
7. Confiram que a seção 6 da ficha e `config.R` registram `prf_k = 0`.
8. Enviem os consolidados individuais da teoria para `consolidados/<seu nome>/`.

<!-- estado-R:inicio -->
<!-- gerado por motor06 v1 2026-10-01 em 2026-10-13 16:00:00 -->
| Objeto | Tipo | Tamanho | Amostra |
|---|---|---|---|
| `docs` | character, nomeado | 132 | 1 Guarujá é um município..., 2 Atualmente a cidade de Guarujá..., ... |
| `origem` | character, nomeado | 132 | 1 Guaruja, 2 Guaruja, ..., 76 Santos, ..., 117 Bertioga |
| `cfg` | list | 11 | elementos: minimo, grupo, limpar, acentos, stopwords, k1, b, juizes, limiar, prf_k, rocchio |
| `qrels` | list | 12 | elementos: q01, q02, q03, q04, q05, q06, q07, q08, q09, q10, q11, q12 |
| `consultas` | character, nomeado | 12 | q01 fundação de Santos, q02 porto de Santos, q03 praias de Guarujá, ... |
| `dev` | character | 8 | q01, q02, q03, q04, q05, q06, q07, q08 |
| `teste` | character | 4 | q09, q10, q11, q12 |
| `tab_dev` | matrix | 4 × 8 | linhas: base, k2, k3, k5 \| colunas: q01, q02, q03, q04, q05, q06, q07, q08 |
| `tab_teste` | matrix | 2 × 4 | linhas: base, prf \| colunas: q09, q10, q11, q12 |
| `ix` | list | 11 | elementos: tokens, vocab, tf, N, df, idf_tfidf, w, wn, postings, dl, avgdl, idf_bm25 |
| `q0` | numeric, nomeado | 3483 | coordenadas da consulta no vocabulario |
| `qm` | numeric, nomeado | 3483 | coordenadas da consulta reformulada por Rocchio |
<!-- estado-R:fim -->
