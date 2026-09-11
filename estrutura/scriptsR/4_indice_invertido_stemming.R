# ============================================================
# Importar dependências (sejam elas locais ou em nuvem)
# Necessário p/ eu e o Prof. executarmos!
# ============================================================

source("https://raw.githubusercontent.com/Megalonnix/proj_ivan_gustavo_jorge_PI3/main/estrutura/scriptsR/1_tokenizacao_stopwords.R")

# ============================================================
# 4_indice_invertido_stemming.R
# Índice Invertido + Stemming + Buscas Booleanas (AND/OR)
#
# FASE 1: corpus de teste (gato / peixe / carne)
# FASE 2: corpus da Aula 01 (8 documentos do professor)
# FASE 3: notícias da A Tribuna (opcional — só roda se os CSVs
#         estiverem em estrutura/bancoDeDados/)
# ============================================================

# ------------------------------------------------------------
# Funções do módulo
# ------------------------------------------------------------

construir_indice_invertido <- function(docs) {
  postings <- list()
  for (doc_id in names(docs)) {
    toks <- unique(processar_texto(docs[doc_id]))
    for (t in toks) {
      postings[[t]] <- c(postings[[t]], doc_id)
    }
  }
  postings
}

preparar_consulta <- function(texto) processar_texto(texto)

buscar_AND <- function(consulta, indice) {
  termos <- preparar_consulta(consulta)
  if (length(termos) == 0) return(character(0))
  listas <- indice[termos]
  listas <- listas[!sapply(listas, is.null)]
  if (length(listas) == 0) return(character(0))
  Reduce(intersect, listas)
}

buscar_OR <- function(consulta, indice) {
  termos <- preparar_consulta(consulta)
  if (length(termos) == 0) return(character(0))
  listas <- indice[termos]
  listas <- listas[!sapply(listas, is.null)]
  if (length(listas) == 0) return(character(0))
  Reduce(union, listas)
}

tabela_indice <- function(postings) {
  df <- data.frame(
    Radical         = names(postings),
    Frequencia_Docs = lengths(postings),
    Documentos      = I(sapply(postings, paste, collapse = ", "))
  )
  df[order(df$Radical), ]
}

# ============================================================
# FASE 1 — Corpus de teste
# ============================================================

cat("\n============================================================\n")
cat("FASE 1 — Corpus de teste (gato / peixe / carne)\n")
cat("============================================================\n")

docs_teste <- c(
  doc1 = "O gato comeu peixe",
  doc2 = "Os gatos comem peixe",
  doc3 = "O cachorro come carne"
)

postings_teste <- construir_indice_invertido(docs_teste)

cat("\n-- Postings --\n")
cat("gat  :", postings_teste[["gat"]],  "\n")
cat("peix :", postings_teste[["peix"]], "\n")
cat("com  :", postings_teste[["com"]],  "\n")

cat("\n-- Buscas booleanas --\n")
cat("AND ('peixe gato') :", buscar_AND("peixe gato", postings_teste), "\n")
cat("OR  ('gato comeu') :", buscar_OR("gato comeu",  postings_teste), "\n")

cat("\n-- Tabela --\n")
print(tabela_indice(postings_teste))

# ============================================================
# FASE 2 — Corpus da Aula 01 (8 documentos do professor)
# ============================================================

cat("\n============================================================\n")
cat("FASE 2 — Corpus da Aula 01 (8 documentos do professor)\n")
cat("============================================================\n")

docs_aula01 <- c(
  d1 = "Recuperacao de Informacao: ORDENA documentos, por relevancia!",
  d2 = "O modelo de espaco-vetorial representa documentos (como vetores).",
  d3 = "BM25 e um modelo probabilistico de ranqueamento de texto.",
  d4 = "Aprendizado estatistico fundamenta a recuperacao moderna.",
  d5 = "O indice invertido acelera a busca em muitos documentos.",
  d6 = "Embeddings capturam a semantica de palavras e documentos.",
  d7 = "A avaliacao mede a relevancia dos resultados da busca.",
  d8 = "Ciencia de dados combina estatistica e programacao."
)

postings_aula01 <- construir_indice_invertido(docs_aula01)

cat("\n-- Postings --\n")
cat("recuperaca :", postings_aula01[["recuperaca"]], "\n")
cat("acel       :", postings_aula01[["acel"]],       "\n")
cat("captur     :", postings_aula01[["captur"]],     "\n")

cat("\n-- Buscas booleanas --\n")
cat("AND ('modelo probabilistico') :",
    buscar_AND("modelo probabilistico", postings_aula01), "\n")
cat("OR  ('modelo probabilistico') :",
    buscar_OR("modelo probabilistico",  postings_aula01), "\n")

cat("\n-- Tabela (10 primeiros) --\n")
print(head(tabela_indice(postings_aula01), 10))

# ============================================================
# FASE 3 — Notícias da A Tribuna (opcional)
# ============================================================

cat("\n============================================================\n")
cat("FASE 3 — Notícias da A Tribuna (opcional)\n")
cat("============================================================\n")

caminho_noticias <- file.path("estrutura", "bancoDeDados",
                              "noticias_santos.csv")

if (file.exists(caminho_noticias)) {
  
  cat("\nArquivo encontrado:", caminho_noticias, "\n")
  
  noticias <- read.csv(caminho_noticias,
                       stringsAsFactors = FALSE,
                       fileEncoding = "UTF-8")
  
  docs_noticias <- noticias$titulo
  names(docs_noticias) <- paste0("n", seq_along(docs_noticias))
  
  postings_noticias <- construir_indice_invertido(docs_noticias)
  
  cat("\n-- Postings --\n")
  cat("sant       :", postings_noticias[["sant"]],       "\n")
  cat("funcionari :", postings_noticias[["funcionari"]], "\n")
  
  cat("\n-- Buscas booleanas --\n")
  cat("AND ('Santos')        :",
      buscar_AND("Santos",       postings_noticias), "\n")
  cat("OR  ('morre ampliar') :",
      buscar_OR("morre ampliar", postings_noticias), "\n")
  
  cat("\n-- Tabela (10 primeiros) --\n")
  print(head(tabela_indice(postings_noticias), 10))
  
} else {
  
  cat("\n[SKIP] Arquivo não encontrado:\n")
  cat("      ", caminho_noticias, "\n")
  cat("      Rode o módulo 5 (webscraping) para gerar os CSVs,\n")
  cat("      ou copie-os do projeto antigo para essa pasta.\n")
}