# Aula 05 — Teoria: Construção de Coleções de Teste, Pooling e Concordância (Kappa)

**Grupo:** Ivan Guimarães dos S. da Silva · Gustavo Geminiano · Jorge Sugano Suzart  
**Disciplina:** Projeto Integrador III — Motor de Busca (Fatec Baixada Santista)

---

## Síntese Conceitual

1. **Paradigma de Cranfield e Necessidades de Informação:** A avaliação científica de um motor de busca requer três componentes independentes: um corpus fixo de documentos ($N = 132$ parágrafos autônomos), um conjunto de necessidades de informação explícitas (divididas em desenvolvimento `dev` e `teste`, com consulta curta, descrição da necessidade e critério de escopo) e julgamentos humanos de relevância (*qrels*).
2. **Método de *Pooling* (Amostragem por Pool):** Como julgar manualmente todos os pares $\text{consulta} \times \text{documento}$ é inviável em coleções maiores, reúne-se a união dos top-$k$ documentos recuperados por famílias distintas de modelos (Booleano, TF-IDF/Cosseno e BM25), eliminando duplicatas e embaralhando a ordem (`set.seed(42)`) para que o avaliador julgue às cegas, sem conhecer qual modelo recuperou cada documento nem sua posição no ranking.
3. **Relevância Graduada e Concordância Inter-Avaliadores ($\kappa$ de Cohen):** Os julgamentos utilizam três graus (`0` = irrelevante, `1` = parcialmente relevante, `2` = altamente relevante). A consistência entre dois juízes independentes é mensurada pelo coeficiente $\kappa = \frac{P_o - P_e}{1 - P_e}$, que desconta a concordância esperada ao acaso ($P_e$). Documentos fora do conjunto de relevantes julgados recebem grau zero na avaliação fechada.
