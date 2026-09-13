# **Módulo 5 — Web Scraping (Wikipédia) + Recomendação**

📄 Script: [`estrutura/scriptsR/5_webscraping_wikipedia.R`](https://github.com/Megalonnix/proj_ivan_gustavo_jorge_PI3/blob/main/estrutura/scriptsR/5_webscraping_wikipedia.R)

## Objetivo
Coletar artigos da Wikipédia em português sobre **3 assuntos da Baixada Santista** (Guarujá, Santos e Bertioga), persistir como CSV em `estrutura/bancoDeDados/` e aplicar o sistema de recomendação (Módulo 3) sobre os parágrafos coletados.

Este módulo **substitui** o antigo scraper do jornal *A Tribuna*: em vez de raspar manchetes, agora extrai **parágrafos de artigos enciclopédicos**, alinhado ao que o professor pediu.

## Fonte e licença
- **Fonte:** Wikipédia em português (`pt.wikipedia.org`).
- **Licença:** CC BY-SA — uso permitido desde que a fonte seja citada. Isso está documentado no `README.md` do projeto.

## Estrutura do CSV gerado

O arquivo `wikipedia_baixada_santista.csv` tem uma linha por parágrafo e as colunas:

| Coluna   | Descrição |
|----------|-----------|
| `id`     | ID sequencial (1, 2, 3, ...) |
| `titulo` | `"<assunto> — par. N"` (ex.: `"guaruja — par. 3"`) |
| `texto`  | Texto do parágrafo |
| `data`   | Data da última modificação do artigo, no formato `AAAA/MM/DD` |
| `url`    | URL do artigo (âncora de origem) |

**Filtro:** apenas parágrafos com **mais de 30 caracteres** entram no CSV, descartando legendas, notas de rodapé e fragmentos.

## Funções

### `mes_para_numero(mes)`
Converte nome de mês em português para dois dígitos (`"junho"` → `"06"`). Usada para formatar a data extraída do rodapé da Wikipédia.

### `scrape_wikipedia_article(url, nome_assunto = NULL)`
Raspa **um** artigo:
1. Extrai o título (`h1#firstHeading`).
2. Extrai todos os parágrafos (`#mw-content-text p`).
3. Filtra parágrafos com mais de 30 caracteres.
4. Extrai a data da última modificação (`#footer-info-lastmod`) e converte para `AAAA/MM/DD`.
5. Retorna um `data.frame` com **uma linha por parágrafo**.

### `scrape_wikipedia_articles(urls)`
Itera sobre as URLs, chama `scrape_wikipedia_article()` com `Sys.sleep(1)` entre chamadas (educação com o servidor) e concatena tudo num único `data.frame`. Adiciona a coluna `id` na primeira posição.

### `salvar_wikipedia_csv(df, output_dir)`
Salva o `data.frame` em `wikipedia_baixada_santista.csv` dentro de `output_dir`, com `fileEncoding = "UTF-8"`. Cria o diretório se não existir.

### `search_wikipedia_news(query, top_n = 3)`
Raspa os 3 artigos e roda `executar_recomendacao_ao_usuario()` (Módulo 3) sobre os parágrafos, usando `query` como consulta. Retorna `invisible(list(dataframe, query))`.

## Delay entre requisições
Fixo em **1 segundo** via `Sys.sleep(1)` entre artigos. Diferente do scraper antigo (que tinha delay aleatório de 3–8 s entre páginas de busca), aqui são apenas **3 requisições** no total — o custo é baixo e o delay fixo é suficiente.

---

## Testes

Os blocos de teste abaixo ficam comentados no fim do `.R` e podem ser executados descomentando-os. **Requerem conexão com a internet.**

### Teste 1 — Scraping + recomendação

```r
resultados <- search_wikipedia_news("porto e economia de Santos", top_n = 10)
```

Raspa os 3 artigos, monta o corpus de parágrafos e imprime os **10 parágrafos mais similares** à consulta. Espera-se que os primeiros venham do artigo de Santos, e que os primeiros colocados mencionem porto, economia ou comércio.

### Teste 2 — Salvar em CSV

```r
URL_DESTINO_CSV_SCRAPING <- file.path(
  "C:/Users/Ivan/Documents/Pasta-Documentos-PC-antigo/GITHUB-Meus-Repositorios",
  "PesquisaPI3_2026_v2/proj_ivan_gustavo_jorge(PI3)/estrutura/bancoDeDados"
)

salvar_wikipedia_csv(resultados$dataframe,
                     output_dir = URL_DESTINO_CSV_SCRAPING)
```

Gera/sobrescreve `estrutura/bancoDeDados/wikipedia_baixada_santista.csv` em **UTF-8**.

---

## Observações

- **Encoding:** a versão anterior salvava com `fileEncoding = "latin1"`, o que corrompia acentos quando o CSV era lido em outra máquina. Agora está padronizado em **UTF-8** (Fase 0, decisão [6]).
- **Data:** o formato `AAAA/MM/DD` foi escolhido para ordenação lexicográfica direta (mais recente = string maior). A data corresponde à **última modificação do artigo na Wikipédia**, não à data da coleta — é uma aproximação de "quando o texto foi atualizado".
- **Filtro de 30 caracteres:** evita poluir o corpus com fragmentos triviais (`"Ver também"`, `"[editar]"`, notas soltas). Esse limiar foi escolhido empiricamente após inspecionar os primeiros CSVs.
- **`Sys.sleep(1)` entre artigos:** 3 requisições no total, com 1 segundo de intervalo. Baixo custo e suficiente para não parecer abuso contra o servidor da Wikipédia.
- O módulo **não roda automaticamente** ao dar `source()` — apenas define funções. A execução do scraping é sempre uma chamada explícita de `search_wikipedia_news()`, dado o custo (tempo + requisições).