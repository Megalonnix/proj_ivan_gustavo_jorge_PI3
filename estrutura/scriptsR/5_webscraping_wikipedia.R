# ============================================================
# 5_webscraping_wikipedia.R
# Web Scraping: Wikipédia — 3 assuntos da Baixada Santista
# ============================================================

source("https://raw.githubusercontent.com/Megalonnix/proj_ivan_gustavo_jorge_PI3/main/estrutura/scriptsR/3_similaridade_cosseno.R")

if (!require(pacman)) install.packages("pacman")
pacman::p_load(rvest, stringr)

# --- URLs dos 3 assuntos ---
URLS_WIKIPEDIA <- c(
  guaruja  = "https://pt.wikipedia.org/wiki/Guarujá",
  santos   = "https://pt.wikipedia.org/wiki/Santos",
  bertioga = "https://pt.wikipedia.org/wiki/Bertioga"
)

# --- Scraping de UM artigo ---
scrape_wikipedia_article <- function(url, nome_assunto = NULL) {
  pagina <- read_html(url)

  # Título
  titulo <- pagina %>%
    html_element("h1#firstHeading") %>%
    html_text(trim = TRUE)

  # Corpo do artigo: parágrafos dentro de #mw-content-text
  paragrafos <- pagina %>%
    html_elements("#mw-content-text p") %>%
    html_text(trim = TRUE)

  # Remove parágrafos vazios ou muito curtos (lixo de navegação)
  paragrafos <- paragrafos[nchar(paragrafos) > 30]
  texto <- paste(paragrafos, collapse = " ")

  # Data: última modificação da página
  data_raw <- pagina %>%
    html_element("#footer-info-lastmod") %>%
    html_text(trim = TRUE)

  # Extrai algo como "12 de setembro de 2026" com regex simples
  data <- if (!is.na(data_raw)) {
    str_extract(data_raw, "\\d{1,2} de \\w+ de \\d{4}")
  } else {
    NA_character_
  }

  data.frame(
    titulo = ifelse(is.null(nome_assunto), titulo, nome_assunto),
    texto  = texto,
    data   = data,
    url    = url,
    stringsAsFactors = FALSE
  )
}

# --- Scraping de VÁRIOS artigos ---
scrape_wikipedia_articles <- function(urls) {
  artigos <- lapply(seq_along(urls), function(i) {
    cat(sprintf("\n[%d/%d] Scraping: %s\n", i, length(urls), urls[i]))
    Sys.sleep(1)  # educado com o servidor
    tryCatch(
      scrape_wikipedia_article(urls[i], nome_assunto = names(urls)[i]),
      error = function(e) {
        cat("  Erro:", conditionMessage(e), "\n")
        NULL
      }
    )
  })

  artigos <- artigos[!sapply(artigos, is.null)]
  do.call(rbind, artigos)
}

# --- Salvar CSV ---
salvar_wikipedia_csv <- function(df, output_dir = "estrutura/bancoDeDados") {
  if (!dir.exists(output_dir)) dir.create(output_dir, recursive = TRUE)
  filename <- file.path(output_dir, "wikipedia_baixada_santista.csv")
  write.csv(df, filename, row.names = FALSE, fileEncoding = "UTF-8")
  cat(sprintf("\nCSV salvo em: %s\n", filename))
  filename
}

# --- Busca + salvamento + recomendação ---
search_wikipedia_news <- function(query, top_n = 3,
                                  output_dir = "estrutura/bancoDeDados") {
  df <- scrape_wikipedia_articles(URLS_WIKIPEDIA)
  if (nrow(df) == 0) { cat("Nada coletado.\n"); return(NULL) }

  salvar_wikipedia_csv(df, output_dir)

  # Usa o TEXTO (não o título) para a recomendação
  executar_recomendacao_ao_usuario(
    fonteDocumentos         = as.list(df$texto),
    queryEscritaPeloUsuario = query,
    top_n                   = top_n
  )

  invisible(list(dataframe = df, query = query))
}

# --- Exemplo de uso ---
# resultados <- search_wikipedia_news(
#   query = "porto e economia de Santos",
#   top_n = 3
# )


# BAIXANDO MANUALMENTE OS DADOS DA WIKIPEDIA!!!

# resultados <- search_wikipedia_news("porto e economia de Santos", top_n = 3)

# URL_DESTINO_CSV_SCRAPING <- "C:/Users/Ivan/Documents/Pasta-Documentos-PC-antigo/GITHUB-Meus-Repositorios/PesquisaPI3_2026_v2/proj_ivan_gustavo_jorge(PI3)/estrutura/bancoDeDados"

# salvar_wikipedia_csv(
#   resultados$dataframe, 
#   output_dir = URL_DESTINO_CSV_SCRAPING)
