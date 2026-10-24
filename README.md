# Projeto Integrador III — Motor de Busca Municipal e Histórico da Baixada Santista
**Alunos:** Ivan Guimarães dos S. da Silva, Jorge Sugano Suzart e Gustavo Geminiano  
**Professor:** João Paulo Ferreira de Mello  
**Disciplina:** Projeto Integrador 3  
**Repositório:** https://github.com/Megalonnix/proj_ivan_gustavo_jorge_PI3  
**Ambiente:** R base no Google Colab / IRkernel; leitor dos consolidados em Python 3 no Colab

---

## Estrutura Oficial do Repositório

A árvore abaixo reflete a estrutura real do diretório no disco. O nome `projeto_final/` não é uma pasta física neste repositório; ele era uma convenção documental, não uma pasta real.

```text
.
├── 00_FICHA_PROJETO.md
├── config.R
├── corpus.csv
├── necessidades.csv
├── projeto.zip
├── qrels_jorge_2026-10-13.csv
├── README.md
├── wikipedia_baixada_santista.csv
│
├─── consolidados/
│   ├── 00_FICHA_PROJETO.md
│   ├── aula00_consolidado.md
│   ├── aula00_parteD_consolidado.md
│   ├── aula01_consolidado.md
│   ├── aula01_parteD_consolidado.md
│   ├── aula02_consolidado.md
│   ├── aula02_parteD_consolidado.md
│   ├── aula03_consolidado.md
│   ├── aula03_parteD_consolidado.md
│   ├── aula04_consolidado.md
│   ├── aula04_parteD_consolidado.md
│   ├── aula05b_consolidado.md
│   ├── aula05b_parteD_consolidado.md
│   ├── aula06_consolidado.md
│   ├── aula06_parteD_consolidado.md
│   ├── aula07_consolidado.md
│   └── aula07_parteD_consolidado.md
│
├─── estrutura/
│   ├─── bancoDeDados/
│   │   ├── corpus.csv
│   │   ├── necessidades.csv
│   │   ├── qrels_jorge_2026-10-13.csv
│   │   └── wikipedia_baixada_santista.csv
│   │
│   └─── codigo/
│       ├── Consolidados_Colab.ipynb
│       ├── aula00.ipynb
│       ├── Aula00_ParteD.ipynb
│       ├── Aula00_Teoria.ipynb
│       ├── aula01.ipynb
│       ├── Aula01_ParteD.ipynb
│       ├── Aula01_Teoria.ipynb
│       ├── aula02.ipynb
│       ├── Aula02_ParteD.ipynb
│       ├── Aula02_Teoria.ipynb
│       ├── aula03.ipynb
│       ├── Aula03_ParteD.ipynb
│       ├── Aula03_Teoria.ipynb
│       ├── aula04.ipynb
│       ├── Aula04_ParteD.ipynb
│       ├── Aula04_Teoria.ipynb
│       ├── aula05b.ipynb
│       ├── Aula05b_ParteD.ipynb
│       ├── Aula05b_Teoria.ipynb
│       ├── aula06.ipynb
│       ├── Aula06_ParteD.ipynb
│       ├── Aula06_Teoria.ipynb
│       ├── Aula07_ParteD.ipynb
│       ├── Aula07_Teoria.ipynb
│       └── config.R
│
└─── guias_estudo/
    ├── GUIA_ESTUDO_aula00_parteD.md
    ├── GUIA_ESTUDO_aula00_teoria.md
    ├── GUIA_ESTUDO_aula01_parteD.md
    ├── GUIA_ESTUDO_aula01_teoria.md
    ├── GUIA_ESTUDO_aula02_parteD.md
    ├── GUIA_ESTUDO_aula02_teoria.md
    ├── GUIA_ESTUDO_aula03_parteD.md
    ├── GUIA_ESTUDO_aula03_teoria.md
    ├── GUIA_ESTUDO_aula04_parteD.md
    ├── GUIA_ESTUDO_aula04_teoria.md
    ├── GUIA_ESTUDO_aula05b_parteD.md
    ├── GUIA_ESTUDO_aula05b_teoria.md
    ├── GUIA_ESTUDO_aula06_parteD.md
    ├── GUIA_ESTUDO_aula06_teoria.md
    ├── GUIA_ESTUDO_aula07_parteD.md
    └── GUIA_ESTUDO_aula07_teoria.md
```

### Legenda complementar

| Item | Descrição |
| --- | --- |
| `00_FICHA_PROJETO.md` | Ficha técnica acumulada das aulas 01 a 07, consolidando os principais detalhes do projeto. |
| `README.md` | Guia de navegação, visão geral e orientações do repositório. |
| `config.R` | Configuração homologada do motor de busca (BM25, limiar, PRF, LSA e demais parâmetros de execução). |
| `corpus.csv` | Corpus principal com os 132 parágrafos autônomos usados para indexação e avaliação. |
| `wikipedia_baixada_santista.csv` | Base bruta extraída da Wikipédia para a Baixada Santista. |
| `necessidades.csv` | Conjunto de 12 necessidades de busca usadas em desenvolvimento e teste. |
| `qrels_jorge_2026-10-13.csv` | Arquivo de julgamentos de relevância do juiz Jorge com 230 qrels. |
| `projeto.zip` | Arquivo compactado para entrega/submissão direta. |
| `consolidados/` | Relatórios semanais de teoria e sessões de grupo (parte D) por aula, incluindo a aula 07 e 07D. |
| `estrutura/` | Estrutura organizacional do projeto em dados, notebooks e código. |
| `estrutura/bancoDeDados/` | Bases de dados oficiais usadas no projeto. |
| `estrutura/codigo/` | Notebooks executáveis e códigos de experimentação, por aula; inclui o leitor dos consolidados no Colab. |
| `guias_estudo/` | Guias de estudo originais do professor para as aulas 00 a 07. |

> Observação: a árvore corresponde ao repositório real no disco. A pasta oculta `.git/` foi omitida por ser metadado de controle de versão, não conteúdo do projeto.

---

## De onde vêm os consolidados

Os consolidados registram o conteúdo estudado e os resultados das sessões. Os guias de estudo definem o roteiro didático de cada aula e orientam o registro final — por meio de um modelo de consolidado ou de passos de fechamento. Em geral, os arquivos sem `parteD` documentam a sessão de teoria; os arquivos com `parteD` registram a atividade prática ou de grupo. A tabela relaciona cada arquivo de `consolidados/` ao guia correspondente e resume o que foi desenvolvido.

| Arquivo consolidado | Guia de estudo de origem | Conteúdo registrado |
| --- | --- | --- |
| `00_FICHA_PROJETO.md` | Acumulativa: criada com o [GUIA_ESTUDO_aula01_parteD.md](guias_estudo/GUIA_ESTUDO_aula01_parteD.md) e atualizada a partir dos guias de grupo das aulas [02](guias_estudo/GUIA_ESTUDO_aula02_parteD.md), [03](guias_estudo/GUIA_ESTUDO_aula03_parteD.md), [04](guias_estudo/GUIA_ESTUDO_aula04_parteD.md), [05b](guias_estudo/GUIA_ESTUDO_aula05b_parteD.md) e [06](guias_estudo/GUIA_ESTUDO_aula06_parteD.md). | Ficha viva do projeto: tema, fonte e unidade de análise, descrição do corpus, estado da implementação, decisões metodológicas e histórico das sessões. |
| `aula00_consolidado.md` | [GUIA_ESTUDO_aula00_teoria.md](guias_estudo/GUIA_ESTUDO_aula00_teoria.md) | Fundamentos de R aplicados ao corpus: vetores, indexação, texto e funções, tokenização, matrizes e expressões regulares. |
| `aula00_parteD_consolidado.md` | [GUIA_ESTUDO_aula00_parteD.md](guias_estudo/GUIA_ESTUDO_aula00_parteD.md) | Exercícios práticos com frases próprias, limpeza e contagem de texto, regex e fluxo de trabalho com Colab e GitHub. |
| `aula01_consolidado.md` | [GUIA_ESTUDO_aula01_teoria.md](guias_estudo/GUIA_ESTUDO_aula01_teoria.md) | Introdução à recuperação de informação, arquitetura do projeto, corpus, tokenização, vocabulário, matriz termo-documento, busca booleana e TF-IDF. |
| `aula01_parteD_consolidado.md` | [GUIA_ESTUDO_aula01_parteD.md](guias_estudo/GUIA_ESTUDO_aula01_parteD.md) | Definição do tema e da fonte, conceito de documento, coleta do primeiro corpus, organização do repositório e criação da ficha do projeto. |
| `aula02_consolidado.md` | [GUIA_ESTUDO_aula02_teoria.md](guias_estudo/GUIA_ESTUDO_aula02_teoria.md) | Modelo vetorial: pesos TF-IDF, norma e normalização, similaridade do cosseno e ordenação dos documentos por relevância. |
| `aula02_parteD_consolidado.md` | [GUIA_ESTUDO_aula02_parteD.md](guias_estudo/GUIA_ESTUDO_aula02_parteD.md) | Aplicação do cosseno aos 132 documentos do corpus, definição das consultas de trabalho e análise de acertos e limitações no corpus do grupo. |
| `aula03_consolidado.md` | [GUIA_ESTUDO_aula03_teoria.md](guias_estudo/GUIA_ESTUDO_aula03_teoria.md) | Pré-processamento, limpeza com regex, stopwords, stemming, tokenização subword/BPE, índice invertido e consultas booleanas. |
| `aula03_parteD_consolidado.md` | [GUIA_ESTUDO_aula03_parteD.md](guias_estudo/GUIA_ESTUDO_aula03_parteD.md) | Limpeza do corpus real, decisão sobre acentos e stopwords, construção do índice invertido e validação de buscas AND. |
| `aula04_consolidado.md` | [GUIA_ESTUDO_aula04_teoria.md](guias_estudo/GUIA_ESTUDO_aula04_teoria.md) | Fundamentos probabilísticos do BM25, distribuição 2-Poisson, burstiness, eliteness, saturação de frequência, normalização por tamanho e implementação. |
| `aula04_parteD_consolidado.md` | [GUIA_ESTUDO_aula04_parteD.md](guias_estudo/GUIA_ESTUDO_aula04_parteD.md) | Implementação e comparação de BM25 com cosseno no corpus do grupo, experimentos com parâmetros `k1` e `b` e registro da configuração escolhida. |
| `aula05b_consolidado.md` | [GUIA_ESTUDO_aula05b_teoria.md](guias_estudo/GUIA_ESTUDO_aula05b_teoria.md) | Métricas de avaliação de rankings: Precisão, Recall, P@k/R@k, AP/MAP, MRR e nDCG, incluindo diferenças entre relevância binária e graduada. |
| `aula05b_parteD_consolidado.md` | [GUIA_ESTUDO_aula05b_parteD.md](guias_estudo/GUIA_ESTUDO_aula05b_parteD.md) | Preparação dos qrels do grupo, escolha de juiz e limiar, aplicação das métricas às 12 consultas e comparação dos resultados de cosseno e BM25. |
| `aula06_consolidado.md` | [GUIA_ESTUDO_aula06_teoria.md](guias_estudo/GUIA_ESTUDO_aula06_teoria.md) | Realimentação de relevância com Rocchio, expansão e novo ranking, avaliação na coleção residual e pseudo-realimentação com risco de *query drift*. |
| `aula06_parteD_consolidado.md` | [GUIA_ESTUDO_aula06_parteD.md](guias_estudo/GUIA_ESTUDO_aula06_parteD.md) | Aplicação de Rocchio e PRF ao gabarito real, comparação entre coleção completa e residual, avaliação em desenvolvimento/teste e decisão do grupo sobre a configuração do motor. |
| `aula07_consolidado.md` | [GUIA_ESTUDO_aula07_teoria.md](guias_estudo/GUIA_ESTUDO_aula07_teoria.md) | Introdução ao descasamento léxico, embeddings latentes, LSA/SVD, *folding-in* da consulta e fusão híbrida via RRF. |
| `aula07_parteD_consolidado.md` | [GUIA_ESTUDO_aula07_parteD.md](guias_estudo/GUIA_ESTUDO_aula07_parteD.md) | Aplicação de LSA e busca híbrida no corpus real da Baixada Santista, avaliação em dev/teste e decisão de manter BM25 como modelo oficial. |

## Acessar os consolidados

### 🚨 **Baixar todos pelo *Google Colab***

- **Link Colab**: [Abrir o Colab e baixar os 17 arquivos .md](https://colab.research.google.com/github/Megalonnix/proj_ivan_gustavo_jorge_PI3/blob/main/estrutura/codigo/Consolidados_Colab.ipynb)

No Colab, mantenha o runtime padrão **Python 3** e escolha **Runtime → Run all**. O notebook baixa os arquivos da branch `main` para `/content/consolidados/` no armazenamento temporário da sessão e também os exibe na página. Não é necessário instalar pacotes nem enviar arquivos manualmente. A pasta temporária é removida quando a sessão do Colab termina.

### Abrir cada consolidado no GitHub

Os links a seguir abrem os arquivos Markdown individuais no GitHub:

| Consolidado | Abrir no GitHub |
| --- | --- |
| Ficha do projeto | [00_FICHA_PROJETO.md](https://github.com/Megalonnix/proj_ivan_gustavo_jorge_PI3/blob/main/consolidados/00_FICHA_PROJETO.md) |
| Aula 00 — Teoria | [aula00_consolidado.md](https://github.com/Megalonnix/proj_ivan_gustavo_jorge_PI3/blob/main/consolidados/aula00_consolidado.md) |
| Aula 00 — Parte D | [aula00_parteD_consolidado.md](https://github.com/Megalonnix/proj_ivan_gustavo_jorge_PI3/blob/main/consolidados/aula00_parteD_consolidado.md) |
| Aula 01 — Teoria | [aula01_consolidado.md](https://github.com/Megalonnix/proj_ivan_gustavo_jorge_PI3/blob/main/consolidados/aula01_consolidado.md) |
| Aula 01 — Parte D | [aula01_parteD_consolidado.md](https://github.com/Megalonnix/proj_ivan_gustavo_jorge_PI3/blob/main/consolidados/aula01_parteD_consolidado.md) |
| Aula 02 — Teoria | [aula02_consolidado.md](https://github.com/Megalonnix/proj_ivan_gustavo_jorge_PI3/blob/main/consolidados/aula02_consolidado.md) |
| Aula 02 — Parte D | [aula02_parteD_consolidado.md](https://github.com/Megalonnix/proj_ivan_gustavo_jorge_PI3/blob/main/consolidados/aula02_parteD_consolidado.md) |
| Aula 03 — Teoria | [aula03_consolidado.md](https://github.com/Megalonnix/proj_ivan_gustavo_jorge_PI3/blob/main/consolidados/aula03_consolidado.md) |
| Aula 03 — Parte D | [aula03_parteD_consolidado.md](https://github.com/Megalonnix/proj_ivan_gustavo_jorge_PI3/blob/main/consolidados/aula03_parteD_consolidado.md) |
| Aula 04 — Teoria | [aula04_consolidado.md](https://github.com/Megalonnix/proj_ivan_gustavo_jorge_PI3/blob/main/consolidados/aula04_consolidado.md) |
| Aula 04 — Parte D | [aula04_parteD_consolidado.md](https://github.com/Megalonnix/proj_ivan_gustavo_jorge_PI3/blob/main/consolidados/aula04_parteD_consolidado.md) |
| Aula 05b — Teoria | [aula05b_consolidado.md](https://github.com/Megalonnix/proj_ivan_gustavo_jorge_PI3/blob/main/consolidados/aula05b_consolidado.md) |
| Aula 05b — Parte D | [aula05b_parteD_consolidado.md](https://github.com/Megalonnix/proj_ivan_gustavo_jorge_PI3/blob/main/consolidados/aula05b_parteD_consolidado.md) |
| Aula 06 — Teoria | [aula06_consolidado.md](https://github.com/Megalonnix/proj_ivan_gustavo_jorge_PI3/blob/main/consolidados/aula06_consolidado.md) |
| Aula 06 — Parte D | [aula06_parteD_consolidado.md](https://github.com/Megalonnix/proj_ivan_gustavo_jorge_PI3/blob/main/consolidados/aula06_parteD_consolidado.md) |
| Aula 07 — Teoria | [aula07_consolidado.md](https://github.com/Megalonnix/proj_ivan_gustavo_jorge_PI3/blob/main/consolidados/aula07_consolidado.md) |
| Aula 07 — Parte D | [aula07_parteD_consolidado.md](https://github.com/Megalonnix/proj_ivan_gustavo_jorge_PI3/blob/main/consolidados/aula07_parteD_consolidado.md) |

> O leitor do Colab busca os arquivos publicados na branch `main`. As alterações feitas no repositório local aparecerão nesses links depois do push.

---

## Resumo dos Resultados Experimentais Homologados

1. **Aulas 00–02:** Fundação vetorial com TF-IDF e Similaridade do Cosseno ($N=132$).
2. **Aula 03:** Limpeza (`translit`), remoção de 27 stopwords e indexação invertida (3.483 termos).
3. **Aula 04:** BM25 construído com parâmetros canônicos ($k_1=1{,}2$ e $b=0{,}75$).
4. **Aula 05,5:** Avaliação com gabarito de 230 qrels. Empate exato em 6 a 6 entre Cosseno (MAP $0{,}640$) e BM25 (MAP $0{,}637$), P@3 de $0{,}917$ em ambos.
5. **Aula 06:** 
   - Rocchio na coleção completa aparenta salto ($0{,}780 	o 0{,}947$), mas na coleção residual cai ($0{,}649 	o 0{,}498$), provando o viés de reordenação dos documentos já vistos.
   - PRF provoca *query drift* em consultas curtas ($MAP_{dev}: 0{,}653 	o 0{,}448$; $MAP_{teste}: 0{,}612 	o 0{,}487$).
   - Decisão homologada em `config.R`: `prf_k = 0` (desativada em produção) e `rocchio = c(a = 1, b = 0.75, g = 0.15)`.
6. **Aula 07:**
   - Descobrimento do descasamento léxico e do limite do vocabulário puro; LSA/SVD e *folding-in* da consulta expandem semântica em consultas conceptuais.
   - A implementação de RRF em conjunto com BM25 mostrou ganho em alguns cenários conceituais, mas o grupo decidiu manter o BM25 como modelo oficial em produção (`modelo = "bm25"`, `lsa_k = 20`, `rrf_c = 60`).
