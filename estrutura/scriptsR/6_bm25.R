# ============================================================
# 6_bm25.R
# BM25 — Best Matching 25
# Modelo probabilístico de ranqueamento (Aula 04)
#
# Fórmula:
#   BM25(q, d) = Σ_{t ∈ q} IDF(t) · [ f_{t,d}·(k1+1) ] / [ f_{t,d} + K ]
#   K          = k1 · (1 - b + b · |d| / avgdl)
#   IDF_BM25(t)= ln( (N - df_t + 0.5) / (df_t + 0.5) + 1 )
#
# Parâmetros:
#   k1 ∈ [1.2, 2.0]  controla a saturação da frequência
#   b  ∈ [0, 1]      controla o peso do tamanho do documento
# ============================================================

source("https://raw.githubusercontent.com/Megalonnix/proj_ivan_gustavo_jorge_PI3/main/estrutura/scriptsR/3_similaridade_cosseno.R")

# ------------------------------------------------------------
# idf_bm25 — versão probabilística do IDF (Aula 04, pag. 27)
#
# Os "+0.5" evitam divisão/log por zero quando df = N ou df = 0.
# O "+1" impede IDF negativo para termos com df > N/2.
# ------------------------------------------------------------
idf_bm25 <- function(df, N) {
  log((N - df + 0.5) / (df + 0.5) + 1)
}

# ------------------------------------------------------------
# bm25_score — calcula escores para TODOS os docs de uma vez
#
#   query_tokens: vetor de tokens já pré-processados
#   tf_matrix:    matriz termos × documentos (contagens cruas)
#   idf_vector:   idf_bm25(df, N) — vetor nomeado por termo
#   doc_lengths:  vetor |d| por documento
#   avgdl:        média de doc_lengths
# ------------------------------------------------------------
bm25_score <- function(query_tokens, tf_matrix, idf_vector,
                       doc_lengths, avgdl,
                       k1 = 1.2, b = 0.75) {
  vocab <- rownames(tf_matrix)
  N     <- ncol(tf_matrix)

  # K_d para cada documento (vetorizado — um valor por coluna)
  K <- k1 * (1 - b + b * doc_lengths / avgdl)

  scores <- numeric(N)
  names(scores) <- colnames(tf_matrix)

  for (t in unique(query_tokens)) {
    if (!(t %in% vocab)) next
    f_vec  <- tf_matrix[t, ]
    scores <- scores + idf_vector[t] * (f_vec * (k1 + 1)) / (f_vec + K)
  }
  scores
}

# ------------------------------------------------------------
# bm25_rank — wrapper: query + corpus → escores nomeados
#
# Deriva doc_lengths direto do BoW (colSums), sem reprocessar.
# ------------------------------------------------------------
bm25_rank <- function(query, textos,
                      k1 = 1.2, b = 0.75,
                      aplicar_stopwords = TRUE,
                      usar_stemming     = TRUE) {
  bow     <- get_BOW_matrix(textos, aplicar_stopwords, usar_stemming)$matrix
  N       <- ncol(bow)
  df      <- rowSums(bow > 0)
  idf     <- idf_bm25(df, N)
  d_len   <- colSums(bow)
  avgdl   <- mean(d_len)

  q_tokens <- if (usar_stemming) {
    processar_texto(query, aplicar_stopwords)
  } else {
    remove_stopwords(query, aplicar_stopwords)
  }

  bm25_score(q_tokens, bow, idf, d_len, avgdl, k1, b)
}

# ------------------------------------------------------------
# executar_bm25_ao_usuario — imprime top_n no console
# ------------------------------------------------------------
executar_bm25_ao_usuario <- function(fonteDocumentos,
                                     queryEscritaPeloUsuario,
                                     top_n = 3,
                                     k1 = 1.2, b = 0.75,
                                     aplicar_stopwords = TRUE,
                                     usar_stemming     = TRUE) {
  cat("\n=== BUSCAR DOCUMENTOS VIA BM25 ===\n")
  cat(sprintf("\nConsulta: \"%s\"\n", queryEscritaPeloUsuario))
  cat(sprintf("Parâmetros: k1 = %.2f | b = %.2f\n", k1, b))

  scores <- bm25_rank(queryEscritaPeloUsuario, fonteDocumentos,
                      k1, b, aplicar_stopwords, usar_stemming)
  idx <- order(scores, decreasing = TRUE)[1:min(top_n, length(scores))]

  for (i in seq_along(idx)) {
    cat(sprintf("   %d. Score: %.3f\n", i, scores[idx[i]]))
    cat(sprintf("   Documento: %s\n", fonteDocumentos[[idx[i]]]))
  }
  invisible(scores)
}

# ------------------------------------------------------------
# comparar_tfidf_bm25 — ranking lado a lado (tarefa Aula 04)
# ------------------------------------------------------------
comparar_tfidf_bm25 <- function(query, docs, top_n = 5,
                                k1 = 1.2, b = 0.75,
                                aplicar_stopwords = TRUE,
                                usar_stemming     = TRUE) {
  cat("\n============================================================\n")
  cat(sprintf("COMPARAÇÃO TF-IDF × BM25 — Consulta: \"%s\"\n", query))
  cat("============================================================\n")

  res_tfidf   <- recomendar_documentos(query, docs, top_n,
                                       aplicar_stopwords, usar_stemming)
  scores_bm25 <- bm25_rank(query, docs, k1, b,
                           aplicar_stopwords, usar_stemming)
  idx_bm25    <- order(scores_bm25, decreasing = TRUE)[1:min(top_n, length(scores_bm25))]

  cat(sprintf("\n%-4s | %-7s | %-38s | %-7s | %-38s\n",
              "Rank", "TF-IDF", "", "BM25", ""))
  cat(strrep("-", 105), "\n")

  for (i in seq_len(top_n)) {
    d_tfidf <- res_tfidf[[i]]
    d_bm25  <- list(documento = docs[[idx_bm25[i]]],
                    score     = scores_bm25[idx_bm25[i]])

    doc_t <- substr(d_tfidf$documento, 1, 36)
    doc_b <- substr(d_bm25$documento,  1, 36)

    cat(sprintf("%-4d | %.3f   | %-38s | %.3f   | %-38s\n",
                i,
                d_tfidf$similaridade, doc_t,
                d_bm25$score,         doc_b))
  }
  cat("\n")
  invisible(list(tfidf = res_tfidf, bm25_scores = scores_bm25))
}

# ============================================================
# TESTES — descomente para rodar
# ============================================================
#
# docs_aula01 <- list(
#   d1 = "recuperacao de informacao ordena documentos por relevancia",
#   d2 = "o modelo de espaco vetorial representa documentos como vetores",
#   d3 = "bm25 e um modelo probabilistico de ranqueamento de texto",
#   d4 = "aprendizado estatistico fundamenta a recuperacao moderna",
#   d5 = "o indice invertido acelera a busca em muitos documentos",
#   d6 = "embeddings capturam a semantica de palavras e documentos",
#   d7 = "a avaliacao mede a relevancia dos resultados da busca",
#   d8 = "ciencia de dados combina estatistica e programacao"
# )
#
# # --- Teste 1: reproduzir o slide do professor (Aula 04, pag. 36) ---
# # O professor NÃO usa stemming nem remove stopwords.
# scores <- bm25_rank("modelo de recuperacao", docs_aula01,
#                     k1 = 1.2, b = 0.75,
#                     aplicar_stopwords = FALSE,
#                     usar_stemming     = FALSE)
# round(sort(scores, decreasing = TRUE), 3)
# # Esperado (slide 36):
# #   d3    d1    d2    d4    d8    d6    d5    d7
# # 1.873 1.869 1.687 1.427 0.519 0.492 0.000 0.000
#
# # --- Teste 2: mesmo corpus, pipeline padrão do projeto (ON/ON) ---
# executar_bm25_ao_usuario(
#   fonteDocumentos         = docs_aula01,
#   queryEscritaPeloUsuario = "modelo de recuperacao",
#   top_n                   = 5
# )
# # A ORDEM deve ser parecida com a do Teste 1,
# # mas os valores diferem (stemming colapsa variações,
# # stopwords saem do vocabulário e alteram IDF/avgdl).
#
# # --- Teste 3: saturação isolada (sem tamanho: b = 0) ---
# sat <- function(f, k1 = 1.2) (f * (k1 + 1)) / (f + k1)
# round(sapply(1:5, sat), 3)
# # Esperado: 1.000 1.375 1.571 1.692 1.774
# # (bate com o slide 37: "da 1ª p/ 2ª o ganho é grande, depois diminui")
#
# # --- Teste 4: sensibilidade a k1 ---
# for (k in c(0, 0.5, 1.2, 2.0)) {
#   s <- bm25_rank("modelo de recuperacao", docs_aula01,
#                  k1 = k, b = 0.75,
#                  aplicar_stopwords = FALSE,
#                  usar_stemming     = FALSE)
#   top3 <- paste(names(sort(s, decreasing = TRUE))[1:3], collapse = " ")
#   cat(sprintf("k1 = %.1f  |  top 3: %s\n", k, top3))
# }
# # Esperado:
# #   k1 = 0   → ranking degenerado (busca booleana)
# #   k1 grande → ranking se aproxima do TF-IDF
#
# # --- Teste 5: comparação lado a lado TF-IDF vs BM25 ---
# comparar_tfidf_bm25(
#   query = "modelo de recuperacao",
#   docs  = docs_aula01,
#   top_n = 5
# )