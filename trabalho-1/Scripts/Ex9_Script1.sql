
use GSI_AP1
set statistics IO off
set statistics time off
GO
set showplan_text on
-- ponto 0 (executar apenas)


select * from tpart1 where I = 20
-- ponto 1 (execute a instru��o anterior e anote e justifique o plano gerado)
/*
Table Scan(OBJECT:([GSI_AP1].[dbo].[Tpart1]), SEEK:([PtnId1001]=RangePartitionNew(CONVERT_IMPLICIT(int,[@1],0),(0),(500000))),  
WHERE:([GSI_AP1].[dbo].[Tpart1].[i]=CONVERT_IMPLICIT(int,[@1],0)) ORDERED FORWARD)

N�o h� indice e � preciso percorrer a tabela toda para procurar os registos.
*/

select * from tpart1 where I = 20 or I = 60
-- ponto 2(execute a instru��o anterior e anote e justifique o plano gerado)
/*
  Table Scan(OBJECT:([GSI_AP1].[dbo].[Tpart1]), SEEK:([PtnId1001]=(1)),  
  WHERE:([GSI_AP1].[dbo].[Tpart1].[i]=(20) OR [GSI_AP1].[dbo].[Tpart1].[i]=(60)) ORDERED FORWARD)


N�o h� indice e � preciso percorrer a tabela toda para procurar os registos.
*/

select * from tpart1 where I = 700000
-- ponto 3(execute a instru��o anterior e anote e justifique o plano gerado).
/*
  Table Scan(OBJECT:([GSI_AP1].[dbo].[Tpart1]), SEEK:([PtnId1001]=RangePartitionNew([@1],(0),(500000))),  
  WHERE:([GSI_AP1].[dbo].[Tpart1].[i]=[@1]) ORDERED FORWARD)

N�o h� indice e � preciso percorrer a tabela toda para procurar os registos. � usada a parti��o diferente.
*/

select * from tpart1 where I = 20 or I = 700000
-- ponto 4(execute a instru��o anterior e anote e justifique o plano gerado)
/*
  Table Scan(OBJECT:([GSI_AP1].[dbo].[Tpart1]), 
  WHERE:([GSI_AP1].[dbo].[Tpart1].[i]=(20) OR [GSI_AP1].[dbo].[Tpart1].[i]=(700000)))

  Esta query demora o dobro do tempo das anteriores porque � preciso consultar as duas parti��es.
*/

set showplan_text off
-- ponto 5 (executar apenas)
