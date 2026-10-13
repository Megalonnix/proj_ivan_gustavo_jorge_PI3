# Ficha do Projeto — Motor de Busca da Baixada Santista

*criada na Aula 01 (Parte D) em 2026-10-13 — última atualização: Aula 06 Parte D, 2026-10-13, motor06*

---

## 1. Identidade

| Campo | Valor |
|---|---|
| **Projeto** | Motor de Busca Municipal e Histórico da Baixada Santista |
| **Alunos** | Ivan Guimarães dos S. da Silva, Jorge Sugano Suzart e Gustavo Geminiano |
| **Repositório** | https://github.com/Megalonnix/proj_ivan_gustavo_jorge_PI3 |
| **Linguagem & Ambiente** | R base no Google Colab (Linux) / IRkernel / RStudio |

---

## 2. Tema e Formulação

| Campo | Valor |
|---|---|
| **Tema (em uma frase)** | Recuperação de informação sobre a história, geografia, patrimônio e turismo dos municípios da Baixada Santista (Santos, Guarujá e Bertioga). |
| **Ligação com a Região** | Foco territorial estrito nos municípios da Região Metropolitana da Baixada Santista, cobrindo o polo portuário de Santos, o balneário e fortificações de Guarujá e o patrimônio colonial e ambiental de Bertioga. |
| **Público de Aplicação** | Estudantes, pesquisadores regionais, turistas e moradores da Baixada Santista que buscam dados históricos e geográficos específicos. |
| **Três Perguntas que o Motor Responde** | (1) Quais são os marcos históricos da fundação e fortificação de Bertioga e Santos? <br>(2) Quais praias e atrativos turísticos de Guarujá possuem registros de patrimônio ambiental? <br>(3) Como o ciclo do café e a ferrovia impulsionaram a urbanização santista e a conexão com o porto? |
| **Por que este tema** | Combina relevância cultural, diversidade temática (economia portuária, história colonial e turismo) e ampla disponibilidade de texto aberto enciclopédico de alta qualidade. |

---

## 3. Fonte de Dados e Unidade de Análise

| Campo | Valor |
|---|---|
| **Origem dos Dados** | Wikipédia em português (artigos "Santos (São Paulo)", "Guarujá" e "Bertioga"). |
| **Licença** | Creative Commons Atribuição-CompartilhaIgual (CC BY-SA 3.0 / 4.0). |
| **Títulos das Páginas** | `Santos (São Paulo)`, `Guarujá`, `Bertioga`. |
| **O que é UM documento** | Um parágrafo enciclopédico com comprimento superior a 200 caracteres (`nchar > 200`), garantindo contexto autônomo para resposta. |
| **Critério no Código** | `cfg$minimo = 200` (configurado em `config.R`). |

---

## 4. A Cara do Banco Amostral / Corpus Real

| Métrica | Valor Observado |
|---|---|
| **Total de Documentos ($N$)** | 132 parágrafos autônomos congelados em `corpus.csv`. |
| **Distribuição por Artigo** | Santos: 86 parágrafos (65,2%) | Guarujá: 29 parágrafos (22,0%) | Bertioga: 17 parágrafos (12,9%). |
| **Tamanho dos Documentos (Tokens)** | Menor 20 · Maior 167 (d85 - Santos) · Média 66,3 tokens por documento pós-limpeza. |
| **Vocabulário** | 4250 termos brutos · 3483 termos após limpeza e stopwords (Aula 03). |
| **Gabarito e Necessidades** | 12 consultas formuladas em `necessidades.csv` e julgadas em `qrels_jorge_2026-10-13.csv` (230 julgamentos, juiz Jorge). Divisão: 8 dev ($q_{01}..q_{08}$) e 4 teste ($q_{09}..q_{12}$). |
| **Idioma, acentos, caixa, pontuação** | Decisão de acentos: `"translit"` (via `iconv` para ASCII//TRANSLIT); pontuações eliminadas por `[^a-z0-9 ]`. |
| **Consultas de Trabalho Fixadas** | $q_1$: `"porto de santos"` · $q_2$: `"praias e turismo"` · $q_3$: `"forte sao joao"`. |

---

## 5. Status de Implementação

| Componente | Status | Arquivo / Entrega |
|---|---|---|
| Coleta e Extração do Corpus | OK | `estrutura/bancoDeDados/wikipedia_baixada_santista.csv` |
| Configuração `config.R` (`minimo, grupo, limpar, acentos, stopwords, k1, b, juizes, limiar, prf_k, rocchio`) | OK | `estrutura/codigo/config.R` |
| Tokenização e Vocabulário Real | OK | `motor06.R` |
| Matriz Termo-Documento ($4250 \times 132$) | OK | `motor06.R` |
| Busca Booleana Conjuntiva | OK | `busca_booleana` |
| TF-IDF + Similaridade do Cosseno | OK | `Aula02_ParteD.ipynb` |
| Limpeza textual e stopwords do grupo | OK | `Aula03_ParteD.ipynb` |
| Índice invertido rápido + Busca AND | OK | `Aula03_ParteD.ipynb` |
| Modelo Probabilístico BM25 ($k_1=1{,}2, b=0{,}75$) | OK | `Aula04_ParteD.ipynb` |
| Avaliação com Gabarito (P@k, MAP, MRR, nDCG) | OK | `Aula05b_ParteD.ipynb` |
| Realimentação (Rocchio e Pseudo-realimentação PRF) | OK | `Aula06_ParteD.ipynb` (testado; desligado em produção: `prf_k = 0`) |

---

## 6. Decisões Metodológicas e Racional Teórico

1. **Aula 01:** Unidade de documento por parágrafo (`cfg$minimo = 200`) para assegurar atomicidade informacional.
2. **Aula 02:** Consultas de trabalho fixadas: $q_1$: `"porto de santos"`, $q_2$: `"praias e turismo"`, $q_3$: `"forte sao joao"`.
3. **Aula 03:** Adoção de `cfg$acentos = "translit"` e 27 stopwords funcionais, preservando termos do domínio.
4. **Aula 04:** BM25 configurado com $k_1 = 1{,}2$ e $b = 0{,}75$, adotando o padrão canônico para balancear saturação e comprimento.
5. **Aula 5,5 (Juízes e Limiar):** Adoção de prioridade de juízes `cfg$juizes = c("jorge")` e limiar de relevância binária `cfg$limiar = 2` (grau $\ge 2$ para relevância estrita, exigindo que o parágrafo responda à necessidade de informação).
6. **Aula 5,5 (Resultado Experimental):** Nas 12 consultas avaliadas, BM25 vence em 6 consultas no AP e Cosseno vence em 6 (empate exato de 6 a 6). MAP médio do Cosseno: $0{,}640$ vs BM25: $0{,}637$; P@3 médio de $0{,}917$ em ambos. A diferença de $0{,}003$ no MAP é estatisticamente indistinguível.
7. **Aula 06 (Rocchio e Coleção Residual):** Avaliação na consulta $q_{02}$ ("porto de Santos") demonstrou o viés otimista da coleção completa: AP salta de $0{,}780$ para $0{,}947$ pela simples reordenação de documentos já vistos e avaliados ($D_{r\_v}$). Na coleção residual (exclusão honesta dos documentos conhecidos), o AP passou de $0{,}649$ para $0{,}498$, comprovando que o ganho aparente reflete a recuperação de itens já conhecidos pelo usuário.
8. **Aula 06 (Pseudo-Realimentação e Decisão do Motor):** Avaliação de PRF no conjunto de desenvolvimento ($q_{01}..q_{08}$) revelou queda expressiva de MAP para todos os $k \ge 2$: base $k=0$ ($0{,}653$), $k=2$ ($0{,}448$), $k=3$ ($0{,}515$), $k=5$ ($0{,}551$). O fenômeno de *query drift* foi identificado com termos contextuais específicos (ex.: `doencas`, `saneamento`, `mato grosso` introduzidos em $q_{02}$). No teste ($q_{09}..q_{12}$), o baseline $k=0$ obteve MAP $0{,}612$ contra $0{,}487$ de $k=2$. Decisão do grupo: **desligar a PRF no motor (`cfg$prf_k = 0`)** para preservar a precisão informacional em consultas curtas e eliminar latência de segunda busca, mantendo os pesos canônicos registrados em `cfg$rocchio = c(a = 1, b = 0.75, g = 0.15)`.

---

## 7. Histórico de Sessões

- **2026-10-13 (Aula 01 Parte D):** Fundação do projeto. Corpus de 132 parágrafos, TDM $4250 \times 132$, busca booleana.
- **2026-10-13 (Aula 02 Parte D):** Cosseno no corpus real. Homologação das 3 consultas ($q_1$: $d_{76}$, $q_2$: $d_2$, $q_3$: $d_{117}$).
- **2026-10-13 (Aula 03 Parte D):** Limpeza, transliteração, 27 stopwords, índice invertido com 3483 termos.
- **2026-10-13 (Aula 04 Parte D):** BM25 vs Cosseno; fixação de $k_1=1{,}2$ e $b=0{,}75$.
- **2026-10-13 (Aula 5,5 Parte D):** Presentes: Ivan, Jorge e Gustavo. Digitadores: M10: Ivan; M11: Jorge; M12: Gustavo. Leitura do gabarito oficial com 230 julgamentos (juiz Jorge), fixação do limiar $\ge 2$. Avaliação formal nas 12 consultas: empate em 6 a 6 no AP (MAP do Cosseno $0{,}640$, MAP do BM25 $0{,}637$, P@3 de $0{,}917$ em ambos).
- **2026-10-13 (Aula 06 Parte D):** Presentes: Ivan, Jorge e Gustavo. Digitadores: M7: Ivan; M8: Jorge; M9: Gustavo. Teste do Rocchio na consulta $q_{02}$ revelou AP de $0{,}947$ na completa vs $0{,}498$ na residual. Avaliação de PRF no conjunto de desenvolvimento comprovou que $k=0$ (base) supera $k=2, 3, 5$ (MAP $0{,}653$ vs $0{,}448$ em $k=2$), com confirmação no conjunto de teste ($0{,}612$ vs $0{,}487$). O grupo decidiu manter `prf_k = 0` no motor com parâmetros `rocchio` documentados no `config.R`.

---

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
