# =============================================================
# 01b-shannon-pesos.R — Aula 01b (Teoria da Informacao / Shannon)
# Projeto Integrador III · Motor de Busca da Baixada Santista
# Alunos: Ivan Guimaraes, Gustavo Geminiano e Jorge Sugano Suzart
# =============================================================

args_cmd <- commandArgs(trailingOnly = FALSE)
file_arg <- grep("^--file=", args_cmd, value = TRUE)
if (length(file_arg) == 1) {
  setwd(dirname(normalizePath(sub("^--file=", "", file_arg))))
}

raiz <- if (file.exists(file.path("estrutura", "banco-de-dados", "corpus.csv"))) {
  "."
} else if (file.exists(file.path("..", "banco-de-dados", "corpus.csv"))) {
  file.path("..", "..")
} else if (file.exists(file.path("..", "..", "estrutura", "banco-de-dados", "corpus.csv"))) {
  file.path("..", "..")
} else {
  "."
}
setwd(raiz)
source("config.R")

# -------------------------------------------------------------
# PARTE 1 — Corpus canonico do curso (8 documentos)
# -------------------------------------------------------------
docs_aula <- c(
  d1 = "recuperacao de informacao ordena documentos por relevancia",
  d2 = "o modelo de espaco vetorial representa documentos como vetores",
  d3 = "bm25 e um modelo probabilistico de ranqueamento de texto",
  d4 = "aprendizado estatistico fundamenta a recuperacao moderna",
  d5 = "o indice invertido acelera a busca em muitos documentos",
  d6 = "embeddings capturam a semantica de palavras e documentos",
  d7 = "a avaliacao mede a relevancia dos resultados da busca",
  d8 = "ciencia de dados combina estatistica e programacao"
)

tok_b <- function(x) {
  t <- unlist(strsplit(tolower(x), "\\s+"))
  t[nzchar(t)]
}
tokens_a <- lapply(docs_aula, tok_b)
N_a <- length(docs_aula)
contem_a <- function(t) names(docs_aula)[vapply(tokens_a, function(v) t %in% v, logical(1))]
df_a <- function(t) length(contem_a(t))
I_a  <- function(t) log2(N_a / df_a(t))

cat("=== PARTE 1: Corpus da aula (N = 8 docs) ===\n")
cat(sprintf("Incerteza inicial: log2(%d) = %.3f bits\n", N_a, log2(N_a)))
cat(sprintf("I('busca') = %.3f bits (df=%d) | I('de') = %.3f bits (df=%d)\n",
            I_a("busca"), df_a("busca"), I_a("de"), df_a("de")))

consulta_a <- c("modelo", "de", "recuperacao")
idf_bits_a <- sapply(consulta_a, I_a)
contrib_a <- sapply(names(docs_aula), function(d) {
  as.numeric(table(factor(tokens_a[[d]], levels = consulta_a))) * idf_bits_a
})
rownames(contrib_a) <- consulta_a
totais_a <- colSums(contrib_a)
print(round(rbind(contrib_a, total = totais_a), 3))

cat("\nIndependencia vs correlacao (soma de bits vs informacao real):\n")
for (par in list(c("busca", "documentos"), c("recuperacao", "relevancia"),
                 c("aprendizado", "estatistico"), c("modelo", "vetorial"))) {
  inter <- intersect(contem_a(par[1]), contem_a(par[2]))
  soma  <- I_a(par[1]) + I_a(par[2])
  real  <- if (length(inter)) log2(N_a / length(inter)) else NA_real_
  cat(sprintf("  %s + %s | inter=%s | soma=%.3f | real=%.3f | excesso=%.3f\n",
              par[1], par[2], paste(inter, collapse = ","), soma, real, soma - real))
}

# -------------------------------------------------------------
# PARTE 2 — Corpus do grupo (Baixada Santista, N = 132 paragrafos)
# -------------------------------------------------------------
cat("\n=== PARTE 2: Corpus do grupo (Baixada Santista) ===\n")
arq_csv <- if (file.exists("estrutura/banco-de-dados/corpus.csv")) {
  "estrutura/banco-de-dados/corpus.csv"
} else {
  "estrutura/banco-de-dados/wikipedia_baixada_santista.csv"
}
cp <- read.csv(arq_csv, fileEncoding = "latin1", stringsAsFactors = FALSE)
cp <- cp[!is.na(cp$texto) & nchar(cp$texto) > cfg$minimo, ]
docs_c <- setNames(cp$texto, paste0("d", seq_len(nrow(cp))))

limpar_ascii <- function(x) {
  x_utf8 <- enc2utf8(as.character(x))
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
tok_c <- function(x) {
  t <- unlist(strsplit(limpar_ascii(x), "\\s+"))
  t[nzchar(t)]
}

tokens_c <- lapply(docs_c, tok_c)
N_c <- length(docs_c)
df_c <- table(unlist(lapply(tokens_c, unique)))
I_c  <- function(t) if (t %in% names(df_c)) log2(N_c / as.numeric(df_c[t])) else NA_real_
contem_c <- function(t) names(docs_c)[vapply(tokens_c, function(v) t %in% v, logical(1))]

cat(sprintf("N = %d paragrafos | Incerteza inicial: log2(%d) = %.3f bits\n", N_c, N_c, log2(N_c)))
pistas <- c("de", "santos", "porto", "guaruja", "praias", "turismo", "bertioga", "forte", "cafe")
tab_pistas <- data.frame(
  termo = pistas,
  df    = as.integer(df_c[pistas]),
  bits  = round(vapply(pistas, I_c, numeric(1)), 3),
  stringsAsFactors = FALSE
)
print(tab_pistas, row.names = FALSE)
cat(sprintf("Termos raros (df=1 -> %.3f bits): %d de %d termos\n\n",
            log2(N_c), sum(df_c == 1), length(df_c)))

perguntas <- c(
  q1 = "porto de santos",
  q2 = "praias e turismo",
  q3 = "forte sao joao"
)
cat("--- Consultas de trabalho em bits (soma tf * I_bits) ---\n")
for (cq in names(perguntas)) {
  ts_q <- tok_c(perguntas[[cq]])
  ts_q <- ts_q[ts_q %in% names(df_c)]
  sc <- vapply(tokens_c, function(v) sum(as.numeric(table(factor(v, levels = ts_q))) * vapply(ts_q, I_c, numeric(1))), 0)
  top5 <- sort(sc, decreasing = TRUE)[1:5]
  cat(sprintf("%s '%s': %s\n", cq, perguntas[[cq]],
              paste(sprintf("%s=%.2f", ts_q, vapply(ts_q, I_c, numeric(1))), collapse = " | ")))
  cat("  Top-5:", paste(sprintf("%s (%.2f bits)", names(top5), top5), collapse = " · "), "\n")
}

cat("\n--- Independencia vs correlacao no corpus do grupo ---\n")
for (par in list(c("forte", "joao"), c("baixada", "santista"), c("porto", "cafe"), c("vicente", "carvalho"))) {
  inter <- intersect(contem_c(par[1]), contem_c(par[2]))
  soma  <- I_c(par[1]) + I_c(par[2])
  real  <- if (length(inter)) log2(N_c / length(inter)) else NA_real_
  cat(sprintf("  %s + %s | df=%d,%d | juntos=%d | soma=%.2f | real=%.2f | excesso=%.2f\n",
              par[1], par[2], length(contem_c(par[1])), length(contem_c(par[2])),
              length(inter), soma, real, soma - real))
}
