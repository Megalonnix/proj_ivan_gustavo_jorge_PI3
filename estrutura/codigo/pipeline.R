# Executar da raiz: Rscript estrutura/codigo/pipeline.R
# Base R; IDs originais do corpus (132 paragrafos validos > 200 chars) preservados para compatibilidade com qrels.
source('config.R')
set.seed(42)
dir.create('csv/05-qrels-respostas', recursive = TRUE, showWarnings = FALSE)
exportar <- function(x, n) write.csv(x, file.path('csv', n), row.names = FALSE, fileEncoding = 'UTF-8')

c_raw <- read.csv('estrutura/banco-de-dados/corpus.csv', fileEncoding = 'latin1', stringsAsFactors = FALSE)
n     <- read.csv('estrutura/banco-de-dados/necessidades.csv', fileEncoding = 'UTF-8', stringsAsFactors = FALSE)
stopifnot(!anyDuplicated(c_raw$id), all(c('id', 'texto') %in% names(c_raw)))

# Aplica o filtro oficial cfg$minimo (200 caracteres) mantendo os 132 paragrafos autonomos
c <- c_raw[!is.na(c_raw$texto) & nchar(c_raw$texto) > cfg$minimo, ]
ids <- as.character(c$id)

limpar <- function(x) {
  Encoding(x) <- 'latin1'
  x_utf8 <- enc2utf8(x)
  x_utf8 <- chartr(
    intToUtf8(c(225,224,226,227,228, 233,232,234,235, 237,236,238,239, 243,242,244,245,246, 250,249,251,252, 231, 241,
                193,192,194,195,196, 201,200,202,203, 205,204,206,207, 211,210,212,213,214, 218,217,219,220, 199, 209)),
    'aaaaaeeeeiiiiooooouuuucnAAAAAEEEEIIIIOOOOOUUUUCN',
    x_utf8
  )
  x <- tolower(x_utf8)
  x <- gsub('[^a-z0-9 ]', ' ', x)
  trimws(gsub('\\s+', ' ', x))
}

tok <- function(s) {
  z <- strsplit(limpar(s), ' +')
  lapply(z, function(x) x[nzchar(x) & !x %in% cfg$stopwords])
}

ts <- tok(c$texto)
vocab <- sort(unique(unlist(ts)))
tf <- vapply(ts, function(x) as.numeric(table(factor(x, levels = vocab))), numeric(length(vocab)))
colnames(tf) <- ids
rownames(tf) <- vocab

N   <- ncol(tf)
df  <- rowSums(tf > 0)
idf <- log(N / df)
w   <- tf * idf
dl  <- colSums(tf)
ib  <- log(1 + (N - df + 0.5) / (df + 0.5))

qvec <- function(q) as.numeric(table(factor(tok(q)[[1]], levels = vocab))) * idf
cosine <- function(mat, q) {
  den <- sqrt(colSums(mat^2)) * sqrt(sum(q^2))
  z <- as.numeric(crossprod(q, mat))
  z[den > 0] <- z[den > 0] / den[den > 0]
  z[den == 0] <- 0
  z
}
rankids <- function(s) ids[order(-s, as.integer(ids))]
bm <- function(q) {
  terms <- which(vocab %in% tok(q)[[1]])
  if (!length(terms)) return(rep(0, N))
  colSums(ib[terms] * tf[terms, , drop = FALSE] * (cfg$k1 + 1) /
          (tf[terms, , drop = FALSE] + cfg$k1 * rep(1 - cfg$b + cfg$b * dl / mean(dl), each = length(terms))))
}

rankings <- list()
pools <- list()
sv <- svd(w, nu = min(50, nrow(w), N), nv = min(50, nrow(w), N))
ks <- c(10, 20, 50)
ks <- ks[ks <= length(sv$d)]

for (i in seq_len(nrow(n))) {
  q <- n$consulta[i]
  v <- qvec(n$texto_consulta[i])
  b <- bm(n$texto_consulta[i])
  base <- rankids(cosine(w, v))
  terms <- match(tok(n$texto_consulta[i])[[1]], vocab)
  bool <- if (!length(terms) || anyNA(terms)) rep(0, N) else as.numeric(colSums(tf[terms, , drop = FALSE] > 0) == length(terms))
  rr <- list(booleano = rankids(bool), tfidf = base, bm25 = rankids(b))
  # Pseudo-feedback top-3
  pv <- cfg$rocchio['a'] * v + cfg$rocchio['b'] * rowMeans(w[, match(head(base, 3), ids), drop = FALSE])
  rr$prf <- rankids(cosine(w, pv))
  for (k in ks) {
    U <- sv$u[, seq_len(k), drop = FALSE]
    D <- t(sv$v[, seq_len(k), drop = FALSE] * rep(sv$d[seq_len(k)], each = N))
    lr <- rankids(cosine(D, as.numeric(crossprod(U, v))))
    rr[[paste0('lsa_', k)]] <- lr
    for (cc in c(10, 60, 100)) {
      rr[[paste0('hibrido_', k, '_', cc)]] <- rankids(1 / (cc + match(ids, rr$bm25)) + 1 / (cc + match(ids, lr)))
    }
  }
  for (m in names(rr)) {
    rankings[[length(rankings) + 1]] <- data.frame(consulta = q, modelo = m, documento = rr[[m]], posicao = seq_len(N))
  }
  if (q %in% head(n$consulta[n$conjunto == 'dev'], 3)) {
    docs_bool <- ids[order(-bool, as.integer(ids))][sort(bool, decreasing = TRUE) > 0]
    docs_pool <- unique(c(head(docs_bool, 10), head(base, 10), head(rr$bm25, 10)))
    docs_pool <- sample(docs_pool, length(docs_pool))
    j <- match(docs_pool, ids)
    pools[[length(pools) + 1]] <- data.frame(
      consulta = q, documento = docs_pool, texto_consulta = n$texto_consulta[i],
      necessidade = n$necessidade[i], escopo = n$escopo[i],
      titulo = c$titulo[j], texto = c$texto[j], grau = NA_integer_
    )
  }
}

r    <- do.call(rbind, rankings)
pool <- do.call(rbind, pools)
exportar(r, 'rankings.csv')
exportar(pool, '05-pool.csv')
exportar(r[r$modelo == 'prf', ], '06-pseudo-feedback-por-consulta.csv')
exportar(r[grepl('^(lsa|hibrido)', r$modelo), ], '07-lsa-por-consulta.csv')

for (juiz in c('ivan', 'gustavo', 'jorge')) {
  template <- pool
  template$juiz <- juiz
  dest <- file.path('csv/05-qrels-respostas', paste0('modelo-', juiz, '.csv'))
  if (!file.exists(dest)) write.csv(template, dest, row.names = FALSE, fileEncoding = 'UTF-8')
}

# Copia o gabarito oficial caso ainda nao esteja em csv/05-qrels-respostas
arq_qrels_bd <- 'estrutura/banco-de-dados/qrels_jorge_2026-10-13.csv'
arq_qrels_resp <- 'csv/05-qrels-respostas/qrels_jorge_2026-10-13.csv'
if (file.exists(arq_qrels_bd) && !file.exists(arq_qrels_resp)) {
  file.copy(arq_qrels_bd, arq_qrels_resp, overwrite = TRUE)
}

files <- list.files('csv/05-qrels-respostas', pattern = '^qrels.*[.]csv$', full.names = TRUE)
if (!length(files)) {
  cat('Pool e rankings gerados. Aguardando qrels reais para Kappa, metricas e decisao.\n')
  quit(save = 'no')
}

a <- do.call(rbind, lapply(files, function(f) read.csv(f, fileEncoding = 'UTF-8-BOM', stringsAsFactors = FALSE)))
a$documento <- as.character(a$documento)
# Filtra julgamentos referentes aos 132 paragrafos validos (> 200 caracteres)
a <- a[a$documento %in% ids & a$consulta %in% n$consulta & a$grau %in% 0:2, ]
a <- a[!duplicated(a[c('consulta', 'documento', 'juiz')], fromLast = TRUE), ]

key <- paste(a$consulta, a$documento)
kap <- list()
juizes <- unique(a$juiz)
if (length(juizes) > 1) {
  for (pair in combn(juizes, 2, simplify = FALSE)) {
    x <- a[a$juiz == pair[1], ]
    y <- a[a$juiz == pair[2], ]
    z <- merge(x, y, by = c('consulta', 'documento'))
    tab <- table(factor(z$grau.x, levels = 0:2), factor(z$grau.y, levels = 0:2))
    nn <- sum(tab)
    pe <- if (nn) sum(rowSums(tab) * colSums(tab)) / nn^2 else NA_real_
    kap[[length(kap) + 1]] <- data.frame(
      juiz1 = pair[1], juiz2 = pair[2], n = nn,
      kappa = if (nn && pe < 1) (sum(diag(tab)) / nn - pe) / (1 - pe) else NA_real_
    )
  }
}
if (length(kap)) exportar(do.call(rbind, kap), '05-kappa.csv')

conflicts <- names(which(vapply(split(a$grau, key), function(g) length(unique(g)) > 1, logical(1))))
exportar(a[key %in% conflicts, ], '05-divergencias.csv')

# Consolida gabarito segundo a prioridade oficial em cfg$juizes (ex.: jorge)
a_ord <- a[order(match(a$juiz, cfg$juizes)), ]
g <- aggregate(grau ~ consulta + documento, a_ord, function(x) x[1])
exportar(g, '05-qrels.csv')

metric <- function(order, grades, k = 10) {
  rels <- setNames(grades$grau, as.character(grades$documento))
  v <- rels[order]
  v[is.na(v)] <- 0
  hits <- v >= cfg$limiar
  R <- sum(rels >= cfg$limiar)
  top <- head(v, k)
  dcg <- function(x) sum((2^x - 1) / log2(seq_along(x) + 1))
  ideal <- dcg(head(sort(rels, decreasing = TRUE), k))
  c(
    P_at_10    = sum(head(hits, k)) / k,
    Recall     = if (R) sum(hits) / R else NA_real_,
    AP         = if (R) sum((cumsum(hits) / seq_along(hits))[hits]) / R else NA_real_,
    MRR        = if (any(hits)) 1 / unname(which(hits)[1]) else 0,
    nDCG_at_10 = if (ideal) dcg(top) / ideal else NA_real_
  )
}

out <- list()
for (q in unique(g$consulta)) {
  for (m in unique(r$modelo)) {
    z <- r[r$consulta == q & r$modelo == m, ]
    out[[length(out) + 1]] <- data.frame(
      consulta = q,
      conjunto = n$conjunto[match(q, n$consulta)],
      modelo   = m,
      t(metric(z$documento, g[g$consulta == q, ]))
    )
  }
}
metrics <- do.call(rbind, out)
exportar(metrics, '05b-metricas-por-consulta.csv')
exportar(aggregate(AP ~ modelo + conjunto, metrics, mean), '05b-map.csv')

# Feedback explicito (Rocchio) utiliza somente consultas dev
feedback <- list()
for (q in intersect(g$consulta, n$consulta[n$conjunto == 'dev'])) {
  gg <- g[g$consulta == q, ]
  dr <- match(gg$documento[gg$grau >= cfg$limiar], ids)
  dn <- match(gg$documento[gg$grau < cfg$limiar], ids)
  v  <- cfg$rocchio['a'] * qvec(n$texto_consulta[match(q, n$consulta)])
  if (length(dr)) v <- v + cfg$rocchio['b'] * rowMeans(w[, dr, drop = FALSE])
  if (length(dn)) v <- v - cfg$rocchio['g'] * rowMeans(w[, dn, drop = FALSE])
  feedback[[length(feedback) + 1]] <- data.frame(consulta = q, documento = rankids(cosine(w, v)), posicao = seq_len(N))
}
if (length(feedback)) exportar(do.call(rbind, feedback), '06-rocchio-por-consulta.csv')
exportar(metrics[grepl('^(lsa_|hibrido_)', metrics$modelo), ], '07-lsa-map-por-k.csv')

cat(sprintf('Pipeline concluido com sucesso! Corpus: N = %d paragrafos validos | Vocabulario limpo: %d termos.\n', N, length(vocab)))
cat('Tabelas CSV exportadas em csv/.\n')
