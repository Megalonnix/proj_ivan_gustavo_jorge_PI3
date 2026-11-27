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
> - **Sequencial (`d1..d132`)** — usada no `entrega-1-docs.csv`, nos notebooks e em `docs.rds`. É a numeração estável do corpus congelado.
> - **Por id original (`d<id_orig>`, 1..152 com 132 válidos)** — usada nos consolidados das Aulas 05b–08, em `pipeline.R` (`csv/`) e no `estado-R`. Reflete o `id` que veio da extração bruta antes do filtro `nchar > 200`.
>
> A ponte entre as duas é a coluna `id_orig` do `entrega-1-docs.csv` (e o mapa `id_orig_map` em `entrega-1-corpus.R`). Exemplo: o `d121` citado no consolidado da Aula 07 (poesia de Vicente de Carvalho e Victor Hugo, `id_orig=121`) corresponde ao **`d108` sequencial** da entrega. Já o `d121` sequencial da entrega (`id_orig=134`) é outro parágrafo, sobre o Forte de São João de Bertioga.

---

## 📋 Guia Rápido para Avaliação do Professor (Entrega de Meio de Semestre)

Esta seção reúne em um único lugar todas as entregas exigidas nas diretrizes da **Entrega de Meio de Semestre** e os comandos exatos para verificação no terminal ou RStudio.

### 1. Checklist das Entregas no Repositório

| Entrega Exigida | Status | Arquivos no Repositório (Links Diretos) |
|---|---|---|
| **1. Texto de Descrição e Defesa do Corpus (PDF `abnTeX2`, 3 páginas + Referências)** | ✅ Entregue | • PDF em `entregas/entrega-1/`: [`entregas/entrega-1/entrega-1-corpus.pdf`](entregas/entrega-1/entrega-1-corpus.pdf)<br>• Código-fonte `.Rnw`: [`entregas/entrega-1/entrega-1-corpus.Rnw`](entregas/entrega-1/entrega-1-corpus.Rnw)<br>• Bibliografia `.bib`: [`entregas/entrega-1/referencias.bib`](entregas/entrega-1/referencias.bib)<br>• Script gerador e resumo: [`entregas/entrega-1/entrega-1-corpus.R`](entregas/entrega-1/entrega-1-corpus.R) · [`entregas/entrega-1/entrega-1-numeros.txt`](entregas/entrega-1/entrega-1-numeros.txt) |
| **2. Ficha do Projeto completa (Seções 1 a 7 + Estado do R)** | ✅ Entregue | • [`consolidados/00_FICHA_PROJETO.md`](consolidados/00_FICHA_PROJETO.md) |
| **3. Corpus congelado em `.rds` e scripts executáveis (`coletar.R`, `01b-shannon-pesos.R`, `aula02.R`, `buscar.R`, `pipeline.R`)** | ✅ Entregue | • Corpus `.rds`: [`estrutura/banco-de-dados/docs.rds`](estrutura/banco-de-dados/docs.rds) e [`estrutura/banco-de-dados/origem.rds`](estrutura/banco-de-dados/origem.rds)<br>• Base bruta `.csv`: [`estrutura/banco-de-dados/corpus.csv`](estrutura/banco-de-dados/corpus.csv) (152 brutos → 132 válidos)<br>• Scripts de terminal: [`estrutura/codigo/coletar.R`](estrutura/codigo/coletar.R) · [`estrutura/codigo/01b-shannon-pesos.R`](estrutura/codigo/01b-shannon-pesos.R) · [`estrutura/codigo/aula02.R`](estrutura/codigo/aula02.R) · [`estrutura/codigo/buscar.R`](estrutura/codigo/buscar.R) · [`estrutura/codigo/pipeline.R`](estrutura/codigo/pipeline.R)<br>• Configuração canônica: [`config.R`](config.R) |
| **4. Consolidados das Aulas 00 a 08 (Teoria, Parte D, 01b Shannon e Tema 7)** | ✅ Entregue | • Pasta [`consolidados/`](consolidados/) completa (`aula00` a `aula08`, `aula01b_shannon_consolidado.md` e `aula08_tema/aula08_tema_consolidado.md`)<br>• Leitor automático no Colab: [`arquivo-legado/Consolidados_Colab.ipynb`](arquivo-legado/Consolidados_Colab.ipynb) |
| **5. Julgamento, Pool (12 consultas) e Kappa (`05-julgamento/`)** | ✅ Estruturado | • Interface HTML: [`estrutura/codigo/05-julgamento/05-julgar.html`](estrutura/codigo/05-julgamento/05-julgar.html)<br>• Scripts: [`05a-kappa.R`](estrutura/codigo/05-julgamento/05a-kappa.R) · [`05e-consolidar-qrels.R`](estrutura/codigo/05-julgamento/05e-consolidar-qrels.R)<br>• Respostas e templates (`q01..q12`): [`csv/05-qrels-respostas/`](csv/05-qrels-respostas/README.md) |

---

### 2. Instruções para o Professor — Roteiro da Demonstração no Terminal

Todos os scripts foram construídos apenas com **R base** (sem dependências externas para o motor) e detectam automaticamente a raiz do repositório, podendo ser executados da raiz do projeto ou de `estrutura/codigo/`.

#### Passo 1 — Conferir o repositório, o PDF do corpus e a Ficha do Projeto
- Abrir [`entregas/entrega-1/entrega-1-corpus.pdf`](entregas/entrega-1/entrega-1-corpus.pdf) (3 páginas de texto + Referências na página 4) e [`entregas/entrega-1/entrega-1-numeros.txt`](entregas/entrega-1/entrega-1-numeros.txt).
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
> **Resultado esperado:** lê os 152 parágrafos brutos de `estrutura/banco-de-dados/corpus.csv`, aplica o corte `nchar(texto) > cfg$minimo` (`200` caracteres), descarta os 20 fragmentos curtos (cabeçalhos/rodapés) e grava os **132 parágrafos autônomos (`d1..d132`)** distribuídos em **Santos (86 — 65,2%)**, **Guarujá (29 — 22,0%)** e **Bertioga (17 — 12,9%)**.

#### Passo 3 — Rodar `aula02.R` (TF-IDF + Cosseno) e `01b-shannon-pesos.R`
No terminal:
```bash
Rscript estrutura/codigo/01b-shannon-pesos.R
Rscript estrutura/codigo/aula02.R
```
> **Resultado esperado em `aula02.R` (tokenização bruta da Aula 02, antes da limpeza — idêntico à Seção 4 de `consolidados/00_FICHA_PROJETO.md`):**
> - **`q1 = "porto de santos"`** → Top-5 Cosseno: `d76 (0.193) · d39 (0.146) · d50 (0.132) · d67 (0.132) · d26 (0.123)`
> - **`q2 = "praias e turismo"`** → Top-5 Cosseno: `d2 (0.135) · d19 (0.120) · d80 (0.116) · d118 (0.106) · d53 (0.097)`
> - **`q3 = "forte sao joao"`** → Top-5 Cosseno: `d117 (0.205) · d121 (0.190) · d16 (0.129) · d132 (0.106) · d10 (0.104)`
>
> **Nota sobre os escores.** Os valores acima são da **tokenização bruta** (Aula 02, sem limpeza e sem stopwords). A partir da Aula 03, com `translit` e 27 stopwords, os escores pós-limpeza no `entrega-1-rankings.csv` passam a ser: `q1 d76 = 0.2711`, `q2 d2 = 0.1789`, `q3 d117 = 0.3219`.

#### Passo 4 — Explicar por que o 1.º colocado ganhou (parcelas do produto escalar `qw * w[, melhor]`)
O próprio script `aula02.R` já imprime no terminal a decomposição exata de `qw * w[, melhor]` para o 1.º colocado de cada consulta:
- Em **q₁ (`"porto de santos"`)**, vence **`d76`** (Santos, inauguração do Porto de Santos em 1892): `porto = 4.22 | de = 0.01 | santos = 0.59`. O termo raro `porto` (IDF alto, repetido no parágrafo) domina a soma, enquanto a preposição `de` (presente em quase todo o corpus) contribui apenas `0.01`.
- Em **q₂ (`"praias e turismo"`)**, vence **`d2`** (Guarujá): `praias = 5.32 | e = 0.05 | turismo = 0.00`. Na busca pós-limpeza com BM25 (`Rscript estrutura/codigo/buscar.R`), o 1.º lugar passa a ser **`d80`** (Santos), pois contém simultaneamente `praias` e `turismo`.
- Em **q₃ (`"forte sao joao"`)**, vence **`d117`** (Bertioga, Forte de São João): `forte = 6.28 | são = 1.37 | joão = 3.78`.

#### Passo 5 (Opcional) — Auditoria multimétodo (Booleano AND/OR, TF-IDF, Cosseno, BM25 e nDCG@5)
Para verificar os resultados da **Tabela 2 do PDF do corpus** (pós-limpeza da Aula 03 com `translit` e remoção das 27 stopwords, avaliados contra `csv/05-qrels-respostas/qrels_jorge_2026-10-13.csv`):
```bash
Rscript estrutura/codigo/buscar.R
```

#### Passo 6 (Opcional) — Recompilar os CSVs e o PDF `entrega-1-corpus.pdf` do zero
Para regenerar todas as tabelas de `entregas/entrega-1/` (`entrega-1-docs.csv`, `entrega-1-paginas.csv`, `entrega-1-metodos.csv`, `entrega-1-rankings.csv`, `entrega-1-resultados.csv`, `entrega-1-top10.csv`, `entrega-1-julgamento.csv`, `entrega-meio-semestre-auditoria.csv`, `entrega-1-numeros.txt`) e recompilar o `.Rnw` em PDF (requer pacote `knitr` e distribuição LaTeX com `abntex2`):
```bash
Rscript entregas/entrega-1/entrega-1-corpus.R
```
Ou compilando diretamente o `.Rnw` dentro de `entregas/entrega-1/`:
```bash
cd entregas/entrega-1
Rscript -e "knitr::knit2pdf('entrega-1-corpus.Rnw', bib_engine = 'bibtex')"
```

> **Auditoria dos tamanhos limpos (UTF-8 transliterado sem mojibake):** os 132 documentos têm de **20 a 167 tokens limpos**, total de **8.746**, média **66,3** e mediana **58,5**; `d85` é o maior, com 167 tokens. O vocabulário limpo unificado é **3.483 termos** (idêntico ao registrado na Aula 03).

---

## 📂 Estrutura Oficial do Repositório

```text
.
├── config.R                            # Configuração única homologada do motor de busca
├── README.md                           # Este guia de navegação e instruções para o professor
│
├─── arquivo-legado/
│   └── Consolidados_Colab.ipynb        # Leitor automático dos consolidados no Google Colab
│
├─── consolidados/
│   ├── 00_FICHA_PROJETO.md             # Ficha acumulativa do projeto (Seções 1–7 + Estado do R)
│   ├── aula00_consolidado.md .. aula08_parteD_consolidado.md
│   ├── aula01b_shannon_consolidado.md  # Teoria da Informação (bits) no curso e no corpus
│   └── aula08_tema/
│       └── aula08_tema_consolidado.md  # Tema 7 (combinar escores: notas vs posições) + Estado do R
│
├─── csv/
│   ├── 05-qrels-respostas/             # Gabarito (qrels_jorge), templates q01..q12 e README
│   ├── rankings.csv                    # Rankings completos dos modelos (N = 132)
│   ├── 05-pool.csv                     # Pool completa de 12 consultas (Booleano, TF-IDF, BM25)
│   ├── 05-divergencias.csv             # Auditoria de divergências entre juízes
│   ├── 05-qrels.csv                    # Gabarito consolidado nos 132 parágrafos válidos (219 linhas)
│   ├── 05b-metricas-por-consulta.csv   # P@10, Recall, AP, MRR e nDCG@10 (ganho linear)
│   ├── 05b-map.csv                     # MAP médio por modelo e conjunto (dev/teste)
│   ├── 06-pseudo-feedback-por-consulta.csv
│   ├── 06-rocchio-por-consulta.csv
│   ├── 06-rocchio-metricas.csv         # Comparativo completo vs residual realista no dev
│   ├── 07-lsa-por-consulta.csv
│   ├── 07-lsa-map-por-k.csv
│   ├── 07-lsa-top5.csv                 # Top-5 comparativo: bm25 vs lsa_20 vs hibrido_20_60
│   ├── 08-rerank-por-consulta.csv      # Métricas e top-5 após reordenação por proximidade
│   ├── 08-rerank-grade-dev.csv         # Grade de MAP (k x janela) em dev/teste
│   └── 08-rerank-top5.csv              # Comparativo top-5 estágio 1 vs rerank (k=10, janela=3)
│
├─── entregas/
│   └─── entrega-1/
│       ├── entrega-1-corpus.pdf        # PDF oficial da Entrega 1 (abnTeX2, 3 págs + Referências)
│       ├── entrega-1-corpus.Rnw        # Código-fonte LaTeX + knitr (Sweave) sem números fixos
│       ├── entrega-1-corpus.R          # Script gerador dos CSVs, TXT e compilação do PDF
│       ├── referencias.bib             # Base BibTeX (Manning, Robertson, Järvelin, Wikipédia)
│       ├── entrega-1-numeros.txt       # Resumo auditável em texto puro dos números da entrega
│       └── entrega-1-*.csv / entrega-meio-semestre-auditoria.csv
│
├─── estrutura/
│   ├─── banco-de-dados/
│   │   ├── docs.rds                    # Vetor nomeado (d1..d132) com os 132 parágrafos válidos
│   │   ├── origem.rds                  # Vetor nomeado (d1..d132) com a página de origem
│   │   ├── corpus.csv                  # Base bruta única (152 parágrafos; 132 válidos > 200 chars)
│   │   └── necessidades.csv            # 12 necessidades de informação (8 dev + 4 teste)
│   │
│   └─── codigo/
│       ├── 05-julgamento/
│       │   ├── 05-julgar.html          # Ferramenta HTML de julgamento às cegas (Aula 05)
│       │   ├── 05a-kappa.R             # Cálculo do Kappa de Cohen (matrizes da aula + qrels)
│       │   ├── 05e-consolidar-qrels.R  # Consolidação de respostas em csv/05-qrels.csv
│       │   └── README.md               # Instruções da pool e julgamento de relevância
│       ├── coletar.R                   # Regenera docs.rds e origem.rds a partir da base bruta
│       ├── 01b-shannon-pesos.R         # Aula 01b: autoinformação em bits (8 docs + corpus)
│       ├── aula02.R                    # Executa TF-IDF + Cosseno nas 3 consultas de trabalho
│       ├── buscar.R                    # Executa Booleano AND/OR, TF-IDF, Cosseno, BM25 e nDCG@5
│       ├── pipeline.R                  # Pipeline reprodutível das Aulas 05–08 (exporta csv/)
│       └── Aula00_Teoria.ipynb .. Aula08_ParteD.ipynb
│
└─── guias_estudo/
    └── GUIA_ESTUDO_aula00 .. aula08 (.md)
```

---

## 🔗 Abrir Entregas e Consolidados Diretamente no GitHub

### 🚨 Baixar e visualizar todos os consolidados pelo *Google Colab*
- **Link direto para o Colab:** [Abrir o Colab e carregar os arquivos `.md`](https://colab.research.google.com/github/Megalonnix/proj_ivan_gustavo_jorge_PI3/blob/main/arquivo-legado/Consolidados_Colab.ipynb)  
  *(No Colab, mantenha o runtime padrão **Python 3** e clique em **Runtime → Run all**).*

### Links diretos para cada documento no GitHub

| Documento / Consolidado | Guia / Modelo de Origem | Abrir no GitHub |
| --- | --- | --- |
| **Texto do Corpus (PDF)** | Modelo oficial `entrega-1-corpus.Rnw` (`abnTeX2`) | [`entregas/entrega-1/entrega-1-corpus.pdf`](entregas/entrega-1/entrega-1-corpus.pdf) |
| **Código-fonte do Corpus (`.Rnw`)** | Modelo oficial `entrega-1-corpus.Rnw` (`knitr`) | [`entregas/entrega-1/entrega-1-corpus.Rnw`](entregas/entrega-1/entrega-1-corpus.Rnw) |
| **Ficha do Projeto** | Acumulativa ([Aula 01](guias_estudo/GUIA_ESTUDO_aula01_parteD.md) a [Aula 08](guias_estudo/GUIA_ESTUDO_aula08_parteD.md)) | [`consolidados/00_FICHA_PROJETO.md`](consolidados/00_FICHA_PROJETO.md) |
| **Aula 00 — Teoria** | [GUIA_ESTUDO_aula00_teoria.md](guias_estudo/GUIA_ESTUDO_aula00_teoria.md) | [`consolidados/aula00_consolidado.md`](consolidados/aula00_consolidado.md) |
| **Aula 00 — Parte D** | [GUIA_ESTUDO_aula00_parteD.md](guias_estudo/GUIA_ESTUDO_aula00_parteD.md) | [`consolidados/aula00_parteD_consolidado.md`](consolidados/aula00_parteD_consolidado.md) |
| **Aula 01 — Teoria** | [GUIA_ESTUDO_aula01_teoria.md](guias_estudo/GUIA_ESTUDO_aula01_teoria.md) | [`consolidados/aula01_consolidado.md`](consolidados/aula01_consolidado.md) |
| **Aula 01 — Parte D** | [GUIA_ESTUDO_aula01_parteD.md](guias_estudo/GUIA_ESTUDO_aula01_parteD.md) | [`consolidados/aula01_parteD_consolidado.md`](consolidados/aula01_parteD_consolidado.md) |
| **Aula 01b — Shannon (Bits)** | [`estrutura/codigo/01b-shannon-pesos.R`](estrutura/codigo/01b-shannon-pesos.R) | [`consolidados/aula01b_shannon_consolidado.md`](consolidados/aula01b_shannon_consolidado.md) |
| **Aula 02 — Teoria** | [GUIA_ESTUDO_aula02_teoria.md](guias_estudo/GUIA_ESTUDO_aula02_teoria.md) | [`consolidados/aula02_consolidado.md`](consolidados/aula02_consolidado.md) |
| **Aula 02 — Parte D** | [GUIA_ESTUDO_aula02_parteD.md](guias_estudo/GUIA_ESTUDO_aula02_parteD.md) | [`consolidados/aula02_parteD_consolidado.md`](consolidados/aula02_parteD_consolidado.md) |
| **Aula 03 — Teoria** | [GUIA_ESTUDO_aula03_teoria.md](guias_estudo/GUIA_ESTUDO_aula03_teoria.md) | [`consolidados/aula03_consolidado.md`](consolidados/aula03_consolidado.md) |
| **Aula 03 — Parte D** | [GUIA_ESTUDO_aula03_parteD.md](guias_estudo/GUIA_ESTUDO_aula03_parteD.md) | [`consolidados/aula03_parteD_consolidado.md`](consolidados/aula03_parteD_consolidado.md) |
| **Aula 04 — Teoria** | [GUIA_ESTUDO_aula04_teoria.md](guias_estudo/GUIA_ESTUDO_aula04_teoria.md) | [`consolidados/aula04_consolidado.md`](consolidados/aula04_consolidado.md) |
| **Aula 04 — Parte D** | [GUIA_ESTUDO_aula04_parteD.md](guias_estudo/GUIA_ESTUDO_aula04_parteD.md) | [`consolidados/aula04_parteD_consolidado.md`](consolidados/aula04_parteD_consolidado.md) |
| **Aula 05 — Teoria** | [GUIA_ESTUDO_aula05_teoria.md](guias_estudo/GUIA_ESTUDO_aula05_teoria.md) | [`consolidados/aula05_consolidado.md`](consolidados/aula05_consolidado.md) |
| **Aula 05 — Parte D** | [GUIA_ESTUDO_aula05_parteD.md](guias_estudo/GUIA_ESTUDO_aula05_parteD.md) | [`consolidados/aula05_parteD_consolidado.md`](consolidados/aula05_parteD_consolidado.md) |
| **Aula 05b — Teoria** | [GUIA_ESTUDO_aula05b_teoria.md](guias_estudo/GUIA_ESTUDO_aula05b_teoria.md) | [`consolidados/aula05b_consolidado.md`](consolidados/aula05b_consolidado.md) |
| **Aula 05b — Parte D** | [GUIA_ESTUDO_aula05b_parteD.md](guias_estudo/GUIA_ESTUDO_aula05b_parteD.md) | [`consolidados/aula05b_parteD_consolidado.md`](consolidados/aula05b_parteD_consolidado.md) |
| **Aula 06 — Teoria** | [GUIA_ESTUDO_aula06_teoria.md](guias_estudo/GUIA_ESTUDO_aula06_teoria.md) | [`consolidados/aula06_consolidado.md`](consolidados/aula06_consolidado.md) |
| **Aula 06 — Parte D** | [GUIA_ESTUDO_aula06_parteD.md](guias_estudo/GUIA_ESTUDO_aula06_parteD.md) | [`consolidados/aula06_parteD_consolidado.md`](consolidados/aula06_parteD_consolidado.md) |
| **Aula 07 — Teoria** | [GUIA_ESTUDO_aula07_teoria.md](guias_estudo/GUIA_ESTUDO_aula07_teoria.md) | [`consolidados/aula07_consolidado.md`](consolidados/aula07_consolidado.md) |
| **Aula 07 — Parte D** | [GUIA_ESTUDO_aula07_parteD.md](guias_estudo/GUIA_ESTUDO_aula07_parteD.md) | [`consolidados/aula07_parteD_consolidado.md`](consolidados/aula07_parteD_consolidado.md) |
| **Aula 08 — Teoria** | [GUIA_ESTUDO_aula08.md](guias_estudo/GUIA_ESTUDO_aula08.md) | [`consolidados/aula08_consolidado.md`](consolidados/aula08_consolidado.md) |
| **Aula 08 — Parte D** | [GUIA_ESTUDO_aula08_parteD.md](guias_estudo/GUIA_ESTUDO_aula08_parteD.md) | [`consolidados/aula08_parteD_consolidado.md`](consolidados/aula08_parteD_consolidado.md) |
| **Aula 08 — Tema 7 (Notas × Posições)** | `GUIA_TEMA_07_combinar_escores.md` | [`consolidados/aula08_tema/aula08_tema_consolidado.md`](consolidados/aula08_tema/aula08_tema_consolidado.md) |

---

## 📊 Resumo dos Resultados Experimentais Homologados pelo Grupo

1. **Aulas 00–02 (Corpus e Modelo Vetorial):** Extração de 152 parágrafos brutos da Wikipédia e congelamento de $N = 132$ parágrafos autônomos (`cfg$minimo = 200` caracteres: 86 de Santos, 29 de Guarujá e 17 de Bertioga). Homologação das 3 consultas de trabalho no modelo TF-IDF + Cosseno (q₁ → `d76`, q₂ → `d2`, q₃ → `d117`).

2. **Aula 01b (Shannon e Bits):** $\log_2(132) = 7{,}044\text{ bits}$ de incerteza inicial; a preposição `de` ocorre em todos os 132 parágrafos ($I = 0{,}000\text{ bits}$), enquanto termos específicos como `forte` e `cafe` carregam $4{,}044\text{ bits}$ cada.

3. **Aula 03 (Limpeza e Índice Invertido):** Adoção de `cfg$acentos = "translit"`, remoção de 27 stopwords funcionais e construção do índice invertido (`postings`), reduzindo o vocabulário de **4.250 para 3.483 termos** (8.746 tokens limpos), sem partir topônimos regionais (ex.: `Guarujá` → `guaruja`, não `guaruj`).

4. **Aula 04 (Modelo Probabilístico BM25):** Implementação do BM25 com parâmetros canônicos ($k_1 = 1{,}2$ e $b = 0{,}75$), promovendo documentos que cobrem **todos** os termos da consulta (como `d80` e `d118` em q₂), em contraste com o Cosseno, que privilegiava `d2` por repetição de `praias`.

5. **Aula 05 / 05,5 (Pool, Julgamento e Avaliação Formal):**
   - Os 230 julgamentos iniciais do juiz Jorge (`csv/05-qrels-respostas/qrels_jorge_2026-10-13.csv`, todos marcados com `grau = 2`, sendo 219 nos 132 parágrafos válidos) servem como base de referência atual (`cfg$juizes = c("jorge")`, `cfg$limiar = 2`). A pool completa das 12 consultas (`csv/05-pool.csv`) e a ferramenta [`05-julgar.html`](estrutura/codigo/05-julgamento/05-julgar.html) já estão configuradas para coleta dos votos graduados (`0/1/2`) dos demais juízes (Ivan e Gustavo) e cálculo de $\kappa$.
   - Na comparação entre **Cosseno** e **BM25**: nos notebooks (`motor08.R`, 230 qrels brutos) registrou-se empate em AP (MAP Cosseno = $0{,}640$ vs BM25 = $0{,}637$); no `pipeline.R` limpo (219 qrels filtrados aos 132 docs válidos), **BM25 obtém $\text{MAP}_{\text{dev}} = 0{,}787$** ($\text{MAP}_{\text{teste}} = 0{,}749$) contra $\text{MAP}_{\text{dev}} = 0{,}784$ ($\text{MAP}_{\text{teste}} = 0{,}765$) do TF-IDF/Cosseno.

6. **Aula 06 (Rocchio e Pseudo-Realimentação PRF):**
   - Na avaliação residual realista (`csv/06-rocchio-metricas.csv`), o Rocchio eleva artificialmente o AP na **coleção completa** (ex.: $q_{02}$ salta de $0{,}823$ para $1{,}000$), mas cai fortemente na **coleção residual** ($0{,}699 \to 0{,}537$), comprovando o viés otimista de reordenação dos documentos já vistos.
   - A PRF provocou *query drift* em consultas curtas ($\text{MAP}_{\text{dev}}$ cai de $0{,}784$ para $0{,}601$ no `pipeline.R`; $0{,}653 \to 0{,}448$ em $k=2$ no notebook). Decisão homologada em `config.R`: **`prf_k = 0`**.

7. **Aula 07 (LSA/SVD e Fusão Híbrida RRF):**
   - No `dev` ($q_{01}..q_{08}$), o **BM25 puro vence todas as variantes** ($\text{MAP}_{\text{dev}} = 0{,}787$ no `pipeline.R` e $0{,}744$ no notebook `motor08.R`, contra $0{,}691$ / $0{,}652$ do híbrido RRF com $k=20, c=60$ e $0{,}425$ / $0{,}402$ do LSA $k=20$).
   - Decisão homologada em `config.R`: manter **`modelo = "bm25"`** em produção (`lsa_k = 20`, `rrf_c = 60`).

8. **Aula 08 (Reordenação por Proximidade Ordenada + Tema 7 — Combinação de Escores):**
   - **Proximidade ordenada:** na grade `dev` ($k \in \{3, 5, 10\} \times \text{janela} \in \{2, 3, 5\}$), $k=3$ e $k=5$ empataram exatamente com o estágio 1 (`0,787` no `pipeline.R` / `0,744` no notebook), enquanto $k=10$ caiu para `0,786` / `0,743` por perda em $q_{04}$ (`"clima na Baixada Santista"`). Decisão em `config.R`: **`rerank_k = 0`** e **`janela = 3`**.
   - **Tema 7 (Combinação por notas *min-max* / *z-score*):** no `dev`, nenhuma combinação na grade ($\alpha \in \{0{,}2, 0{,}5, 0{,}8\}$ com $k = 10$) superou o BM25 puro ($0{,}744$ contra $0{,}743$ em $\alpha \in \{0{,}5, 0{,}8\}$ e $0{,}738$–$0{,}739$ em $\alpha = 0{,}2$), confirmando a permanência de `bm25` em produção.

## Pipeline reprodutível (aulas 05–08)

Na raiz: `Rscript estrutura/codigo/pipeline.R` (Base R). Saídas exportadas em `csv/` sobre os $N = 132$ parágrafos válidos (`nchar > 200`). Instruções de julgamento em [05-julgamento](estrutura/codigo/05-julgamento/README.md); decisões e parâmetros homologados em [consolidados/00_FICHA_PROJETO.md](consolidados/00_FICHA_PROJETO.md) e [config.R](config.R).
