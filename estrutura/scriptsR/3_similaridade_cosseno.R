# ============================================================
# 3_similaridade_cosseno.R
# Similaridade do Cosseno + Recomendação de Documentos
#
# Parâmetros repassados:
#   aplicar_stopwords = TRUE
#   usar_stemming     = TRUE  (padrão de produção)
# ============================================================

source("https://raw.githubusercontent.com/Megalonnix/proj_ivan_gustavo_jorge_PI3/main/estrutura/scriptsR/2_bow_tfidf.R")

# ------------------------------------------------------------
# cosine_similarity_native
#   Matriz termos x documentos  ->  matriz docs x docs.
# ------------------------------------------------------------
cosine_similarity_native <- function(m) {
  norms <- sqrt(colSums(m^2))
  norms[norms == 0] <- 1
  m_norm <- sweep(m, 2, norms, "/")
  t(m_norm) %*% m_norm
}

# ------------------------------------------------------------
# getCossine_Similarity_matrix
#   Se receber textos, monta TF-IDF internamente.
#   Se receber matriz, apenas calcula o cosseno.
# ------------------------------------------------------------
getCossine_Similarity_matrix <- function(nonProcessedTexts = list(),
                                         tf_idf_matrix     = NULL,
                                         aplicar_stopwords = TRUE,
                                         usar_stemming     = TRUE) {
  if (length(nonProcessedTexts) > 0 && is.null(tf_idf_matrix)) {
    tf_idf_matrix <- get_TFIDF_matrix(nonProcessedTexts,
                                      aplicar_stopwords,
                                      usar_stemming)$matrix
    return(cosine_similarity_native(tf_idf_matrix))
  }
  if (!is.null(tf_idf_matrix)) {
    return(cosine_similarity_native(tf_idf_matrix))
  }
  NULL
}

# ------------------------------------------------------------
# recomendar_documentos
#   A query entra como "documento 0"; retorna top_n mais próximos.
# ------------------------------------------------------------
recomendar_documentos <- function(query,
                                  lista_documentos,
                                  top_n             = 3,
                                  aplicar_stopwords = TRUE,
                                  usar_stemming     = TRUE) {
  textos <- c(list(query), lista_documentos)
  tfidf  <- get_TFIDF_matrix(textos,
                             aplicar_stopwords,
                             usar_stemming)$matrix
  sim    <- cosine_similarity_native(tfidf)
  
  sims <- sim[1, -1]
  n    <- min(top_n, length(sims))
  idx  <- order(sims, decreasing = TRUE)[1:n]
  
  lapply(idx, function(i) {
    list(documento    = lista_documentos[[i]],
         similaridade = sims[i])
  })
}

# ------------------------------------------------------------
# executar_recomendacao_ao_usuario  (wrapper de console)
# ------------------------------------------------------------
executar_recomendacao_ao_usuario <- function(fonteDocumentos,
                                             queryEscritaPeloUsuario,
                                             top_n             = 3,
                                             aplicar_stopwords = TRUE,
                                             usar_stemming     = TRUE) {
  cat("\n=== BUSCAR DOCUMENTOS MAIS PRÓXIMOS DA CONSULTA ===\n")
  cat(sprintf("\nConsulta: \"%s\"\n", queryEscritaPeloUsuario))
  
  res <- recomendar_documentos(
    query             = queryEscritaPeloUsuario,
    lista_documentos  = fonteDocumentos,
    top_n             = top_n,
    aplicar_stopwords = aplicar_stopwords,
    usar_stemming     = usar_stemming
  )
  
  for (i in seq_along(res)) {
    cat(sprintf("   %d. Score: %.3f\n", i, res[[i]]$similaridade))
    cat(sprintf("   Documento: %s\n", res[[i]]$documento))
  }
  invisible(res)
}

# ============================================================
# TESTES — descomente para rodar
# ============================================================
#
# # --- Teste 1: matriz de similaridade de um corpus pequeno ---
textos <- list(
  "Amo comer pizza",
  "Amo comer hamburguer",
  "Odeio lutar"
)
sim <- getCossine_Similarity_matrix(textos)
round(sim, 3)
# # Diagonal = 1.000 sempre.
# # Texto 1 vs 2 deve ter score ALTO (compartilham "amo" e "comer").
# # Texto 3 vs 1/2 deve ter score BAIXO (nada em comum).
#
# # --- Teste 2: recomendação (corpus de receitas) ---
receitas <- list(
  "bolo de chocolate",
  "bolo de nozes e chocolate",
  "cafe com chocolate",
  "cookies 'n cream e bolo de chocolate, receita facil",
  "hamburguer vegano com ovos e bacon"
)
executar_recomendacao_ao_usuario(
  fonteDocumentos         = receitas,
  queryEscritaPeloUsuario = "receita de bolo de chocolate",
  top_n                   = 5
)
# # Esperado: os 2 primeiros são sobre bolo; "cafe com chocolate"
# # vem em terceiro por causa de "chocolate".
#
# # --- Teste 3: corpus da Aula 01 (8 documentos) ---
docs <- list(
  d1 = "recuperacao de informacao ordena documentos por relevancia",
  d2 = "o modelo de espaco vetorial representa documentos como vetores",
  d3 = "bm25 e um modelo probabilistico de ranqueamento de texto",
  d4 = "aprendizado estatistico fundamenta a recuperacao moderna",
  d5 = "o indice invertido acelera a busca em muitos documentos",
  d6 = "embeddings capturam a semantica de palavras e documentos",
  d7 = "a avaliacao mede a relevancia dos resultados da busca",
  d8 = "ciencia de dados combina estatistica e programacao"
)
executar_recomendacao_ao_usuario(
  fonteDocumentos         = docs,
  queryEscritaPeloUsuario = "modelo de espaco vetorial",
  top_n                   = 3
)
# # Esperado: d2 em primeiro (contém todos os termos da query).