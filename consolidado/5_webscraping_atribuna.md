# **Módulo 5 — Web Scraping (A Tribuna)**

## Objetivo
Coletar notícias do jornal *A Tribuna* das cidades de **Guarujá**, **Santos** e **Bertioga**, persistir como CSV e aplicar o sistema de recomendação sobre os títulos.

## Arquivo
`estrutura/scriptsR/5_webscraping_atribuna.R`

## Configuração das cidades

| Cidade   | `cid`    |
|----------|----------|
| Guarujá  | 1.499556 |
| Santos   | 1.499607 |
| Bertioga | 1.499531 |

Base URL: `https://www.atribuna.com.br/buscar?page=%d&cid=%s&pageStart=%d`

## Boas práticas

- **Delay aleatório** entre requisições (3–4 s ou 6–8 s, conforme uma chave uniforme em [0, 20]) para não sobrecarregar o servidor.
- **Deduplicação** por URL após cada página.
- **Persistência** em `estrutura/bancoDeDados/noticias_<cidade>.csv`.

## Funções

- `random_delay_varied()` — sleep variável entre requisições.
- `scrape_city_news(city_key, max_articles)` — paginação + extração de `titulo`, `url`, `categoria` dos teasers.
- `search_city_news(city_key, query, top_n, max_articles, output_dir)` — scraping + salvamento + recomendação em um único passo.

## Exemplo de execução

```r
source("estrutura/scriptsR/5_webscraping_atribuna.R")

resultados <- search_city_news(
  city_key     = "bertioga",
  query        = "Bertioga completa 35 anos",
  top_n        = 5,
  max_articles = 20
)
```

**Saída (Bertioga):**

| Rank | Score | Documento |
|------|-------|-----------|
| 1    | 0.674 | Bertioga completa 35 anos de emancipação e traça metas… |
| 2    | 0.420 | Bertioga aposta em ecoturismo e crescimento ordenado ao completar 35 anos… |
| 3    | 0.114 | Homem que acompanhava prova de caiaque desmaia e desaparece… |
| 4    | 0.000 | Praças no litoral de São Paulo serão repaginadas… |
| 5    | 0.000 | Cidade do litoral de São Paulo intensifica fiscalização… |

## Observação
O módulo **não** roda automaticamente ao dar `source()` — apenas define funções. A execução do scraping é sempre uma chamada explícita de `search_city_news()`, dado o custo (tempo + requisições ao servidor).