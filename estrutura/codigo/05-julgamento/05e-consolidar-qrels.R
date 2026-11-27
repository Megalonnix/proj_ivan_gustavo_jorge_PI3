# =============================================================
# 05e-consolidar-qrels.R — Consolida votos de csv/05-qrels-respostas/
# Projeto Integrador III · Motor de Busca da Baixada Santista
# =============================================================

args_cmd <- commandArgs(trailingOnly = FALSE)
file_arg <- grep("^--file=", args_cmd, value = TRUE)
if (length(file_arg) == 1) {
  setwd(dirname(normalizePath(sub("^--file=", "", file_arg))))
}

raiz <- if (file.exists(file.path("csv", "05-qrels-respostas"))) {
  "."
} else if (file.exists(file.path("..", "..", "..", "csv", "05-qrels-respostas"))) {
  file.path("..", "..", "..")
} else {
  "."
}
setwd(raiz)
source("config.R")

arq_corpus <- if (file.exists("estrutura/banco-de-dados/corpus.csv")) {
  "estrutura/banco-de-dados/corpus.csv"
} else {
  "estrutura/banco-de-dados/wikipedia_baixada_santista.csv"
}
c_raw <- read.csv(arq_corpus, fileEncoding = "latin1", stringsAsFactors = FALSE)
n     <- read.csv("estrutura/banco-de-dados/necessidades.csv", fileEncoding = "UTF-8", stringsAsFactors = FALSE)
ids_validos <- as.character(c_raw$id[!is.na(c_raw$texto) & nchar(c_raw$texto) > cfg$minimo])

arqs <- list.files("csv/05-qrels-respostas", pattern = "^qrels.*[.]csv$", full.names = TRUE)
if (!length(arqs)) stop("Nenhum arquivo qrels*.csv em csv/05-qrels-respostas/", call. = FALSE)

partes <- lapply(arqs, function(f) read.csv(f, fileEncoding = "UTF-8-BOM", stringsAsFactors = FALSE))
a <- do.call(rbind, partes)
a$documento <- as.character(a$documento)
a$juiz <- trimws(a$juiz)

# Filtra para os 132 paragrafos validos e graus 0..2
a <- a[a$documento %in% ids_validos & a$consulta %in% n$consulta & a$grau %in% 0:2, ]
a <- a[!duplicated(a[c("consulta", "documento", "juiz")], fromLast = TRUE), ]

key <- paste(a$consulta, a$documento)
juizes <- unique(a$juiz)
if (length(juizes) > 1) {
  kap <- list()
  for (pair in combn(juizes, 2, simplify = FALSE)) {
    x <- a[a$juiz == pair[1], ]
    y <- a[a$juiz == pair[2], ]
    z <- merge(x, y, by = c("consulta", "documento"))
    tab <- table(factor(z$grau.x, levels = 0:2), factor(z$grau.y, levels = 0:2))
    nn <- sum(tab)
    pe <- if (nn) sum(rowSums(tab) * colSums(tab)) / nn^2 else NA_real_
    kap[[length(kap) + 1]] <- data.frame(
      juiz1 = pair[1], juiz2 = pair[2], n = nn,
      kappa = if (nn && pe < 1) (sum(diag(tab)) / nn - pe) / (1 - pe) else NA_real_
    )
  }
  write.csv(do.call(rbind, kap), "csv/05-kappa.csv", row.names = FALSE, fileEncoding = "UTF-8")
}

conflicts <- names(which(vapply(split(a$grau, key), function(g) length(unique(g)) > 1, logical(1))))
write.csv(a[key %in% conflicts, ], "csv/05-divergencias.csv", row.names = FALSE, fileEncoding = "UTF-8")

a_ord <- a[order(match(a$juiz, cfg$juizes)), ]
g <- aggregate(grau ~ consulta + documento, a_ord, function(x) x[1])
write.csv(g, "csv/05-qrels.csv", row.names = FALSE, fileEncoding = "UTF-8")

cat(sprintf("Consolidado em csv/05-qrels.csv: %d julgamentos validos nos 132 paragrafos.\n", nrow(g)))
print(table(grau = g$grau))
