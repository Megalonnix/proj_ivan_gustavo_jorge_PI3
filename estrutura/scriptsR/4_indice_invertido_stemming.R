# ============================================================
# 4_indice_invertido_stemming.R
# Índice Invertido + Stemming + Buscas Booleanas (AND/OR)
#
# Sempre usa processar_texto() (pipeline de PRODUÇÃO, com stemming).
# ============================================================

source("https://raw.githubusercontent.com/Megalonnix/proj_ivan_gustavo_jorge_PI3/main/estrutura/scriptsR/1_tokenizacao_stopwords.R")

# ------------------------------------------------------------
# Funções do módulo
# ------------------------------------------------------------

construir_indice_invertido <- function(docs, aplicar_stopwords = TRUE) {
  postings <- list()
  for (doc_id in names(docs)) {
    toks <- unique(processar_texto(docs[doc_id], aplicar_stopwords))
    for (t in toks) {
      postings[[t]] <- c(postings[[t]], doc_id)
    }
  }
  postings
}

preparar_consulta <- function(texto, aplicar_stopwords = TRUE) {
  processar_texto(texto, aplicar_stopwords)
}

buscar_AND <- function(consulta, indice, aplicar_stopwords = TRUE) {
  termos <- preparar_consulta(consulta, aplicar_stopwords)
  if (length(termos) == 0) return(character(0))
  listas <- indice[termos]
  listas <- listas[!sapply(listas, is.null)]
  if (length(listas) == 0) return(character(0))
  Reduce(intersect, listas)
}

buscar_OR <- function(consulta, indice, aplicar_stopwords = TRUE) {
  termos <- preparar_consulta(consulta, aplicar_stopwords)
  if (length(termos) == 0) return(character(0))
  listas <- indice[termos]
  listas <- listas[!sapply(listas, is.null)]
  if (length(listas) == 0) return(character(0))
  Reduce(union, listas)
}

tabela_indice <- function(postings) {
  df <- data.frame(
    Radical         = names(postings),
    Frequencia_Docs = lengths(postings),
    Documentos      = I(sapply(postings, paste, collapse = ", "))
  )
  df[order(df$Radical), ]
}

# ============================================================
# TESTES — descomente para rodar
# ============================================================
#
# # --- Teste 1: corpus mínimo em PT (didático) ---
# docs_teste <- c(
#   doc1 = "O gato comeu peixe",
#   doc2 = "Os gatos comem peixe",
#   doc3 = "O cachorro come carne"
# )
#
# postings <- construir_indice_invertido(docs_teste)
#
# postings[["gat"]]
# # Deve conter doc1 e doc2 (ambos contêm "gato"/"gatos").
#
# postings[["peix"]]
# # Deve conter doc1 e doc2.
#
# postings[["carn"]]
# # Deve conter apenas doc3.
#
# # --- Teste 2: buscas booleanas ---
# buscar_AND("peixe gato", postings)   # interseção: doc1, doc2
# buscar_OR("gato carne",  postings)   # união:       doc1, doc2, doc3
#
# # --- Teste 3: tabela do índice ---
# tabela_indice(postings)
#
# # --- Teste 4: corpus de 8 documentos da Aula 01 ---
# docs_aula01 <- c(
#   d1 = "Recuperacao de Informacao: ORDENA documentos, por relevancia!",
#   d2 = "O modelo de espaco-vetorial representa documentos (como vetores).",
#   d3 = "BM25 e um modelo probabilistico de ranqueamento de texto.",
#   d4 = "Aprendizado estatistico fundamenta a recuperacao moderna.",
#   d5 = "O indice invertido acelera a busca em muitos documentos.",
#   d6 = "Embeddings capturam a semantica de palavras e documentos.",
#   d7 = "A avaliacao mede a relevancia dos resultados da busca.",
#   d8 = "Ciencia de dados combina estatistica e programacao."
# )
# postings_aula01 <- construir_indice_invertido(docs_aula01)
#
# buscar_AND("modelo probabilistico", postings_aula01)  # deve retornar d3
# buscar_OR ("modelo probabilistico", postings_aula01)  # deve retornar d2, d3
#
# head(tabela_indice(postings_aula01), 10)