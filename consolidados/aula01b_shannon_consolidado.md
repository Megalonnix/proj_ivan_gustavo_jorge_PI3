# Consolidado — PI III — Aula 01b — De Shannon aos Pesos dos Termos (Bits)

**Grupo:** Ivan Guimarães dos S. da Silva · Gustavo Geminiano · Jorge Sugano Suzart  
**Disciplina:** Projeto Integrador III — Motor de Busca (Fatec Baixada Santista)  
**Script de referência:** [`estrutura/codigo/01b-shannon-pesos.R`](../estrutura/codigo/01b-shannon-pesos.R)

---

## 1. Corpus da Aula ($N = 8$ documentos)

- **Incerteza inicial:** $\log_2(8) = 3{,}000\text{ bits}$ para identificar 1 documento entre os 8.
- **Autoinformação por termo ($I(t) = \log_2(N / \text{df}_t)$):**
  - `busca` ($\text{df} = 2$): $I(\text{busca}) = \log_2(8/2) = 2{,}000\text{ bits}$
  - `modelo` ($\text{df} = 2$): $I(\text{modelo}) = 2{,}000\text{ bits}$
  - `recuperacao` ($\text{df} = 2$): $I(\text{recuperacao}) = 2{,}000\text{ bits}$
  - `de` ($\text{df} = 5$): $I(\text{de}) = \log_2(8/5) = 0{,}678\text{ bits}$
- **Consulta `"modelo de recuperacao"` (soma de $\text{tf} \cdot I$):** `d3` ($3{,}356\text{ bits}$, pois contém `modelo` e duas ocorrências de `de`), `d1` ($2{,}678\text{ bits}$), `d2` ($2{,}678\text{ bits}$), `d4` ($2{,}000\text{ bits}$), `d6` e `d8` ($0{,}678\text{ bits}$), `d5` e `d7` ($0{,}000\text{ bits}$).
- **Logaritmo na base 2 vs natural:** $\log_2(x) = \ln(x)/\ln(2)$ altera apenas a escala (bits vs nats), preservando integralmente a ordem do ranking.

---

## 2. Aplicação no Corpus da Baixada Santista ($N = 132$ parágrafos)

- **Incerteza inicial:** $\log_2(132) = 7{,}044\text{ bits}$ (vocabulário ASCII sem remoção de stopwords: $3.510$ termos, dos quais $2.255$ com $\text{df} = 1$ atingem o teto de $7{,}044\text{ bits}$).
- **Autoinformação de pistas representativas:**
  - `de` ($\text{df} = 132$): **$0{,}000\text{ bits}$** (aparece em todos os parágrafos do corpus — confirmação empírica de que stopwords universais carregam zero informação discriminativa)
  - `santos` ($\text{df} = 83$): $0{,}669\text{ bits}$
  - `guaruja` ($\text{df} = 25$): $2{,}401\text{ bits}$
  - `porto` ($\text{df} = 23$): $2{,}521\text{ bits}$
  - `bertioga` ($\text{df} = 18$): $2{,}874\text{ bits}$
  - `turismo` ($\text{df} = 15$): $3{,}138\text{ bits}$
  - `praias` ($\text{df} = 13$): $3{,}344\text{ bits}$
  - `forte` ($\text{df} = 8$): $4{,}044\text{ bits}$
  - `cafe` ($\text{df} = 8$): $4{,}044\text{ bits}$
- **Consultas de trabalho em bits ($\sum \text{tf} \cdot I_{\text{bits}}$):**
  - **$q_1$ (`"porto de santos"`):** `porto` ($2{,}521$) · `de` ($0{,}000$) · `santos` ($0{,}669$) → Top-5: `d39` ($11{,}58$), `d50` ($10{,}91$), `d76` ($9{,}57$), `d78` ($8{,}23$), `d85` ($7{,}05$).
  - **$q_2$ (`"praias e turismo"`):** `praias` ($3{,}344$) · `e` ($0{,}067$) · `turismo` ($3{,}138$) → Top-5: `d2` ($10{,}43$), `d19` ($10{,}43$), `d118` ($10{,}03$), `d80` ($9{,}82$), `d53` ($9{,}82$).
  - **$q_3$ (`"forte sao joao"`):** `forte` ($4{,}044$) · `sao` ($0{,}895$) · `joao` ($3{,}874$) → Top-5: `d121` ($22{,}57$), `d117` ($12{,}86$), `d123` ($8{,}81$), `d16` ($7{,}92$), `d9` ($7{,}45$).
- **Independência vs. correlação (excesso de informação somada):**
  - `forte` + `joao`: $\text{df}=(8, 9)$, juntos em $4$ docs → soma $7{,}92\text{ bits}$ vs real $5{,}04\text{ bits}$ (excesso $2{,}87\text{ bits}$).
  - `baixada` + `santista`: $\text{df}=(10, 25)$, juntos em $10$ docs → soma $6{,}12\text{ bits}$ vs real $3{,}72\text{ bits}$ (excesso $2{,}40\text{ bits}$).
  - `vicente` + `carvalho`: $\text{df}=(26, 8)$, juntos em $7$ docs → soma $6{,}39\text{ bits}$ vs real $4{,}24\text{ bits}$ (excesso $2{,}15\text{ bits}$).
  - `porto` + `cafe`: $\text{df}=(23, 8)$, juntos em $4$ docs → soma $6{,}57\text{ bits}$ vs real $5{,}04\text{ bits}$ (excesso $1{,}52\text{ bits}$).
