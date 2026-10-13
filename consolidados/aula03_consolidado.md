# Consolidado — PI III — Aula 03 — 2026-10-13
*guia versão 3 · tutora: Antigravity · sessão individual (teoria) · motor03*  
**Alunos:** Ivan Guimarães dos S. da Silva, Jorge Sugano Suzart e Gustavo Geminiano

## 1. O que foi passado
- **M1 — O texto sujo:** Identificação de falha de casamento por caixa e pontuação (`"documentos,"` vs `"documentos"`); o vocabulário bruto sobe de 45 para 48 termos; a busca booleana crua perde 3 de 4 documentos relevantes.
- **M2 — `limpar`: as duas regex:** Construção do pipeline determinístico em 4 passos: (1) `tolower`, (2) substituição de não-alfanuméricos `[^a-z0-9 ]` por espaço, (3) colapso de espaços múltiplos `\s+` em espaço simples, e (4) `trimws`. Preservação da integridade estrutural e vetorização no corpus. Tratamento de acentos com `iconv(from = "UTF-8", to = "ASCII//TRANSLIT")`.
- **M3 — Stopwords:** Demonstração empírica de distorção de ranking por termos de alta frequência e baixa carga semântica (`"de"` invertia a ordenação relativa entre $d_3$ e $d_4$ no cosseno). Implementação de `sem_stop` via operador `%in%`. Remoção de 8 stopwords presentes no corpus canônico.
- **M4 — Stemming (brinquedo e Snowball):** Comparação entre heurística ingênua de sufixos por regex e o algoritmo canônico Snowball (`wordStem` do pacote `SnowballC` em português). Entendimento do compromisso (*trade-off*) entre *precision* e *recall*, e da dependência de acentuação no Snowball.
- **M5 — Tokenização subword:** Análise das limitações de vocabulário fechado por palavras (OOV — *Out-of-Vocabulary*, perda de relações morfológicas e explosão dimensional). Apresentação das famílias BPE (GPT), WordPiece (BERT) e SentencePiece (T5/Llama).
- **M6 — BPE em três passos:** Simulação passo a passo de indução estatística de subwords: decomposição em caracteres, contagem ponderada de pares adjacentes (vitória de `as` com contagem 12: $5 + 4 + 3$) e fusão iterativa. Emergência estatística do sufixo de plural `-as`.
- **M7 — O Índice Invertido:** Mudança de paradigma computacional: da varredura linear orientada a documentos ($O(N)$) para o acesso direto via dicionário hash e listas de postagens (*postings lists*). Eliminação de 298 zeros esparsos da TDM clássica.
- **M8 — Construindo o índice em R:** Implementação do laço de inversão `termo -> documentos` com listas de postagens dinâmicas. Papel crítico do operador `unique()` na garantia de que a cardinalidade da postagem corresponda estritamente à frequência de documentos ($	ext{df}$).
- **M9 — Buscando pelo índice:** Operação de consulta booleana conjuntiva via `Reduce(intersect, postings[termos])`. Validação das buscas de referência: `"modelo documentos"` $\rightarrow$ `d2` e `"busca documentos"` $\rightarrow$ `d5`. Índice final com 37 termos e tempo de resposta independente do tamanho do acervo.

## 2. Como foi o aprendizado — opinião da tutora
O aluno demonstrou excelente maturidade conceitual e agilidade analítica ao longo de todos os 9 módulos. Compreendeu de imediato a distinção entre a negação dentro dos colchetes `[^a-z0-9 ]` e a âncora de início de cadeia `^`. No módulo de *stopwords*, identificou prontamente por que termos morfológicos derivados como `"dos"` e preposições ausentes da lista como `"em"` sobrevivem ao filtro. No cálculo manual do BPE, deduziu com precisão a contagem ponderada de `as = 12` ($5 + 4 + 3$) somando as frequências documentais em vez de contar ocorrências discretas. No índice invertido, assimilou a inversão matricial e o valor computacional do `unique()` para preservar a integridade do $\text{df}$.

**Teste final:** Acertou 100% das questões (Módulos 1, 2, 3, 4, 5, 6, 7, 8 e 9). Você tem um índice invertido plenamente funcional e compreendido em profundidade.

## 3. Observações para a frente
- **Revisar antes da Aula 04:** A transição de consultas booleanas sem pesos para o modelo probabilístico BM25, onde a lista de postagens passará a conter pares `(doc_id, tf)` para cálculo em tempo de busca.
- **Para a próxima tutora:** Aluno com forte raciocínio lógico-matemático, excelente compreensão de estruturas vetoriais e boa desenvoltura com operações funcionais em R (`Reduce`, `lapply`, `sapply`).
- **Perguntas guardadas:** Ponderação probabilística e normalização por tamanho de documento no índice (atendida na Aula 04: BM25); integração com modelos neurais e *subwords* (atendida na Aula 07: *embeddings*).
- **Produzido:** Índice invertido canônico com 37 termos; buscas `busca_AND("modelo documentos")` $\rightarrow$ `d2` e `busca_AND("busca documentos")` $\rightarrow$ `d5`; simulação de BPE com desempate na 2ª rodada (`pr = 7`).
- **Parte D (sessão de grupo):** A marcar — limpeza, acentuação, stopwords e indexação do corpus real da Baixada Santista (`wikipedia_baixada_santista.csv`) com a ficha do projeto.

<!-- estado-R:inicio -->
<!-- gerado por motor03 v1 2026-10-01 em 2026-10-13 15:05:00 -->
| Objeto | Tipo | Tamanho | Amostra |
|---|---|---|---|
| `docs` | character, nomeado | 8 | d1 recuperacao de informacao ordena..., d2 o modelo de espaco vetorial repre..., d3 bm25 e um modelo probabilistico ..., d4 aprendizado estatistico fundament..., d5 o indice invertido acelera a busc..., d6 embeddings capturam a semantica d..., ... |
| `brutos` | character, nomeado | 8 | d1 Recuperacao de Informacao: ORDEN..., d2 O modelo de espaco-vetorial repre..., d3 BM25 e um modelo probabilistico ..., d4 Aprendizado estatistico fundament..., d5 O indice invertido acelera a busc..., d6 Embeddings capturam a semantica d..., ... |
| `limpos` | character, nomeado | 8 | d1 recuperacao de informacao ordena..., d2 o modelo de espaco vetorial repre..., d3 bm25 e um modelo probabilistico ..., d4 aprendizado estatistico fundament..., d5 o indice invertido acelera a busc..., d6 embeddings capturam a semantica d..., ... |
| `stopwords` | character | 10 | de, o, a, e, um, por, como, que, da, do |
| `postings` | list | 37 | elementos: recuperacao, informacao, ordena, documentos, relevancia, modelo, espaco, vetorial, representa, vetores, bm25, probabilistico, ranqueamento, texto, aprendizado, estatistico, ... |
| `cfg` | list | 0 | elementos: |
| `ix` | list | 8 | elementos: tokens, vocab, tf, N, df, idf_tfidf, w, wn |
<!-- estado-R:fim -->
