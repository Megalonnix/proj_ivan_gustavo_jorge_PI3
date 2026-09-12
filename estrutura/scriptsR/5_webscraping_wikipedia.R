# ============================================================
# 5_webscraping_wikipedia.R
# Web Scraping: Wikipédia — 3 assuntos da Baixada Santista
# ============================================================

source("https://raw.githubusercontent.com/Megalonnix/proj_ivan_gustavo_jorge_PI3/main/estrutura/scriptsR/3_similaridade_cosseno.R")

if (!require(pacman)) install.packages("pacman")
pacman::p_load(rvest, stringr)

URLS_WIKIPEDIA <- c(
  guaruja  = "https://pt.wikipedia.org/wiki/Guarujá",
  santos   = "https://pt.wikipedia.org/wiki/Santos",
  bertioga = "https://pt.wikipedia.org/wiki/Bertioga"
)

mes_para_numero <- function(mes) {
  meses <- c(
    janeiro = "01", fevereiro = "02", março = "03", abril = "04",
    maio = "05", junho = "06", julho = "07", agosto = "08",
    setembro = "09", outubro = "10", novembro = "11", dezembro = "12"
  )
  meses[[tolower(mes)]]
}

scrape_wikipedia_article <- function(url, nome_assunto = NULL) {
  pagina <- read_html(url)
  
  titulo <- pagina %>%
    html_element("h1#firstHeading") %>%
    html_text(trim = TRUE)
  
  paragrafos <- pagina %>%
    html_elements("#mw-content-text p") %>%
    html_text(trim = TRUE)
  
  paragrafos <- paragrafos[nchar(paragrafos) > 30]
  
  data_raw <- pagina %>%
    html_element("#footer-info-lastmod") %>%
    html_text(trim = TRUE)
  
  data <- NA_character_
  if (!is.na(data_raw)) {
    m <- regmatches(data_raw,
                    regexec("(\\d{1,2}) de (\\S+) de (\\d{4})", data_raw))[[1]]
    if (length(m) == 4) {
      dia <- sprintf("%02d", as.integer(m[2]))
      mes <- mes_para_numero(m[3])
      ano <- m[4]
      if (!is.null(mes)) data <- paste(ano, mes, dia, sep = "/")
    }
  }
  
  data.frame(
    titulo = paste0(ifelse(is.null(nome_assunto), titulo, nome_assunto),
                    " — par. ", seq_along(paragrafos)),
    texto  = paragrafos,
    data   = data,
    url    = url,
    stringsAsFactors = FALSE
  )
}

scrape_wikipedia_articles <- function(urls) {
  artigos <- lapply(seq_along(urls), function(i) {
    cat(sprintf("\n[%d/%d] Scraping: %s\n", i, length(urls), urls[i]))
    Sys.sleep(1)
    tryCatch(
      scrape_wikipedia_article(urls[i], nome_assunto = names(urls)[i]),
      error = function(e) {
        cat("  Erro:", conditionMessage(e), "\n")
        NULL
      }
    )
  })
  
  artigos <- artigos[!sapply(artigos, is.null)]
  df <- do.call(rbind, artigos)
  df <- cbind(id = seq_len(nrow(df)), df)
  rownames(df) <- NULL
  df
}

salvar_wikipedia_csv <- function(df, output_dir = "estrutura/bancoDeDados") {
  if (!dir.exists(output_dir)) dir.create(output_dir, recursive = TRUE)
  filename <- file.path(output_dir, "wikipedia_baixada_santista.csv")
  write.csv(df, filename, row.names = FALSE, fileEncoding = "UTF-8")
  cat(sprintf("\nCSV salvo em: %s\n", filename))
  filename
}

search_wikipedia_news <- function(query, top_n = 3) {
  df <- scrape_wikipedia_articles(URLS_WIKIPEDIA)
  if (nrow(df) == 0) { cat("Nada coletado.\n"); return(NULL) }
  
  executar_recomendacao_ao_usuario(
    fonteDocumentos         = as.list(df$texto),
    queryEscritaPeloUsuario = query,
    top_n                   = top_n
  )
  
  invisible(list(dataframe = df, query = query))
}

# ============================================================
# TESTES — descomente para rodar (precisa de internet)
# ============================================================
#
# resultados <- search_wikipedia_news("porto e economia de Santos", top_n = 10)
#
# URL_DESTINO_CSV_SCRAPING <- file.path(
#   "C:/Users/Ivan/Documents/Pasta-Documentos-PC-antigo/GITHUB-Meus-Repositorios",
#   "PesquisaPI3_2026_v2/proj_ivan_gustavo_jorge(PI3)/estrutura/bancoDeDados"
# )
#
# salvar_wikipedia_csv(resultados$dataframe,
#                      output_dir = URL_DESTINO_CSV_SCRAPING)
# # O CSV agora é escrito em UTF-8 (antes era latin1).