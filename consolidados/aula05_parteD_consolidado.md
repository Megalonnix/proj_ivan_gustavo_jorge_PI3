# Aula 05 — Parte D: Aplicação no Grupo (Necessidades, Pool e Julgamentos de Relevância)

**Grupo:** Ivan Guimarães dos S. da Silva · Gustavo Geminiano · Jorge Sugano Suzart  
**Data de referência:** 2026-10-13  

---

## Implementação e Resultados do Grupo

1. **Formulação das 12 Necessidades (`estrutura/banco-de-dados/necessidades.csv`):** O grupo estruturou 12 necessidades de informação sobre Santos, Guarujá e Bertioga, especificando `consulta`, `texto_consulta`, `necessidade`, `escopo` e partição (`8 dev`: `q01..q08` e `4 teste`: `q09..q12`).
2. **Geração Reprodutível da Pool (`estrutura/codigo/pipeline.R` e `csv/05-pool.csv`):** Sobre os $N = 132$ parágrafos válidos (`nchar > 200`), a pool combina os top-10 de Booleano, TF-IDF e BM25 com semente fixa `42` e exporta os formulários de avaliação em `csv/05-qrels-respostas/`.
3. **Gabarito Homologado (`qrels_jorge_2026-10-13.csv`):** Foram consolidados 230 julgamentos de relevância nas 12 consultas (`q01..q12`), homologados em `config.R` com `cfg$juizes = c("jorge")` e limiar de relevância estrita `cfg$limiar = 2`, servindo de base canônica para as avaliações das Aulas 05b, 06 e 07.
