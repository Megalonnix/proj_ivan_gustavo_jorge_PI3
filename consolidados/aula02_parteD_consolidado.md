# Consolidado — PI III — Aula 02 — Parte D — 2026-10-13
*guia versão 3 — tutora: Antigravity — sessão de grupo — motor02*  
**Alunos:** Ivan Guimarães dos S. da Silva, Jorge Sugano Suzart e Gustavo Geminiano

## 1. O que foi feito
- **M9 — Análise vetorial do corpus real (132 documentos):** Identificação de $d_{110}$ (Santos) como o documento de maior norma ($68{,}2$), seguido por $d_{85}$ (Santos, $56{,}5$) e $d_{14}$ (Guarujá, $54{,}9$), decorrente de sua extensão e concentração de termos técnicos e culturais específicos. Normalização unitária confirmada com `norm_cols` (todas as 132 colunas com comprimento euclidiano exatamente igual a 1).
- **M10 — Definição e homologação das 3 consultas de trabalho do projeto:**
  - $q_1$: `"porto de santos"` $\rightarrow$ Top 1: $d_{76}$ (Santos, $\cos = 0{,}278$).  
    *Trecho:* "Santos possui o maior porto da América Latina, o Porto de Santos. Suas obras começaram em 1888 e o primeiro trecho de cais foi inaugurado em 1892..."
  - $q_2$: `"praias e turismo"` $\rightarrow$ Top 1: $d_{2}$ (Guarujá, $\cos = 0{,}188$).  
    *Trecho:* "Atualmente, a cidade de Guarujá é conhecida como a 'Pérola do Atlântico', devido às suas belas praias e belezas naturais. Muito procurada pelos turistas..."
  - $q_3$: `"forte sao joao"` $\rightarrow$ Top 1: $d_{117}$ (Bertioga, $\cos = 0{,}296$).  
    *Trecho:* "Umas das cidades mais antigas do Brasil, preserva muitos edifícios históricos, como o Forte de São João, o primeiro forte do país, e destaca-se como..."
- **M11 — Investigação experimental dos limites do modelo vetorial:** Identificação empírica de falha por ortogonalidade semântica / sinonímia. A consulta `"litoral"` recupera $d_{67}$ (Santos, $\cos = 0{,}220$), mas atribui similaridade nula ($0{,}000$) a documentos altamente relevantes sobre praias e turismo costeiro (como $d_{18}$ e $d_{20}$) que não contêm o vocábulo literal exato "litoral".

## 2. Decisões do grupo e justificativas
- **Estrutura de Leitura Remota:** O notebook emprega download direto via `download.file()` com modo binário e leitura com `fileEncoding = "latin1"`, evitando conflitos de decodificação no Google Colab e viabilizando a execução autônoma diretamente do repositório GitHub do grupo (`https://github.com/Megalonnix/proj_ivan_gustavo_jorge_PI3`).
- **Garantia de Normalização:** Adoção da normalização euclidiana por colunas para eliminar o viés de tamanho de parágrafos extensos sobre a similaridade do cosseno.

## 3. Próximos passos
- Incorporar na Aula 03 o módulo de pré-processamento textual (remoção de pontuação, minúsculas consistentes e tratamento de stopwords) e a construção do índice invertido com postings.

<!-- estado-R:inicio -->
<!-- gerado por motor02 v1 2026-10-01 em 2026-10-13 14:52:00 -->
| Objeto | Tipo | Tamanho | Amostra |
|---|---|---|---|
| `docs` | character, nomeado | 132 | d1 Guarujá é um município brasileiro..., d2 Atualmente, a cidade de Guarujá..., d3 O primeiro registro histórico da..., d4 Em 1893, a Companhia Balneária..., d5 Durante a Primeira Guerra Mundi..., d6 O município tem sua economia ba..., ... |
| `origem` | character, nomeado | 132 | d1 Guaruja, d2 Guaruja, d3 Guaruja, d4 Guaruja, d5 Guaruja, d6 Guaruja, ... |
| `cfg` | list | 2 | elementos: minimo, grupo |
| `ix` | list | 7 | elementos: tokens, vocab, tf, N, df, idf_tfidf, w |
| `wn` | matrix | 4250 × 132 | linhas: 1892, 1958, 2010... \| colunas: d1, d2, d3... |
| `normas` | numeric, nomeado | 132 | d1 13.82, d2 18.24, d3 12.11, d4 16.45, d5 14.30, d6 19.55, ... |
| `r1` | numeric, nomeado | 132 | d76 0.2779, d78 0.1807, d25 0.1376, d39 0.1288, d50 0.0890, ... |
| `r2` | numeric, nomeado | 132 | d2 0.1878, d118 0.1642, d20 0.1140, d51 0.1107, d18 0.1050, ... |
| `r3` | numeric, nomeado | 132 | d117 0.2962, d121 0.1728, d132 0.1168, d16 0.1077, d123 0.0887, ... |
<!-- estado-R:fim -->
