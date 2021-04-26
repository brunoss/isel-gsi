use GSI_AP1
-- ponto 0 (execute apenas)

select * from tpart1 where i = 20 and j = -20
-- ponto 1 observe o plano de execu��o da query anterior, incluindo parti��es usadas
-- (coloque o rato pro cima do operador Table Scan [Heap] para ver informa��o das parti��es - RangePartitionNew)



SELECT * FROM sys.partitions
WHERE object_id = object_id('tpart1')
 -- ponto 2: veja as parti�oes existentes

create nonclustered index ii on tpart1(j) ON ps(i)
-- ponto 3 (executar apenas)

SELECT * FROM sys.partitions
WHERE object_id in
  (select object_id from sys.indexes where name = 'ii')
-- ponto 4 observe o resultado da query anterior(comparar com ponto 2)


  select * from tpart1 where i = 20 and j = -20
  -- ponto 5 observe o plano de execu��o da query anterior incluindo parti��es usadas (comparar com ponto 1)  


 drop index tpart1.ii
 create nonclustered index ii on tpart1(j)
  -- ponto 6  (executar apenas)



 select * from tpart1 where i = 20 and j = -20
  -- ponto 7 observe o plano de execu��o da query anterior incluindo parti��es usadas (comparar com ponto 1)


create table tt (i int, j int)
create nonclustered index ii on tt(j) ON ps(i)
-- ponto 8 (executar apenas)


select * from tt where i < 20 and j = -20
-- ponto 9 observe o plano de execu��o da query anterior incluindo parti��es usadas 

drop index tt.ii
create nonclustered index ii on tt(j)
-- ponto 10 (executar apenas)


select * from tt with (index(ii)) where i < 20 and j = -20
-- ponto 11 observe o plano de execu��o da query anterior incluindo parti��es usadas 


 

drop index tpart1.ii
-- ponto 12 (executar apenas)

-- ponto 13 Discutir as diferen�as de comportamento do Sql Server entre o que tinha a ver
-- com a tabela tpart1 e o que tinha a ver com a tabela tt



