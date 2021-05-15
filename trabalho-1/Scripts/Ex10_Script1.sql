use GSI_AP1
create  table tpart (i int, j int) on ps(i)
-- ponto 0 (executar apenas)


SELECT * FROM tpart1 WHERE $partition.pf(i) = 1
SELECT * FROM tpart WHERE $partition.pf(i) = 1
-- ponto 1 (observer os resultados das interrogações anteriores)
/*
tpart está vazia.
tpart1 tem as entradas até ao valor i = 500000
*/

SET STATISTICS TIME ON
--ponto 2 (executar apenas)

dbcc dropcleanbuffers
insert into tpart select * from tpart1 WHERE $partition.pf(i) = 1
-- ponto 3 (anote o tempo de cpu para a execução)
/*
SQL Server parse and compile time: 
   CPU time = 0 ms, elapsed time = 19 ms.
DBCC execution completed. If DBCC printed error messages, contact your system administrator.

 SQL Server Execution Times:
   CPU time = 0 ms,  elapsed time = 6 ms.

 SQL Server Execution Times:
   CPU time = 734 ms,  elapsed time = 1244 ms.

(500001 rows affected)

Completion time: 2021-05-15T14:07:20.9957395+01:00
*/

SET STATISTICS time Off
delete from tpart
SET STATISTICS time ON
-- pont 4 (executar apenas)

dbcc dropcleanbuffers
ALTER TABLE tpart1 SWITCH PARTITION 1 TO tpart PARTITION 1

-- ponto 5 (anote o tempo de cpu para a execução)
-- comparar com o ponto 3)
/*
SQL Server parse and compile time: 
   CPU time = 0 ms, elapsed time = 3 ms.

Não demora tanto tempo como o ponto 1 porque não é preciso inserir dados. Só é mudado uns apontadores.
*/

SET STATISTICS TIME Off
-- ponto 6 (executar apenas)

SELECT * FROM tpart1 WHERE $partition.pf(i) = 1
SELECT * FROM tpart WHERE $partition.pf(i) = 1
-- ponto 7 (confirme a troca)
/*
	Houve uma troca das partições. A tabela tpart1 ficou vazia.
*/

ALTER TABLE tpart SWITCH PARTITION 1 TO tpart1 PARTITION 1
-- ponto 8 (execute apenas)
/*
	Foi feita novamente a troca de partições. A tabela tpart1 ficou com ados e a tabela tpart ficou vaiza. 
*/
