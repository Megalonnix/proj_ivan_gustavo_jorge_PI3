# Julgamento de Relevância e Pooling (Aula 05)

Da raiz do repositório, execute:

```bash
Rscript estrutura/codigo/pipeline.R
```

1. **Construção da Pool (`csv/05-pool.csv`):** A pool reúne o top-10 dos modelos Booleano (conjunção), TF-IDF (Cosseno) e BM25 sobre os $N = 132$ parágrafos válidos (`nchar > 200`), removendo duplicatas por par `(consulta, documento)` e embaralhando a ordem de apresentação com semente fixa (`set.seed(42)`) para evitar viés de posição.
2. **Escala de Julgamento:** Cada par `(consulta, documento)` é avaliado na escala graduada de três níveis:
   - **Grau `0`:** Irrelevante / fora do escopo;
   - **Grau `1`:** Parcialmente relevante (toca o tema sem responder integralmente à necessidade);
   - **Grau `2`:** Relevante (atende diretamente à necessidade de informação).
3. **Gabarito Oficial (`qrels_jorge_2026-10-13.csv`):** Os 230 julgamentos humanos do grupo estão preservados em `estrutura/banco-de-dados/qrels_jorge_2026-10-13.csv` e espelhados em `csv/05-qrels-respostas/qrels_jorge_2026-10-13.csv`, seguindo a configuração homologada em `config.R` (`cfg$juizes = c("jorge")`, `cfg$limiar = 2`).
4. **Saídas Reprodutíveis em `csv/`:** A execução de `pipeline.R` exporta automaticamente os rankings completos (`rankings.csv`), a pool (`05-pool.csv`), o gabarito consolidado nos 132 parágrafos válidos (`05-qrels.csv`), as métricas por consulta (`05b-metricas-por-consulta.csv`), o MAP por modelo (`05b-map.csv`), os rankings de Rocchio/PRF (`06-rocchio-por-consulta.csv`, `06-pseudo-feedback-por-consulta.csv`) e as avaliações de LSA e fusão híbrida RRF (`07-lsa-por-consulta.csv`, `07-lsa-map-por-k.csv`).
