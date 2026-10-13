# Consolidado — PI III — Aula 5,5 — Parte D — 2026-10-13
*guia versão 3 · tutora: Antigravity · sessão de grupo · motor05b*  
**Alunos:** Ivan Guimarães dos S. da Silva, Jorge Sugano Suzart e Gustavo Geminiano  
**Grupo:** ivan_gustavo_jorge · **presentes:** Ivan, Jorge e Gustavo · **digitou:** M10: Ivan; M11: Jorge; M12: Gustavo

## 1. O que foi feito
- **M10 — Gabarito do grupo, juízes e decisão do limiar:** Carregamento de `qrels_jorge_2026-10-13.csv` com 230 julgamentos cobrindo as 12 necessidades do projeto em `necessidades.csv`. Decisão da prioridade de juiz único `cfg$juizes = c("jorge")` e do limiar estrito `cfg$limiar = 2` (exigência de resposta cabal à necessidade informacional). Todas as 12 consultas apresentaram $R > 0$ e entraram na avaliação comparativa.
- **M11 — Implementação das funções e teste unitário:** Definição em R das funções `precisao_k()`, `ap()`, `rr()`, `dcg()`, `ndcg()` e agregador `metricas()`. Validação das funções contra os gabaritos da teoria da Aula 5,5 (conferência exata: Cosseno AP $= 0{,}500$, BM25 AP $= 0{,}833$). Avaliação preliminar de $q_{01}$ ("fundação de Santos"): BM25 AP $= 0{,}657$ vs Cosseno AP $= 0{,}618$.
- **M12 — Avaliação completa das 12 consultas e primeiro resultado do motor:**
  - Aplicação dos dois sistemas (BM25 com $k_1=1{,}2, b=0{,}75$ vs Cosseno com TF-IDF unitário) nas 12 consultas.
  - Placar de vitórias no AP: **Empate rigoroso em 6 a 6**!
    - BM25 venceu em: $q_{01}$ (fundação de Santos), $q_{02}$ (porto de Santos), $q_{05}$ (população de Santos), $q_{07}$ (vida cultural), $q_{08}$ (acesso entre Guarujá e Santos), $q_{12}$ (economia do café).
    - Cosseno venceu em: $q_{03}$ (praias de Guarujá), $q_{04}$ (clima na Baixada), $q_{06}$ (origem do nome Bertioga), $q_{09}$ (estâncias balneárias), $q_{10}$ (fatos históricos em Bertioga), $q_{11}$ (esporte em Santos).
  - Médias globais: MAP do Cosseno $= 0{,}640$, MAP do BM25 $= 0{,}637$; P@3 $= 0{,}917$ em ambos; MRR $= 0{,}921$ (BM25) vs $0{,}920$ (Cosseno); nDCG graduado $= 0{,}880$ (Cosseno) vs $0{,}878$ (BM25).
  - Consulta mais desafiadora: $q_{05}$ ("população de Santos"), onde ambos atingiram AP baixo ($pprox 0{,}107$, P@3 $= 0$), pois os parágrafos demográficos utilizavam vocabulário estatístico específico de censos não previsto nos termos de consulta originais.

## 2. Como o grupo trabalhou — opinião da tutora
O grupo trabalhou com grande sinergia e admirável maturidade científica. A fixação do limiar em $\ge 2$ foi decidida com base no critério de que o usuário busca respostas informacionais diretas, e não menções superficiais. Ao analisar o placar de 6 vitórias para o BM25 e 6 para o Cosseno, o grupo compreendeu perfeitamente a importância de não declarar um modelo unilateralmente superior a partir de uma margem microscópica de MAP ($0{,}640$ contra $0{,}637$), identificando a presença da terceira armadilha teórica (diferença residual que não reflete significância estatística). A alternância dos digitadores (Ivan no M10, Jorge no M11 e Gustavo no M12) permitiu que todos dominassem a montagem das matrizes de métricas e o uso de `rowMeans`. O arquivo `config.R` foi devidamente atualizado.

## 3. Observações para a frente
- **Para a próxima sessão prática (Aula 06):** O gabarito construído pelo grupo passará a ser utilizado como entrada algorítmica para a expansão de consultas via retroalimentação por relevância (Rocchio), verificando se a reformulação automática de consulta eleva o MAP sobre este mesmo gabarito.
- **Perguntas guardadas:** Aplicação de testes de hipóteses estatísticos (teste t pareado e Wilcoxon) para avaliar a significância da diferença entre os modelos (Aula 16).
- **Produzido:** Avaliação experimental completa nas 12 consultas, placar 6 a 6 homologado, `config.R` sincronizado com `limiar = 2` e `juizes = c("jorge")`.
- **Ficha atualizada:** Sim — seções 4, 5, 6, 7 e cabeçalho devidamente atualizados.

<!-- estado-R:inicio -->
<!-- gerado por motor05b v1 2026-10-01 em 2026-10-13 15:35:00 -->
| Objeto | Tipo | Tamanho | Amostra |
|---|---|---|---|
| `docs` | character, nomeado | 132 | 1 Guarujá é um município..., 2 Atualmente a cidade de Guarujá..., ... |
| `origem` | character, nomeado | 132 | 1 Guaruja, 2 Guaruja, ..., 76 Santos, ..., 117 Bertioga |
| `cfg` | list | 9 | elementos: minimo, grupo, limpar, acentos, stopwords, k1, b, juizes, limiar |
| `qrels` | list | 12 | elementos: q01, q02, q03, q04, q05, q06, q07, q08, q09, q10, q11, q12 |
| `consultas` | character, nomeado | 12 | q01 fundação de Santos, q02 porto de Santos, q03 praias de Guarujá, ... |
| `tab_bm` | matrix | 5 × 12 | linhas: P_at_k, AP, RR, nDCG_bin, nDCG_grad \| colunas: q01, q02, q03... |
| `tab_cos` | matrix | 5 × 12 | linhas: P_at_k, AP, RR, nDCG_bin, nDCG_grad \| colunas: q01, q02, q03... |
| `medias` | matrix | 2 × 5 | linhas: BM25, Cosseno \| colunas: P_at_k, AP, RR, nDCG_bin, nDCG_grad |
| `ix` | list | 11 | elementos: tokens, vocab, tf, N, df, idf_tfidf, w, wn, postings, dl, avgdl, idf_bm25 |
<!-- estado-R:fim -->
