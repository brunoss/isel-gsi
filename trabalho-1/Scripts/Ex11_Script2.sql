use GSI_AP1
-- ponto 0 (executar apenas)

exec getPages
-- ponto 1 (anote o n�mero de p�ginas de cada combina��o {PageType, iam_chain_type})


dbcc dropcleanbuffers
set statistics io on
-- ponto 2 (executar apenas)


select * from tc where i % 20 = 0 
--ponto 3 (anotar n.� de p�ginas lidas (logical, physical, read-ahead) para p�ginas normais e lob

--Nota do professor:
/*
 se executar select * from tc (sem cl�usula where), poder� observar um n.� de lob physical reads (lfr) inferior
 ao n�emero de lob logical reads (llr). Concretamente, pode acontecer que lfr seja igual a llr/8. A raz�o � que,
 o Sql Server pode decidir fazer leituras extent a extent em vez de p�gina a p�gina. Por uma raz�o que n�o
 sei explicar, nesta situa��o, cada leitura de um extent � contabilizada como apenas um lfr e n�o como 8.
*/


set statistics io off   
-- ponto 4 (executar apenas)

EXEC sp_estimate_data_compression_savings
      'dbo', 'tc', NULL, NULL, 'PAGE' 
-- ponto 5(ver o ganho estimado)    


alter table tc rebuild  with (DATA_COMPRESSION = PAGE)
checkpoint
-- ponto 6 (executar apenas)


exec getPages
-- ponto 7 -- comparar com ponto 1

-- Pode aparecer uma p�gina de overflow sem dados.
-- Pode v�-la com--dbcc ind('GSI_AP1',TC,-1)
-- DBCC TRACEON (3604);
-- DBCC page('GSI_AP1',1,<n.� p�gina overflow de tipo 3>,3)


dbcc dropcleanbuffers
set statistics io on
-- ponto 8 (executar apenas)



select * from tc where i % 20 = 0 
--ponto 9 ((anotar n.� de p�ginas lidas (logical, physical, read-ahead) para p�ginas normais e lob
--         comparar com ponto 3


set statistics io off
-- ponto 10 (executar apenas)




