# =============================================================
# coletar.R — regenera o corpus do projeto (Baixada Santista)
# Projeto Integrador III · Motor de Busca
# Alunos: Ivan Guimaraes dos S. da Silva, Jorge Sugano Suzart e Gustavo Geminiano
# =============================================================

args_cmd <- commandArgs(trailingOnly = FALSE)
file_arg <- grep("^--file=", args_cmd, value = TRUE)
if (length(file_arg) == 1) {
  setwd(dirname(normalizePath(sub("^--file=", "", file_arg))))
}

# Localiza a raiz do repositorio independentemente de onde Rscript foi chamado
raiz <- if (file.exists("wikipedia_baixada_santista.csv")) {
  "."
} else if (file.exists(file.path("..", "bancoDeDados", "wikipedia_baixada_santista.csv"))) {
  file.path("..", "..")
} else if (file.exists(file.path("..", "..", "wikipedia_baixada_santista.csv"))) {
  file.path("..", "..")
} else {
  "."
}

arq_cfg <- if (file.exists(file.path(raiz, "config.R"))) {
  file.path(raiz, "config.R")
} else if (file.exists("config.R")) {
  "config.R"
} else {
  NULL
}
if (!is.null(arq_cfg)) {
  source(arq_cfg)
} else {
  cfg <- list(minimo = 200, grupo = "ivan_gustavo_jorge")
}

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

# Nas Aulas 01 a 04 os documentos sao nomeados d1..d132;
# nas Aulas 05b a 07 o gabarito usa o id original da linha (1..152).
# Gravamos docs.rds / origem.rds com d1..d132 (padrao da Aula 01/02)
# e tambem docs_id.rds / origem_id.rds com os IDs do gabarito.
docs <- setNames(cp_validos$texto, paste0("d", seq_len(nrow(cp_validos))))
origem <- setNames(
  ifelse(grepl("guaruja", cp_validos$titulo, ignore.case = TRUE), "Guaruja",
  ifelse(grepl("santos",  cp_validos$titulo, ignore.case = TRUE), "Santos", "Bertioga")),
  names(docs)
)

for (pasta_bd in c(file.path(raiz, "estrutura", "banco-de-dados"),
                   file.path(raiz, "estrutura", "bancoDeDados"))) {
  dir.create(pasta_bd, recursive = TRUE, showWarnings = FALSE)
  saveRDS(docs,   file.path(pasta_bd, "docs.rds"))
  saveRDS(origem, file.path(pasta_bd, "origem.rds"))
}

W <- 74L
hr <- function(ch = "=") cat(paste(rep(ch, W), collapse = ""), "\n", sep = "")
hr("=")
cat("  COLETAR.R  |  Motor de Busca da Baixada Santista (Santos, Guaruja, Bertioga)\n")
cat("  Grupo: Ivan Guimaraes, Gustavo Geminiano e Jorge Sugano Suzart\n")
hr("=")
cat(sprintf("  Fonte bruta : %s (%d paragrafos extraidos)\n", arq_csv, nrow(corpus_raw)))
cat(sprintf("  Criterio    : paragrafo com nchar > %d (cfg$minimo)\n", cfg$minimo))
cat(sprintf("  Descartados : %d paragrafos curtos (<= %d caracteres)\n",
            nrow(corpus_raw) - nrow(cp_validos), cfg$minimo))
cat(sprintf("  Congelados  : N = %d paragrafos autonomos (d1..d%d)\n\n",
            length(docs), length(docs)))

tab_orig <- table(origem)[c("Santos", "Guaruja", "Bertioga")]
cat(sprintf("  %-12s  %-26s  %10s  %10s  %10s\n",
            "Origem", "Artigo Wikipedia (PT)", "Brutos", "Validos", "Proporcao"))
cat(sprintf("  %-12s  %-26s  %10s  %10s  %10s\n",
            "------------", "--------------------------", "----------", "----------", "----------"))

orig_raw <- ifelse(grepl("guaruja", corpus_raw$titulo, ignore.case = TRUE), "Guaruja",
            ifelse(grepl("santos",  corpus_raw$titulo, ignore.case = TRUE), "Santos", "Bertioga"))
tab_raw <- table(orig_raw)[c("Santos", "Guaruja", "Bertioga")]
art_nomes <- c(Santos = "Santos (Sao Paulo)", Guaruja = "Guaruja", Bertioga = "Bertioga")

for (nm in c("Santos", "Guaruja", "Bertioga")) {
  cat(sprintf("  %-12s  %-26s  %10d  %10d  %9.1f%%\n",
              nm, art_nomes[[nm]], tab_raw[[nm]], tab_orig[[nm]],
              100 * tab_orig[[nm]] / length(docs)))
}
cat(sprintf("\n  %-12s  %-26s  %10d  %10d  %9.1f%%\n",
            "TOTAL", "3 paginas (CC BY-SA 4.0)", nrow(corpus_raw), length(docs), 100.0))
hr("-")
cat("  Arquivos gerados: estrutura/banco-de-dados/docs.rds e origem.rds\n")
cat("                    estrutura/bancoDeDados/docs.rds e origem.rds\n")
cat("  Proximo passo   : Rscript aula02.R  ou  Rscript buscar.R\n")
hr("=")
