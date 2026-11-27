# Julgamento de Relevância e Pooling (Aula 05)

Da raiz do repositório, execute:

```bash
Rscript estrutura/codigo/pipeline.R
```

1. **Construção da Pool (`csv/05-pool.csv`):** A pool reúne o top-10 dos modelos Booleano (conjunção), TF-IDF (Cosseno) e BM25 sobre **todas as 12 necessidades (`q01..q12`)** nos $N = 132$ parágrafos válidos (`nchar > 200`), removendo duplicatas por par `(consulta, documento)` e embaralhando a ordem de apresentação com semente fixa (`set.seed(42)`) para evitar viés de posição.
2. **Ferramenta de Julgamento (`05-julgar.html`):** Abra [`05-julgar.html`](05-julgar.html) no navegador, carregue `csv/05-pool.csv` (ou os formulários `csv/05-qrels-respostas/modelo-*.csv`), avalie às cegas e salve o CSV de respostas (`qrels_<juiz>_<data>.csv`) em `csv/05-qrels-respostas/`.
3. **Escala de Julgamento:**
   - **Grau `0`:** Irrelevante / fora do escopo;
   - **Grau `1`:** Parcialmente relevante (toca o tema sem responder integralmente à necessidade);
   - **Grau `2`:** Relevante (atende diretamente à necessidade de informação).
4. **Kappa de Cohen e Consolidação (`05a-kappa.R` e `05e-consolidar-qrels.R`):**
   ```bash
   Rscript estrutura/codigo/05-julgamento/05a-kappa.R
   Rscript estrutura/codigo/05-julgamento/05e-consolidar-qrels.R
   ```
   Os 230 votos reais do juiz Jorge estão preservados em [`csv/05-qrels-respostas/qrels_jorge_2026-10-13.csv`](../../../csv/05-qrels-respostas/qrels_jorge_2026-10-13.csv) (219 referentes aos 132 parágrafos válidos, consolidados em `csv/05-qrels.csv`). Quando Ivan e Gustavo registrarem seus votos pelo `05-julgar.html`, `05a-kappa.R` e `05e-consolidar-qrels.R` calcularão automaticamente o $\kappa$ entre pares e as divergências.
5. **Saídas Reprodutíveis em `csv/`:** `rankings.csv`, `05-pool.csv`, `05-qrels.csv`, `05-divergencias.csv`, `05b-metricas-por-consulta.csv`, `05b-map.csv`, `06-rocchio-por-consulta.csv`, `06-rocchio-metricas.csv`, `06-pseudo-feedback-por-consulta.csv`, `07-lsa-por-consulta.csv`, `07-lsa-map-por-k.csv`, `07-lsa-top5.csv`, `08-rerank-por-consulta.csv`, `08-rerank-grade-dev.csv` e `08-rerank-top5.csv`.
