use GSI_AP1

-- ponto 0 (execute apenas)


SELECT * FROM sys.filegroups
-- ponto 1 (observe o resultado da instrução)


SELECT * FROM sys.partitions
WHERE object_id = OBJECT_ID('dbo.tpart1');
-- ponto 2 (observe o resultado da instrução)

SELECT * FROM tpart1
WHERE $partition.pf(i) = 1
-- ponto 3 (observe o resultado da instrução)



 dbcc dropcleanbuffers
 set statistics time on
 -- ponto 4 (executar apenas)


  select I,COUNT(*) from tpart1 group by I
   -- ponto 5 
 --(observe o resultado da instrução anterior na janela Messages)
 -- veja também o plano de execução


  dbcc dropcleanbuffers
  -- ponto 6 (executar apenas)

 
   select I,COUNT(*) from tpart1 group by I OPTION(MAXDOP 1)
-- ponto 7
 --(observe o resultado da instrução anterior na janela Messages)
 -- veja também o plano de execução


set statistics time off
-- ponto 8 (executar apenas)



