# Aula 05 — Parte D: Aplicação no Grupo (Necessidades, Pool e Julgamentos de Relevância)

**Grupo:** Ivan Guimarães dos S. da Silva · Gustavo Geminiano · Jorge Sugano Suzart  
**Data de referência:** 2026-10-13 *(revisado em 2026-11-26)*

---

## Implementação e Resultados do Grupo

1. **Formulação das 12 Necessidades (`estrutura/banco-de-dados/necessidades.csv`):** O grupo estruturou 12 necessidades de informação sobre Santos, Guarujá e Bertioga, especificando `consulta`, `texto_consulta`, `necessidade`, `escopo` e partição (`8 dev`: `q01..q08` e `4 teste`: `q09..q12`).
2. **Geração Reprodutível da Pool (`estrutura/codigo/pipeline.R` e `csv/05-pool.csv`):** Sobre os $N = 132$ parágrafos válidos (`nchar > 200`), a pool reúne os top-10 de Booleano, TF-IDF e BM25 em **todas as 12 consultas (`q01..q12`)**, totalizando **136 pares únicos** embaralhados com semente fixa (`set.seed(42)`), com formulários individuais exportados em `csv/05-qrels-respostas/modelo-{ivan,gustavo,jorge}.csv`.
3. **Ferramental de Julgamento e Kappa (`estrutura/codigo/05-julgamento/`):**
   - Interface HTML de julgamento às cegas: `05-julgar.html`.
   - Cálculo de concordância inter-juízes ($\kappa$ de Cohen): `05a-kappa.R`.
   - Consolidação de respostas: `05e-consolidar-qrels.R`.
4. **Gabarito Atual (`csv/05-qrels-respostas/qrels_jorge_2026-10-13.csv` e `csv/05-qrels.csv`):** Estão consolidados os 230 julgamentos do juiz `jorge` (**219** referentes aos 132 parágrafos válidos, todos com `grau = 2`), homologados em `config.R` com `cfg$juizes = c("jorge")` e `cfg$limiar = 2`. O fluxo está pronto para receber os votos graduados (`0/1/2`) de Ivan e Gustavo via `05-julgar.html` e calcular o $\kappa$ entre os três avaliadores.
