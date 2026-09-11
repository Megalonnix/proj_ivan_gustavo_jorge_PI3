# ============================================================
# Importar dependências (sejam elas locais ou em nuvem)
# Necessário p/ eu e o Prof. executarmos!
# ============================================================


nm_script_buscado <- "1_tokenizacao_stopwords.R"
local_scripts_folder <- "C:/Users/Ivan/Documents/Pasta-Documentos-PC-antigo/GITHUB-Meus-Repositorios/PesquisaPI3_2026_v2/proj_ivan_gustavo_jorge(PI3)/estrutura/scriptsR/"
local_path <- file.path(local_scripts_folder, nm_script_buscado)

if (file.exists(local_path)) { 
  source(local_path) 
} else {
  source(paste0(
    "https://raw.githubusercontent.com/Megalonnix/proj_ivan_gustavo_jorge_PI3/",
    "main/estrutura/scriptsR/",
    nm_script_buscado
  ))
}


# ============================================================
# 2_bow_tfidf.R
# Matrizes Bag-of-Words (BoW) e TF-IDF
# ============================================================

get_processed_tokens <- function(nonProcessedTexts,
                                 dontRemoveStopWords = FALSE) {
  lapply(nonProcessedTexts, function(txt) {
    remove_stopwords(txt, desligado = dontRemoveStopWords)
  })
}

get_BOW_matrix <- function(nonProcessedTexts,
                           dontRemoveStopWords = FALSE) {
  corpus  <- get_processed_tokens(nonProcessedTexts, dontRemoveStopWords)
  vocab   <- sort(unique(unlist(corpus)))
  doc_lab <- sapply(corpus, paste, collapse = " ")
  
  m <- matrix(0,
              nrow = length(vocab),
              ncol = length(corpus),
              dimnames = list(vocab, doc_lab))
  
  for (i in seq_along(corpus)) {
    counts <- table(corpus[[i]])
    m[names(counts), i] <- as.numeric(counts)
  }
  
  list(matrix = m, df = as.data.frame(m))
}

get_TFIDF_matrix <- function(nonProcessedTexts,
                             dontRemoveStopWords = FALSE) {
  corpus  <- get_processed_tokens(nonProcessedTexts, dontRemoveStopWords)
  vocab   <- sort(unique(unlist(corpus)))
  doc_lab <- sapply(corpus, paste, collapse = " ")
  n_docs  <- length(corpus)
  
  count_m <- matrix(0,
                    nrow = length(vocab),
                    ncol = n_docs,
                    dimnames = list(vocab, doc_lab))
  
  for (i in seq_along(corpus)) {
    counts <- table(corpus[[i]])
    count_m[names(counts), i] <- as.numeric(counts)
  }
  
  doc_freq <- rowSums(count_m > 0)
  idf      <- log((1 + n_docs) / (1 + doc_freq)) + 1
  tfidf    <- count_m * idf
  
  norms <- sqrt(colSums(tfidf^2))
  norms[norms == 0] <- 1
  tfidf <- sweep(tfidf, 2, norms, "/")
  
  list(matrix = tfidf, df = as.data.frame(tfidf))
}