use AdventureWorks2019



/***************************************************************
   Para a realização destes exercícios seleccionar a opção
   Include Actual Execution Plan do Sql Server Management Studio
*/

--ponto 1

-- ponto 1.1
dbcc show_statistics ('Sales.SalesOrderDetail',[SalesOrderDetailID])
-- anotar as estatísticas
/*
RANGE_HI_KEY	RANGE_ROWS	EQ_ROWS	DISTINCT_RANGE_ROWS	AVG_RANGE_ROWS
1	0	1	0	1
9250	9321.676	1	9248	1.007967
23987	14789.13	1	14736	1.003606
35381	11944.86	1	11393	1.048438
42940	7678.439	1	7558	1.015935
46851	4265.306	1	3910	1.090871
50756	3980.878	1	3904	1.019692
54443	3980.878	1	3686	1.079999
62121	7962.867	1	7677	1.037237
63300	1136.6	1	1137	1
67611	4549.733	1	4310	1.055623
74560	6825.155	1	6825	1.000003
77646	2843.167	1	2843	1
81064	2843.167	1	2843	1
84118	2843.167	1	2843	1
86695	2274.311	1	2274	1
88064	1136.6	1	1137	1
90459	2274.311	1	2274	1
93775	2843.167	1	2843	1
106691	12798.14	1	12798	1.00001
110708	4265.306	1	4016	1.062078
121316	10737.15	1	10607	1.01227
121317	0	1	0	1
*/
-- ponto 1.2
dbcc freeproccache
select * from Sales.SalesOrderDetail where SalesOrderDetailId 
                                     BETWEEN 221 and 225   OPTION (QUERYTRACEON 9481)
-- Explicar a razão de ser do nº de linhas estimado para o operador (Select)                                  
/*
São estimadas 5 linhas porque está a ser utilizado uma clausula where sobre a chave primária com valores entre 221 e 225 (5 registos).
*/

-- ponto 2 

-- ponto 2.1    
 
dbcc show_statistics ('Production.Product',Color) 
-- anotar as estatísticas
/*
RANGE_HI_KEY	RANGE_ROWS	EQ_ROWS	DISTINCT_RANGE_ROWS	AVG_RANGE_ROWS
NULL	0	248	0	1
Black	0	93	0	1
Blue	0	26	0	1
Grey	0	1	0	1
Multi	0	8	0	1
Red	0	38	0	1
Silver	0	43	0	1
Silver/Black	0	7	0	1
White	0	4	0	1
Yellow	0	36	0	1
*/
-- ponto 2.2                                
dbcc freeproccache                                                       
select Color,COUNT(ProductId) from Production.Product
GROUP BY Color --OPTION (QUERYTRACEON 9481)
--Explicar a razão de ser do nº de linhas estimado  no operador select
/*
10 registos
Existem 10 entradas diferentes para a Color do produto e por isso o plano de execução estima 10 registos
*/

-- ponto 3 

-- ponto 3.1
dbcc show_statistics ('Person.PersonPhone',IX_PersonPhone_PhoneNumber) 
-- anotar as estatísticas
/*
RANGE_HI_KEY	RANGE_ROWS	EQ_ROWS	DISTINCT_RANGE_ROWS	AVG_RANGE_ROWS
1 (11) 500 555-0110	0	135	0	1
1 (11) 500 555-0111	0	180	0	1
1 (11) 500 555-0112	0	185	0	1
1 (11) 500 555-0113	0	192	0	1
*/

-- ponto 3.2
dbcc freeproccache 
declare @pn nvarchar(25)
set @pn='1 (11) 500 555-0113'
select * from Person.PersonPhone
where PhoneNumber = @pn --OPTION (QUERYTRACEON 9481)
--Explicar a razão de ser do nº de linhas estimado  no operador select
/*
192 Registos
O SGBD estima 2 registos porque a maior parte dos registos tem só 1 ou 2 entradas.
*/

-- ponto 4  
-- ponto 4.1
dbcc show_statistics ('Production.Product',PK_Product_ProductID)
-- anotar estatisticas
/*
RANGE_HI_KEY	RANGE_ROWS	EQ_ROWS	DISTINCT_RANGE_ROWS	AVG_RANGE_ROWS
948	3	1	3	1
952	3	1	3	1
956	3	1	3	1
960	3	1	3	1
964	3	1	3	1
968	3	1	3	1
972	3	1	3	1
976	3	1	3	1
980	3	1	3	1
984	3	1	3	1
988	3	1	3	1
992	3	1	3	1
996	3	1	3	1
998	1	1	1	1
999	0	1	0	1
*/

-- ponto 4.2
dbcc freeproccache
declare @pi1 int, @pi2 int
set @pi1=950
set @pi2=1000
select * from Production.Product
where ProductId > @pi1 and ProductId < @pi2  --OPTION (QUERYTRACEON 9481)
--Explicar a razão de ser do nº de linhas estimado no operador select
/*
49 registos
Nº de registos = 504
30% x SQRT(30) * Nº de registos = 82,815
*/

-- ponto 5 
--  explicar possível diferença entre nº de linhas estimado e o nº de linhas actual
--  observados no opedador clustered index scan, nos seguintes 3 casos:


--5.5.1
dbcc freeproccache
Select * from Production.Product 
WHERE ReorderPoint = 375 AND Color ='Black'  --OPTION (QUERYTRACEON 9481)
/*
45 registos

select Count(*) from Production.Product 
Total = 504

select Count(*) from Production.Product 
where Color ='Black'
NBlack = 93

select Count(*) from Production.Product 
where ReorderPoint = 375
NReorder = 167

Valor Estimado = SQRT(NReorder/Total) * NBlack/Total * Total
= SQRT(167/504) * 93/504 * 504 = 53.53353

*/
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
/*
45 registos

select Count(*) from Production.Product 
where color is not null
Total = 256

select Count(*) from Production.Product 
where Color ='Black'
NBlack = 93

select Count(*) from Production.Product 
where ReorderPoint = 375 and Color is not null
NReorder = 113

Valor Estimado = NReorder/Total * NBlack/Total * Total
= 93/256 * 113/256 * 256 = 41.0507

Estima = 41.05
*/
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
/*
As estatisticas foram criadas somente para a cor preta e pode ser usado o valor direto da tabela.

RANGE_HI_KEY	RANGE_ROWS	EQ_ROWS	DISTINCT_RANGE_ROWS	AVG_RANGE_ROWS
3	0	17	0	1
75	0	30	0	1
375	0	45	0	1
750	0	1	0	1
*/