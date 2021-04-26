use gsi_ap1

create unique clustered index ci on t(i)
create unique clustered index ci on t1(i) with FILLFACTOR = 50


dbcc checktable("t")
dbcc checktable("t1")
-- ponto 1 (comparar resultados para as duas tabelas)



SELECT  avg_page_space_used_in_percent
FROM sys.dm_db_index_physical_stats(DB_ID(N'GSI_Ap1'),OBJECT_ID(N'T'),
                                    DEFAULT,DEFAULT,'DETAILED'
) WHERE index_level = 0;

SELECT  avg_page_space_used_in_percent
FROM sys.dm_db_index_physical_stats(DB_ID(N'GSI_Ap1'),OBJECT_ID(N'T1'),
                                    DEFAULT,DEFAULT,'DETAILED'
) WHERE index_level = 0;
-- ponto 2 (comparar resultados para as duas tabelas)