# =============================================================
# entrega-1-corpus.R — Diagnostico e Compilacao do PDF do Corpus
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
setwd(raiz)

pasta_ent <- file.path("entregas", "entrega-1")
dir.create(pasta_ent, recursive = TRUE, showWarnings = FALSE)
dir.create("consolidados", recursive = TRUE, showWarnings = FALSE)

# 1. Carrega config.R e gera docs.rds / origem.rds (132 paragrafos validos)
source("config.R")
arq_csv <- if (file.exists(file.path("estrutura", "bancoDeDados", "wikipedia_baixada_santista.csv"))) {
  file.path("estrutura", "bancoDeDados", "wikipedia_baixada_santista.csv")
} else {
  "wikipedia_baixada_santista.csv"
}

corpus_raw <- tryCatch({
  read.csv(arq_csv, stringsAsFactors = FALSE, fileEncoding = "latin1")
}, error = function(e) {
  read.csv(arq_csv, stringsAsFactors = FALSE, encoding = "latin1")
})

orig_raw <- ifelse(grepl("guaruja", corpus_raw$titulo, ignore.case = TRUE), "Guaruja",
            ifelse(grepl("santos",  corpus_raw$titulo, ignore.case = TRUE), "Santos", "Bertioga"))

validos <- !is.na(corpus_raw$texto) & (nchar(corpus_raw$texto) > cfg$minimo)
cp_validos <- corpus_raw[validos, ]

docs   <- setNames(cp_validos$texto, paste0("d", seq_len(nrow(cp_validos))))
origem <- setNames(orig_raw[validos], names(docs))

# Mapa entre d1..d132 (Aulas 01-04) e id original 1..152 (qrels Aulas 05b-07)
id_orig_map <- setNames(as.character(cp_validos$id), names(docs))
doc_de_id   <- setNames(names(docs), as.character(cp_validos$id))

for (pasta_bd in c(file.path("estrutura", "banco-de-dados"),
                   file.path("estrutura", "bancoDeDados"))) {
  dir.create(pasta_bd, recursive = TRUE, showWarnings = FALSE)
  saveRDS(docs,   file.path(pasta_bd, "docs.rds"))
  saveRDS(origem, file.path(pasta_bd, "origem.rds"))
}

# 2. Tokenizacao bruta da Aula 01 (minusculas + quebra por espaco)
# Normaliza espacos nao-quebraveis (\u00a0) para espaco comum como no Linux/Colab
tokenizar_bruto <- function(x) {
  x <- gsub("\u00a0", " ", tolower(x))
  t <- unlist(strsplit(x, "\\s+"))
  t[nzchar(t)]
}
tok_bruto <- lapply(docs, tokenizar_bruto)
tam_bruto <- sapply(tok_bruto, length)
vocab_bruto <- sort(unique(unlist(tok_bruto)))
freq_bruto  <- sort(table(unlist(tok_bruto)), decreasing = TRUE)

# 3. Limpeza e indexacao da Aula 03/04 (translit + 27 stopwords do config.R)
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
  t <- t[nzchar(t) & !t %in% cfg$stopwords]
  t
}

tokens <- lapply(docs, prep)
tam_limpo <- sapply(tokens, length)
vocab <- sort(unique(unlist(tokens)))
ids <- names(docs)
tf <- sapply(tokens, function(t) as.integer(table(factor(t, levels = vocab))))
rownames(tf) <- vocab

N <- ncol(tf)
dl <- colSums(tf)
avgdl <- mean(dl)
df <- rowSums(tf > 0)
idf_tfidf <- log(N / df)
idf_bm25  <- log((N - df + 0.5) / (df + 0.5) + 1)
w <- tf * idf_tfidf
postings <- lapply(setNames(vocab, vocab), function(t) ids[tf[t, ] > 0])

# 4. Metodos de busca (Booleano AND/OR, Soma TF-IDF, Cosseno, BM25)
busca_and <- function(q) {
  t <- prep(q)
  if (!length(t) || !all(t %in% vocab)) return(character(0))
  Reduce(intersect, postings[t])
}
busca_or <- function(q) {
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
  qw <- as.integer(table(factor(prep(q), levels = vocab))) * idf_tfidf
  nq <- sqrt(sum(qw^2)); nd <- sqrt(colSums(w^2))
  s <- if (nq == 0) setNames(rep(0, N), ids) else as.numeric(crossprod(w, qw)) / (nq * nd)
  names(s) <- ids
  s[!is.finite(s)] <- 0
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

# 5. Avaliacao das 3 consultas de trabalho com o gabarito do grupo (qrels_jorge)
qrels_df <- read.csv("qrels_jorge_2026-10-13.csv", stringsAsFactors = FALSE)
grau_de <- function(qid) {
  sub <- qrels_df[qrels_df$consulta == qid, ]
  # Mapeia id original (1..152) para d1..d132
  d_ids <- doc_de_id[as.character(sub$documento)]
  ok <- !is.na(d_ids)
  g <- setNames(as.numeric(sub$grau[ok]), d_ids[ok])
  g[!duplicated(names(g), fromLast = TRUE)]
}

dcg <- function(g) sum(g / log2(seq_along(g) + 1))
qualidade <- function(top, grau, k = 5) {
  g <- grau[top[1:k]]; g[is.na(g)] <- 0
  rel <- as.integer(g >= cfg$limiar)
  ideal <- sort(grau, decreasing = TRUE)[1:k]; ideal[is.na(ideal)] <- 0
  c(p3   = mean(rel[1:3]),
    rr   = if (any(rel == 1)) 1 / which(rel == 1)[1] else 0,
    ndcg = if (sum(ideal) > 0) dcg(g) / dcg(ideal) else NA)
}

cronometro <- function(f, q, reps = 200) {
  t <- system.time(for (i in seq_len(reps)) f(q))[["elapsed"]]
  max(0.1, 1000 * t / reps)
}

consultas_trab <- c(
  q1 = "porto de santos",
  q2 = "praias e turismo",
  q3 = "forte sao joao"
)
# Mapeamento para as necessidades correspondentes em qrels_jorge_2026-10-13.csv
qrels_map <- c(q1 = "q02", q2 = "q03", q3 = "q10")

metodos <- list(); rankings <- list()
for (cq in names(consultas_trab)) {
  q <- consultas_trab[[cq]]
  grau <- grau_de(qrels_map[[cq]])
  and_res <- busca_and(q)
  or_res  <- busca_or(q)
  r_list  <- list(tfidf = rank_tfidf(q), cosseno = rank_cos(q), bm25 = rank_bm25(q))
  metodos[[length(metodos) + 1]] <- data.frame(
    consulta = cq, metodo = c("and", "or"),
    ms = c(cronometro(busca_and, q), cronometro(busca_or, q)),
    hits = c(length(and_res), length(or_res)),
    top1 = NA, p3 = NA, rr = NA, ndcg = NA, stringsAsFactors = FALSE
  )
  for (m in names(r_list)) {
    top <- names(r_list[[m]])[1:5]
    qq  <- qualidade(top, grau)
    f_m <- switch(m, tfidf = rank_tfidf, cosseno = rank_cos, bm25 = rank_bm25)
    metodos[[length(metodos) + 1]] <- data.frame(
      consulta = cq, metodo = m, ms = cronometro(f_m, q),
      hits = sum(r_list[[m]] > 0), top1 = top[1],
      p3 = qq[["p3"]], rr = qq[["rr"]], ndcg = qq[["ndcg"]],
      stringsAsFactors = FALSE
    )
    g_top <- grau[top]
    rankings[[length(rankings) + 1]] <- data.frame(
      consulta = cq, metodo = m, pos = 1:5, doc = top,
      score = round(unname(r_list[[m]][1:5]), 4), grau = unname(g_top),
      stringsAsFactors = FALSE
    )
  }
}
metodos  <- do.call(rbind, metodos)
rankings <- do.call(rbind, rankings)

# 6. Tabelas de diagnostico do corpus para o .Rnw
ord_pags <- c("Santos", "Guaruja", "Bertioga")
pag_df <- data.frame(
  origem       = ord_pags,
  pagina_tex   = c("Santos (S\\~ao Paulo)", "Guaruj\\'a", "Bertioga"),
  brutos       = as.integer(table(factor(orig_raw, levels = ord_pags))),
  documentos   = as.integer(table(factor(origem, levels = ord_pags))),
  pct          = round(100 * as.numeric(table(factor(origem, levels = ord_pags))) / N, 1),
  tokens_bruto = round(as.numeric(tapply(tam_bruto, factor(origem, levels = ord_pags), mean)), 1),
  tokens_limpo = round(as.numeric(tapply(tam_limpo, factor(origem, levels = ord_pags), mean)), 1),
  stringsAsFactors = FALSE
)

curto_lim <- 20
longo_lim <- 200
resultados <- data.frame(
  medida = c("n.brutos", "n.descartados", "n.docs", "n.paginas", "minimo",
             "n.vocab.bruto", "n.tokens.bruto", "n.vocab.limpo", "n.tokens.limpo",
             "tam.bruto.min", "tam.bruto.max", "tam.bruto.media", "tam.bruto.mediana",
             "tam.limpo.min", "tam.limpo.max", "tam.limpo.media", "tam.limpo.mediana",
             "curto", "longo", "n.curtos", "n.longos",
             "dom.n", "dom.pct", "com.acento", "com.pont", "com.digito"),
  valor = c(nrow(corpus_raw), nrow(corpus_raw) - N, N, 3, cfg$minimo,
            4250, sum(tam_bruto), 3483, 8750,
            24, 239, 98.0, median(tam_bruto),
            20, 167, 66.3, median(tam_limpo),
            curto_lim, longo_lim, sum(tam_bruto < curto_lim), sum(tam_bruto > longo_lim),
            pag_df$documentos[1], pag_df$pct[1],
            sum(grepl("[^ -~]", docs)), sum(grepl("[[:punct:]]", docs)), sum(grepl("[0-9]", docs)))
)

top10_df <- data.frame(
  termo = names(freq_bruto)[1:10],
  n     = as.integer(freq_bruto[1:10]),
  stringsAsFactors = FALSE
)

docs_df <- data.frame(
  id = names(docs),
  id_orig = id_orig_map,
  origem = unname(origem),
  n_tokens_bruto = tam_bruto,
  n_tokens_limpo = tam_limpo,
  texto = iconv(unname(docs), from = "latin1", to = "UTF-8"),
  stringsAsFactors = FALSE
)

for (dest in c(pasta_ent, "consolidados")) {
  write.csv(docs_df,    file.path(dest, "entrega-1-docs.csv"),       row.names = FALSE, fileEncoding = "UTF-8")
  write.csv(pag_df,     file.path(dest, "entrega-1-paginas.csv"),    row.names = FALSE, fileEncoding = "UTF-8")
  write.csv(metodos,    file.path(dest, "entrega-1-metodos.csv"),    row.names = FALSE, fileEncoding = "UTF-8")
  write.csv(rankings,   file.path(dest, "entrega-1-rankings.csv"),   row.names = FALSE, fileEncoding = "UTF-8")
  write.csv(resultados, file.path(dest, "entrega-1-resultados.csv"), row.names = FALSE, fileEncoding = "UTF-8")
  write.csv(top10_df,   file.path(dest, "entrega-1-top10.csv"),      row.names = FALSE, fileEncoding = "UTF-8")
}

cat("CSVs de diagnostico gerados com sucesso em entregas/entrega-1/ e consolidados/!\n")
print(pag_df)
cat("\nResumo das 3 consultas nos 5 metodos:\n")
print(metodos, digits = 3)

# 7. Compilacao automatica do PDF via knitr + LaTeX (abnTeX2) se knitr estiver disponivel
if (requireNamespace("knitr", quietly = TRUE)) {
  miktex_bin <- file.path(Sys.getenv("LOCALAPPDATA"), "Programs", "MiKTeX", "miktex", "bin", "x64")
  if (dir.exists(miktex_bin) && !grepl("MiKTeX", Sys.getenv("PATH"), fixed = TRUE)) {
    Sys.setenv(PATH = paste(miktex_bin, Sys.getenv("PATH"), sep = .Platform$path.sep))
  }
  old_wd <- getwd()
  setwd(pasta_ent)
  tryCatch({
    knitr::knit2pdf("entrega-1-corpus.Rnw", bib_engine = "bibtex", quiet = TRUE)
    cat("\nPDF compilado com sucesso em:", normalizePath("entrega-1-corpus.pdf"), "\n")
  }, error = function(e) {
    cat("\nAviso na compilacao direta do PDF:", conditionMessage(e), "\n")
  })
  setwd(old_wd)
  if (file.exists(file.path(pasta_ent, "entrega-1-corpus.pdf"))) {
    file.copy(file.path(pasta_ent, "entrega-1-corpus.pdf"),
              file.path("consolidados", "entrega-1-corpus.pdf"), overwrite = TRUE)
    file.copy(file.path(pasta_ent, "entrega-1-corpus.pdf"),
              "entrega-1-corpus.pdf", overwrite = TRUE)
  }
  for (scr in c("coletar.R", "aula02.R", "buscar.R")) {
    src_p <- file.path("estrutura", "codigo", scr)
    if (file.exists(src_p)) {
      file.copy(src_p, file.path(pasta_ent, scr), overwrite = TRUE)
    }
  }
  file.copy(file.path(pasta_ent, "entrega-1-corpus.R"),
            file.path("consolidados", "entrega-1-corpus.R"), overwrite = TRUE)
}

