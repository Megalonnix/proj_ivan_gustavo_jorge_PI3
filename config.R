# config.R - Configuracoes do Motor de Busca do Grupo
# Projeto Integrador III - Baixada Santista
# Alunos: Ivan Guimaraes dos S. da Silva (RA 0051352421038)
#         Gustavo Geminiano (RA 0051352511009)
#         Jorge Sugano Suzart (RA 0051352511005)

cfg <- list(
  minimo    = 200,
  grupo     = "ivan_gustavo_jorge",
  limpar    = TRUE,
  acentos   = "translit",
  stopwords = c(
    "de", "a", "o", "em", "e", "do", "da", "que", "dos", "no",
    "um", "uma", "com", "na", "por", "para", "as", "os", "ao",
    "se", "das", "pelo", "pela", "mais", "foi", "nos", "nas"
  ),
  k1        = 1.2,
  b         = 0.75,
  juizes    = c("jorge"),
  limiar    = 2,
  # --- Aula 06: realimentacao ---------------------------------------------
  prf_k     = 0,                            # 0 = sem pseudo-realimentacao; k = usa os top-k
  rocchio   = c(a = 1, b = 0.75, g = 0.15), # pesos canonicos do Rocchio
  # --- Aula 07: LSA e hibrido RRF -----------------------------------------
  modelo    = "bm25",                       # "bm25", "lsa" ou "hibrido"
  lsa_k     = 20,                           # dimensoes latentes da SVD truncada
  rrf_c     = 60                            # constante da Reciprocal Rank Fusion
)
