# Projeto Integrador III — Motor de Busca Municipal e Histórico da Baixada Santista

**Alunos:**
- **Ivan Guimarães dos S. da Silva** — RA `0051352421038`
- **Gustavo Geminiano** — RA `0051352511009`
- **Jorge Sugano Suzart** — RA `0051352511005`

**Professor:** Prof. Dr. João Paulo Ferreira de Mello  
**Disciplina:** Projeto Integrador III — Motor de Busca (Tecnologia em Ciência de Dados — Fatec Baixada Santista / Rubens Lara)  
**Repositório:** https://github.com/Megalonnix/proj_ivan_gustavo_jorge_PI3  
**Ambiente:** R base (`Rscript` / RStudio / Google Colab IRkernel) · LaTeX (`abnTeX2` + `knitr`)

> **Nota sobre convenção de identificadores.** Ao longo do curso convivem duas numerações para os documentos do corpus:
> - **Sequencial (`d1..d132`)** — usada no `entrega-1-docs.csv`, nos notebooks e no `corpus.csv`. É a numeração estável do corpus congelado.
> - **Por id original (`d<id_orig>`, 1..152 com 132 válidos)** — usada nos consolidados das Aulas 05b–07 e no `estado-R`. Reflete o `id` que veio da extração bruta antes do filtro `nchar > 200`.
>
> A ponte entre as duas é a coluna `id_orig` do `entrega-1-docs.csv` (e o mapa `id_orig_map` em `entrega-1-corpus.R`). Exemplo: o `d121` citado no consolidado da Aula 07 (poesia de Vicente de Carvalho e Victor Hugo, `id_orig=121`) corresponde ao **`d108` sequencial** da entrega. Já o `d121` sequencial da entrega (`id_orig=134`) é outro parágrafo, sobre o Forte de São João de Bertioga.

---

## 📋 Guia Rápido para Avaliação do Professor (Entrega de Meio de Semestre)

Esta seção reúne em um único lugar todas as entregas exigidas nas diretrizes da **Entrega de Meio de Semestre** e os comandos exatos para verificação no terminal ou RStudio.

### 1. Checklist das Entregas no Repositório

| Entrega Exigida | Status | Arquivos no Repositório (Links Diretos) |
|---|---|---|
| **1. Texto de Descrição e Defesa do Corpus (PDF `abnTeX2`, 3 páginas + Referências)** | ✅ Regenerado e conferido | • PDF em `consolidados/`: [`consolidados/entrega-1-corpus.pdf`](consolidados/entrega-1-corpus.pdf)<br>• PDF em `entregas/entrega-1/`: [`entregas/entrega-1/entrega-1-corpus.pdf`](entregas/entrega-1/entrega-1-corpus.pdf)<br>• PDF na raiz: [`entrega-1-corpus.pdf`](entrega-1-corpus.pdf)<br>• Código-fonte `.Rnw`: [`consolidados/entrega-1-corpus.Rnw`](consolidados/entrega-1-corpus.Rnw) · [`entregas/entrega-1/entrega-1-corpus.Rnw`](entregas/entrega-1/entrega-1-corpus.Rnw)<br>• Bibliografia `.bib`: [`consolidados/referencias.bib`](consolidados/referencias.bib) · [`entregas/entrega-1/referencias.bib`](entregas/entrega-1/referencias.bib)<br>• Script gerador dos CSVs e compilação: [`entregas/entrega-1/entrega-1-corpus.R`](entregas/entrega-1/entrega-1-corpus.R) |
| **2. Ficha do Projeto completa (Seções 1 a 7 + Estado do R)** | ✅ Entregue | • [`consolidados/00_FICHA_PROJETO.md`](consolidados/00_FICHA_PROJETO.md)<br>• [`00_FICHA_PROJETO.md`](00_FICHA_PROJETO.md) (espelho na raiz) |
| **3. Corpus congelado em `.rds` e scripts executáveis (`coletar.R`, `aula02.R`, `buscar.R`)** | ✅ Entregue | • Corpus `.rds`: [`estrutura/banco-de-dados/docs.rds`](estrutura/banco-de-dados/docs.rds) e [`estrutura/banco-de-dados/origem.rds`](estrutura/banco-de-dados/origem.rds) (também em `estrutura/bancoDeDados/`)<br>• Base bruta `.csv`: [`estrutura/bancoDeDados/wikipedia_baixada_santista.csv`](estrutura/bancoDeDados/wikipedia_baixada_santista.csv) (152 brutos → 132 válidos)<br>• Scripts de terminal: [`estrutura/codigo/coletar.R`](estrutura/codigo/coletar.R) · [`estrutura/codigo/aula02.R`](estrutura/codigo/aula02.R) · [`estrutura/codigo/buscar.R`](estrutura/codigo/buscar.R) (também em `entregas/entrega-1/`) |
| **4. Consolidados das Aulas 00 a 07 (Teoria e Parte D)** | ✅ Entregue | • Pasta [`consolidados/`](consolidados/) completa (`aula00` a `aula07`, teoria e `parteD`)<br>• Leitor automático no Colab: [`estrutura/codigo/Consolidados_Colab.ipynb`](estrutura/codigo/Consolidados_Colab.ipynb) |

---

### 2. Instruções para o Professor — Roteiro da Demonstração no Terminal

Todos os scripts foram construídos apenas com **R base** (sem dependências externas para o motor) e detectam automaticamente a raiz do repositório, podendo ser executados da raiz do projeto, de `estrutura/codigo/` ou de `entregas/entrega-1/`.

#### Passo 1 — Conferir o repositório, o PDF do corpus e a Ficha do Projeto
- Abrir [`consolidados/entrega-1-corpus.pdf`](consolidados/entrega-1-corpus.pdf) (3 páginas de texto + Referências na página 4).
- Abrir [`consolidados/00_FICHA_PROJETO.md`](consolidados/00_FICHA_PROJETO.md) e verificar na **Seção 4** os rankings Top-5 de referência das três consultas de trabalho (q₁, q₂, q₃).

#### Passo 2 — Regenerar e verificar o corpus (`docs.rds` e `origem.rds`)
No terminal (na raiz do repositório):
```bash
Rscript estrutura/codigo/coletar.R
```
Ou diretamente no console do R / RStudio:
```r
docs   <- readRDS("estrutura/banco-de-dados/docs.rds")
origem <- readRDS("estrutura/banco-de-dados/origem.rds")
length(docs)        # [1] 132
table(origem)       # Bertioga: 17 | Guaruja: 29 | Santos: 86
substr(docs[1:2], 1, 90)
```
> **Resultado esperado:** lê os 152 parágrafos brutos de `wikipedia_baixada_santista.csv`, aplica o corte `nchar(texto) > cfg$minimo` (`200` caracteres), descarta os 20 fragmentos curtos (cabeçalhos/rodapés) e grava os **132 parágrafos autônomos (`d1..d132`)** distribuídos em **Santos (86 — 65,2%)**, **Guarujá (29 — 22,0%)** e **Bertioga (17 — 12,9%)**.

#### Passo 3 — Rodar `aula02.R` (TF-IDF + Cosseno) e conferir com a Seção 4 da Ficha
No terminal:
```bash
Rscript estrutura/codigo/aula02.R
```
> **Resultado esperado (idêntico à Seção 4 de `00_FICHA_PROJETO.md` — tokenização bruta da Aula 02, antes da limpeza):**
> - **`q1 = "porto de santos"`** → Top-5 Cosseno: `d76 (0.193) · d39 (0.146) · d50 (0.132) · d67 (0.132) · d26 (0.123)`
> - **`q2 = "praias e turismo"`** → Top-5 Cosseno: `d2 (0.135) · d19 (0.120) · d80 (0.116) · d118 (0.106) · d53 (0.097)`
> - **`q3 = "forte sao joao"`** → Top-5 Cosseno: `d117 (0.205) · d121 (0.190) · d16 (0.129) · d132 (0.106) · d10 (0.104)`
>
> **Nota sobre os escores.** Os valores acima são da **tokenização bruta** (Aula 02, sem limpeza e sem stopwords) e são exatamente os que `aula02.R` imprime. A partir da Aula 03, com `translit` e 27 stopwords, os escores pós-limpeza são diferentes — e são esses que aparecem no `entrega-1-rankings.csv`: `q1 d76 = 0.2648`, `q2 d2 = 0.1780`, `q3 d117 = 0.2974`. **Ambos estão corretos dentro do seu contexto**; o `aula02.R` documenta o passo bruto; o CSV da entrega documenta o resultado pós-limpeza (fonte canônica da entrega).

#### Passo 4 — Explicar por que o 1.º colocado ganhou (parcelas do produto escalar `qw * w[, melhor]`)
O próprio script `aula02.R` já imprime no terminal a decomposição exata de `qw * w[, melhor]` para o 1.º colocado de cada consulta:
- Em **q₁ (`"porto de santos"`)**, vence **`d76`** (Santos, inauguração do Porto de Santos em 1892): `porto = 4.22 | de = 0.01 | santos = 0.59`. O termo raro `porto` (IDF alto, repetido no parágrafo) domina a soma, enquanto a preposição `de` (presente em quase todo o corpus) contribui apenas `0.01`.
- Em **q₂ (`"praias e turismo"`)**, vence **`d2`** (Guarujá): `praias = 5.32 | e = 0.05 | turismo = 0.00`. Na busca pós-limpeza com BM25 (`Rscript estrutura/codigo/buscar.R`), o 1.º lugar passa a ser **`d80`** (Santos), pois contém simultaneamente `praias` e `turismo`.
- Em **q₃ (`"forte sao joao"`)**, vence **`d117`** (Bertioga, Forte de São João): `forte = 6.28 | são = 1.37 | joão = 3.78`.

#### Passo 5 (Opcional) — Auditoria multimétodo (Booleano AND/OR, TF-IDF, Cosseno, BM25 e nDCG@5)
Para verificar os resultados da **Tabela 2 do PDF do corpus** (pós-limpeza da Aula 03 com `translit` e remoção das 27 stopwords, avaliados contra `qrels_jorge_2026-10-13.csv`):
```bash
Rscript estrutura/codigo/buscar.R
```

#### Passo 6 (Opcional) — Recompilar o PDF `entrega-1-corpus.pdf` do zero
Caso deseje regenerar todas as tabelas `.csv` (`entrega-1-docs.csv`, `entrega-1-paginas.csv`, `entrega-1-metodos.csv`, `entrega-1-rankings.csv`, `entrega-1-resultados.csv`, `entrega-1-top10.csv`) e recompilar o `.Rnw` em PDF (requer pacote `knitr` e distribuição LaTeX com `abntex2`):
```bash
Rscript entregas/entrega-1/entrega-1-corpus.R
```
Ou compilando diretamente o `.Rnw` dentro de `consolidados/` (ou `entregas/entrega-1/`):
```bash
cd consolidados
Rscript -e "knitr::knit2pdf('entrega-1-corpus.Rnw', bib_engine = 'bibtex')"
```

> **Auditoria dos tamanhos limpos:** os 132 documentos têm de **22 a 186 tokens limpos**, total de **9.632**, média **73,0** e mediana **64,5**; `d85` é o maior, com 186 tokens. Os CSVs e os três PDFs foram regenerados a partir dos dados e agora apresentam essas medidas. O vocabulário limpo calculado pelo gerador atual é **3.471 termos**.

> **Nota histórica sobre vocabulário:** os consolidados das Aulas 03 e 07 registram 3.483 e 3.493 termos, respectivamente. Esses números são snapshots de sessões anteriores; para a versão atual da Entrega 1, use 3.471, calculado pelo gerador.

---

## 📂 Estrutura Oficial do Repositório

```text
.
├── 00_FICHA_PROJETO.md                 # Ficha acumulativa (Aulas 01 a 07 - motor07)
├── config.R                            # Configuração homologada do motor de busca
├── corpus.csv                          # Base bruta (152 parágrafos; 132 válidos > 200 chars)
├── entrega-1-corpus.pdf                # PDF da Entrega 1 (cópia na raiz para acesso imediato)
├── necessidades.csv                    # 12 necessidades de informação (8 dev + 4 teste)
├── qrels_jorge_2026-10-13.csv          # 230 julgamentos humanos de relevância (0, 1, 2)
├── README.md                           # Este guia de navegação e instruções para o professor
├── wikipedia_baixada_santista.csv      # Base bruta extraída da Wikipédia (Santos, Guarujá, Bertioga)
│
├─── consolidados/
│   ├── 00_FICHA_PROJETO.md             # Ficha do projeto sincronizada
│   ├── entrega-1-corpus.pdf            # PDF oficial da Entrega 1 (abnTeX2, 3 págs + Referências)
│   ├── entrega-1-corpus.Rnw            # Código-fonte LaTeX + knitr (Sweave) sem números fixos
│   ├── entrega-1-corpus.R              # Script que gera os CSVs diagnósticos e compila o PDF
│   ├── referencias.bib                 # Base BibTeX (Manning, Robertson, Järvelin, Wikipédia)
│   ├── entrega-1-*.csv                 # 6 tabelas CSV lidas pelos chunks do .Rnw
│   ├── aula00_consolidado.md .. aula07_parteD_consolidado.md
│
├─── entregas/
│   └─── entrega-1/
│       ├── entrega-1-corpus.pdf        # PDF oficial da Entrega 1
│       ├── entrega-1-corpus.Rnw        # Código-fonte LaTeX + knitr
│       ├── entrega-1-corpus.R          # Script gerador dos CSVs e compilação do PDF
│       ├── referencias.bib             # Base BibTeX
│       ├── entrega-1-*.csv             # 6 tabelas CSV geradas pelo script
│       ├── coletar.R                   # Cópia do script de coleta/filtro do corpus
│       ├── aula02.R                    # Cópia do script de demonstração da Aula 02
│       └── buscar.R                    # Cópia do script de auditoria multimétodo
│
├─── estrutura/
│   ├─── banco-de-dados/
│   │   ├── docs.rds                    # Vetor nomeado (d1..d132) com os 132 parágrafos válidos
│   │   └── origem.rds                  # Vetor nomeado (d1..d132) com a página de origem
│   │
│   ├─── bancoDeDados/
│   │   ├── docs.rds
│   │   ├── origem.rds
│   │   ├── corpus.csv
│   │   ├── necessidades.csv
│   │   ├── qrels_jorge_2026-10-13.csv
│   │   └── wikipedia_baixada_santista.csv
│   │
│   └─── codigo/
│       ├── coletar.R                   # Regenera docs.rds e origem.rds a partir da base bruta
│       ├── aula02.R                    # Executa TF-IDF + Cosseno nas 3 consultas de trabalho
│       ├── buscar.R                    # Executa Booleano AND/OR, TF-IDF, Cosseno, BM25 e nDCG@5
│       ├── config.R                    # Configuração homologada do motor
│       ├── Consolidados_Colab.ipynb    # Leitor automático dos consolidados no Google Colab
│       └── aula00.ipynb .. Aula07_ParteD.ipynb
│
└─── guias_estudo/
    └── GUIA_ESTUDO_aula00 .. aula07 (.md)
```

---

## 🔗 Abrir Entregas e Consolidados Diretamente no GitHub

### 🚨 Baixar e visualizar todos os consolidados pelo *Google Colab*
- **Link direto para o Colab:** [Abrir o Colab e carregar os 17 arquivos `.md`](https://colab.research.google.com/github/Megalonnix/proj_ivan_gustavo_jorge_PI3/blob/main/estrutura/codigo/Consolidados_Colab.ipynb)  
  *(No Colab, mantenha o runtime padrão **Python 3** e clique em **Runtime → Run all**).*

### Links diretos para cada documento no GitHub

| Documento / Consolidado | Guia / Modelo de Origem | Abrir no GitHub |
| --- | --- | --- |
| **Texto do Corpus (PDF)** | Modelo oficial `entrega-1-corpus.Rnw` (`abnTeX2`) | [`consolidados/entrega-1-corpus.pdf`](consolidados/entrega-1-corpus.pdf) |
| **Código-fonte do Corpus (`.Rnw`)** | Modelo oficial `entrega-1-corpus.Rnw` (`knitr`) | [`consolidados/entrega-1-corpus.Rnw`](consolidados/entrega-1-corpus.Rnw) |
| **Ficha do Projeto** | Acumulativa ([Aula 01](guias_estudo/GUIA_ESTUDO_aula01_parteD.md) a [Aula 07](guias_estudo/GUIA_ESTUDO_aula07_parteD.md)) | [`consolidados/00_FICHA_PROJETO.md`](consolidados/00_FICHA_PROJETO.md) |
| **Aula 00 — Teoria** | [GUIA_ESTUDO_aula00_teoria.md](guias_estudo/GUIA_ESTUDO_aula00_teoria.md) | [`consolidados/aula00_consolidado.md`](consolidados/aula00_consolidado.md) |
| **Aula 00 — Parte D** | [GUIA_ESTUDO_aula00_parteD.md](guias_estudo/GUIA_ESTUDO_aula00_parteD.md) | [`consolidados/aula00_parteD_consolidado.md`](consolidados/aula00_parteD_consolidado.md) |
| **Aula 01 — Teoria** | [GUIA_ESTUDO_aula01_teoria.md](guias_estudo/GUIA_ESTUDO_aula01_teoria.md) | [`consolidados/aula01_consolidado.md`](consolidados/aula01_consolidado.md) |
| **Aula 01 — Parte D** | [GUIA_ESTUDO_aula01_parteD.md](guias_estudo/GUIA_ESTUDO_aula01_parteD.md) | [`consolidados/aula01_parteD_consolidado.md`](consolidados/aula01_parteD_consolidado.md) |
| **Aula 02 — Teoria** | [GUIA_ESTUDO_aula02_teoria.md](guias_estudo/GUIA_ESTUDO_aula02_teoria.md) | [`consolidados/aula02_consolidado.md`](consolidados/aula02_consolidado.md) |
| **Aula 02 — Parte D** | [GUIA_ESTUDO_aula02_parteD.md](guias_estudo/GUIA_ESTUDO_aula02_parteD.md) | [`consolidados/aula02_parteD_consolidado.md`](consolidados/aula02_parteD_consolidado.md) |
| **Aula 03 — Teoria** | [GUIA_ESTUDO_aula03_teoria.md](guias_estudo/GUIA_ESTUDO_aula03_teoria.md) | [`consolidados/aula03_consolidado.md`](consolidados/aula03_consolidado.md) |
| **Aula 03 — Parte D** | [GUIA_ESTUDO_aula03_parteD.md](guias_estudo/GUIA_ESTUDO_aula03_parteD.md) | [`consolidados/aula03_parteD_consolidado.md`](consolidados/aula03_parteD_consolidado.md) |
| **Aula 04 — Teoria** | [GUIA_ESTUDO_aula04_teoria.md](guias_estudo/GUIA_ESTUDO_aula04_teoria.md) | [`consolidados/aula04_consolidado.md`](consolidados/aula04_consolidado.md) |
| **Aula 04 — Parte D** | [GUIA_ESTUDO_aula04_parteD.md](guias_estudo/GUIA_ESTUDO_aula04_parteD.md) | [`consolidados/aula04_parteD_consolidado.md`](consolidados/aula04_parteD_consolidado.md) |
| **Aula 05b — Teoria** | [GUIA_ESTUDO_aula05b_teoria.md](guias_estudo/GUIA_ESTUDO_aula05b_teoria.md) | [`consolidados/aula05b_consolidado.md`](consolidados/aula05b_consolidado.md) |
| **Aula 05b — Parte D** | [GUIA_ESTUDO_aula05b_parteD.md](guias_estudo/GUIA_ESTUDO_aula05b_parteD.md) | [`consolidados/aula05b_parteD_consolidado.md`](consolidados/aula05b_parteD_consolidado.md) |
| **Aula 06 — Teoria** | [GUIA_ESTUDO_aula06_teoria.md](guias_estudo/GUIA_ESTUDO_aula06_teoria.md) | [`consolidados/aula06_consolidado.md`](consolidados/aula06_consolidado.md) |
| **Aula 06 — Parte D** | [GUIA_ESTUDO_aula06_parteD.md](guias_estudo/GUIA_ESTUDO_aula06_parteD.md) | [`consolidados/aula06_parteD_consolidado.md`](consolidados/aula06_parteD_consolidado.md) |
| **Aula 07 — Teoria** | [GUIA_ESTUDO_aula07_teoria.md](guias_estudo/GUIA_ESTUDO_aula07_teoria.md) | [`consolidados/aula07_consolidado.md`](consolidados/aula07_consolidado.md) |
| **Aula 07 — Parte D** | [GUIA_ESTUDO_aula07_parteD.md](guias_estudo/GUIA_ESTUDO_aula07_parteD.md) | [`consolidados/aula07_parteD_consolidado.md`](consolidados/aula07_parteD_consolidado.md) |

---

## 📊 Resumo dos Resultados Experimentais Homologados pelo Grupo

1. **Aulas 00–02 (Corpus e Modelo Vetorial):** Extração de 152 parágrafos brutos da Wikipédia e congelamento de N = 132 parágrafos autônomos (`cfg$minimo = 200` caracteres: 86 de Santos, 29 de Guarujá e 17 de Bertioga). Homologação das 3 consultas de trabalho no modelo TF-IDF + Cosseno (q₁ → `d76`, q₂ → `d2`, q₃ → `d117`).

2. **Aula 03 (Limpeza e Índice Invertido):** Adoção de `cfg$acentos = "translit"`, remoção de 27 stopwords funcionais e construção do índice invertido (`postings`), reduzindo o vocabulário de 4.250 para 3.483 termos no resultado registrado naquela sessão, sem partir topônimos regionais (ex.: `Guarujá` → `guaruja`, não `guaruj`/`guaruj a`).

3. **Aula 04 (Modelo Probabilístico BM25):** Implementação do BM25 com parâmetros canônicos (k₁ = 1,2 e b = 0,75), promovendo documentos que cobrem **todos** os termos da consulta (como `d80` e `d118` em q₂), em contraste com o Cosseno, que privilegiava `d2` por repetição de `praias`.

4. **Aula 05,5 (Avaliação Formal com 230 Qrels):** No conjunto de 12 necessidades julgadas pelo juiz Jorge (`cfg$limiar = 2`), houve empate técnico de **6 a 6** em AP entre Cosseno (MAP = 0,640) e BM25 (MAP = 0,637), ambos com P@3 = 0,917. A diferença de 0,003 no MAP é estatisticamente indistinguível em 12 consultas.

5. **Aula 06 (Rocchio e Pseudo-Realimentação PRF):**
   - Na consulta q₀₂, o Rocchio elevou o AP na **coleção completa** (0,780 → 0,947), mas caiu na **coleção residual** (0,649 → 0,498), comprovando o viés otimista de reordenação dos documentos já vistos pelo usuário.
   - A PRF provocou *query drift* em consultas curtas (MAP<sub>dev</sub>: 0,653 → 0,448 em k = 2; MAP<sub>teste</sub>: 0,612 → 0,487). Decisão homologada em `config.R`: **`prf_k = 0`** (desligada em produção).

6. **Aula 07 (Decomposição Espectral LSA/SVD e Fusão Híbrida RRF):**
   - Avaliação sistemática de SVD truncada (k = 10, 20, 50) e fusão híbrida RRF (c = 60): no dev (q₀₁..q₀₈), o BM25 puro obteve MAP = 0,744 contra 0,652 do híbrido (k = 20) e 0,402 do LSA puro (k = 20); no teste (q₀₉..q₁₂), o BM25 confirmou a liderança com MAP = 0,718 contra 0,642 do híbrido (k = 20).
   - A inspeção qualitativa em q₀₁ ("fundação de Santos") mostrou que o LSA introduziu documentos sem termos da consulta por alinhamento latente — o exemplo canônico é o parágrafo sobre a poesia de Vicente de Carvalho e Victor Hugo, identificado como `d121` **na convenção dos consolidados** (`id_orig=121`), que corresponde ao `d108` **sequencial** da entrega.
   - Decisão homologada em `config.R`: manter **`modelo = "bm25"`** em produção (`lsa_k = 20`, `rrf_c = 60`).