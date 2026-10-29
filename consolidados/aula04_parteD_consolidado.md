# Consolidado — PI III — Aula 04 — Parte D — 2026-10-13
*guia versão 3 · tutora: Antigravity · sessão de grupo · motor04*  
**Alunos:** Ivan Guimarães dos S. da Silva, Jorge Sugano Suzart e Gustavo Geminiano  
**Grupo:** ivan_gustavo_jorge · **presentes:** Ivan, Jorge e Gustavo · **digitou:** M10: Ivan; M11: Jorge; M12: Gustavo

## 1. O que foi feito
- **M10 — Métricas de comprimento e IDF do BM25 no corpus do grupo:** Cálculo dos comprimentos documentais `dl` pós-limpeza (mínimo de 20 tokens, máximo de 167 tokens no documento $d_{85}$ de Santos, média `avgdl` $= 66{,}3$ tokens). O documento mais longo ($d_{85}$) tem $K = 2{,}568$, de modo que uma ocorrência isolada nele vale apenas $61{,}7\%$ da contribuição em um documento médio. Cálculo do vetor `idf_b` para os 3483 termos indexados.
- **M11 — As três consultas de trabalho no BM25 e no Cosseno:**
  - Consulta 1 (`"porto de santos"`): Alta concordância no Top 4 ($d_{76}$ lidera com score $3{,}900$ no BM25 e $0{,}271$ no cosseno; seguido por $d_{78}$, $d_{25}$ e $d_{77}$). Em 5º lugar, $d_{39}$ sobe no BM25 ($3{,}175$) ultrapassando $d_{50}$ por apresentar maior densidade dos termos da busca.
  - Consulta 2 (`"praias e turismo"`): Divergência metodológica marcante. No Cosseno, $d_{2}$ liderava ($0{,}179$) impulsionado exclusivamente pela repetição tripla do termo `"praias"`, mesmo sem conter `"turismo"`. No BM25, $d_{80}$ ($4{,}996$, Santos) e $d_{118}$ ($4{,}930$, Bertioga) assumem o topo porque contêm **ambos os termos da busca** (`praias` e `turismo`), beneficiando-se da propriedade aditiva da evidência e da saturação do termo isolado em $d_{2}$.
  - Consulta 3 (`"forte sao joao"`): Concordância sólida no topo: $d_{117}$ lidera com folga ($8{,}614$ no BM25 e $0{,}322$ no cosseno), seguido por $d_{121}$, $d_{16}$ e $d_{123}$.
- **M12 — Experimentos com $b=0$, $b=1$, $k_1=0$ e decisão:**
  - Com $b = 0$, documentos mais extensos deixam de ser penalizados e sobem de posição ($d_{39}$ assume a liderança em $q_1$).
  - Com $b = 1$, a penalização proporcional a $|d|/\text{avgdl}$ maximiza a pontuação de documentos concisos ($d_{76}$ sobe para $4{,}075$).
  - Com $k_1 = 0$, a frequência é ignorada e todos os documentos que contêm os termos empatam na soma dos IDFs ($2{,}199$).
  - Decisão: O grupo fixou $k_1 = 1{,}2$ e $b = 0{,}75$ no `config.R`, adotando o padrão da literatura para evitar sobreajuste preliminar antes do teste com gabarito na Aula 5,5.

> **Nota de auditoria (2026-10-29):** os valores de comprimento registrados nesta sessão (máximo 167, média 66,3 e $K=2{,}568$) são o retrato histórico da Aula 04. O CSV atual de documentos registra mínimo 22, máximo 186 e média 72,97 tokens limpos; os arquivos da Entrega 1 foram atualizados para essa base.

## 2. Como o grupo trabalhou — opinião da tutora
O grupo trabalhou com extraordinário rigor técnico e postura analítica exemplar. Ao identificar que $d_{80}$ e $d_{118}$ ultrapassaram $d_{2}$ na consulta `"praias e turismo"`, os alunos inspecionaram diretamente as contagens de termos na TDM (`counts$praias` vs `counts$turismo`) e os comprimentos documentais, explicando a inversão pelo duplo mecanismo de saturação de frequência e soma aditiva de termos em vez de atribuir a diferença a preferências estéticas. A alternância de digitadores ocorreu com fluidez (Ivan conduziu o M10, Jorge o M11 e Gustavo o M12). As variações de parâmetros foram testadas de maneira univariada, compreendendo com clareza o efeito assintótico de $k_1 = 0$. O arquivo `config.R` foi descomentado e sincronizado com perfeição.

## 3. Observações para a frente
- **Para a próxima sessão prática (Aula 05):** O grupo construirá o gabarito de relevância (*ground truth*) julgando manualmente documentos candidatos para as três consultas de trabalho, estabelecendo a base para a avaliação quantitativa na Aula 5,5.
- **Perguntas guardadas:** Qual modelo atingirá maior MAP e nDCG@5 no corpus do projeto (Aula 5,5).
- **Produzido:** Ficha técnica atualizada com métricas de comprimento, `config.R` configurado com $k_1 = 1{,}2$ e $b = 0{,}75$, e comparações BM25 vs Cosseno documentadas.
- **Ficha atualizada:** Sim — seções 4, 5, 6, 7 e cabeçalho devidamente atualizados.

<!-- estado-R:inicio -->
<!-- gerado por motor04 v1 2026-10-01 em 2026-10-13 15:23:00 -->
| Objeto | Tipo | Tamanho | Amostra |
|---|---|---|---|
| `docs` | character, nomeado | 132 | d1 Guarujá é um município..., d2 Atualmente a cidade de Guarujá..., ... |
| `origem` | character, nomeado | 132 | d1 Guaruja, d2 Guaruja, ..., d76 Santos, ..., d117 Bertioga |
| `cfg` | list | 7 | elementos: minimo, grupo, limpar, acentos, stopwords, k1, b |
| `dl` | numeric, nomeado | 132 | d1 61, d2 62, d3 48, d4 72, ..., d85 167, ..., d132 89 |
| `avgdl` | numeric | 1 | 66.3 |
| `idf_b` | numeric, nomeado | 3483 | santos 0.697, sao 0.865, cidade 1.011, porto 1.867, praias 2.511, ... |
| `r_bm1` | numeric, nomeado | 132 | d76 3.900, d78 3.314, d25 3.188, d77 3.188, d39 3.175, ... |
| `r_cos1` | numeric, nomeado | 132 | d76 0.271, d78 0.175, d25 0.150, d77 0.132, d50 0.124, ... |
| `ix` | list | 9 | elementos: tokens, vocab, tf, N, df, idf_tfidf, w, wn, postings |
<!-- estado-R:fim -->
