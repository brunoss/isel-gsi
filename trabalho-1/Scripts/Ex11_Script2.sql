use GSI_AP1
-- ponto 0 (executar apenas)

exec getPages
-- ponto 1 (anote o número de páginas de cada combinação {PageType, iam_chain_type})
/*
1	In-row data	10000				- 10000 páginas de dados
10	In-row data	1					- 1 Página de IAM de dados
10	Row-overflow data	1			- 1 Página de IAM de overflow
3	Row-overflow data	10000		- 10000 Página de dados de overflow
2	In-row data	18					- 18 Páginas de indice
*/

dbcc dropcleanbuffers
set statistics io on
-- ponto 2 (executar apenas)


select * from tc where i % 20 = 0 
--ponto 3 (anotar n.º de páginas lidas (logical, physical, read-ahead) para páginas normais e lob
/*
Table 'tc'. Scan count 1, logical reads 10019, physical reads 3, page server reads 0, read-ahead reads 10015, 
page server read-ahead reads 0, lob logical reads 500, lob physical reads 500, lob page server reads 0, lob read-ahead reads 0, lob page server read-ahead reads 0.
*/
--Nota do professor:
/*
 se executar select * from tc (sem cláusula where), poderá observar um n.º de lob physical reads (lfr) inferior
 ao núemero de lob logical reads (llr). Concretamente, pode acontecer que lfr seja igual a llr/8. A razão é que,
 o Sql Server pode decidir fazer leituras extent a extent em vez de página a página. Por uma razão que não
 sei explicar, nesta situação, cada leitura de um extent é contabilizada como apenas um lfr e não como 8.
*/


set statistics io off   
-- ponto 4 (executar apenas)

EXEC sp_estimate_data_compression_savings
      'dbo', 'tc', NULL, NULL, 'PAGE' 
-- ponto 5(ver o ganho estimado)    
/*
object_name	schema_name	index_id	partition_number	size_with_current_compression_setting(KB)	size_with_requested_compression_setting(KB)	sample_size_with_current_compression_setting(KB)	sample_size_with_requested_compression_setting(KB)
tc			dbo			1			1					160160										80160										39384												19712

Ganho de cerca de 50% de espaço utilizado caso sejam comprimidos os dados.
*/

alter table tc rebuild  with (DATA_COMPRESSION = PAGE)
checkpoint
-- ponto 6 (executar apenas)


exec getPages
-- ponto 7 -- comparar com ponto 1
/*
1	In-row data	10000
10	In-row data	1
2	In-row data	18

Não há páginas de overflow
*/


-- Pode aparecer uma página de overflow sem dados.
-- Pode vê-la com--dbcc ind('GSI_AP1',TC,-1)
-- DBCC TRACEON (3604);
-- DBCC page('GSI_AP1',1,<n.º página overflow de tipo 3>,3)


dbcc dropcleanbuffers
set statistics io on
-- ponto 8 (executar apenas)



select * from tc where i % 20 = 0 
--ponto 9 ((anotar n.º de páginas lidas (logical, physical, read-ahead) para páginas normais e lob
--         comparar com ponto 3
/*
Table 'tc'. Scan count 1, logical reads 10019, physical reads 3, page server reads 0, read-ahead reads 10015, page server read-ahead reads 0, lob logical reads 0, 
lob physical reads 0, lob page server reads 0, lob read-ahead reads 0, lob page server read-ahead reads 0.

Não há leituras de lob (overflow)
*/

set statistics io off
-- ponto 10 (executar apenas)




