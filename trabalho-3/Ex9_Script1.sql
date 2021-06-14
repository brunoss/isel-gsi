-- ponto 0
use GSI_AP3


create  table t2(x int primary key, a char(1000), y nvarchar(2000), y1 nvarchar(2000), z decimal(6,2))


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
-- anotar percentagem de fragmentação
SELECT alloc_unit_type_desc,index_depth,avg_fragmentation_in_percent
FROM sys.dm_db_index_physical_stats(DB_ID(N'GSI_AP3'),OBJECT_ID(N'T2'),
                                    DEFAULT,DEFAULT,'DETAILED')
WHERE index_level = 0;

-- ou:
DBCC SHOWCONTIG ('t2')


-- ponto 4
update t2 set y = replicate('e' ,2000), y1 = replicate('v' ,2000) where x % 2 = 0


-- ponto 5
-- anotar estrutura de páginas
DBCC IND ('GSI_AP3', 't2',1)

-- ponto 6
-- ver estrutura dos slots na 1.ª página de dados
DBCC PAGE ('GSI_AP3',1,<numero da página>,3) 
-- usar DBCC PAGE para determinar quais as páginas onde se encontram os dados referentes a x = 2
-- apontar ocorrências de row chaining ou row migration



-- ponto 7
-- anotar percentagem de fragmentação
-- comparar com ponto 3, indicando consequências para o desempenho
SELECT alloc_unit_type_desc,index_depth,avg_fragmentation_in_percent
FROM sys.dm_db_index_physical_stats(DB_ID(N'GSI_AP3'),OBJECT_ID(N'T2'),
                                    DEFAULT,DEFAULT,'DETAILED')
WHERE index_level = 0;

-- ou:
DBCC SHOWCONTIG ('t2')

-- ponto 8

alter table t2 rebuild


-- ponto 9
-- anotar estrutura de páginas
DBCC IND ('GSI_AP3', 't2',1)

-- ponto 10
-- ver estrutura dos slots na 1.ª página de dados
DBCC PAGE ('GSI_AP3',1,<n.º da página>,3) 
-- usar DBCC PAGE para determinar quais as páginas onde se encontram os dados referentes a x = 2
-- apontar ocorrências de row chaining ou row migration 



-- ponto 11
-- anotar percentagem de fragmentação
-- comparar com pontos 7 e 3, indicando consequências para o desempenho
SELECT alloc_unit_type_desc,index_depth,avg_fragmentation_in_percent
FROM sys.dm_db_index_physical_stats(DB_ID(N'GSI_AP3'),OBJECT_ID(N'T2'),
                                    DEFAULT,DEFAULT,'DETAILED')
WHERE index_level = 0;

-- ou:
DBCC SHOWCONTIG ('t2')


-- ponto 12
drop table t2
create table t2(x int primary key, a char(1000), y nvarchar(2000), y1 nvarchar(2000), z decimal(6,2))

set nocount on
declare @n int = 1
while @n <= 1000
begin
   insert into t2 values(@n,'a','b','c',2.8)
   set @n = @n+1
end

-- ponto 13
-- anotar estrutura de páginas
DBCC IND ('GSI_AP3', 't2',1)

-- ponto 14
-- ver estrutura dos slots na 1.ª página de dados
DBCC PAGE ('GSI_AP3',1,<página de dados>,3) 


-- ponto 15
-- anotar percentagem de fragmentação
SELECT alloc_unit_type_desc,index_depth,avg_fragmentation_in_percent
FROM sys.dm_db_index_physical_stats(DB_ID(N'GSI_AP3'),OBJECT_ID(N'T2'),
                                    DEFAULT,DEFAULT,'DETAILED')
WHERE index_level = 0;

-- ou:
DBCC SHOWCONTIG ('t2')


-- ponto 16
update t2 set y = replicate('e' ,2000), y1 = replicate('v' ,2000) where x % 2 = 0


-- ponto 17
-- anotar estrutura de páginas
DBCC IND ('GSI_AP3', 't2',1)

-- ponto1 8
-- ver estrutura dos slots na 1.ª página de dados
DBCC PAGE ('GSI_AP3',1,<numero da página>,3) 


-- ponto 19
-- anotar percentagem de fragmentação
SELECT alloc_unit_type_desc,index_depth,avg_fragmentation_in_percent
FROM sys.dm_db_index_physical_stats(DB_ID(N'GSI_AP3'),OBJECT_ID(N'T2'),
                                    DEFAULT,DEFAULT,'DETAILED')
WHERE index_level = 0;

-- ou:
DBCC SHOWCONTIG ('t2')

-- ponto 20

alter table t2 rebuild




-- ponto 21
-- anotar estrutura de páginas
DBCC IND ('GSI_AP3', 't2',1)

-- ponto 22
-- ver estrutura dos slots na 1.ª página de dados
DBCC PAGE ('GSI_AP3',1,<página de dados>,3) 



-- ponto 23
-- anotar percentagem de fragmentação
-- comparar com o observado no ponto 11
SELECT alloc_unit_type_desc,index_depth,avg_fragmentation_in_percent
FROM sys.dm_db_index_physical_stats(DB_ID(N'GSI_AP3'),OBJECT_ID(N'T2'),
                                    DEFAULT,DEFAULT,'DETAILED')
WHERE index_level = 0;

-- ou:
DBCC SHOWCONTIG ('t2')


-- ponto 24
drop table t2


--(ver informação sobre em )
-- para mais informaçã, ver: https://docs.microsoft.com/en-us/sql/relational-databases/system-dynamic-management-views/sys-dm-db-index-physical-stats-transact-sql?view=sql-server-ver15 e
                  https://docs.microsoft.com/en-us/sql/t-sql/database-console-commands/dbcc-showcontig-transact-sql?view=sql-server-ver15


