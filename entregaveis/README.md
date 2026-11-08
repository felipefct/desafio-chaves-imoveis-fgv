# Projeto Prático – Administração de Banco de Dados

**Instituição:** Fundação Getulio Vargas (FGV) – Instituto Tecnológico do Rio de Janeiro  
**Disciplina:** Administração de Banco de Dados  
**Aluno:** Felipe Faria de Carvalho Tavares  
**Repositório:** [desafio-chaves-imoveis-fgv](https://github.com/felipefct/desafio-chaves-imoveis-fgv)

---

## 📌 Sobre o Projeto

Este repositório contém a resolução da **Prática Avaliada 1** da disciplina de Administração de Banco de Dados. O objetivo principal é a modelagem, população, controle de acesso e consulta operacional de um banco de dados relacional voltado para a gestão de uma imobiliária fictícia denominada **"Chaves Imóveis"**, utilizando o SGBD **PostgreSQL 18**.

---

## 🛠️ Tecnologias e Ferramentas

* **SGBD:** PostgreSQL 18
* **Interface/IDE:** Visual Studio Code
* **Linguagem de Consulta:** SQL (DDL, DML, DCL e TCL)
* **Ambiente:** macOS

---

## 📂 Estrutura do Repositório

```text
Projeto_BancoDeDados/
├── scripts_iniciais/
│   ├── ChavesImoveis.sql               # DDL: Criação do schema (oper_chaves_imoveis) e das 15 tabelas
│   └── CarregadadosChavesImoveis.sql   # DML: Carga de dados iniciais de teste nas tabelas
├── entregaveis/
│   ├── pratica_avaliada.sql            # Script consolidado com os requisitos da avaliação (DCL, DML e TCL)
│   └── resultados.txt                  # Relatório de saída gerado via psql com o resultado das consultas
└── README.md                           # Documentação e instrução de execução do projeto