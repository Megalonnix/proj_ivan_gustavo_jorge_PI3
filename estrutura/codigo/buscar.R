# =============================================================
# buscar.R — Demonstracao / Auditoria Completa do Motor de Busca
# Projeto Integrador III · Motor de Busca da Baixada Santista
# Alunos: Ivan Guimaraes dos S. da Silva (RA 0051352421038)
#         Gustavo Geminiano (RA 0051352511009)
#         Jorge Sugano Suzart (RA 0051352511005)
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

source(file.path(raiz, "config.R"))

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

validos <- !is.na(corpus_raw$texto) & (nchar(corpus_raw$texto) > cfg$minimo)
cp_validos <- corpus_raw[validos, ]

docs   <- setNames(cp_validos$texto, paste0("d", seq_len(nrow(cp_validos))))
origem <- setNames(
  ifelse(grepl("guaruja", cp_validos$titulo, ignore.case = TRUE), "Guaruja",
  ifelse(grepl("santos",  cp_validos$titulo, ignore.case = TRUE), "Santos", "Bertioga")),
  names(docs)
)
doc_de_id <- setNames(names(docs), as.character(cp_validos$id))

limpar <- function(x) {
  Encoding(x) <- "latin1"
  x_utf8 <- enc2utf8(x)
  x_utf8 <- chartr(
    intToUtf8(c(225,224,226,227,228, 233,232,234,235, 237,236,238,239, 243,242,244,245,246, 250,249,251,252, 231, 241,
                193,192,194,195,196, 201,200,202,203, 205,204,206,207, 211,210,212,213,214, 218,217,219,220, 199, 209)),
    "aaaaaeeeeiiiiooooouuuucnAAAAAEEEEIIIIOOOOOUUUUCN",
    x_utf8
  )
  x <- tolower(x_utf8)
  x <- gsub("[^a-z0-9 ]", " ", x)
  trimws(gsub("\\s+", " ", x))
}
prep <- function(x) {
  t <- unlist(strsplit(limpar(x), " "))
  t[nzchar(t) & !t %in% cfg$stopwords]
}

tokens <- lapply(docs, prep)
ids    <- names(docs)
vocab  <- sort(unique(unlist(tokens)))
tf     <- sapply(tokens, function(t) as.integer(table(factor(t, levels = vocab))))
rownames(tf) <- vocab

N        <- ncol(tf)
dl       <- colSums(tf)
avgdl    <- mean(dl)
df       <- rowSums(tf > 0)
idf_tf   <- log(N / df)
idf_bm25 <- log((N - df + 0.5) / (df + 0.5) + 1)
w        <- tf * idf_tf
postings <- lapply(setNames(vocab, vocab), function(t) ids[tf[t, ] > 0])

busca_AND <- function(q) {
  t <- prep(q)
  if (!length(t) || !all(t %in% vocab)) return(character(0))
  Reduce(intersect, postings[t])
}
busca_OR <- function(q) {
  t <- intersect(prep(q), vocab)
  if (!length(t)) return(character(0))
  unique(unlist(postings[t], use.names = FALSE))
}
rank_tfidf <- function(q) {
  t <- intersect(prep(q), vocab)
  s <- if (length(t)) colSums(w[t, , drop = FALSE]) else setNames(rep(0, N), ids)
  sort(s, decreasing = TRUE)
}
rank_cos <- function(q) {
  qw <- as.integer(table(factor(prep(q), levels = vocab))) * idf_tf
  nq <- sqrt(sum(qw^2)); nd <- sqrt(colSums(w^2))
  s <- if (nq == 0) setNames(rep(0, N), ids) else as.numeric(crossprod(w, qw)) / (nq * nd)
  names(s) <- ids; s[!is.finite(s)] <- 0
  sort(s, decreasing = TRUE)
}
rank_bm25 <- function(q, k1 = cfg$k1, b = cfg$b) {
  t <- intersect(prep(q), vocab)
  K <- k1 * (1 - b + b * dl / avgdl)
  s <- setNames(rep(0, N), ids)
  for (term in t) {
    f <- tf[term, ]
    s <- s + idf_bm25[[term]] * f * (k1 + 1) / (f + K)
  }
  sort(s, decreasing = TRUE)
}

qrels_df <- read.csv(file.path(raiz, "qrels_jorge_2026-10-13.csv"), stringsAsFactors = FALSE)
grau_de <- function(qid) {
  sub <- qrels_df[qrels_df$consulta == qid, ]
  d_ids <- doc_de_id[as.character(sub$documento)]
  ok <- !is.na(d_ids)
  g <- setNames(as.numeric(sub$grau[ok]), d_ids[ok])
  g[!duplicated(names(g), fromLast = TRUE)]
}
dcg <- function(g) sum(g / log2(seq_along(g) + 1))

W <- 78L
hr <- function(ch = "=") cat(paste(rep(ch, W), collapse = ""), "\n", sep = "")
hr("=")
cat("  BUSCAR.R  |  Auditoria Multi-Metodo — Motor de Busca da Baixada Santista\n")
cat("  Grupo: Ivan Guimaraes, Gustavo Geminiano e Jorge Sugano Suzart\n")
cat(sprintf("  Corpus: N = %d paragrafos (Santos=86, Guaruja=29, Bertioga=17) | Vocab: %d\n", N, length(vocab)))
cat(sprintf("  Modelo oficial em config.R: %s (k1=%.2f, b=%.2f, prf_k=%d, lsa_k=%d, rrf_c=%d)\n",
            cfg$modelo, cfg$k1, cfg$b, cfg$prf_k, cfg$lsa_k, cfg$rrf_c))
hr("=")

consultas <- c(
  q1 = "porto de santos",
  q2 = "praias e turismo",
  q3 = "forte sao joao"
)
qrels_map <- c(q1 = "q02", q2 = "q03", q3 = "q10")

for (cq in names(consultas)) {
  q   <- consultas[[cq]]
  qid <- qrels_map[[cq]]
  g   <- grau_de(qid)

  and_ids <- busca_AND(q)
  or_ids  <- busca_OR(q)
  r_tf    <- rank_tfidf(q)
  r_cos   <- rank_cos(q)
  r_bm    <- rank_bm25(q)

  cat(sprintf("\n  >> [%s] Consulta: \"%s\" (Gabarito: %s | R=%d relevantes grau>=2)\n",
              cq, q, qid, sum(g >= cfg$limiar)))
  cat(sprintf("     Termos limpos : %s\n", paste(prep(q), collapse = " | ")))
  cat(sprintf("     Booleano      : AND = %d docs  |  OR = %d docs\n", length(and_ids), length(or_ids)))

  for (met in c("TF-IDF", "Cosseno", "BM25")) {
    rk <- switch(met, "TF-IDF" = r_tf, "Cosseno" = r_cos, "BM25" = r_bm)
    top5 <- names(rk)[1:5]
    g5   <- g[top5]; g5[is.na(g5)] <- 0
    rel3 <- as.integer(g5[1:3] >= cfg$limiar)
    ideal5 <- sort(g, decreasing = TRUE)[1:5]; ideal5[is.na(ideal5)] <- 0
    ndcg5 <- if (sum(ideal5) > 0) dcg(g5) / dcg(ideal5) else 0
    cat(sprintf("     %-7s Top-5 : %s  [P@3=%.2f | nDCG@5=%.2f]\n",
                met,
                paste(sprintf("%s(%.2f)", top5, rk[1:5]), collapse = " "),
                mean(rel3), ndcg5))
  }
  top1_bm <- names(r_bm)[1]
  cat(sprintf("     1o Lugar BM25 : %s (%s) -> \"%s...\"\n",
              top1_bm, origem[[top1_bm]], substr(gsub("\\s+", " ", docs[[top1_bm]]), 1, 95)))
}
hr("=")
