use GSI_AP1

-- ponto 0 (execute apenas)


SELECT * FROM sys.filegroups
-- ponto 1 (observe o resultado da instru��o)


SELECT * FROM sys.partitions
WHERE object_id = OBJECT_ID('dbo.tpart1');
-- ponto 2 (observe o resultado da instru��o)

SELECT * FROM tpart1
WHERE $partition.pf(i) = 1
-- ponto 3 (observe o resultado da instru��o)



 dbcc dropcleanbuffers
 set statistics time on
 -- ponto 4 (executar apenas)


  select I,COUNT(*) from tpart1 group by I
   -- ponto 5 
 --(observe o resultado da instru��o anterior na janela Messages)
 -- veja tamb�m o plano de execu��o


  dbcc dropcleanbuffers
  -- ponto 6 (executar apenas)

 
   select I,COUNT(*) from tpart1 group by I OPTION(MAXDOP 1)
-- ponto 7
 --(observe o resultado da instru��o anterior na janela Messages)
 -- veja tamb�m o plano de execu��o


set statistics time off
-- ponto 8 (executar apenas)



