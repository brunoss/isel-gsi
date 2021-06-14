use AdventureWorks2019



/***************************************************************
   Para a realiza��o destes exerc�cios seleccionar a op��o
   Include Actual Execution Plan do Sql Server Management Studio
*/

--ponto 1

-- ponto 1.1
dbcc show_statistics ('Sales.SalesOrderDetail',SalesOrderDetailId)
-- anotar as estat�sticas

-- ponto 1.2
dbcc freeproccache
select * from Sales.SalesOrderDetail where SalesOrderDetailId 
                                     BETWEEN 221 and 225   --OPTION (QUERYTRACEON 9481)
-- Explicar a raz�o de ser do n� de linhas estimado para o operador (Select)                                  



-- ponto 2 

-- ponto 2.1    
 
dbcc show_statistics ('Production.Product',Color) 
-- anotar as estat�sticas

-- ponto 2.2                                
dbcc freeproccache                                                       
select Color,COUNT(ProductId) from Production.Product
GROUP BY Color --OPTION (QUERYTRACEON 9481)
--Explicar a raz�o de ser do n� de linhas estimado  no operador select


  


-- ponto 3 

-- ponto 3.1
dbcc show_statistics ('Person.PersonPhone',IX_PersonPhone_PhoneNumber) 
-- anotar as estat�sticas

-- ponto 3.2
dbcc freeproccache 
declare @pn nvarchar(25)
set @pn='1 (11) 500 555-0113'
select * from Person.PersonPhone
where PhoneNumber = @pn --OPTION (QUERYTRACEON 9481)
--Explicar a raz�o de ser do n� de linhas estimado  no operador select


-- ponto 4  
-- ponto 4.1
dbcc show_statistics ('Production.Product',PK_Product_ProductID)
-- anotar estatisticas

-- ponto 4.2
dbcc freeproccache
declare @pi1 int, @pi2 int
set @pi1=950
set @pi2=1000
select * from Production.Product
where ProductId > @pi1 and ProductId < @pi2  --OPTION (QUERYTRACEON 9481)
--Explicar a raz�o de ser do n� de linhas estimado no operador select


-- ponto 5 
--  explicar poss�vel diferen�a entre n� de linhas estimado e o n� de linhas actual
--  observados no opedador clustered index scan, nos seguintes 3 casos:


--5.5.1
dbcc freeproccache
Select * from Production.Product 
WHERE ReorderPoint = 375 AND Color ='Black'  --OPTION (QUERYTRACEON 9481)

--5.5.2
dbcc show_statistics ('Production.Product',Color)
dbcc show_statistics ('Production.Product',ReorderPoint)


--5.5.3
--drop statistics Production.Product.S
create statistics S on Production.Product(ReorderPoint)
WHERE Color is not null

dbcc show_statistics ('Production.Product',S)


dbcc freeproccache
Select * from Production.Product 
WHERE ReorderPoint = 375 AND Color ='Black'  -- OPTION (QUERYTRACEON 9481)




-- Select Color,count(*) from Production.Product WHERE ReorderPoint = 375 group by color
-- Select color,reorderpoint, count(*) from Production.Product group by color, reorderpoint


--5.5.4
drop statistics Production.Product.S
create statistics S on Production.Product(ReorderPoint)
WHERE Color = 'Black'

dbcc show_statistics ('Production.Product',S)

dbcc freeproccache

Select * from Production.Product 
WHERE ReorderPoint = 375 AND Color ='Black'  -- OPTION (QUERYTRACEON 9481)

drop statistics Production.Product.S
