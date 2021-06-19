use AdventureWorks2019

-- ponto 1
-- executar as seguintes instruções:

select * INTO dbo.SalesOrderDetail FROM Sales.SalesOrderDetail
create index ix on dbo.SalesOrderDetail(orderQty)
Go
SET SHOWPLAN_XML on
GO

-- ponto 2
-- Executar e verificar existência de missing indexes
-- Explicar qual a lógica associada à proposta deste índice
select UnitPrice from dbo.SalesOrderDetail where ProductId=750  --OPTION (QUERYTRACEON 9481)
/*
É sugerido um indice sobre a coluna ProductId com o include do UnitPrice. 
O que faz todo o sentido uma vez que a coluna ProductId é utilizada na clausula where e a coluna selecionada é a UnitPrice
*/

-- ponto 3
SET SHOWPLAN_XML off

-- ponto 4
--Criar os missing index
create index ixProductIdWithUnitPrice on dbo.SalesOrderDetail(ProductId) include (UnitPrice)

-- ponto 5
SET SHOWPLAN_XML on


-- ponto 6
-- voltar a ver o plano de execução para a instrução:
 select UnitPrice from dbo.SalesOrderDetail where ProductId=750  --OPTION (QUERYTRACEON 9481)

SET SHOWPLAN_XML off
GO
--Já é feito um indice seek.


