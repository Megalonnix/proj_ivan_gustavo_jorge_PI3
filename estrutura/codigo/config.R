# config.R - Configuracoes do Motor de Busca do Grupo
# Projeto Integrador III - Baixada Santista
# Alunos: Ivan Guimaraes dos S. da Silva, Jorge Sugano Suzart e Gustavo Geminiano

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
  rocchio   = c(a = 1, b = 0.75, g = 0.15)  # pesos canonicos do Rocchio
)
