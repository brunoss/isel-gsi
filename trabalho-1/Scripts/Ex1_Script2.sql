

use gsi_ap1

select cpu_count, physical_memory_kb,virtual_memory_kb,committed_kb, committed_target_kb from osInfo

--ponto 1 (ver e anotar os valores)

DBCC DROPCLEANBUFFERS
select * from bufferPool_Object

--Os buffers foram limpos e a query não retorna nadas

--ponto 2 (ver uso da cache)
select * from t
select * from t1
select * from bufferPool_Object

-- Fizemos o select e os dados passaram a estar em memória. 
-- Existem 21 páginas porque cada linha ocupa 5Kb e por isso, só pode haver uma linha por cada página. 


--ponto 3 (ver uso da cache e comparar com ponto 2)
dbcc dropcleanbuffers
set statistics IO on

select * from t1 where i = 15
select * from t1 where i = 15

-- O primeiro select faz um read-ahead das 20 páginas e o segundo não faz, porque os dados estão em memória.
-- Faz 20 Logical reads. Lê 20 páginas porque a tabela t1 não tem indice, então faz full-table scan

-- ponto 4 (ver janela Messages e comparar resultados)

dbcc dropcleanbuffers

select * from t where i = 15
select * from t where i = 15
-- O primeiro select faz 2 physical reads. Lê 2 páginas porque a tabela t tem um indíce.
-- Então é lida a pagina que contem o indice e é lida a página que tem o valor correspondente.

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
-- xxx -> Páginos de dados (20)

dbcc ind('gsi_ap1','t1',1)
-- 1	305	NULL	NULL	661577395	0	1	72057594043367424	In-row data	10	NULL	0	0	0	0 -> IAM
-- xxx -> Páginos de dados (20)

SELECT avg_page_space_used_in_percent
FROM sys.dm_db_index_physical_stats(DB_ID(N'GSI_AP1'),OBJECT_ID(N'T'),
DEFAULT,DEFAULT,'DETAILED'
) WHERE index_level = 0;

--A query retorna o espaço ocupado em cada página. Cada página tem 5000bytes ocupados e, por isso, 
-- as páginas estão ocupadas cerca de 5004/8000 (62%)s