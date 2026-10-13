# Consolidado — PI III — Aula 03 — Parte D — 2026-10-13
*guia versão 3 · tutora: Antigravity · sessão de grupo · motor03*  
**Alunos:** Ivan Guimarães dos S. da Silva, Jorge Sugano Suzart e Gustavo Geminiano  
**Grupo:** ivan_gustavo_jorge · **presentes:** Ivan, Jorge e Gustavo · **digitou:** M10: Ivan; M11: Jorge; M12: Gustavo

## 1. O que foi feito
- **M10 — Corpus limpo e decisão dos acentos:** Aplicação de `limpar()` no corpus de 132 documentos do projeto. O grupo decidiu por `cfg$acentos = "translit"` (via `iconv(..., "ASCII//TRANSLIT")`), pois `"manter"` partiria vocábulos vitais da toponímia regional (como `"Guarujá"` $\rightarrow$ `"guaruj"` e `"são"` $\rightarrow$ `"s o"`). Verificado $0$ documentos com falha de conversão.
- **M11 — Stopwords do projeto decididas a partir dos dados:** Inspeção da distribuição de frequências no corpus. Foram selecionadas 27 palavras funcionais gramaticais (`de`, `a`, `o`, `em`, `e`, `do`, `da`, `que`, etc.). O grupo manteve conscientemente termos de alta frequência e alta relevância informacional (`santos`, `porto`, `cidade`, `sao`, `praias`, `turismo`). O vocabulário encolheu de 4250 termos brutos para **3483 termos limpos**.
- **M12 — Índice invertido e buscas conjuntivas AND:** Construção da estrutura `postings` contendo 3483 entradas. Implementação de `busca_AND()` baseada em `Reduce(intersect)`. Homologação de duas buscas:
  - Consulta $1$ (`"porto santos"`): Interseção não-vazia retornando **21 documentos** (`d9, d25, d27, d28, d30, d36, d39, d41, d45, d49, d50, d51, d75, d76, d77, d78, d85, d95, d99, d124, d130`), cobrindo majoritariamente Santos ($15$), Guarujá ($4$) e Bertioga ($2$).
  - Consulta $2$ (`"cafe tupinambas"`): Interseção disjunta retornando `character(0)` ($8$ documentos de Santos sobre café cruzados com $2$ de Bertioga sobre tupinambás resultam em conjunto vazio).

## 2. Como o grupo trabalhou — opinião da tutora
O grupo trabalhou com excelente sinergia, alternando os digitadores a cada módulo conforme previsto pelo guia metodológico. A decisão entre `"manter"` e `"translit"` foi tomada com clareza técnica imediata ao observar o efeito destrutivo da negação regex sobre letras acentuadas da Baixada Santista. Na definição das stopwords, Jorge conduziu a análise das contagens e o grupo recusou unanimemente descartar palavras frequentes de domínio como `"porto"` e `"santos"`. Gustavo implementou a indexação invertida no M12 e validou com precisão a lógica de interseção conjuntiva, explicando corretamente o caso disjunto pela separação temática dos artigos de origem. O arquivo `config.R` foi atualizado e sincronizado sem erros de sintaxe.

## 3. Observações para a frente
- **Para a próxima sessão prática (Aula 04):** O `motor04` lerá o `config.R` de forma automatizada e refará a preparação textual e o índice invertido. O grupo implementará o ranqueamento probabilístico BM25 com saturação de frequência e penalização de comprimento.
- **Perguntas guardadas:** Ponderação TF-IDF e BM25 dentro do índice invertido (Aula 04); expansão de sinônimos via modelos de representação densa (Aula 07).
- **Produzido:** Ficha técnica atualizada com índice de 3483 termos, `config.R` configurado, e buscas AND homologadas.
- **Ficha atualizada:** Sim — seções 4, 5, 6, 7 e cabeçalho devidamente atualizados.

<!-- estado-R:inicio -->
<!-- gerado por motor03 v1 2026-10-01 em 2026-10-13 15:12:00 -->
| Objeto | Tipo | Tamanho | Amostra |
|---|---|---|---|
| `docs` | character, nomeado | 132 | d1 Guarujá é um município..., d2 Atualmente a cidade de Guarujá..., ... |
| `origem` | character, nomeado | 132 | d1 Guaruja, d2 Guaruja, ..., d76 Santos, ..., d117 Bertioga |
| `cfg` | list | 5 | elementos: minimo, grupo, limpar, acentos, stopwords |
| `tokens_g` | list | 132 | d1 municipio brasileiro estado..., d2 atualmente cidade guaruja..., ... |
| `postings` | list | 3483 | elementos: santos, sao, cidade, como, tambem, paulo, maior, entre, ilha, sua, porto, praias, turismo, ... |
| `ix` | list | 9 | elementos: tokens, vocab, tf, N, df, idf_tfidf, w, wn, postings |
<!-- estado-R:fim -->
