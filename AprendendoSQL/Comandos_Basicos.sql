-- =========================================================================
-- BLOCO 1: ESTRUTURAÇÃO DO AMBIENTE (DDL)
-- =========================================================================
CREATE DATABASE IF NOT EXISTS APRENDENDO_SQL;
USE APRENDENDO_SQL;

-- =========================================================================
-- BLOCO 2: CRIAÇÃO DE TABELAS E INTEGRIDADE (DDL)
-- =========================================================================
CREATE TABLE DEV(
    ID_DEV INT AUTO_INCREMENT,
    NOME VARCHAR(100) NOT NULL,
    LINGUAGEM VARCHAR(50) DEFAULT "JavaScript", 
    PRIMARY KEY(ID_DEV)
);

CREATE TABLE PROJETO(
    ID_PROJETO INT AUTO_INCREMENT,
    NOME_PROJETO VARCHAR(100) NOT NULL,
    ORCAMENTO DECIMAL(8,2) NOT NULL,
    ID_DEV INT NOT NULL,
    PRIMARY KEY(ID_PROJETO),
    FOREIGN KEY(ID_DEV) REFERENCES DEV(ID_DEV) ON UPDATE RESTRICT ON DELETE RESTRICT
);

SHOW TABLES;
DESC DEV;
DESC PROJETO;

-- =========================================================================
-- BLOCO 3: MANIPULAÇÃO E POVOAMENTO DE DADOS (DML)
-- =========================================================================
INSERT INTO DEV(NOME, LINGUAGEM)
VALUES  ("Tiago Silva", "PHP"),
        ("Marcos Santos", "Java");
        ("Yágo Santos", "C#");
INSERT INTO DEV(NOME)
VALUES  ("Aline Souza");

INSERT INTO PROJETO(NOME_PROJETO, ORCAMENTO, ID_DEV)
VALUES  ("Sistemas E-commerce", 1500.00, 1),
        ("App Mobile", 8500.00, 2);


-- =========================================================================
-- BLOCO 4: CONSULTAS, FILTROS E JUNÇÕES (DQL)
-- =========================================================================
SELECT *FROM DEV;
SELECT *FROM PROJETO;

SELECT *FROM DEV WHERE NOME LIKE "%a";
SELECT *FROM DEV WHERE NOME LIKE "T%";
SELECT *FROM DEV WHERE NOME LIKE "%n%";
SELECT * FROM DEV WHERE NOME LIKE "Y_go Santos";

SELECT *FROM PROJETO WHERE ORCAMENTO BETWEEN 1000 AND 2000;
SELECT *FROM PROJETO WHERE ORCAMENTO NOT BETWEEN 1000 AND 2000;

SELECT *FROM DEV WHERE LINGUAGEM = "Java"; 

SELECT *FROM PROJETO WHERE ORCAMENTO IN (8500);
SELECT *FROM PROJETO WHERE ORCAMENTO IN (10000);

SELECT *FROM DEV WHERE LINGUAGEM IS NOT NULL;

SELECT *FROM DEV WHERE (LINGUAGEM = "Java" OR LINGUAGEM = "PHP") AND NOME LIKE "%a";