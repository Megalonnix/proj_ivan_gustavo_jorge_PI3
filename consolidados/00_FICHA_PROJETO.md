# Ficha do Projeto — Motor de Busca da Baixada Santista

*criada na Aula 01 (Parte D) em 2026-10-13 — última atualização: Aula 08 Tema 7 e Revisão Pós-Pente-Fino, 2026-11-26*

---

## 1. Identidade

| Campo | Valor |
|---|---|
| **Projeto** | Motor de Busca Municipal e Histórico da Baixada Santista |
| **Alunos** | Ivan Guimarães dos S. da Silva (RA 0051352421038) · Gustavo Geminiano (RA 0051352511009) · Jorge Sugano Suzart (RA 0051352511005) |
| **Repositório** | https://github.com/Megalonnix/proj_ivan_gustavo_jorge_PI3 |
| **Texto do Corpus (PDF)** | `entregas/entrega-1/entrega-1-corpus.pdf` (gerado por `entregas/entrega-1/entrega-1-corpus.Rnw` + `entregas/entrega-1/entrega-1-corpus.R`) |
| **Linguagem & Ambiente** | R base no Google Colab (Linux) / IRkernel / RStudio (`Rscript`) |

---

## 2. Tema e Formulação

| Campo | Valor |
|---|---|
| **Tema (em uma frase)** | Recuperação de informação sobre a história, geografia, patrimônio e turismo dos municípios da Baixada Santista (Santos, Guarujá e Bertioga). |
| **Ligação com a Região** | Foco territorial estrito nos municípios da Região Metropolitana da Baixada Santista, cobrindo o polo portuário de Santos, o balneário e fortificações de Guarujá e o patrimônio colonial e ambiental de Bertioga. |
| **Público de Aplicação** | Estudantes, pesquisadores regionais, turistas e moradores da Baixada Santista que buscam dados históricos e geográficos específicos. |
| **Três Perguntas que o Motor Responde** | (1) Como o ciclo do café, a ferrovia e o Porto de Santos impulsionaram a urbanização e a economia santista? (`"porto de santos"`) <br>(2) Quais praias e atrativos turísticos de Guarujá e Santos destacam o litoral? (`"praias e turismo"`) <br>(3) Quais são os marcos históricos da fundação e fortificação colonial de Bertioga? (`"forte sao joao"`) |
| **Por que este tema** | Combina relevância cultural, diversidade temática (economia portuária, história colonial e turismo) e ampla disponibilidade de texto aberto enciclopédico de alta qualidade. |

---

## 3. Fonte de Dados e Unidade de Análise

| Campo | Valor |
|---|---|
| **Origem dos Dados** | Wikipédia em português (artigos `"Santos (São Paulo)"`, `"Guarujá"` e `"Bertioga"`). |
| **Licença** | Creative Commons Atribuição-CompartilhaIgual (CC BY-SA 4.0). |
| **Títulos das Páginas** | `Santos (São Paulo)`, `Guarujá`, `Bertioga`. |
| **O que é UM documento** | Um parágrafo enciclopédico com comprimento superior a 200 caracteres (`nchar > 200`), garantindo contexto autônomo para resposta. |
| **Critério no Código** | `cfg$minimo = 200` (configurado em `config.R` e aplicado em `coletar.R` e `pipeline.R`). |

---

## 4. A Cara do Banco Amostral / Corpus Real

| Métrica | Valor Observado |
|---|---|
| **Total de Documentos ($N$)** | 132 parágrafos autônomos (`d1..d132`) congelados em `estrutura/banco-de-dados/docs.rds` (de 152 parágrafos brutos extraídos em `estrutura/banco-de-dados/corpus.csv`; 20 descartados com $\le 200$ caracteres). |
| **Distribuição por Artigo** | Santos: 86 parágrafos de 91 brutos (65,2%, média 100,5 tokens brutos / 69,1 limpos) · Guarujá: 29 de 37 (22,0%, média 93,8 brutos / 61,8 limpos) · Bertioga: 17 de 24 (12,9%, média 91,8 brutos / 59,5 limpos). |
| **Tamanho dos Documentos (Tokens)** | Tokenização bruta (Aula 01): menor 24 · maior 239 · média 97,9 (98,0) tokens · mediana 81,5 (0 curtos $<20$; 7 longos $>200$). <br>Tokenização limpa (Aula 03, UTF-8 transliterado): menor 20 · maior 167 (`d85` - Santos) · média 66,3 · mediana 58,5 tokens. |
| **Vocabulário** | 4.250 termos brutos (12.925 ocorrências) · **3.483 termos limpos** (8.746 ocorrências) após transliteração e remoção das 27 stopwords (alinhado entre Aula 03, `buscar.R`, `pipeline.R` e Entrega 1). |
| **Top-10 Termos Brutos** | `de` (910), `a` (494), `e` (392), `o` (365), `do` (301), `da` (250), `em` (226), `que` (157), `com` (126), `na` (114). |
| **Gabarito e Necessidades** | 12 consultas formuladas em `estrutura/banco-de-dados/necessidades.csv` e julgadas em `csv/05-qrels-respostas/qrels_jorge_2026-10-13.csv` (230 julgamentos, juiz Jorge; 219 nos 132 documentos válidos em `csv/05-qrels.csv`). Divisão: 8 dev ($q_{01}..q_{08}$) e 4 teste ($q_{09}..q_{12}$). |
| **Idioma, acentos, caixa, pontuação** | Decisão de acentos: `"translit"` (transliteração para ASCII sem partir palavras); pontuações eliminadas por `[^a-z0-9 ]`. |
| **Consultas de Trabalho Fixadas** | $q_1$: `"porto de santos"` · $q_2$: `"praias e turismo"` · $q_3$: `"forte sao joao"`. |
| **Top-5 Cosseno — Aula 02 (`Rscript estrutura/codigo/aula02.R`, tokenização bruta)** | • $q_1$ (`"porto de santos"`): `d76 (0.193) · d39 (0.146) · d50 (0.132) · d67 (0.132) · d26 (0.123)` — 1.º lugar `d76` (Santos), parcelas `porto=4.22 | de=0.01 | santos=0.59` <br>• $q_2$ (`"praias e turismo"`): `d2 (0.135) · d19 (0.120) · d80 (0.116) · d118 (0.106) · d53 (0.097)` — 1.º lugar `d2` (Guarujá), parcelas `praias=5.32 | e=0.05 | turismo=0.00` <br>• $q_3$ (`"forte sao joao"`): `d117 (0.205) · d121 (0.190) · d16 (0.129) · d132 (0.106) · d10 (0.104)` — 1.º lugar `d117` (Bertioga), parcelas `forte=6.28 | são=1.37 | joão=3.78` |
| **Top-5 Pós-Limpeza — Aula 03/04 (`Rscript estrutura/codigo/buscar.R`, `translit` + 27 stopwords)** | • $q_1$ (`"porto de santos"`): Cosseno `d76 (0.2711) · d78 (0.1750) · d25 (0.1496) · d77 (0.1317) · d50 (0.1245)` ($\text{nDCG@5}=1{,}00$) \| BM25 `d76 (3.9001) · d78 (3.3143) · d25 (3.1880) · d77 (3.1880) · d39 (3.1746)` ($\text{nDCG@5}=1{,}00$) <br>• $q_2$ (`"praias e turismo"`): Cosseno `d2 (0.1789) · d118 (0.1553) · d80 (0.1298) · d19 (0.1295) · d53 (0.1255)` ($\text{nDCG@5}=0{,}70$) \| BM25 `d80 (4.9961) · d118 (4.9305) · d19 (4.7322) · d53 (4.7228) · d51 (4.2598)` ($\text{nDCG@5}=0{,}51$) <br>• $q_3$ (`"forte sao joao"`): Cosseno `d117 (0.3219) · d121 (0.2022) · d16 (0.1513) · d123 (0.1291) · d132 (0.0871)` ($\text{nDCG@5}=0{,}70$) \| BM25 `d117 (8.6140) · d121 (7.1844) · d16 (6.0740) · d123 (5.9826) · d36 (3.5062)` ($\text{nDCG@5}=0{,}70$) |

---

## 5. Status de Implementação

| Componente | Status | Arquivo / Entrega |
|---|---|---|
| Texto de Descrição e Defesa do Corpus (PDF `abnTeX2`, 3 páginas + Referências) | OK — CSVs corrigidos; PDF pronto para recompilar em ambiente com `abnTeX2` | `entregas/entrega-1/entrega-1-corpus.pdf` · `entregas/entrega-1/entrega-1-corpus.Rnw` · `entregas/entrega-1/entrega-1-corpus.R` · `entregas/entrega-1/entrega-1-numeros.txt` |
| Coleta e Extração do Corpus (`docs.rds` e `origem.rds`) | OK | `estrutura/codigo/coletar.R` · `estrutura/banco-de-dados/docs.rds` · `estrutura/banco-de-dados/corpus.csv` |
| Scripts Executáveis via Terminal (`Rscript`) | OK | `estrutura/codigo/coletar.R` · `estrutura/codigo/01b-shannon-pesos.R` · `estrutura/codigo/aula02.R` · `estrutura/codigo/buscar.R` · `estrutura/codigo/pipeline.R` |
| Configuração `config.R` (`minimo, grupo, limpar, acentos, stopwords, k1, b, juizes, limiar, prf_k, rocchio, modelo, lsa_k, rrf_c, rerank_k, janela`) | OK | `config.R` |
| Tokenização e Vocabulário Real | OK | `Aula01_ParteD.ipynb` · `coletar.R` |
| Aula 01b — Shannon e Pesos em Bits | OK | `estrutura/codigo/01b-shannon-pesos.R` · `consolidados/aula01b_shannon_consolidado.md` |
| Matriz Termo-Documento ($4250 \times 132$ bruta; $3483 \times 132$ limpa) | OK | `Aula01_ParteD.ipynb` · `Aula03_ParteD.ipynb` · `buscar.R` · `pipeline.R` |
| Busca Booleana Conjuntiva (AND) e Disjuntiva (OR) | OK | `Aula01_ParteD.ipynb` · `buscar.R` |
| TF-IDF + Similaridade do Cosseno | OK | `Aula02_ParteD.ipynb` · `estrutura/codigo/aula02.R` |
| Limpeza textual e stopwords do grupo | OK | `Aula03_ParteD.ipynb` · `buscar.R` · `pipeline.R` |
| Índice invertido rápido + Busca AND | OK | `Aula03_ParteD.ipynb` |
| Modelo Probabilístico BM25 ($k_1=1{,}2, b=0{,}75$) | OK | `Aula04_ParteD.ipynb` · `estrutura/codigo/buscar.R` |
| Ferramental de Julgamento, Pool (12 consultas) e Kappa | OK (pool completa e `05-julgar.html` prontos; aguardando votos de Ivan e Gustavo) | `estrutura/codigo/05-julgamento/05-julgar.html` · `05a-kappa.R` · `05e-consolidar-qrels.R` · `csv/05-pool.csv` |
| Avaliação com Gabarito (P@k, MAP, MRR, nDCG) | OK | `Aula05b_ParteD.ipynb` · `csv/05-qrels-respostas/qrels_jorge_2026-10-13.csv` · `csv/05b-metricas-por-consulta.csv` |
| Realimentação (Rocchio e Pseudo-realimentação PRF) | OK | `Aula06_ParteD.ipynb` · `csv/06-rocchio-metricas.csv` (desligado em produção: `prf_k = 0`) |
| Decomposição Espectral LSA (SVD) e Fusão Híbrida RRF | OK | `Aula07_ParteD.ipynb` · `csv/07-lsa-top5.csv` (mantido BM25 em produção: `modelo = "bm25"`, `lsa_k = 20`, `rrf_c = 60`) |
| Reordenação (proximidade ordenada) | testado, não usado (`rerank_k = 0`) | `estrutura/codigo/Aula08_ParteD.ipynb` · `csv/08-rerank-por-consulta.csv` · `csv/08-rerank-grade-dev.csv` · `csv/08-rerank-top5.csv` |
| Tema 7 — Combinação de Escores (min-max e z-score) | testado, não usado (mantido `bm25`) | `consolidados/aula08_tema/aula08_tema_consolidado.md` |

---

## 6. Decisões Metodológicas e Racional Teórico

1. **Aula 01:** Unidade de documento por parágrafo (`cfg$minimo = 200`) para assegurar atomicidade informacional ($N = 132$ parágrafos válidos de 152 brutos).
2. **Aula 02:** Consultas de trabalho fixadas: $q_1$: `"porto de santos"`, $q_2$: `"praias e turismo"`, $q_3$: `"forte sao joao"`.
3. **Aula 03:** Adoção de `cfg$acentos = "translit"` e 27 stopwords funcionais, preservando termos do domínio e topônimos regionais.
4. **Aula 04:** BM25 configurado com $k_1 = 1{,}2$ e $b = 0{,}75$, adotando o padrão canônico para balancear saturação e comprimento.
5. **Aula 5,5 (Juízes e Limiar):** Adoção de prioridade de juízes `cfg$juizes = c("jorge")` e limiar de relevância binária `cfg$limiar = 2` (grau $\ge 2$ para relevância estrita, exigindo que o parágrafo responda à necessidade de informação).
6. **Aula 5,5 (Resultado Experimental):** Nas 12 consultas avaliadas, BM25 vence em 6 consultas no AP e Cosseno vence em 6 (empate exato de 6 a 6). MAP médio do Cosseno: $0{,}640$ vs BM25: $0{,}637$; P@3 médio de $0{,}917$ em ambos. A diferença de $0{,}003$ no MAP é estatisticamente indistinguível.
7. **Aula 06 (Rocchio e Coleção Residual):** Avaliação na consulta $q_{02}$ ("porto de Santos") demonstrou o viés otimista da coleção completa: AP salta de $0{,}780$ para $0{,}947$ pela simples reordenação de documentos já vistos e avaliados ($D_{r\_v}$). Na coleção residual (exclusão honesta dos documentos conhecidos), o AP passou de $0{,}649$ para $0{,}498$, comprovando que o ganho aparente reflete a recuperação de itens já conhecidos pelo usuário.
8. **Aula 06 (Pseudo-Realimentação e Decisão do Motor):** Avaliação de PRF no conjunto de desenvolvimento ($q_{01}..q_{08}$) revelou queda expressiva de MAP para todos os $k \ge 2$: base $k=0$ ($0{,}653$), $k=2$ ($0{,}448$), $k=3$ ($0{,}515$), $k=5$ ($0{,}551$). O fenômeno de *query drift* foi identificado com termos contextuais específicos (ex.: `doencas`, `saneamento`, `mato grosso` introduzidos em $q_{02}$). No teste ($q_{09}..q_{12}$), o baseline $k=0$ obteve MAP $0{,}612$ contra $0{,}487$ de $k=2$. Decisão do grupo: **desligar a PRF no motor (`cfg$prf_k = 0`)** para preservar a precisão informacional em consultas curtas e eliminar latência de segunda busca, mantendo os pesos canônicos registrados em `cfg$rocchio = c(a = 1, b = 0.75, g = 0.15)`.
9. **Aula 07 (LSA via SVD Truncada e Fusão Híbrida RRF):** A decomposição em valores singulares (SVD) acumulou $21{,}83\%$ da energia em $k=10$, $36{,}60\%$ em $k=20$, $65{,}98\%$ em $k=50$ e $92{,}00\%$ em $k=100$. No conjunto de desenvolvimento ($q_{01}..q_{08}$), o BM25 puro obteve MAP $0{,}744$, superando o LSA puro ($0{,}324$ em $k=10$; $0{,}402$ em $k=20$; $0{,}506$ em $k=50$) e a fusão híbrida RRF com $c=60$ ($0{,}585$ em $k=10$; $0{,}652$ em $k=20$; $0{,}684$ em $k=50$). No conjunto de teste ($q_{09}..q_{12}$), o BM25 confirmou a liderança com MAP $0{,}718$ contra $0{,}642$ do híbrido ($k=20$), embora na consulta conceitual $q_{09}$ ("estâncias balneárias no litoral paulista") o híbrido com $k=50$ tenha superado o BM25 ($0{,}867$ vs $0{,}843$). Decisão do grupo: **manter `cfg$modelo = "bm25"` como modelo oficial do motor**, registrando `cfg$lsa_k = 20` e `cfg$rrf_c = 60` em `config.R`.
10. **Aula 08 (Reordenação por Proximidade Ordenada — *Retrieve & Rerank*):** Reordenação = top-$0$ (`0 = não reordenar`), janela $3$, sobre o estágio 1 `bm25`, porque no desenvolvimento ($q_{01}..q_{08}$) os cortes $k=3$ e $k=5$ apenas empataram com o estágio 1 ($\text{MAP}_{\text{dev}} = 0{,}744$ nas janelas $2, 3$ e $5$, sem vencer em nenhuma consulta) e $k=10$ reduziu o $\text{MAP}_{\text{dev}}$ para $0{,}743$ ($0{,}7425$), perdendo em $q_{04}$ (`"clima na Baixada Santista"`: $\text{AP}$ caiu de $0{,}766$ para $0{,}754$), onde o par do topônimo composto `("baixada", "santista")` atribuiu $\text{prox} = 1{,}0$ ao documento irrelevante `128` (sobre iatismo/vela) e rebaixou o documento climático `148` ($\text{prox} = 0{,}0$); no teste ($q_{09}..q_{12}$), $\text{MAP}_{\text{teste}}: 0{,}718 \to 0{,}718$ · `cfg$rerank_k = 0`, `cfg$janela = 3`.
11. **Aula 08 — Tema 7 (Combinação por Notas *min-max* / *z-score*) e Consolidação Pós-Pente-Fino:** No Tema 7, a fusão por escores normalizados de BM25 + LSA ($k=20$, top-$10$) não superou o BM25 puro no desenvolvimento ($\text{MAP}_{\text{dev}} = 0{,}744$ contra $0{,}743$ para $\alpha \in \{0{,}5, 0{,}8\}$), mantendo-se `bm25` em produção. Na revisão do `pipeline.R` (correção de encoding UTF-8 em `limpar()`, DCG linear unificado e filtragem estrita aos 219 qrels pertencentes aos 132 documentos válidos), os números de `csv/05b-map.csv` e `csv/08-rerank-grade-dev.csv` passaram a refletir integralmente as mesmas decisões (`bm25` vence no dev com $\text{MAP}_{\text{dev}} = 0{,}787$; `rerank` $k=3,5$ empata e $k=10$ cai para $0{,}786$).

---

## 7. Histórico de Sessões

- **2026-10-13 (Aula 01 Parte D):** Fundação do projeto. Corpus de 132 parágrafos, TDM $4250 \times 132$, busca booleana.
- **2026-10-13 (Aula 02 Parte D):** Cosseno no corpus real. Homologação das 3 consultas ($q_1$: $d_{76}$, $q_2$: $d_2$, $q_3$: $d_{117}$).
- **2026-10-13 (Aula 03 Parte D):** Limpeza, transliteração, 27 stopwords, índice invertido com 3483 termos.
- **2026-10-13 (Aula 04 Parte D):** BM25 vs Cosseno; fixação de $k_1=1{,}2$ e $b=0{,}75$.
- **2026-10-13 (Aula 5,5 Parte D):** Presentes: Ivan, Jorge e Gustavo. Digitadores: M10: Ivan; M11: Jorge; M12: Gustavo. Leitura do gabarito oficial com 230 julgamentos (juiz Jorge), fixação do limiar $\ge 2$. Avaliação formal nas 12 consultas: empate em 6 a 6 no AP (MAP do Cosseno $0{,}640$, MAP do BM25 $0{,}637$, P@3 de $0{,}917$ em ambos).
- **2026-10-13 (Aula 06 Parte D):** Presentes: Ivan, Jorge e Gustavo. Digitadores: M7: Ivan; M8: Jorge; M9: Gustavo. Teste do Rocchio na consulta $q_{02}$ revelou AP de $0{,}947$ na completa vs $0{,}498$ na residual. Avaliação de PRF no conjunto de desenvolvimento comprovou que $k=0$ (base) supera $k=2, 3, 5$ (MAP $0{,}653$ vs $0{,}448$ em $k=2$), com confirmação no conjunto de teste ($0{,}612$ vs $0{,}487$). O grupo decidiu manter `prf_k = 0` no motor com parâmetros `rocchio` documentados no `config.R`.
- **2026-10-23 (Aula 07 Parte D):** Presentes: Ivan, Jorge e Gustavo. Digitadores: M7: Ivan; M8: Jorge; M9: Gustavo. Implementação de LSA (`lsa()`, `ranking_lsa()`) e fusão híbrida (`rrf()`, `ranking_modelo()`, `ranking_motor()`). Inspeção qualitativa de $q_{01}$ mostrou que o LSA ($k=20$) introduz documentos sem termos da consulta por alinhamento latente (ex.: $d_{121}$ sobre poesia). No dev ($q_{01}..q_{08}$), BM25 atingiu MAP $0{,}744$ contra $0{,}652$ do híbrido $k=20$; no teste ($q_{09}..q_{12}$), BM25 obteve MAP $0{,}718$ contra $0{,}642$ do híbrido $k=20$. O grupo decidiu manter `modelo = "bm25"`, `lsa_k = 20` e `rrf_c = 60` em `config.R`.
- **2026-11-10 (Aula 08 Parte D):** Presentes: Ivan, Jorge e Gustavo. Digitadores: M7: Ivan; M8: Jorge; M9: Gustavo. Implementação de `proximidade()`, `reordenar()`, `estagio1()`, `rerank_prox()`, `ap_rerank()` e `ranking_final()` sobre o estágio 1 `bm25`. Inspeção qualitativa em $q_{02}$ mostrou troca entre `88` (que usa a forma flexionada *"Complexo Portuário"*, $\text{prox}=0$) e `58` ($\text{prox}=1$). Na grade de desenvolvimento ($k \in \{3, 5, 10\} \times w \in \{2, 3, 5\}$), $k=3$ e $k=5$ empataram com $k=0$ ($\text{MAP}_{\text{dev}} = 0{,}744$) e $k=10$ caiu para $0{,}743$ por promover menções genéricas a `"Baixada Santista"` em $q_{04}$ (`128` sobre iatismo acima de `148` sobre clima). No teste ($q_{09}..q_{12}$), $\text{MAP}_{\text{teste}} = 0{,}718$. Decisão homologada em `config.R`: `rerank_k = 0` e `janela = 3`.
- **2026-11-26 (Aula 08 Tema 7 + Revisão Pós-Pente-Fino):** Consolidação do Tema 7 (`consolidados/aula08_tema/aula08_tema_consolidado.md`, `Estado do R` anexado no Colab); correção de encoding UTF-8 em `limpar()`, leitura `UTF-8-BOM` de qrels, DCG linear unificado e pool completa de 12 consultas em `pipeline.R`; remoção de arquivos duplicados; inclusão da Aula 01b (`01b-shannon-pesos.R`), guias da Aula 05 e ferramenta `05-julgar.html` + `05a-kappa.R` + `05e-consolidar-qrels.R`.

---

<!-- estado-R:inicio -->
## Estado do R ao fim da sessão
*gerado por `anexar_estado()` em 2026-11-10 11:17 · R version 4.6.1 (2026-06-24 ucrt) · motor08 v2 2026-10-22 · não edite à mão*

### Objetos

| objeto | tipo | tamanho | valor / amostra |
|---|---|---|---|
| `ap0` | numeric, nomeado | 8 | q01 0.7181, q02 0.7909, q03 0.706, q04 0.7661, q05 0.7353, q06 0.7901, ... |
| `ap1` | numeric, nomeado | 8 | q01 0.7181, q02 0.7909, q03 0.706, q04 0.7544, q05 0.7353, q06 0.7901, ... |
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
| `cfg$rerank_k` | numeric | 1 | 0 |
| `cfg$janela` | numeric | 1 | 3 |
| `consultas` | character, nomeado | 12 | q01 fundação de Santos, q02 porto de Santos, q03 praias de Guarujá, q04 clima na Baixada Santista, q05 população de Santos, q06 origem do nome Bertioga, ... |
| `cp` | data.frame | 132 × 5 | colunas: id, titulo, texto, data, url |
| `dev` | character | 8 | q01, q02, q03, q04, q05, q06, ... |
| `docs` | character, nomeado | 132 | 1 Guarujá é um município bras..., 2 Atualmente, a cidade de Gua..., 3 Guarujá é um dos quinze mun..., 5 A Ilha de Santo Amaro surge..., 6 Os primeiros habitantes for..., 7 Após a era dos sambaquis, a..., ... |
| `grade` | matrix | 3 × 3 | linhas: k3, k5, k10 \| colunas: janela2, janela3, janela5 |
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
| `j_esc` | numeric | 1 | 3 |
| `k_esc` | numeric | 1 | 0 |
| `m` | NULL | 0 |  |
| `map0` | numeric | 1 | 0.744 |
| `MOTOR_VERSAO` | character | 1 | motor08 v2 2026-10-22 |
| `nec` | data.frame | 12 × 5 | colunas: consulta, texto_consulta, necessidade, escopo, conjunto |
| `origem` | character, nomeado | 132 | 1 Guaruja, 2 Guaruja, 3 Guaruja, 5 Guaruja, 6 Guaruja, 7 Guaruja, ... |
| `q` | character | 1 | q02 |
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
| `qt` | character | 2 | porto, santos |
| `qts$q01` | character | 2 | fundacao, santos |
| `qts$q02` | character | 2 | porto, santos |
| `qts$q03` | character | 2 | praias, guaruja |
| `qts$q04` | character | 3 | clima, baixada, santista |
| `qts$q05` | character | 2 | populacao, santos |
| `qts$q06` | character | 3 | origem, nome, bertioga |
| `qts$q07` | character | 3 | vida, cultural, santos |
| `qts$q08` | character | 4 | acesso, entre, guaruja, santos |
| `qts$q09` | character | 4 | estancias, balnearias, litoral, paulista |
| `qts$q10` | character | 4 | fatos, historicos, marcantes, bertioga |
| `qts$q11` | character | 2 | esporte, santos |
| `qts$q12` | character | 3 | economia, cafe, santos |
| `R_q` | integer, nomeado | 12 | q01 24, q02 19, q03 19, q04 18, q05 18, q06 19, ... |
| `rk` | numeric, nomeado | 132 | 87 3.9, 89 3.314, 31 3.188, 88 3.188, 47 3.175, 58 3.013, ... |
| `rks$q01` | numeric, nomeado | 132 | 13 5.12, 55 4.268, 114 0.8364, 87 0.8257, 83 0.8167, 99 0.8124, ... |
| `rks$q02` | numeric, nomeado | 132 | 87 3.9, 89 3.314, 31 3.188, 88 3.188, 47 3.175, 58 3.013, ... |
| `rks$q03` | numeric, nomeado | 132 | 2 5.958, 20 5.268, 19 4.654, 6 3.874, 18 3.738, 29 2.96, ... |
| `rks$q04` | numeric, nomeado | 132 | 63 5.531, 148 5.377, 129 5.315, 85 4.893, 76 4.824, 70 4.743, ... |
| `rks$q05` | numeric, nomeado | 132 | 129 3.492, 40 3.394, 53 3.31, 78 3.303, 50 3.101, 57 2.85, ... |
| `rks$q06` | numeric, nomeado | 132 | 132 10.83, 10 4.694, 131 4.649, 50 4.461, 42 3.49, 139 3.158, ... |
| `rks$q07` | numeric, nomeado | 132 | 79 4.624, 130 4.329, 46 3.954, 61 3.891, 38 3.873, 41 3.133, ... |
| `rks$q08` | numeric, nomeado | 132 | 19 7.221, 33 6.053, 102 5.734, 104 5.253, 138 5.004, 150 4.855, ... |
| `rks$q09` | numeric, nomeado | 132 | 3 7.871, 94 7.819, 77 6.827, 131 6.668, 11 6.037, 40 5.935, ... |
| `rks$q10` | numeric, nomeado | 132 | 130 5.733, 139 3.158, 136 3.092, 132 3.082, 137 3.073, 148 2.669, ... |
| `rks$q11` | numeric, nomeado | 132 | 128 5.91, 126 5.532, 114 0.8364, 87 0.8257, 83 0.8167, 99 0.8124, ... |
| `rks$q12` | numeric, nomeado | 132 | 39 7.385, 57 5.863, 110 5.055, 87 4.341, 93 3.975, 88 3.755, ... |
| `rn` | character | 132 | 87, 89, 31, 47, 58, 88, ... |
| `tab_teste` | matrix | 2 × 4 | linhas: estagio1, rerank \| colunas: q09, q10, q11, q12 |
| `teste` | character | 4 | q09, q10, q11, q12 |
| `usar` | character | 12 | q01, q02, q03, q04, q05, q06, ... |
| `validos` | logical | 152 | TRUE, TRUE, TRUE, FALSE, TRUE, TRUE, ... |

### Funções definidas

`anexar_estado`, `ap`, `ap_rerank`, `bm25`, `bm25_doc`, `busca_AND`, `busca_booleana`, `cfg_aula`, `cosseno`, `dcg`, `docs_aula`, `estado`, `estagio1`, `gabarito_aula`, `idf_bm25`, `idf_classico`, `indice_invertido`, `kappa_cohen`, `kappa_matriz`, `ler_qrels`, `limpar`, `lsa`, `matriz_tf`, `metricas`, `montar`, `ndcg`, `norm_cols`, `precisao_k`, `preparar`, `prf`, `proximidade`, `ranking_bm25`, `ranking_cosseno`, `ranking_final`, `ranking_lsa`, `ranking_vetor`, `recall_k`, `relevancia`, `reordenar`, `rerank_prox`, `residual`, `rocchio`, `rr`, `rrf`, `saturacao`, `sem_stop`, `stopwords_aula`, `tokenizar`, `vetor_consulta`
<!-- estado-R:fim -->

