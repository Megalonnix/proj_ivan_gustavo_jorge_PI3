# Consolidado — PI III — Aula 08 — Parte D — 2026-11-10
*guia versão 2 · tutora: Antigravity · sessão de grupo · motor08*  
**Grupo:** ivan_gustavo_jorge · **presentes:** Ivan, Jorge e Gustavo · **digitou:** M7: Ivan; M8: Jorge; M9: Gustavo

## 1. O que foi feito
- **M7 — `proximidade` e `reordenar` no estágio 1 do grupo (`bm25`); top-5 antes × depois numa consulta, lendo os textos:** Implementação de `proximidade()`, `reordenar()`, `estagio1()` e `rerank_prox()` sobre o estágio 1 homologado na Aula 07 (`cfg$modelo = "bm25"`). Inspeção das consultas de desenvolvimento revelou que em $q_{01}$ (`"fundação de Santos"`, tokens `fundacao, santos`) todos os 10 primeiros candidatos têm $\text{prox} = 0$ na janela $w = 3$, mantendo o top-5 inalterado (`13, 55, 114, 87, 83`). Já na consulta $q_{02}$ (`"porto de Santos"`, tokens `porto, santos`), os escores de proximidade no top-10 foram `87 (1), 89 (1), 31 (1), 88 (0), 47 (1), 58 (1), 57 (0), 110 (0), 49 (0), 53 (0)`:
  - Top-5 do estágio 1 (`bm25`): `87`, `89`, `31`, `88`, `47`.
  - Top-5 após reordenação ($k = 10, w = 3$): `87`, `89`, `31`, `47`, `58`.
  - Leitura dos textos que mudaram: o documento `88` (*"O Complexo Portuário de Santos responde por mais de um quarto da movimentação da balança comercial brasileira é o principal porto..."*, grau $2$) caiu do $4.^\circ$ para o $6.^\circ$ lugar por utilizar a forma flexionada *"Complexo Portuário de Santos"* (`portuario` $\neq$ `porto`), recebendo $\text{prox} = 0$, enquanto o documento `58` (história da imigração italiana e crescimento cafeeiro ligado ao `"Porto de Santos"`, grau $2$) subiu do $6.^\circ$ para o $5.^\circ$ lugar por conter a sequência literal `porto santos` (após remoção da stopword `de`, distância $1 \to \text{prox} = 1{,}0$). Na consulta $q_{08}$ (`"acesso entre Guarujá e Santos"`, 4 tokens), o documento `33` (balsas da travessia Santos–Guarujá, $\text{prox} = 1{,}0$) ultrapassou `19` (urbanização das praias, $\text{prox} = 0{,}0$).
- **M8 — Grade $k \in \{3, 5, 10\}$ × janela $\in \{2, 3, 5\}$ em todas as consultas; escolha no dev; teste relatado:** Avaliação sistemática nas 8 consultas de desenvolvimento ($q_{01}..q_{08}$):
  - MAP do estágio 1 sozinho ($k = 0$): $\text{MAP}_{\text{dev}} = 0{,}744$ ($0{,}7440$).
  - Grade de desenvolvimento ($k \in \{3, 5, 10\} \times w \in \{2, 3, 5\}$):
    - Para $k = 3$: $\text{MAP}_{\text{dev}} = 0{,}744$ ($0{,}7440$) nas janelas $2, 3$ e $5$ (empate exato em todas as 8 consultas).
    - Para $k = 5$: $\text{MAP}_{\text{dev}} = 0{,}744$ ($0{,}7440$) nas janelas $2, 3$ e $5$ (empate exato em todas as 8 consultas).
    - Para $k = 10$: $\text{MAP}_{\text{dev}} = 0{,}743$ ($0{,}7425$) nas janelas $2, 3$ e $5$ (empate em 7 consultas e perda em $q_{04}$, onde o $\text{AP}$ caiu de $0{,}766$ para $0{,}754$).
  - Diagnóstico qualitativo da perda em $q_{04}$ (`"clima na Baixada Santista"`, tokens `clima, baixada, santista`) para $k = 10$: no estágio 1, o documento `148` (*"O clima de Bertioga é o subtropical úmido, com verões quentes e invernos relativamente frios..."*, grau $2$, $2.^\circ$ colocado no BM25) descreve diretamente o clima, mas não repete o topônimo composto `"Baixada Santista"`, ficando com $\text{prox} = 0{,}0$. Já o documento `128` (*"Outro esporte da cidade é o Iatismo (ou vela)..."*, $10.^\circ$ colocado no BM25, irrelevante / não julgado) menciona a expressão `"Baixada Santista"` (`baixada` seguido de `santista` a distância $1 \to \text{prox} = 1{,}0$). Com $k = 10$, a proximidade promoveu o documento irrelevante `128` acima do documento climático `148`, reduzindo o $\text{AP}$ de $0{,}766$ para $0{,}754$.
  - Execução única no conjunto de teste ($q_{09}..q_{12}$): tanto o estágio 1 ($k = 0$) quanto a escolha avaliada obtiveram $\text{MAP}_{\text{teste}} = 0{,}718$ ($\text{AP}$ por consulta: $q_{09} = 0{,}843$, $q_{10} = 0{,}670$, $q_{11} = 0{,}593$, $q_{12} = 0{,}767$).
- **M9 — A decisão; `config.R` e ficha:** Como na grade de desenvolvimento nenhum valor de $k \in \{3, 5, 10\}$ superou o $\text{MAP}_{\text{dev}} = 0{,}744$ do estágio 1 ($k = 0$), $k = 10$ degradou $q_{04}$ por promover menções genéricas ao topônimo `"Baixada Santista"` e $k > 0$ impõe custo adicional de leitura de $k$ documentos a cada consulta sem ganho de precisão, o grupo decidiu **não reordenar em produção (`cfg$rerank_k = 0`, `cfg$janela = 3`)**, preservando o ranking do BM25 puro e documentando a função `ranking_final()`.

## 2. Como o grupo trabalhou — opinião da tutora
O grupo conduziu a sessão prática com excelente espírito crítico e domínio das ferramentas construídas na teoria. Copiaram e validaram de imediato as funções `proximidade()` e `reordenar()` com os testes unitários antes de aplicá-las ao corpus da Baixada Santista. Na etapa de leitura de textos (Módulo 7), não se limitaram a uma consulta inerte: ao notarem que $q_{01}$ tinha proximidade zero em todo o top-10, inspecionaram proativamente $q_{02}$, $q_{04}$ e $q_{08}$, identificando com precisão cirúrgica o fenômeno linguístico pelo qual o topônimo composto `"Baixada Santista"` em $q_{04}$ gerava escore de proximidade $1{,}0$ em documentos de esporte (`128`), rebaixando um parágrafo essencial sobre clima subtropical (`148`). A decisão por `rerank_k = 0` e `janela = 3` emergiu de forma unânime do próprio grupo a partir da tabela de desenvolvimento e do critério de parcimônia computacional.

## 3. Observações para a frente
- **Para a próxima sessão prática (Aula 09):** Na Aula 09 (*Learning to Rank*), o escore de proximidade deixará de atuar isoladamente como critério rígido de ordenação da cabeça e passará a ser combinado com o BM25 e o LSA como *feature* ponderada, evitando que um empate em `"Baixada Santista"` anule o peso léxico de `"clima"`.
- **Perguntas guardadas:** Como ponderar a proximidade junto ao escore do BM25 para que ela sirva apenas de bônus suave sem derrubar documentos com termos raros — tema central da Aula 09 (*Learning to Rank*).
- **Produzido:** Ver a entrada "Aula 08" na linha do tempo da ficha do projeto (`00_FICHA_PROJETO.md`), notebook `Aula08_ParteD.ipynb` e tabelas `csv/08-rerank-por-consulta.csv` e `csv/08-rerank-grade-dev.csv`.
- **Ficha atualizada:** Sim — seções alteradas: 5, 6, 7, cabeçalho e seção 8 ("Estado do R ao fim da sessão").

## Passos de fechamento
1. Salvem a ficha como **`00_FICHA_PROJETO.md`** e o consolidado como **`aula08_parteD_consolidado.md`** (Bloco de Notas → *Salvar como* → "Todos os arquivos", UTF-8).
2. No Colab, **sem fechar a sessão**, enviem os dois (pasta à esquerda → upload). `list.files()` tem que mostrá-los soltos, com esses nomes exatos.
3. Rodem, numa célula:
   ```r
   anexar_estado("00_FICHA_PROJETO.md")            # o estado do R vai para a ficha
   anexar_estado("aula08_parteD_consolidado.md")   # e para o consolidado do grupo
   ```
4. Baixem (três pontinhos → *Fazer download*): os dois `.md`; o **`config.R`** (mudou: `rerank_k`, `janela`); e o **notebook R** (*Arquivo → Fazer download → Baixar o .ipynb*), salvo como **`aula08.ipynb`** / **`Aula08_ParteD.ipynb`**.
5. No GitHub, enviem (*Add file → Upload files*; mesmo nome substitui): `consolidados/` ← `00_FICHA_PROJETO.md` e `aula08_parteD_consolidado.md`; `estrutura/codigo/` ← `config.R` e `Aula08_ParteD.ipynb`.
6. Confiram no GitHub que a ficha termina com a seção "Estado do R" e que o `config.R` tem `rerank_k` e `janela` **sem** `#` na frente.
7. Confiram que a seção 6 da ficha e o `config.R` dizem o mesmo: o mesmo `rerank_k` e a mesma `janela`, sobre o mesmo estágio 1 (`modelo`).
8. Cada integrante envia o **seu** consolidado da teoria (`aula08_consolidado.md`) para `consolidados/`.

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

