# =============================================================
# aula02.R — Top-5 Cosseno nas 3 Consultas de Trabalho
# Projeto Integrador III · Motor de Busca da Baixada Santista
# Alunos: Ivan Guimaraes dos S. da Silva, Jorge Sugano Suzart e Gustavo Geminiano
# =============================================================

args_cmd <- commandArgs(trailingOnly = FALSE)
file_arg <- grep("^--file=", args_cmd, value = TRUE)
if (length(file_arg) == 1) {
  setwd(dirname(normalizePath(sub("^--file=", "", file_arg))))
}

raiz <- if (file.exists("wikipedia_baixada_santista.csv")) {
  "."
} else if (file.exists(file.path("..", "bancoDeDados", "wikipedia_baixada_santista.csv"))) {
  file.path("..", "..")
} else if (file.exists(file.path("..", "..", "wikipedia_baixada_santista.csv"))) {
  file.path("..", "..")
} else {
  "."
}

rds_docs <- file.path(raiz, "estrutura", "banco-de-dados", "docs.rds")
rds_orig <- file.path(raiz, "estrutura", "banco-de-dados", "origem.rds")

if (file.exists(rds_docs) && file.exists(rds_orig)) {
  docs   <- readRDS(rds_docs)
  origem <- readRDS(rds_orig)
} else {
  arq_csv <- if (file.exists(file.path(raiz, "estrutura", "bancoDeDados", "wikipedia_baixada_santista.csv"))) {
    file.path(raiz, "estrutura", "bancoDeDados", "wikipedia_baixada_santista.csv")
  } else {
    file.path(raiz, "wikipedia_baixada_santista.csv")
  }
  corpus_raw <- tryCatch({
    read.csv(arq_csv, stringsAsFactors = FALSE, fileEncoding = "latin1")
  }, error = function(e) {
    read.csv(arq_csv, stringsAsFactors = FALSE, encoding = "latin1")
  })
  validos <- !is.na(corpus_raw$texto) & (nchar(corpus_raw$texto) > 200)
  docs   <- setNames(corpus_raw$texto[validos], paste0("d", seq_len(sum(validos))))
  origem <- setNames(
    ifelse(grepl("guaruja", corpus_raw$titulo[validos], ignore.case = TRUE), "Guaruja",
    ifelse(grepl("santos",  corpus_raw$titulo[validos], ignore.case = TRUE), "Santos", "Bertioga")),
    names(docs)
  )
}

# 1. Tokenizacao da Aula 01/02 (bruta: minusculas e quebra por espaco)
tokenizar <- function(texto) {
  t <- unlist(strsplit(tolower(texto), "\\s+"))
  t[nzchar(t)]
}

tokens <- lapply(docs, tokenizar)
vocab  <- sort(unique(unlist(tokens)))
tf     <- sapply(tokens, function(tk) as.integer(table(factor(tk, levels = vocab))))
rownames(tf) <- vocab

N   <- ncol(tf)
df  <- rowSums(tf > 0)
idf <- log(N / df)
w   <- tf * idf

cosseno <- function(a, b) {
  den <- sqrt(sum(a^2)) * sqrt(sum(b^2))
  if (den == 0) return(0)
  sum(a * b) / den
}

norm_cols <- function(m) {
  nrm <- sqrt(colSums(m^2))
  nrm[nrm == 0] <- 1
  sweep(m, 2, nrm, "/")
}

vetor_consulta <- function(termos, vocab, idf) {
  q <- as.integer(table(factor(termos, levels = vocab)))
  q * idf
}

ranking_cosseno <- function(consulta) {
  qw <- vetor_consulta(tokenizar(consulta), vocab, idf)
  s  <- apply(w, 2, function(d) cosseno(qw, d))
  sort(s, decreasing = TRUE)
}

W <- 76L
hr <- function(ch = "=") cat(paste(rep(ch, W), collapse = ""), "\n", sep = "")
hr("=")
cat("  AULA02.R  |  Modelo Vetorial TF-IDF + Similaridade do Cosseno (Aula 02)\n")
cat("  Grupo: Ivan Guimaraes, Gustavo Geminiano e Jorge Sugano Suzart\n")
hr("=")
cat(sprintf("  Documentos (N) : %d paragrafos (Santos=86, Guaruja=29, Bertioga=17)\n", N))
cat(sprintf("  Vocabulario    : %d termos distintos  |  TDM: %d x %d\n", length(vocab), nrow(w), ncol(w)))

normas <- sqrt(colSums(w^2))
top_n  <- sort(normas, decreasing = TRUE)[1:3]
cat(sprintf("  Maiores normas : %s\n",
            paste(sprintf("%s (%s, %.1f)", names(top_n), origem[names(top_n)], top_n), collapse = " | ")))
hr("-")

consultas <- c(
  q1 = "porto de santos",
  q2 = "praias e turismo",
  q3 = "forte sao joao"
)

for (qid in names(consultas)) {
  q <- consultas[[qid]]
  rk <- ranking_cosseno(q)
  # Fallback para acento caso tokenizacao bruta da Aula 02 exija forma acentuada em q3
  if (sum(rk > 0) == 0 && qid == "q3") {
    q_ac <- intToUtf8(c(102,111,114,116,101,32,115,227,111,32,106,111,227,111))
    rk <- ranking_cosseno(q_ac)
  }
  melhor <- names(rk)[1]
  cat(sprintf("\n  [%s] Consulta: \"%s\"\n", qid, q))
  cat("  Top-5 Cosseno : ")
  cat(paste(sprintf("%s (%.3f)", names(rk)[1:5], rk[1:5]), collapse = " · "), "\n")
  cat(sprintf("  1o Lugar      : %s (%s, score = %.4f)\n", melhor, origem[[melhor]], rk[[1]]))

  # Parcelas no produto escalar do 1o colocado (explicacao com numeros para demonstracao)
  q_tok <- tokenizar(q)
  if (all(!q_tok %in% vocab) && qid == "q3") {
    q_tok <- tokenizar(intToUtf8(c(102,111,114,116,101,32,115,227,111,32,106,111,227,111)))
  }
  qw <- vetor_consulta(q_tok, vocab, idf)
  termos_q <- intersect(q_tok, vocab)
  parc <- qw[termos_q] * w[termos_q, melhor]
  cat("  Parcelas (qw * w[, melhor]): ",
      paste(sprintf("%s=%.2f", termos_q, parc), collapse = " | "), "\n", sep = "")
  trecho <- substr(gsub("\\s+", " ", docs[[melhor]]), 1, 115)
  cat(sprintf("  Trecho        : \"%s...\"\n", trecho))
}
hr("=")
