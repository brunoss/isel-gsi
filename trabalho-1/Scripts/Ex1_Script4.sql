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


--307 0x70 IAM_PG MIXED_EXT ALLOCATED   0_PCT_FULL
--306 0x64 MIXED_EXT ALLOCATED 100_PCT_FULL
DBCC PAGE ('GSI_AP1', 1, 480, 3) WITH TABLERESULTS
--where Field like 'gam%' or Field like 'sgam%' or field like 'pfs%'

DBCC EXTENTINFO('GSI_AP1', 't')
-- pode aparecer um valor de pg_alloc = 9, o que significa um extent totalmente atribu�do �
-- tabela e que a atribui��o se inicia logo com uniform extents (n�o s�o usados mixed extents para as primeiras 8 p�ginas)
-- (pode acontecer, por exemplo, a seguir a um rebuild ou com MIXED_PAGE_ALLOCATION OFF). No m�ximo, ocorre 1 vez

-- page_id 306 - mesma p�gina de dados. pg_alloc = 1
-- Podemos ainda alocar mais 7 p�ginas a este Mixed Extent
-- Fica no mesmo Mixed Extent do IAM
-- Ext_size = 1 - Pode ser partilhado com outras p�ginas

-- ponto 2
-- Comparar com resultado do ponto 1



insert into t values(2,replicate('A', 8000))
insert into t values(3,replicate('A', 8000))
insert into t values(4,replicate('A', 8000))
insert into t values(5,replicate('A', 8000))
insert into t values(6,replicate('A', 8000))
insert into t values(7,replicate('A', 8000))
insert into t values(8,replicate('A', 8000))
--alter table t rebuild;
--insert into t values(9,replicate('A', 8000))
--insert into t values(10,replicate('A', 8000))


DBCC IND ('GSI_AP1','t',-1)
-- ponto 3 -- comparar com ponto 1
-- Foi alocada uma p�gina por cada liha da tabela


DBCC EXTENTINFO('GSI_AP1', 't')
-- pode aparecer um valor de pg_alloc = 9, o que significa um extent totalmente atribu�do �
-- tabela e que a atribui��o se inicia logo com uniform extents (n�o s�o usados mixed extents para as primeiras 8 p�ginas

-- ponto 4
-- Comparar com resultado dos ponto 2 e 3
-- Se n�o fizer o rebuild aparecem 8 p�ginas. Sen�o aparece s� uma com pg_alloc = 9.
-- Todas as p�ginas pertencem ao Mixed extent


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
-- Foram criadas 7 p�ginas adicionais. O Id das paginas n�o � consecutivo em rela��o aos Ids anteriores porque as p�ginas s�o alocadas de 8 em 8.
-- A tabela � um heap porque n�o tem p�gina de indice.

DBCC EXTENTINFO('GSI_AP1', 't')
-- pode aparecer um valor de pg_alloc = 9, o que significa um extent totalmente atribu�do �
-- tabela e que a atribui��o se inicia logo com uniform extents (n�o s�o usados mixed extents para as primeiras 8 p�ginas)

-- ponto 6
-- Comparar com resultado do ponto 4 e 5
-- 1	320	7	8	965578478	0	1	72057594044809216	In-row data	0x4444444444444400
-- Ainda h� uma p�gina que pode ser associada a este extent


insert into t values(17,replicate('A', 8800))
insert into t values(18,replicate('A', 8800))

DBCC IND ('GSI_AP1','t',-1)
-- ponto 7-- comparar com ponto 5
-- 1	336	1	307	965578478	0	1	72057594044809216	In-row data	1	0	0	0	0	0
-- Foi criada uma nova p�gina num id n�o consecutivo pela mesma raz�o do ponto 5.

DBCC EXTENTINFO('GSI_AP1', 't')
-- pode aparecer um valor de pg_alloc = 9, o que significa um extent totalmente atribu�do �
-- tabela e que a atribui��o se inicia logo com uniform extents (n�o s�o usados mixed extents para as primeiras 8 p�ginas


-- ponto 8
-- Comparar com resultado dos ponto 7 e 6

--1	320	8	8	965578478	0	1	72057594044809216	In-row data	0x4444444444444444
--1	336	1	8	965578478	0	1	72057594044809216	In-row data	0x4400000000000000
--A p�gina do extent anterior ficou cheia (pg_alloc = 8 e ext_size = 8) e foi criado um novo extent com uma s� p�gina.


alter table t rebuild


DBCC IND ('GSI_AP1','t',-1)
-- ponto 9 -- comparar com ponto 7
--As p�ginas ficam consecutivas



DBCC EXTENTINFO('GSI_AP1', 't')
-- pode aparecer um valor de pg_alloc = 9, o que significa um extent totalmente atribu�do �
-- tabela e que a atribui��o se inicia logo com uniform extents (n�o s�o usados mixed extents para as primeiras 8 p�ginas


-- ponto 10
-- Comparar com resultado dos pontos 9 e 8 

--Pass�mos a ter 3 extents e o primeiro extent est� totalmente ocupado.
--1	496	9	8	1029578706	0	1	72057594045333504	In-row data	0x4444444444444444
--1	504	8	8	1029578706	0	1	72057594045333504	In-row data	0x4444444444444444
--1	512	1	8	1029578706	0	1	72057594045333504	In-row data	0x4400000000000000

ALTER DATABASE gsi_ap1 SET MIXED_PAGE_ALLOCATION OFF;


drop table t
create table t (i int, j char(8000))


insert into t values(1,replicate('A', 8000))





DBCC IND ('GSI_AP1','t',-1)
-- ponto 11
-- ver estrutura do heap 
--1	306	NULL	NULL	1045578763	0	1	72057594045399040	In-row data	10	NULL	0	0	0	0 -> IAM
--1	312	1	306	1045578763	0	1	72057594045399040	In-row data	1	0	0	0	0	0
--H� uma p�gina de dados e uma do IAM



DBCC EXTENTINFO('GSI_AP1', 't')
-- pode aparecer um valor de pg_alloc = 9, o que significa um extent totalmente atribu�do �
-- tabela e que a atribui��o se inicia logo com uniform extents (n�o s�o usados mixed extents para as primeiras 8 p�ginas


-- ponto 12
-- Comparar com resultado do ponto 2
--No ponto 2 foram criados mixed extents enquanto neste ponto foi criado um uniform extent.


insert into t values(2,replicate('A', 8000))
insert into t values(3,replicate('A', 8000))
insert into t values(4,replicate('A', 8000))
insert into t values(5,replicate('A', 8000))
insert into t values(6,replicate('A', 8000))
insert into t values(7,replicate('A', 8000))
insert into t values(8,replicate('A', 8000))

DBCC EXTENTINFO('GSI_AP1', 't')
-- pode aparecer um valor de pg_alloc = 9, o que significa um extent totalmente atribu�do �
-- tabela e que a atribui��o se inicia logo com uniform extents (n�o s�o usados mixed extents para as primeiras 8 p�ginas

-- ponto 13
-- Comparar com resultado do ponto 8
--1	312	9	8	1045578763	0	1	72057594045399040	In-row data	0x4444444444444444
--O uniform extent est� totalmente atribuido, uma vez que foram criadas mais 7 p�ginas.

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
-- ver estrutura do heap (anotar n� de p�gidas de dados), 
-- uso de extents e espa�o livre em p�ginas
--Espa�o ocupado = 4 (header) +  3004 (fixo) + (Null Block) + 800*1 + 2 (colunas vari�veis) = 12 bytes
--NullBlock = (2 + (3 + 7) / 8) = 3
-- 4 + 3004 + 3 + 800 + 2 = 3813
-- LPP = 8096 / (3813+2) = 2.12 -> 2
-- 20 / 2 = 10

-- Calcul�mos 10 p�ginas mas o SQL Server cirou 12. O SGBD usa heuristicas em rela��o aos dados introduzidos para verificar se deve ou n�o alocar
-- uma nova p�gina e a utliza��o das pag�nias n�o � necess�riamente a mais optimizada.

DBCC Checktable('t')

SELECT avg_page_space_used_in_percent
FROM sys.dm_db_index_physical_stats(DB_ID(N'GSI_AP1'),OBJECT_ID(N'T'),
                                    DEFAULT,DEFAULT,'DETAILED')
WHERE index_level = 0;
-- ponto 15
-- ver % de espa�o usado por p�gina
--78.572609340252

alter table t rebuild


DBCC IND ('GSI_AP1','t',1)
DBCC EXTENTINFO('GSI_AP1', 't')
-- ponto 16
-- ver novamente estrutura do heap (anotar n� de p�gidas de dados) e uso de extents

-- Foram ajustadas as linhas para ocupar apenas 10 p�ginas

SELECT avg_page_space_used_in_percent
FROM sys.dm_db_index_physical_stats(DB_ID(N'GSI_AP1'),OBJECT_ID(N'T'),
                                    DEFAULT,DEFAULT,'DETAILED')
WHERE index_level = 0;

-- ponto 17
-- ver % de fragmenta��o (interna)
--94.2920681986657


update t set k = replicate('C',6000)


DBCC IND ('GSI_AP1','t',1)
-- ponto 18
--ver novamente estrutura do heap (anotar n� de p�gidas de dados) 
--34 p�ginas, havendo v�rias p�ginas de overflow

alter table t rebuild

DBCC IND ('GSI_AP1','t',1)
-- ponto 19
-- ver novamente estrutura do heap (anotar n� de p�gidas de dados e 1.� p�g. de dados)
--33 p�ginas
--1	448	1	318	1093578934	0	1	72057594045792256	In-row data	1	0	1	449	0	0
--IN_ROW_DATA	62.5936990363232
--ROW_OVERFLOW_DATA	74.3019520632567


SELECT alloc_unit_type_desc, avg_page_space_used_in_percent
FROM sys.dm_db_index_physical_stats(DB_ID(N'GSI_AP1'),OBJECT_ID(N'T'),
                                    DEFAULT,DEFAULT,'DETAILED')
WHERE index_level = 0;
-- ponto 20
-- ver ocupa��o de espa�o
--IN_ROW_DATA	75.1173708920188
--ROW_OVERFLOW_DATA	70.7637756362738

-- tamb�m pode ver p�gina a p�gina:
select allocated_page_page_id, page_type, page_type_desc, page_free_space_percent
from sys.dm_db_database_page_allocations(db_id(),object_id('t'),0,null,'DETAILED');




DBCC TRACEON (3604);
DBCC PAGE ('GSI_AP1',1,608,3) -- alterar 448 para o seu caso
-- ponto 21
-- ver primeira p�gina de dados



create clustered index ci on t(i)


DBCC IND ('GSI_AP1','t',1)
-- ponto 22 comparar com ponto 19
-- 1	340	1	341	1125579048	1	1	72057594046119936	In-row data	1	0	1	306	0	0 -> 1� p�gina de dados
-- 1	307	1	341	1125579048	1	1	72057594046119936	In-row data	2	1	0	0	0	0 -> p�gina de indice




SELECT alloc_unit_type_desc,index_depth,avg_page_space_used_in_percent
FROM sys.dm_db_index_physical_stats(DB_ID(N'GSI_AP1'),OBJECT_ID(N'T'),
                                    DEFAULT,DEFAULT,'DETAILED')
WHERE index_level = 0;
-- ponto 23 comparar com ponto 20
--IN_ROW_DATA	2	75.1667902149741
--ROW_OVERFLOW_DATA	1	74.3019520632567
-- Passou a haver um index_depth

alter table t rebuild


DBCC IND ('GSI_AP1','t',1)
-- ponto 22 comparar com ponto 19
--Existem as mesmas p�ginas

SELECT alloc_unit_type_desc,index_depth,avg_page_space_used_in_percent
FROM sys.dm_db_index_physical_stats(DB_ID(N'GSI_AP1'),OBJECT_ID(N'T'),
                                    DEFAULT,DEFAULT,'DETAILED')
WHERE index_level = 0;
-- ponto 23 comparar com ponto 20
-- O Indice n�o mudou nada, para al�m de acrescentar a p�gina de indice

drop index t.ci

DBCC IND ('GSI_AP1','t',1)
-- ponto 24 comparar cpom ponto 22
-- J� n�o tem a p�gina de indice

SELECT alloc_unit_type_desc, avg_page_space_used_in_percent
FROM sys.dm_db_index_physical_stats(DB_ID(N'GSI_AP1'),OBJECT_ID(N'T'),
                                    DEFAULT,DEFAULT,'DETAILED')
WHERE index_level = 0;
-- ponto 25 comparar com ponto 17
--IN_ROW_DATA	75.1667902149741
--ROW_OVERFLOW_DATA	74.3019520632567
--J� n�o tem a coluna index_depth