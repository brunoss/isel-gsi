
-- ponto 0
use GSI_AP3


create  table t2(x int, a char(1000), y nvarchar(2000), y1 nvarchar(2000), z decimal(6,2))


insert into t2 values(1,'a','b','c',2.8)
insert into t2 values(2,'a','b','c',2.8)
insert into t2 values(3,'a','b','c',2.8)
insert into t2 values(4,'a','b','c',2.8)
insert into t2 values(5,'a','b','c',2.8)
insert into t2 values(6,'a','b','c',2.8)
insert into t2 values(7,'a','b','c',2.8)




DBCC TRACEON (3604);


-- ponto 1
-- anotar estrutura de páginas
DBCC IND ('GSI_AP3', 't2',1)

-- ponto 2
-- ver estrutura dos slots na 1.ª página de dados
DBCC PAGE ('GSI_AP3',1,<página de dados>,3) 



-- ponto 3
update t2 set y = replicate('e' ,2000), y1 = replicate('v' ,2000) where x % 2 = 0


-- ponto 4
-- anotar estrutura de páginas
DBCC IND ('GSI_AP3', 't2',1)

-- ponto 5
-- ver estrutura dos slots na 1.ª página de dados
DBCC PAGE ('GSI_AP3',1,<numero da página>,3) 
-- usar DBCC PAGE para determinar quais as páginas onde se encontram os dados referentes a x = 2
-- apontar ocorrências de row chaining ou row migration



-- ponto 6

alter table t2 rebuild


-- ponto 7
-- anotar estrutura de páginas
DBCC IND ('GSI_AP3', 't2',1)

-- ponto 8
-- ver estrutura dos slots na 1.ª página de dados
DBCC PAGE ('GSI_AP3',1,<numero da página>,3) 
-- usar DBCC PAGE para determinar quais as páginas onde se encontram os dados referentes a x = 2
-- apontar ocorrências de row chaining ou row migration 



-- ponto 9
drop table t2



