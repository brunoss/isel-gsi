ALTER DATABASE gsi_ap1 SET MIXED_PAGE_ALLOCATION ON;

use gsi_ap1

if exists (select object_id from sys.tables where name = 't')
   drop table t
create table t (i int, j char(8000))
GO

insert into t values(1,replicate('A', 8000))

DBCC IND ('GSI_AP1','t', -1)
--1	307	NULL	NULL	677577452	0	1	72057594043432960	In-row data	10	NULL	0	0	0	0 -> IAM
--1	306	1 (Dados)

-- ponto 1
-- ver estrutura do heap 



DBCC EXTENTINFO('GSI_AP1', 't')
-- pode aparecer um valor de pg_alloc = 9, o que significa um extent totalmente atribuído à
-- tabela e que a atribuição se inicia logo com uniform extents (não são usados mixed extents para as primeiras 8 páginas
-- (pode acontecer, por exemplo, a seguir a um rebuild ou com MIXED_PAGE_ALLOCATION OFF). No máximo, ocorre 1 vez

-- page_id 306 - mesma página de dados. pg_alloc = 1

-- ponto 2
-- Comparar com resultado do ponto 1



insert into t values(2,replicate('A', 8000))
insert into t values(3,replicate('A', 8000))
insert into t values(4,replicate('A', 8000))
insert into t values(5,replicate('A', 8000))
insert into t values(6,replicate('A', 8000))
insert into t values(7,replicate('A', 8000))
insert into t values(8,replicate('A', 8000))
alter table t rebuild;
--insert into t values(9,replicate('A', 8000))
--insert into t values(10,replicate('A', 8000))


DBCC IND ('GSI_AP1','t',-1)
-- ponto 3 -- comparar com ponto 1
-- O PageID muda


DBCC EXTENTINFO('GSI_AP1', 't')
-- pode aparecer um valor de pg_alloc = 9, o que significa um extent totalmente atribuído à
-- tabela e que a atribuição se inicia logo com uniform extents (não são usados mixed extents para as primeiras 8 páginas

-- ponto 4
-- Comparar com resultado dos ponto 2 e 3
-- Se não fizer o rebuild. Aparecem 8 páginas. Senão aparece só uma com pg_alloc = 9.



set nocount on
declare @i int
set @i = 10
while @i <= 16
begin

    insert into t values(@i,replicate('A', 8000))
    set @i = @i+1
end


DBCC IND ('GSI_AP1','t',-1)
-- ponto 5 -- comparar com ponto 3


DBCC EXTENTINFO('GSI_AP1', 't')
-- pode aparecer um valor de pg_alloc = 9, o que significa um extent totalmente atribuído à
-- tabela e que a atribuição se inicia logo com uniform extents (não são usados mixed extents para as primeiras 8 páginas

-- ponto 6
-- Comparar com resultado do ponto 4 e 5


insert into t values(17,replicate('A', 8800))
insert into t values(18,replicate('A', 8800))



DBCC IND ('GSI_AP1','t',-1)
-- ponto 7-- comparar com ponto 5



DBCC EXTENTINFO('GSI_AP1', 't')
-- pode aparecer um valor de pg_alloc = 9, o que significa um extent totalmente atribuído à
-- tabela e que a atribuição se inicia logo com uniform extents (não são usados mixed extents para as primeiras 8 páginas


-- ponto 8
-- Comparar com resultado dos ponto 7 e 6


alter table t rebuild


DBCC IND ('GSI_AP1','t',-1)
-- ponto 9 -- comparar com ponto 7



DBCC EXTENTINFO('GSI_AP1', 't')
-- pode aparecer um valor de pg_alloc = 9, o que significa um extent totalmente atribuído à
-- tabela e que a atribuição se inicia logo com uniform extents (não são usados mixed extents para as primeiras 8 páginas


-- ponto 10
-- Comparar com resultado dos pontos 9 e 8 

ALTER DATABASE gsi_ap1 SET MIXED_PAGE_ALLOCATION OFF;


drop table t
create table t (i int, j char(8000))


insert into t values(1,replicate('A', 8000))





DBCC IND ('GSI_AP1','t',-1)
-- ponto 11
-- ver estrutura do heap 


DBCC EXTENTINFO('GSI_AP1', 't')
-- pode aparecer um valor de pg_alloc = 9, o que significa um extent totalmente atribuído à
-- tabela e que a atribuição se inicia logo com uniform extents (não são usados mixed extents para as primeiras 8 páginas


-- ponto 12
-- Comparar com resultado do ponto 2



insert into t values(2,replicate('A', 8000))
insert into t values(3,replicate('A', 8000))
insert into t values(4,replicate('A', 8000))
insert into t values(5,replicate('A', 8000))
insert into t values(6,replicate('A', 8000))
insert into t values(7,replicate('A', 8000))
insert into t values(8,replicate('A', 8000))

DBCC EXTENTINFO('GSI_AP1', 't')
-- pode aparecer um valor de pg_alloc = 9, o que significa um extent totalmente atribuído à
-- tabela e que a atribuição se inicia logo com uniform extents (não são usados mixed extents para as primeiras 8 páginas

-- ponto 13
-- Comparar com resultado do ponto 8

ALTER DATABASE gsi_ap1 SET MIXED_PAGE_ALLOCATION ON;
drop table t
create table t (i int, j char(3000), k varchar(6000))
GO


set nocount on
declare @i int
set @i = 1
while @i <= 20
begin

    insert into t values(@i,'A',replicate('B', 800))
    set @i = @i+1
end



DBCC IND ('GSI_AP1','t',1)
DBCC EXTENTINFO('GSI_AP1', 't')
-- ponto 14
-- ver estrutura do heap (anotar nº de págidas de dados), 
-- uso de extents e espaço livre em páginas


SELECT avg_page_space_used_in_percent
FROM sys.dm_db_index_physical_stats(DB_ID(N'GSI_AP1'),OBJECT_ID(N'T'),
                                    DEFAULT,DEFAULT,'DETAILED')
WHERE index_level = 0;
-- ponto 15
-- ver % de espaço usado por página



alter table t rebuild


DBCC IND ('GSI_AP1','t',1)
DBCC EXTENTINFO('GSI_AP1', 't')
-- ponto 16
-- ver novamente estrutura do heap (anotar nº de págidas de dados) e uso de extents


SELECT avg_page_space_used_in_percent
FROM sys.dm_db_index_physical_stats(DB_ID(N'GSI_AP1'),OBJECT_ID(N'T'),
                                    DEFAULT,DEFAULT,'DETAILED')
WHERE index_level = 0;

-- ponto 17
-- ver % de fragmentação (interna)


update t set k = replicate('C',6000)


DBCC IND ('GSI_AP1','t',1)
-- ponto 18
--ver novamente estrutura do heap (anotar nº de págidas de dados) 

alter table t rebuild

DBCC IND ('GSI_AP1','t',1)
-- ponto 19
-- ver novamente estrutura do heap (anotar nº de págidas de dados e 1.ª pág. de dados)


SELECT alloc_unit_type_desc, avg_page_space_used_in_percent
FROM sys.dm_db_index_physical_stats(DB_ID(N'GSI_AP1'),OBJECT_ID(N'T'),
                                    DEFAULT,DEFAULT,'DETAILED')
WHERE index_level = 0;
-- ponto 20
-- ver ocupação de espaço


-- também pode ver página a página:
select allocated_page_page_id, page_type, page_type_desc, page_free_space_percent
from sys.dm_db_database_page_allocations(db_id(),object_id('t'),0,null,'DETAILED');




DBCC TRACEON (3604);
DBCC PAGE ('GSI_AP1',1,448,3) -- alterar 448 para o seu caso
-- ponto 21
-- ver primeira página de dados



create clustered index ci on t(i)


DBCC IND ('GSI_AP1','t',1)
-- ponto 22 comparar com ponto 19




SELECT alloc_unit_type_desc,index_depth,avg_page_space_used_in_percent
FROM sys.dm_db_index_physical_stats(DB_ID(N'GSI_AP1'),OBJECT_ID(N'T'),
                                    DEFAULT,DEFAULT,'DETAILED')
WHERE index_level = 0;
-- ponto 23 comparar com ponto 20


alter table t rebuild


DBCC IND ('GSI_AP1','t',1)
-- ponto 22 comparar com ponto 19


SELECT alloc_unit_type_desc,index_depth,avg_page_space_used_in_percent
FROM sys.dm_db_index_physical_stats(DB_ID(N'GSI_AP1'),OBJECT_ID(N'T'),
                                    DEFAULT,DEFAULT,'DETAILED')
WHERE index_level = 0;
-- ponto 23 comparar com ponto 20



drop index t.ci


DBCC IND ('GSI_AP1','t',1)
-- ponto 24 comparar cpom ponto 22




SELECT alloc_unit_type_desc, avg_page_space_used_in_percent
FROM sys.dm_db_index_physical_stats(DB_ID(N'GSI_AP1'),OBJECT_ID(N'T'),
                                    DEFAULT,DEFAULT,'DETAILED')
WHERE index_level = 0;
-- ponto 25 comparar com ponto 17