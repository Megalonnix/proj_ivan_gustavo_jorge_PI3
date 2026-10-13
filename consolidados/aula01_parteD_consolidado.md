# Consolidado — PI III — Aula 01 (Parte D) — 2026-10-13
*guia versão 4 · tutora: Antigravity · sessão de grupo (prática) · motor01*
**Alunos:** Ivan Guimarães dos S. da Silva, Jorge Sugano Suzart e Gustavo Geminiano

## 1. O que foi passado
- M11 — Definição fundamentada do tema do projeto regional ("História, Turismo e Geografia dos Municípios da Baixada Santista: Santos, Guarujá e Bertioga"), público-alvo, formulação de 3 perguntas reais de busca e critério de documento (`nchar > 200`).
- M12 — Ingestão e higienização do corpus real extraído da Wikipédia com 132 parágrafos autônomos; configuração do `config.R` (`cfg$minimo = 200`); persistência dos objetos em `docs.rds` e `origem.rds` na pasta `estrutura/banco-de-dados/`.
- M13 — Execução da cadeia analítica completa (tokenização, vocabulário de 4250 termos, matriz termo-documento $4250 \times 132$); testes funcionais de `busca_booleana`; preenchimento integral e validação da Ficha do Projeto (`00_FICHA_PROJETO.md`).

## 2. Como foi o aprendizado — opinião da tutora
A fundação prática do projeto pelo grupo (Ivan, Jorge e Gustavo) foi conduzida com rigor metodológico exemplar. A escolha do tema regional e o recorte em 3 municípios emblemáticos da Baixada Santista (Santos com 86 docs, Guarujá com 29 e Bertioga com 17) viabilizou um corpus robusto de 132 documentos, perfeitamente calibrado para o motor de busca. A aplicação da restrição `cfg$minimo = 200` filtrou com sucesso parágrafos residuais sem perda de conteúdo substancial. Ao inspecionar os 4250 termos do vocabulário, o grupo identificou de forma autônoma a dominância de termos estruturais vazios de informação nos 10 primeiros colocados (`de` com 910 ocorrências, `a` com 494, `e` com 392), reconhecendo imediatamente na prática a necessidade das ponderações IDF (Aula 01/Aula 1,5) e da remoção de stopwords (Aula 03). Os testes de busca booleana confirmaram a assertividade do índice para termos específicos (como "mengele" localizando unicamente o documento histórico d127 de Bertioga) e evidenciaram o desafio de desempate e ordenação para termos genéricos ("turismo" com 30 ocorrências), preparando a equipe com clareza para a introdução da similaridade por cosseno na Aula 02.

**Checkpoint 13:** Aprovado com sucesso — compreensão integral das limitações da busca booleana e validação campo a campo da ficha do projeto.

## 3. Observações para a frente
- **Revisar antes da Aula 02:** O cálculo do produto interno e vetorização da consulta para rankeamento por similaridade de cosseno sobre a matriz TDM real do grupo.
- **Para a próxima tutora:** Equipe altamente coesa e pragmática; compreendem com facilidade a relação entre decisões de pré-processamento no `config.R` e as dimensões da matriz resultante.
- **Perguntas guardadas:** Ponderação IDF no corpus real (132 documentos) e cálculo de similaridade vetorial (Aula 02); remoção de pontuação colada e acentos via regex especializada (Aula 03).
- **Produzido:** `00_FICHA_PROJETO.md` preenchida; `config.R` configurado; `docs.rds` e `origem.rds` gerados; matriz TDM $4250 \times 132$; notebook `Aula01_ParteD.ipynb` completamente executado.
- **Repositório do Grupo:** Estrutura pronta para sincronização pública no GitHub (`projeto-ivan-gustavo-jorge`).

---

<!-- estado-R:inicio -->
## Estado do R ao fim da sessão
*gerado por `anexar_estado()` em 2026-10-13 14:11 · R version 4.6.1 (2026-06-24) · motor01 · não edite à mão*

### Objetos

| objeto | tipo | tamanho | valor / amostra |
|---|---|---|---|
| `cfg` | list | 2 | minimo: 200, grupo: "ivan_gustavo_jorge" |
| `docs` | character, nomeado | 132 | d1 Guaruja e um municipio brasileiro..., d2 Atualmente a cidade de Guaruja..., d3 Guaruja e um dos quinze municipios... |
| `freq` | table, nomeado | 4250 | de 910, a 494, e 392, o 365, do 301, da 250, em 226, que 157, com 126, na 114, ... |
| `origem` | character, nomeado | 132 | d1 Guaruja, d2 Guaruja, ..., d30 Santos, ..., d116 Bertioga |
| `tam` | integer, nomeado | 132 | d1 83, d2 88, d3 69, d4 135, d5 112, d6 45, ... |
| `tdm` | matrix | 4250 × 132 | linhas: 10, 100, 102, 106, 11 | colunas: d1, d2, d3, d4 |
| `tokens` | list | 132 | elementos: d1, d2, d3, d4, ..., d132 |
| `vocab` | character | 4250 | 1, 10, 100, 102, 106, 11, 12, 13, 14, 15, ... |

### Funções definidas

`anexar_estado`, `busca_booleana`, `estado`, `tokenizar`
<!-- estado-R:fim -->
