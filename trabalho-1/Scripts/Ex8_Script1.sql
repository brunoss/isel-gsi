use GSI_AP1
-- ponto 0 (execute apenas)

select * from tpart1 where i = 20 and j = -20
-- ponto 1 observe o plano de execu��o da query anterior, incluindo parti��es usadas
-- (coloque o rato pro cima do operador Table Scan [Heap] para ver informa��o das parti��es - RangePartitionNew)
/*
Usa a primeira parti��o
*/


SELECT * FROM sys.partitions
WHERE object_id = object_id('tpart1')
 -- ponto 2: veja as parti�oes existentes
 /*
 72057594043170816	885578193	0	1	72057594043170816	500001	0	0	NONE
72057594043236352	885578193	0	2	72057594043236352	499999	0	0	NONE
 */

create nonclustered index ii on tpart1(j) ON ps(i)
-- ponto 3 (executar apenas)

SELECT * FROM sys.partitions
WHERE object_id in
  (select object_id from sys.indexes where name = 'ii')
-- ponto 4 observe o resultado da query anterior(comparar com ponto 2)
/*
72057594043170816	885578193	0	1	72057594043170816	500001	0	0	NONE
72057594043236352	885578193	0	2	72057594043236352	499999	0	0	NONE
72057594043301888	885578193	4	1	72057594043301888	500001	0	0	NONE
72057594043367424	885578193	4	2	72057594043367424	499999	0	0	NONE

Foram criadas mais 2 parti��es para o indice que foi criado.
*/

  select * from tpart1 where i = 20 and j = -20
  -- ponto 5 observe o plano de execu��o da query anterior incluindo parti��es usadas (comparar com ponto 1)  
 /*
 Foi feito um Index seek porque a coluna do indice � a j e a coluna i faz parte da parti��o e tem que ser incluida obrigat�riamente no indice.
 */

 drop index tpart1.ii
 create nonclustered index ii on tpart1(j)
  -- ponto 6  (executar apenas)

 select * from tpart1 where i = 20 and j = -20
  -- ponto 7 observe o plano de execu��o da query anterior incluindo parti��es usadas (comparar com ponto 1)
  /*
 Foi feito um Index seek porque a coluna do indice � a j e a coluna i faz parte da parti��o e tem que ser incluida obrigat�riamente no indice.
  */

create table tt (i int, j int)
create nonclustered index ii on tt(j) ON ps(i)
-- ponto 8 (executar apenas)


select * from tt where i < 20 and j = -20
-- ponto 9 observe o plano de execu��o da query anterior incluindo parti��es usadas 
/*
O plano � identico ao anterior. � usado um Seek keys adicional.
*/

drop index tt.ii
create nonclustered index ii on tt(j)
-- ponto 10 (executar apenas)


select * from tt with (index(ii)) where i < 20 and j = -20
-- ponto 11 observe o plano de execu��o da query anterior incluindo parti��es usadas 
/*
	� feito um Index Seek com a coluna j que faz parte do �ndice. E depois � feito um RID Lookup para obter o valor do i < 20.
*/ 

drop index tpart1.ii
-- ponto 12 (executar apenas)

-- ponto 13 Discutir as diferen�as de comportamento do Sql Server entre o que tinha a ver
-- com a tabela tpart1 e o que tinha a ver com a tabela tt

/*
Detalhar melhor no relat�rio
*/