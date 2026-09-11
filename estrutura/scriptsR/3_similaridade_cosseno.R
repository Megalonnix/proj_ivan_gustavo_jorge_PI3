# ============================================================
# Importar dependências (sejam elas locais ou em nuvem)
# Necessário p/ eu e o Prof. executarmos!
# ============================================================

source("https://raw.githubusercontent.com/Megalonnix/proj_ivan_gustavo_jorge_PI3/main/estrutura/scriptsR/2_bow_tfidf.R")

# ============================================================
# 3_similaridade_cosseno.R
# Similaridade do Cosseno + Recomendação de Documentos
# ============================================================

cosine_similarity_native <- function(m) {
  norms <- sqrt(colSums(m^2))
  norms[norms == 0] <- 1
  m_norm <- sweep(m, 2, norms, "/")
  t(m_norm) %*% m_norm
}

getCossine_Similarity_matrix <- function(nonProcessedTexts = list(),
                                         tf_idf_matrix = NULL,
                                         cancelStopWordRemoval = FALSE) {
  if (length(nonProcessedTexts) > 0 && is.null(tf_idf_matrix)) {
    tf_idf_matrix <- get_TFIDF_matrix(nonProcessedTexts,
                                      cancelStopWordRemoval)$matrix
    return(cosine_similarity_native(tf_idf_matrix))
  }
  
  if (!is.null(tf_idf_matrix)) {
    if (cancelStopWordRemoval) {
      cat(">>> AVISO: matriz TF-IDF recebida como parâmetro. <<<\n")
      cat("-> Não é possível desligar stopwords por essa via.\n")
      cat("-> Use getCossine_Similarity_matrix(nonProcessedTexts, NULL, TRUE)\n\n")
    }
    return(cosine_similarity_native(tf_idf_matrix))
  }
  NULL
}

recomendar_documentos <- function(query,
                                  lista_documentos,
                                  top_n = 3,
                                  dontRemoveStopWords = FALSE) {
  textos <- c(list(query), lista_documentos)
  tfidf  <- get_TFIDF_matrix(textos, dontRemoveStopWords)$matrix
  sim    <- getCossine_Similarity_matrix(tf_idf_matrix = tfidf)
  
  sims <- sim[1, -1]
  n    <- min(top_n, length(sims))
  idx  <- order(sims, decreasing = TRUE)[1:n]
  
  lapply(idx, function(i) {
    list(documento = lista_documentos[[i]],
         similaridade = sims[i])
  })
}

executar_recomendacao_ao_usuario <- function(fonteDocumentos,
                                             queryEscritaPeloUsuario,
                                             top_n = 3) {
  cat("\n=== BUSCAR DOCUMENTOS MAIS PRÓXIMOS DA CONSULTA ===\n")
  cat(sprintf("\nConsulta: \"%s\"\n", queryEscritaPeloUsuario))
  
  res <- recomendar_documentos(
    query = queryEscritaPeloUsuario,
    lista_documentos = fonteDocumentos,
    top_n = top_n
  )
  
  for (i in seq_along(res)) {
    cat(sprintf("   %d. Score: %.3f\n", i, res[[i]]$similaridade))
    cat(sprintf("   Documento: %s\n", res[[i]]$documento))
  }
  invisible(res)
}