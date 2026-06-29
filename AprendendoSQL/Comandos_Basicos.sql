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
-- BLOCO 2.1: ALTERAÇÕES DE ESTRUTURA (DDL - ALTER)
-- =========================================================================
ALTER TABLE DEV ADD COLUMN EMAIL VARCHAR(150) AFTER NOME;
ALTER TABLE PROJETO MODIFY COLUMN NOME_PROJETO VARCHAR(200) NOT NULL; 
ALTER TABLE PROJETO CHANGE COLUMN ORCAMENTO VALOR_ORCAMENTO DECIMAL(10,2) NOT NULL;
ALTER TABLE PROJETO DROP COLUMN TESTE;

-- =========================================================================
-- BLOCO 3: MANIPULAÇÃO E POVOAMENTO DE DADOS (DML)
-- =========================================================================
INSERT INTO DEV(NOME, LINGUAGEM)
VALUES  ("Tiago Silva", "PHP"),
        ("Marcos Santos", "Java"),
        ("Yágo Santos", "C#");
INSERT INTO DEV(NOME)
VALUES  ("Aline Souza");

INSERT INTO PROJETO(NOME_PROJETO, VALOR_ORCAMENTO, ID_DEV)
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


SELECT d.NOME, d.EMAIL, p.NOME_PROJETO
FROM DEV d JOIN PROJETO p 
ON d.ID_DEV = p.ID_DEV;

SELECT d.NOME, d.EMAIL, p.NOME_PROJETO
FROM DEV d LEFT JOIN PROJETO p 
ON d.ID_DEV = p.ID_DEV;

SELECT 
    COUNT(*) AS TOTAL_PEDIDO
FROM DEV;

SELECT 
    SUM(VALOR_ORCAMENTO),
    AVG(VALOR_ORCAMENTO),
    MIN(VALOR_ORCAMENTO),
    MAX(VALOR_ORCAMENTO)
FROM PROJETO;

SELECT ID_DEV ,SUM(VALOR_ORCAMENTO) AS TOTAL_POR_DEV
FROM PROJETO
GROUP BY ID_DEV;

SELECT LINGUAGEM, COUNT(*) AS TOTAL_POR_LINGUAGEM
FROM DEV
GROUP BY LINGUAGEM;

SELECT ID_DEV, NOME_PROJETO, COUNT(*) AS QUANTIDADE_POJETOS
FROM PROJETO
GROUP BY ID_DEV;

SELECT ID_DEV, AVG(VALOR_ORCAMENTO) AS VALOR_MEDIO
FROM PROJETO
GROUP BY ID_DEV;

SELECT 
    MAX(VALOR_ORCAMENTO)
FROM PROJETO;

SELECT ID_DEV, MIN(VALOR_ORCAMENTO)
FROM PROJETO
GROUP BY ID_DEV;   

-- =========================================================================
-- BLOCO 4: PROCEDURES E TRIGGERS 
-- =========================================================================

DELIMITER //
CREATE PROCEDURE BuscarNomeDev (IN p_id_dev INT)
BEGIN
    DECLARE v_nome_dev VARCHAR(100);
    
    SELECT NOME INTO v_nome_dev 
    FROM DEV 
    WHERE ID_DEV = p_id_dev;
    
    SELECT CONCAT("O desenvolvedor selecionado foi: ", v_nome_dev) AS Resultado;
END //
DELIMITER ;
CALL BuscarNomeDev(1);


DELIMITER //
CREATE PROCEDURE VerificaOrcamentoProjeto (IN p_id_projeto INT)
BEGIN 
    DECLARE v_orcamento DECIMAL(10,2);

    SELECT VALOR_ORCAMENTO INTO v_orcamento
    FROM PROJETO
    WHERE ID_PROJETO = p_id_projeto;

    IF v_orcamento > 5000.00 THEN
        SELECT "Este é um projeto de grande porte " AS CLASSIFICACAO;
    ELSE
        SELECT "Este é um projeto de baixo porte" AS CLASSIFICACAO;
    END IF;

END //
DELIMITER;

CALL VerificaOrcamentoProjeto(2);


DELIMITER //
    CREATE PROCEDURE VincularDevProjeto(
        IN p_nome_projeto VARCHAR(200),
        IN p_valor DECIMAL(10,2),
        IN p_id_dev INT
    )
BEGIN   
    DECLARE v_linguagem VARCHAR(200);

    SELECT LINGUAGEM INTO v_linguagem
    FROM DEV 
    WHERE ID_DEV = p_id_dev;

    IF v_linguagem = 'PHP' THEN 
        SELECT 'Bloqueado : Desenvolvedor PHP nao pode assumir novos projetos' AS STATUS_OPERACAO;
    ELSE
        INSERT INTO PROJETO(NOME_PROJETO, VALOR_ORCAMENTO, ID_DEV)
        VALUES  (p_nome_projeto, p_valor, p_id_dev);

        SELECT 'Sucesso : Projeto vinculado com sucesso' AS STATUS_OPERACAO;
    END IF;
END //
DELIMITER;

CALL VincularDevProjeto('Sistema novo', 3000.00, 1);
CALL VincularDevProjeto('Sistema novo', 3000.00, 2);


DELIMITER //
    CREATE PROCEDURE VerificaCompatibilidadeDevs(
        IN id_dev_1 INT,
        IN id_dev_2 INT
    )
BEGIN
    DECLARE v_ling_1 VARCHAR(200);
    DECLARE v_ling_2 VARCHAR(200);

    SELECT LINGUAGEM INTO v_ling_1 
    FROM DEV
    WHERE ID_DEV = id_dev_1; 

    SELECT LINGUAGEM INTO v_ling_2 
    FROM DEV
    WHERE ID_DEV = id_dev_2; 

    IF v_ling_1 = v_ling_2 THEN
        SELECT 'Compativeis : os desenvolvedores trabalham com a mesma linguagem';
    ELSE
        SELECT 'Incompativeis : os desenvolvedores não trabalham com a mesma linguagem';
    END IF;
        
END//
DELIMITER;

CALL VerificaCompatibilidadeDevs(1, 2);