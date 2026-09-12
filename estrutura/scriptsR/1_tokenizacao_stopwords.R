# ============================================================
# 1_tokenizacao_stopwords.R
# Tokenização + Remoção de Stopwords + Stemming
#
# Duas famílias de funções:
#   - remove_stopwords(): DIDÁTICA — tokeniza + remove stopwords PT.
#                         Sem stemming. Usada em demos / notebooks.
#   - processar_texto():  PRODUÇÃO — tokeniza + stopwords PT + stemming.
#                         Usada pelos módulos 2, 3 e 4.
#
# Parâmetro unificado: aplicar_stopwords = TRUE (TRUE = aplica).
# Stopwords: apenas PT (fonte snowball).
# ============================================================

if (!require(pacman)) install.packages("pacman")
pacman::p_load(stopwords, SnowballC)

# --- Núcleo compartilhado -----------------------------------

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

# --- Versão DIDÁTICA (sem stemming) -------------------------

remove_stopwords <- function(txt, aplicar_stopwords = TRUE) {
  tokens <- tokenize_txt(remove_punctuation(txt))
  if (aplicar_stopwords) {
    sw_pt  <- stopwords::stopwords(language = "pt", source = "snowball")
    tokens <- tokens[!tokens %in% sw_pt]
  }
  return(tokens)
}

# --- Versão de PRODUÇÃO (com stemming PT) -------------------

processar_texto <- function(txt, aplicar_stopwords = TRUE) {
  tokens <- tokenize_txt(remove_punctuation(txt))
  if (aplicar_stopwords) {
    sw_pt  <- stopwords::stopwords(language = "pt", source = "snowball")
    tokens <- tokens[!tokens %in% sw_pt]
  }
  tokens <- wordStem(tokens, language = "portuguese")
  return(tokens)
}

# ============================================================
# TESTES — descomente para rodar
# ============================================================
#
# # --- Teste 1: tokenização crua ---
# tokenize_txt("O gato pulou na mesa")
# # Deve retornar 5 tokens. Note que "mesa" já vem sem ponto.
#
# # --- Teste 2: remove_stopwords (versão DIDÁTICA) ---
# remove_stopwords("O gato pulou na mesa", aplicar_stopwords = FALSE)
# # Retorna TODOS os tokens (sem remoção).
#
# remove_stopwords("O gato pulou na mesa", aplicar_stopwords = TRUE)
# # Remove "o" e "na" (stopwords PT). Devem sobrar ~3 tokens.
#
# # --- Teste 3: processar_texto (versão PRODUÇÃO, com stemming) ---
# processar_texto("Os gatos estão comendo peixes na mesa",
#                 aplicar_stopwords = TRUE)
# # "gatos"  -> "gat"   (stemming)
# # "peixes" -> "peix"  (stemming)
# # "mesa"   -> "mes"   (stemming agressivo do PT)
# # "os", "estão", "na" removidas como stopwords.
#
# # --- Teste 4: contraste lado a lado ---
# remove_stopwords("documentos ranqueamento relevancia", TRUE)
# # ["documentos", "ranqueamento", "relevancia"]  (palavras inteiras)
#
# processar_texto("documentos ranqueamento relevancia", TRUE)
# # ["document", "ranqueament", "relev"]           (radicais)