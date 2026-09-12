# ============================================================
# 2_bow_tfidf.R
# Matrizes Bag-of-Words (BoW) e TF-IDF
#
# Parâmetros:
#   aplicar_stopwords = TRUE  -> remove stopwords PT
#   usar_stemming     = TRUE  -> usa processar_texto (produção)
#                       FALSE -> usa remove_stopwords (didático)
#
# IDF no estilo sklearn (smooth):  log((1+N)/(1+df)) + 1
# Normalização L2 por coluna (documento) ao final.
# ============================================================

source("https://raw.githubusercontent.com/Megalonnix/proj_ivan_gustavo_jorge_PI3/main/estrutura/scriptsR/1_tokenizacao_stopwords.R")

# ------------------------------------------------------------
# get_processed_tokens
#   Escolhe o pipeline conforme 'usar_stemming'.
# ------------------------------------------------------------
get_processed_tokens <- function(texts,
                                 aplicar_stopwords = TRUE,
                                 usar_stemming     = TRUE) {
  if (usar_stemming) {
    lapply(texts, function(txt) processar_texto(txt, aplicar_stopwords))
  } else {
    lapply(texts, function(txt) remove_stopwords(txt, aplicar_stopwords))
  }
}

# ------------------------------------------------------------
# get_BOW_matrix  ->  list(matrix, df)
# ------------------------------------------------------------
get_BOW_matrix <- function(texts,
                           aplicar_stopwords = TRUE,
                           usar_stemming     = TRUE) {
  corpus  <- get_processed_tokens(texts, aplicar_stopwords, usar_stemming)
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

# ------------------------------------------------------------
# get_TFIDF_matrix  ->  list(matrix, df)
# ------------------------------------------------------------
get_TFIDF_matrix <- function(texts,
                             aplicar_stopwords = TRUE,
                             usar_stemming     = TRUE) {
  corpus  <- get_processed_tokens(texts, aplicar_stopwords, usar_stemming)
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
  idf      <- log((1 + n_docs) / (1 + doc_freq)) + 1    # sklearn-style
  tfidf    <- count_m * idf
  
  norms <- sqrt(colSums(tfidf^2))
  norms[norms == 0] <- 1
  tfidf <- sweep(tfidf, 2, norms, "/")
  
  list(matrix = tfidf, df = as.data.frame(tfidf))
}

# ============================================================
# TESTES — descomente para rodar
# ============================================================
#
# # --- Teste 1: corpus mínimo em INGLÊS, sem stemming (bate com sklearn) ---
textos <- list("I love you", "Love")
#
# get_BOW_matrix(textos,
#                aplicar_stopwords = FALSE,
#                usar_stemming     = FALSE)$matrix
# #      i love you love
# # i     1          0
# # love  1          1
# # you   1          0
#
# get_TFIDF_matrix(textos,
#                  aplicar_stopwords = FALSE,
#                  usar_stemming     = FALSE)$matrix
# #      i love you     love
# # i     0.631668     0
# # love  0.449436     1
# # you   0.631668     0
# # (bate com sklearn.TfidfVectorizer default)
#
# # --- Teste 2: corpus PT pequeno, produção (stemming ON) ---
# docs <- list(
#   "O gato comeu o peixe",
#   "O gato comeu a carne",
#   "O cachorro late"
# )
#
# get_BOW_matrix(docs)$matrix
# # 3 colunas (docs), N linhas (radicais). "gato" e "comeu" (radicais
# # correspondentes) devem aparecer nas duas primeiras colunas.
#
# # --- Teste 3: mesmo corpus, sem stemming (didático) ---
# get_BOW_matrix(docs, usar_stemming = FALSE)$matrix
# # Compare com o Teste 2: aqui aparecem "gato", "comeu", etc. inteiros.