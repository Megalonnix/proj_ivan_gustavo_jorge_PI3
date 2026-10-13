# Consolidado — PI III — Aula 00 (Parte D) — 2026-10-12
*guia versão 3 · tutora: Antigravity · sessão prática individual · com motor/estado*
**Aluno:** Ivan Guimarães dos S. da Silva, Jorge Sugano Suzart e Gustavo Geminiano

## 1. O que foi passado
- M12 — Criação de vetor nomeado com 3 frases sujas; execução estrita do pipeline de limpeza de texto em 4 etapas (`trimws`, `tolower`, `gsub("[^a-z ]")`, `gsub("\\s+")`); tokenização com `lapply` e `tokenizar`; análise de frequência com `table` e `sort`; cálculo de termos únicos com `unique`.
- M13 — Elaboração e validação de expressões regulares sobre as frases: detecção de maiúsculas no início (`^\\s*[A-Z]`), dígitos (`[0-9]`), pontuação final (`[^a-z ]$`), extração da primeira palavra via `sub` guloso e substituição global com `gsub`.
- M14 — Fluxo de integração do curso: carregamento remoto de scripts com `source()` via endereço raw; execução do snapshot com `estado()`; upload e validação de integridade de arquivos com `list.files()`; anexação automatizada da seção "Estado do R" com `anexar_estado()`.

## 2. Como foi o aprendizado — opinião da tutora
A transição da teoria para a prática ocorreu com execução direta no ambiente Google Colab em kernel R. O pipeline de higienização de strings foi implementado respeitando rigorosamente a ordem de precedência operacional (`tolower` antes de remover caracteres não alfabéticos, impedindo o truncamento indevido de letras capitais). A verificação da contagem de tokens revelou a prevalência de termos funcionais ("de"), conectando o experimento prático à necessidade conceitual de ponderação de termos que será formalizada na Aula 01. Os padrões de regex foram aplicados considerando as especificidades do interpretador R (como o escape duplo `\\s` e a necessidade de `trimws` para âncoras de terminação `$`). O fluxo do Colab com GitHub foi completamente estabelecido.

## 3. Observações para a frente
- **Revisar antes da Aula 01:** A montagem da matriz termo-documento a partir de `sapply` e `table(factor(..., levels = vocab))` e o uso de `source()` remoto para o carregamento do `motor01.R`.
- **Para a próxima tutora:** Execução orientada a código funcional e testes objetivos no Colab; evita explicações conceituais extensas e valida regras operacionais diretamente pelo resultado do console.
- **Perguntas guardadas:** Ponderação IDF e remoção sistemática de stopwords/pontuações complexas (encaminhadas para Aula 01 e Aula 03).
- **Produzido:** Vetor `f` com 3 frases personalizadas; pipeline de 4 linhas; tabela de frequência de tokens; 5 expressões regulares de busca/substituição; ambiente pronto com `estado.R`.
- **Parte D (frases próprias + Colab e GitHub):** Concluída.

---

<!-- estado-R:inicio -->
## Estado do R ao fim da sessão
*gerado por `anexar_estado()` em 2026-10-12 19:57 · R version 4.6.1 (2026-06-24) · sem motor · não edite à mão*

### Objetos

| objeto | tipo | tamanho | valor / amostra |
|---|---|---|---|
| `docs` | character, nomeado | 8 | d1 recuperacao de informacao o..., d2 o modelo de espaco vetorial..., d3 bm25 e um modelo probabilis..., d4 aprendizado estatistico fun..., d5 o indice invertido acelera ..., d6 embeddings capturam a seman..., ... |
| `f` | character, nomeado | 3 | f1 O Modelo de dados apres..., f2 A ciencia de DADOS moderna..., f3 modelos estatisticos fun... |
| `freq` | table, nomeado | 15 | de 3, dados 2, modelos 2, moderna 2, a 1, alta 1, ... |
| `tokens` | list | 3 | elementos: f1, f2, f3 |
| `tokens$f1` | character | 7 | o, modelo, de, dados, apresenta, alta, complexidade |
| `tokens$f2` | character | 8 | a, ciencia, de, dados, moderna, exige, modelos, de, aprendizado |
| `tokens$f3` | character | 6 | modelos, estatisticos, fundamentam, a, busca, moderna |
| `x` | character, nomeado | 3 | f1 o modelo de dados apresen..., f2 a ciencia de dados modern..., f3 modelos estatisticos fun... |

### Funções definidas

`anexar_estado`, `estado`, `tokenizar`
<!-- estado-R:fim -->
