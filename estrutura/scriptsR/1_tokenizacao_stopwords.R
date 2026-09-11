# ============================================================
# 1_tokenizacao_stopwords.R
# Tokenização + Remoção de Stopwords + Stemming
# ============================================================

if (!require(pacman)) install.packages("pacman")
pacman::p_load(stopwords, SnowballC)

remove_punctuation <- function(txt) {
  txt <- tolower(txt)
  txt <- gsub("[[:punct:]]", "", txt)
  return(txt)
}

tokenize_txt <- function(txt) {
  words <- unlist(strsplit(txt, "\\s+"))
  words <- words[words != ""]
  return(words)
}

remove_stopwords <- function(txt, desligado = FALSE) {
  tokens <- tokenize_txt(remove_punctuation(txt))
  
  sw_en  <- stopwords::stopwords(language = "en", source = "snowball")
  sw_pt  <- stopwords::stopwords(language = "pt", source = "snowball")
  sw_all <- unique(c(sw_en, sw_pt))
  
  if (!desligado) {
    return(tokens[!tokens %in% sw_all])
  }
  return(tokens)
}

processar_texto <- function(txt) {
  txt    <- tolower(txt)
  txt    <- gsub("[[:punct:]]", "", txt)
  tokens <- unlist(strsplit(txt, "\\s+"))
  tokens <- tokens[tokens != ""]
  
  sw_pt  <- stopwords::stopwords("pt", "snowball")
  tokens <- tokens[!tokens %in% sw_pt]
  
  tokens <- wordStem(tokens, language = "portuguese")
  return(tokens)
}