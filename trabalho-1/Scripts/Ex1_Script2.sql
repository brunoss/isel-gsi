

use gsi_ap1

select cpu_count, physical_memory_kb,virtual_memory_kb,committed_kb, committed_target_kb from osInfo

--ponto 1 (ver e anotar os valores)

DBCC DROPCLEANBUFFERS
select * from bufferPool_Object

--Os buffers foram limpos e a query n�o retorna nadas

--ponto 2 (ver uso da cache)
select * from t
select * from t1
select * from bufferPool_Object

-- Fizemos o select e os dados passaram a estar em mem�ria. 
-- Existem 21 p�ginas porque cada linha ocupa 5Kb e por isso, s� pode haver uma linha por cada p�gina. 


--ponto 3 (ver uso da cache e comparar com ponto 2)
dbcc dropcleanbuffers
set statistics IO on

select * from t1 where i = 15
select * from t1 where i = 15

-- O primeiro select faz um read-ahead das 20 p�ginas e o segundo n�o faz, porque os dados est�o em mem�ria.
-- Faz 20 Logical reads. L� 20 p�ginas porque a tabela t1 n�o tem indice, ent�o faz full-table scan

-- ponto 4 (ver janela Messages e comparar resultados)

dbcc dropcleanbuffers

select * from t where i = 15
select * from t where i = 15
-- O primeiro select faz 2 physical reads. L� 2 p�ginas porque a tabela t tem um ind�ce.
-- Ent�o � lida a pagina que contem o indice e � lida a p�gina que tem o valor correspondente.

-- ponto 5 (ver janela Messages e comparar resultados)

--------------------------------------------------
set statistics IO Off
GO

delete from t
delete from t1
GO
set nocount on
declare @i int
set @i = 1
while @i <= 20
begin
    insert into t values(@i,REPLICATE('a',5))
    insert into t1 values(@i,REPLICATE('a',5))
    set @i = @i+1
end

CHECKPOINT
dbcc dropcleanbuffers
GO
-- ponto 7 (Executar apenas)
set statistics IO ON
GO
select * from t where i = 15
select * from t1 where i = 15

-- ponto 8 (ver janela Messages e comparar resultados)

dbcc ind('gsi_ap1','t',1)
-- 1	307	NULL	NULL	629577281	1	1	72057594043301888	In-row data	10	NULL	0	0	0	0 -> IAM
-- 1	400	1	307	629577281	1	1	72057594043301888	In-row data	2	1	0	0	0	0 -> Indice
-- xxx -> P�ginos de dados (20)

dbcc ind('gsi_ap1','t1',1)
-- 1	305	NULL	NULL	661577395	0	1	72057594043367424	In-row data	10	NULL	0	0	0	0 -> IAM
-- xxx -> P�ginos de dados (20)

SELECT avg_page_space_used_in_percent
FROM sys.dm_db_index_physical_stats(DB_ID(N'GSI_AP1'),OBJECT_ID(N'T'),
DEFAULT,DEFAULT,'DETAILED'
) WHERE index_level = 0;

--A query retorna o espa�o ocupado em cada p�gina. Cada p�gina tem 5000bytes ocupados e, por isso, 
-- as p�ginas est�o ocupadas cerca de 5004/8000 (62%)s