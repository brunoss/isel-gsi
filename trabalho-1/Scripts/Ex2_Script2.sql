use gsi_ap1

create unique clustered index ci on t(i)
create unique clustered index ci on t1(i) with FILLFACTOR = 50

dbcc checktable("t")
dbcc checktable("t1")
-- ponto 1 (comparar resultados para as duas tabelas)

--Espa�o ocupado = 4 (header) +  1004 (fixo) + (Null Block) + 0 (colunas vari�veis)
--NullBlock = (2 + (2 + 7) / 8) = 3
-- 4 + 1004 + 3 = 1011
-- LPP = 8096 / (1011+2) = 7.99 -> 7
-- Numero de paginas = 20 / 7 = 3

-- Fill Factor = (100 - 50) / 100 = 0.5
-- LPP = 8096 * 0.5 / 1013 = 4
-- N�mero de p�ginas = 20 / 4 = 5

--There are 20 rows in 3 pages for object "t".
--There are 20 rows in 5 pages for object "t1".

SELECT  avg_page_space_used_in_percent
FROM sys.dm_db_index_physical_stats(DB_ID(N'GSI_Ap1'),OBJECT_ID(N'T'),
                                    DEFAULT,DEFAULT,'DETAILED'
) WHERE index_level = 0;

SELECT  avg_page_space_used_in_percent
FROM sys.dm_db_index_physical_stats(DB_ID(N'GSI_Ap1'),OBJECT_ID(N'T1'),
                                    DEFAULT,DEFAULT,'DETAILED'
) WHERE index_level = 0;
-- ponto 2 (comparar resultados para as duas tabelas)

--83.411588831233
--50.0370644922165

--Na tabela 't' o espa�o � mais ocupado
--Na tabela 't1' o espa�o � ocupado a 50% devido ao Fill Factor

--Na tabela t1 tem um indice �nico e vai benificiar dum acesso mais r�pido com um Fill Factor de 50%
--A desvantgem � que vai ocupar mais p�ginas