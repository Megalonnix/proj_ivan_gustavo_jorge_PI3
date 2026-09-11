# ============================================================
# Importar dependências (sejam elas locais ou em nuvem)
# Necessário p/ eu e o Prof. executarmos!
# ============================================================

source("https://raw.githubusercontent.com/Megalonnix/proj_ivan_gustavo_jorge_PI3/main/estrutura/scriptsR/3_similaridade_cosseno.R")

# ============================================================
# 5_webscraping_atribuna.R
# Web Scraping: A Tribuna — Guarujá, Santos, Bertioga
# ============================================================

if (!require(pacman)) install.packages("pacman")
pacman::p_load(rvest)

# --- Configuração das cidades ---
URL_DOWNLOADS <- file.path("estrutura", "bancoDeDados")

cities <- list(
  guaruja  = list(name = "Guarujá",  cid = "1.499556",
                  base_url = "https://www.atribuna.com.br/buscar?page=%d&cid=%s&pageStart=%d"),
  santos   = list(name = "Santos",   cid = "1.499607",
                  base_url = "https://www.atribuna.com.br/buscar?page=%d&cid=%s&pageStart=%d"),
  bertioga = list(name = "Bertioga", cid = "1.499531",
                  base_url = "https://www.atribuna.com.br/buscar?page=%d&cid=%s&pageStart=%d")
)

# --- Delay aleatório entre requisições ---
random_delay_varied <- function() {
  key   <- runif(1, 0, 20)
  delay <- if (key <= 10) runif(1, 3, 4) else runif(1, 6, 8)
  cat(sprintf("  [Key: %.2f] Waiting %.1f seconds...\n", key, delay))
  Sys.sleep(delay)
}

# --- Scraping por cidade ---
scrape_city_news <- function(city_key, max_articles = 100) {
  city <- cities[[city_key]]
  if (is.null(city)) stop("City not found: use guaruja / santos / bertioga")

  cat(sprintf("\n=== Scraping news from %s ===\n", city$name))

  all_news <- data.frame()
  page_num <- 1; page_start <- 0; page_count <- 0

  while (nrow(all_news) < max_articles) {
    url <- sprintf(city$base_url, page_num, city$cid, page_start)
    page_count <- page_count + 1
    cat(sprintf("\nPage %d: %s\n", page_num, url))

    if (page_count > 1) random_delay_varied()

    pagina <- tryCatch(read_html(url), error = function(e) NULL)
    if (is.null(pagina)) { cat("Failed to load page. Stopping.\n"); break }

    teasers <- c(pagina %>% html_elements(".Teaser.mobile"),
                 pagina %>% html_elements(".Teaser.desktop"))
    if (length(teasers) == 0) {
      cat("No more articles. Stopping.\n"); break
    }

    results <- list()
    for (t in teasers) {
      link <- t %>% html_element(".TeaserTitleText a")
      if (!is.na(link)) {
        results[[length(results) + 1]] <- data.frame(
          titulo    = link %>% html_text(trim = TRUE),
          url       = paste0("https://www.atribuna.com.br",
                             link %>% html_attr("href")),
          categoria = t %>% html_element(".TeaserSubjectText") %>%
                        html_text(trim = TRUE),
          stringsAsFactors = FALSE
        )
      }
    }

    if (length(results) == 0) { cat("No articles on page. Stopping.\n"); break }

    df_page  <- do.call(rbind, results)
    all_news <- rbind(all_news, df_page)
    all_news <- all_news[!duplicated(all_news$url), ]

    cat(sprintf("  Total articles so far: %d\n", nrow(all_news)))
    page_num   <- page_num + 1
    page_start <- page_start + 10
  }

  cat(sprintf("\n=== Finished scraping %s ===\n", city$name))
  cat(sprintf("Total articles collected: %d\n", nrow(all_news)))
  all_news
}

# --- Scraping + salvamento + recomendação ---
search_city_news <- function(city_key, query, top_n = 3,
                             max_articles = 100,
                             output_dir = URL_DOWNLOADS) {
  df <- scrape_city_news(city_key, max_articles)
  if (nrow(df) == 0) { cat("No articles found.\n"); return(NULL) }

  city_name <- cities[[city_key]]$name
  if (!dir.exists(output_dir)) dir.create(output_dir, recursive = TRUE)

  filename <- file.path(output_dir,
                        paste0("noticias_", tolower(city_name), ".csv"))
  write.csv(df, filename, row.names = FALSE, fileEncoding = "UTF-8")
  cat(sprintf("\nDataframe saved as: %s\n", filename))

  executar_recomendacao_ao_usuario(
    fonteDocumentos         = as.list(df$titulo),
    queryEscritaPeloUsuario = query,
    top_n                   = top_n
  )

  invisible(list(city = city_name, query = query, dataframe = df))
}