# =============================================================
# 05a-kappa.R — Aula 05 — Concordancia entre Juizes (Kappa de Cohen)
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

kappa_cohen <- function(m) {
  n <- sum(m)
  po <- sum(diag(m)) / n
  pe <- sum(rowSums(m) * colSums(m)) / n^2
  kappa <- if (n > 0 && pe < 1) (po - pe) / (1 - pe) else NA_real_
  list(n = n, po = po, pe = pe, kappa = kappa)
}

cat("=== Kappa de Cohen (matrizes canonicas da Aula 05) ===\n\n")
m_aula <- matrix(c(18, 3, 0,
                   2, 6, 2,
                   0, 2, 7), nrow = 3, byrow = TRUE,
                 dimnames = list(paste0("A=", 0:2), paste0("B=", 0:2)))
r_aula <- kappa_cohen(m_aula)
print(m_aula)
cat(sprintf("n=%d | po=%.3f | pe=%.3f | kappa=%.3f\n\n",
            r_aula$n, r_aula$po, r_aula$pe, r_aula$kappa))

m_zeros <- matrix(c(37, 2, 0,
                    1, 0, 0,
                    0, 0, 0), nrow = 3, byrow = TRUE,
                  dimnames = list(paste0("A=", 0:2), paste0("B=", 0:2)))
r_zeros <- kappa_cohen(m_zeros)
cat("--- Caso degenerado: 37/40 zeros concordantes (paradoxo do Kappa) ---\n")
print(m_zeros)
cat(sprintf("n=%d | po=%.3f | pe=%.3f | kappa=%.3f\n\n",
            r_zeros$n, r_zeros$po, r_zeros$pe, r_zeros$kappa))

cat("=== Kappa nos qrels do grupo (csv/05-qrels-respostas/) ===\n")
arqs <- list.files("csv/05-qrels-respostas", pattern = "^qrels.*[.]csv$", full.names = TRUE)
if (!length(arqs)) {
  cat("Nenhum arquivo qrels*.csv encontrado.\n")
  quit(save = "no")
}

a <- do.call(rbind, lapply(arqs, function(f) {
  read.csv(f, fileEncoding = "UTF-8-BOM", stringsAsFactors = FALSE)
}))
a$documento <- as.character(a$documento)
a$juiz <- trimws(a$juiz)
a <- a[a$grau %in% 0:2, ]
a <- a[!duplicated(a[c("consulta", "documento", "juiz")], fromLast = TRUE), ]

juizes <- unique(a$juiz)
cat("Juizes encontrados:", paste(juizes, collapse = ", "), "\n")
if (length(juizes) < 2) {
  cat("Apenas 1 juiz com votos reais no momento — aguardando julgamentos de outros juizes (05-julgar.html) para calcular Kappa entre pares.\n")
} else {
  for (pair in combn(juizes, 2, simplify = FALSE)) {
    x <- a[a$juiz == pair[1], ]
    y <- a[a$juiz == pair[2], ]
    z <- merge(x, y, by = c("consulta", "documento"))
    tab <- table(factor(z$grau.x, levels = 0:2), factor(z$grau.y, levels = 0:2))
    res <- kappa_cohen(tab)
    cat(sprintf("%s vs %s | n=%d | po=%.3f | pe=%.3f | kappa=%.3f\n",
                pair[1], pair[2], res$n, res$po, res$pe, res$kappa))
  }
}
