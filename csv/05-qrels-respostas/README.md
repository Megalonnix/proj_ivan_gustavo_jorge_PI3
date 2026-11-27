# Respostas do Julgamento de Relevância

| Arquivo | Juiz | Status | Observação |
|---|---|---|---|
| `qrels_jorge_2026-10-13.csv` | `jorge` | 230 votos (219 nos 132 docs válidos) | Gabarito oficial atual (`cfg$juizes = c("jorge")`) |
| `modelo-ivan.csv` | `ivan` | Template completo (`q01..q12`, `grau = NA`) | Pronto para julgar em `05-julgar.html` |
| `modelo-gustavo.csv` | `gustavo` | Template completo (`q01..q12`, `grau = NA`) | Pronto para julgar em `05-julgar.html` |
| `modelo-jorge.csv` | `jorge` | Template completo (`q01..q12`, `grau = NA`) | Referência da pool completa (12 consultas) |

Após julgar no navegador com `estrutura/codigo/05-julgamento/05-julgar.html`, salve o arquivo como `qrels_<juiz>_<YYYY-MM-DD>.csv` nesta pasta e execute na raiz do projeto:

```bash
Rscript estrutura/codigo/05-julgamento/05a-kappa.R
Rscript estrutura/codigo/05-julgamento/05e-consolidar-qrels.R
Rscript estrutura/codigo/pipeline.R
```
