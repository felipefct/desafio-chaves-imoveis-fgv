-- Aluno: Felipe Faria de Carvalho Tavares
-- Prática Avaliada 1 – Administração de Banco de Dados

-- Define o schema correto para a execução dos comandos
SET search_path = oper_chaves_imoveis;

/* =========================================================================
   1. CRIAÇÃO DE USUÁRIOS E ROLES (20 pontos)
   ========================================================================= */

-- Remove roles antigas para evitar erros de existência
DROP ROLE IF EXISTS corretor, gerente;

-- Cria um usuário chamado corretor com senha
CREATE USER corretor WITH PASSWORD 'senhaSegura123';

-- Cria uma role chamada gerente sem login
CREATE ROLE gerente NOLOGIN;

-- Conceda à role gerente permissão total (DDL e DML) sobre todas as tabelas do banco
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA oper_chaves_imoveis TO gerente;

-- Adicione o usuário corretor à role gerente
GRANT gerente TO corretor;


/* =========================================================================
   2. CONSULTAS SQL (40 pontos)
   ========================================================================= */

-- a) Liste todos os imóveis disponíveis, mostrando endereço, valor e nome do proprietário.
SELECT 
    c.NmLogradouro || ', ' || e.EndNumero AS Endereco,
    i.ImovelValor,
    cli.ClientePrimNome || ' ' || cli.CliUltimoNome AS NomeProprietario
FROM Imovel i
JOIN Endereco e ON i.EndID = e.EndID
JOIN CEP c ON e.CEP = c.CEP
JOIN CliPropriedade cp ON i.ImovelID = cp.ImovelID
JOIN Cliente cli ON cp.ClienteCPF = cli.ClienteCPF
WHERE i.ImovelVazio = TRUE;

-- b) Mostre o nome dos corretores que não realizaram nenhuma venda.
SELECT 
    f.FuncPrimNome || ' ' || f.FuncUltimoNome AS NomeCorretor
FROM Corretor c
JOIN Funcionario f ON c.FuncCPF = f.FuncCPF
LEFT JOIN TransVenda tv ON c.FuncCPF = tv.FuncCPF
WHERE tv.TransVendaID IS NULL;

-- c) Exiba o total de imóveis vendidos por cada corretor, ordenando do maior para o menor.
SELECT 
    f.FuncPrimNome || ' ' || f.FuncUltimoNome AS NomeCorretor,
    COUNT(it.ImovelID) AS TotalImoveisVendidos
FROM Corretor c
JOIN Funcionario f ON c.FuncCPF = f.FuncCPF
JOIN TransVenda tv ON c.FuncCPF = tv.FuncCPF
JOIN ImovelTransacao it ON tv.TransVendaID = it.TransVendaID
GROUP BY f.FuncPrimNome, f.FuncUltimoNome
ORDER BY TotalImoveisVendidos DESC;

-- d) Liste os clientes que negociaram (alugaram/compraram) imóveis mais de uma vez.
SELECT 
    c.ClientePrimNome || ' ' || c.CliUltimoNome AS NomeCliente,
    COUNT(cc.TransVendaID) AS QuantidadeNegocios
FROM Cliente c
JOIN ClienteCompra cc ON c.ClienteCPF = cc.ClienteCPF
GROUP BY c.ClientePrimNome, c.CliUltimoNome
HAVING COUNT(cc.TransVendaID) > 1;


/* =========================================================================
   3. MANIPULAÇÃO DE DADOS (20 pontos)
   ========================================================================= */

BEGIN;

-- Limpeza preventiva de registros de testes anteriores (garante reexecução perfeita)
DELETE FROM CliPropriedade WHERE ImovelID = 'IM9999';
DELETE FROM Imovel WHERE ImovelID = 'IM9999';
DELETE FROM Endereco WHERE EndID = 'EN9999';

-- a) Insira um novo imóvel para aluguel, associando a um proprietário já existente.
INSERT INTO Endereco (EndID, EndNumero, EndComplemento, EndBairro, CEP, RegiaoID) 
VALUES ('EN9999', 10, 'Sala 2', 'Centro', '13010-001', 'RE0001');

INSERT INTO Imovel (ImovelID, ImovelTipo, ImovelQtdQuartos, ImovelQtdBanheiros, ImovelQtdGaragem, ImovelM2, ImovelValor, ImovelVazio, RegiaoID, EndID) 
VALUES ('IM9999', 'Apartamento', 2, 1, 1, 55, 1800.00, TRUE, 'RE0001', 'EN9999');

INSERT INTO CliPropriedade (ImovelID, ClienteCPF) 
VALUES ('IM9999', '10293847566');

-- b) Atualize o valor do aluguel/venda de todos os imóveis localizados no bairro 'Centro', aumentando em 10%.
UPDATE Imovel
SET ImovelValor = ImovelValor * 1.10
WHERE EndID IN (
    SELECT EndID 
    FROM Endereco 
    WHERE EndBairro = 'Centro'
);

-- c) Remova todos os registros de transações com data anterior a 2020.
DELETE FROM ImovelTransacao 
WHERE TransVendaID IN (SELECT TransVendaID FROM TransVenda WHERE TransVendaData < '2020-01-01');

DELETE FROM ClienteCompra 
WHERE TransVendaID IN (SELECT TransVendaID FROM TransVenda WHERE TransVendaData < '2020-01-01');

DELETE FROM ClienteVende 
WHERE TransVendaID IN (SELECT TransVendaID FROM TransVenda WHERE TransVendaData < '2020-01-01');

DELETE FROM TransVenda 
WHERE TransVendaData < '2020-01-01';

COMMIT;


/* =========================================================================
   4. SEGURANÇA E PERMISSÕES (20 pontos)
   ========================================================================= */

-- Revogue da role gerente a permissão de remover (DELETE) registros das tabelas.
REVOKE DELETE ON ALL TABLES IN SCHEMA oper_chaves_imoveis FROM gerente;

-- Conceda ao usuário corretor permissão apenas de leitura (SELECT) sobre a tabela de clientes.
GRANT SELECT ON Cliente TO corretor;