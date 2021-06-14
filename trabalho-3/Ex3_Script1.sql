use AdventureWorks2019

-- ponto 1
-- executar as seguintes instru��es:

select * INTO dbo.SalesOrderDetail FROM Sales.SalesOrderDetail
create index ix on dbo.SalesOrderDetail(orderQty)
Go
SET SHOWPLAN_XML on
GO

-- ponto 2
-- Executar e verificar exist�ncia de missing indexes
-- Explicar qual a l�gica associada � proposta deste �ndice
select UnitPrice from dbo.SalesOrderDetail where ProductId=750  --OPTION (QUERYTRACEON 9481)


-- ponto 3
SET SHOWPLAN_XML off

-- ponto 4
--Criar os missing index

-- ponto 5
SET SHOWPLAN_XML on


-- ponto 6
-- voltar a ver o plano de execu��o para a instru��o:
 select UnitPrice from dbo.SalesOrderDetail where ProductId=750  --OPTION (QUERYTRACEON 9481)

SET SHOWPLAN_XML off
GO



