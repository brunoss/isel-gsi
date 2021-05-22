use GSI_AP1

-- ponto 0 (execute apenas)


SELECT * FROM sys.filegroups
-- ponto 1 (observe o resultado da instrução)
/*
PRIMARY	1	FG	ROWS_FILEGROUP	1	0	NULL	NULL	0	0
FG1	2	FG	ROWS_FILEGROUP	0	0	DFD5989B-4EDC-4F73-BCF6-BA90C326CDEB	NULL	0	0
FG2	3	FG	ROWS_FILEGROUP	0	0	B1AE4C0E-CA6B-4BD4-937F-30B2A4C830BA	NULL	0	0
*/

SELECT * FROM sys.partitions
WHERE object_id = OBJECT_ID('dbo.tpart1');
-- ponto 2 (observe o resultado da instrução)
/*
72057594043170816	885578193	0	1	72057594043170816	500001	0	0	NONE
72057594043236352	885578193	0	2	72057594043236352	499999	0	0	NONE
*/

SELECT * FROM tpart1
WHERE $partition.pf(i) = 1
order by i desc 
-- ponto 3 (observe o resultado da instrução)
-- Só mostra os resultados da partição 1 que vai até ao i = 500000


 dbcc dropcleanbuffers
 set statistics time on
 -- ponto 4 (executar apenas)


  select I,COUNT(*) from tpart1 group by I
   -- ponto 5 
 --(observe o resultado da instrução anterior na janela Messages)
 -- veja também o plano de execução
 /*
 SQL Server parse and compile time: 
   CPU time = 0 ms, elapsed time = 3 ms.

(1000000 rows affected)

 SQL Server Execution Times:
   CPU time = 969 ms,  elapsed time = 5965 ms.

Completion time: 2021-05-15T11:07:53.4846144+01:00

Os resultados aparecem por ordem não sequencial, mas sempre pela mesma ordem.
 */


  dbcc dropcleanbuffers
  -- ponto 6 (executar apenas)

 
   select I, COUNT(*) from tpart1 group by I OPTION(MAXDOP 1)
-- ponto 7
 --(observe o resultado da instrução anterior na janela Messages)
 -- veja também o plano de execução
 /*
Os resultados aparecem por ordem não sequencial, mas sempre pela mesma ordem.

Os resultados com vários cores não garante melhores resultados que 1 só core.
 */


set statistics time off
-- ponto 8 (executar apenas)



