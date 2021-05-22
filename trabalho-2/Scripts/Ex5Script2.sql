use GSI_AP2;


if object_id('t') is not null
    drop table t;

create table t(i int, j char(100))
ALTER TABLE t SET  (LOCK_ESCALATION = TABLE)
GO

set nocount on
declare @n int = 1
while @n <= 20000
begin
    insert into t values(@n, 'A')
	set @n = @n+1
end

SELECT sys.fn_PhysLocFormatter(t.%% physloc %%) as Address,
 t.%% lockres %% as LockHashValue, t.%% physloc %% as phl,
 t.* FROM t

-- ponto 0 (anotar resultados)

--******************* Teste 1 ********************
begin tran
update t set i = i+20000 where i < 50
exec verLocks1 null, 'RID'
-- ponto 1.1 (observar e comentar locks)
/*
60	t	1:328:0                         	RID 	X	GRANT
50 Locks exclusivos, Um lock de escrita para cada uma das linhas
*/
exec verLocks1 null, 'PAG'
-- ponto 1.2 (observar e comentar locks)
/*
60	t	1:328                           	PAG 	SIX	GRANT
Um lock SIX de escrita na página 
*/
exec verLocks1 null, 'TAB'
-- ponto 1.3 (observar e comentar locks)
/*
60	t	                                	TAB 	IX	GRANT
Um lock IX de escrita ao nível da tabela
*/

update t set i=i+20000 where i >= 50 and i < 5000
exec verLocks1 null, 'RID'
-- ponto 2.1 (observar e comentar locks)
/*
60	t	1:330:0                         	RID 	X	GRANT
5000 locks a nivel dos registos, Um lock por cada linha
*/

exec verLocks1 null, 'PAG'
DBCC checktable('t')
-- ponto 2.2 (observar e comentar locks)
/*
There are 20000 rows in 290 pages for object "t".
73 Locks IX a nível das páginas 
*/

exec verLocks1 null, 'TAB'
-- ponto 2.3 (observar e comentar locks)
/*
60	t	                                	TAB 	IX	GRANT
Um lock a nível tabela 
*/

update t set i=i+20000 where i >= 6000 
exec verLocks1 null, 'RID'
-- ponto 3.1 (observar e comentar locks)
/*
Não há lock a nivel de registos
Houve log escalation
Lock:Escalation	60	GSI_AP2	6175	
*/
exec verLocks1 null, 'PAG'
-- ponto 3.2 (observar e comentar locks)
/*
Não há lock a nivel da página
Houve log escalation
Lock:Escalation	60	GSI_AP2	6175	
*/
exec verLocks1 null, 'TAB'
-- ponto 3.3 (observar e comentar locks)
/*
spid	obname	resource	type	mode	status
67	t	                                	TAB 	X	GRANT
Lock:Escalation	60	GSI_AP2	6175	
*/

rollback

-- ponto 4

--******************* Teste 2 ********************
--a)
set statistics time off

if object_id('t') is not null
    drop table t;

create table t(i int primary key, j char(100))

set nocount on
declare @n int = 400000
while @n > 0
begin
    insert into t values(@n, 'A')
	set @n = @n-1
end

-- ponto 5

ALTER TABLE t SET  (LOCK_ESCALATION = TABLE)
checkpoint 1
dbcc dropcleanbuffers

set transaction isolation level repeatable read
begin tran 

-- ponto 6
set statistics time on

 update t set i = i-400000
  -- ponto 7 (anotar tempos de execução -  CPU time e elapsed time)
  /*
  SQL Server parse and compile time: 
   CPU time = 0 ms, elapsed time = 0 ms.

 SQL Server Execution Times:
   CPU time = 1781 ms,  elapsed time = 4262 ms.
  */
set statistics time off
commit
-- ponto 8

 ALTER TABLE t SET  (LOCK_ESCALATION = DISABLE)

checkpoint 1
dbcc dropcleanbuffers
-- ponto 9



set transaction isolation level repeatable read
begin tran

-- ponto 10
set statistics time on

 update t set i = i+400000
  -- ponto 11 (anotar tempos de execução - CPU time e elapsed time)
  /*
  SQL Server parse and compile time: 
   CPU time = 0 ms, elapsed time = 0 ms.

 SQL Server Execution Times:
   CPU time = 1875 ms,  elapsed time = 1965 ms.
  */
set statistics time off
commit
-- ponto 12 (comparar tempos obtidos com as duas opções de lock escalation)
/*
 No ponto 7 houve log Escalation e a atualização de cada um des registos precisa de ser
 feita de forma sequêncial. Enquanto no ponto 12 o SGBD pode atualizar os registos "ao mesmo tempo"
*/


--b)
set statistics time off

if object_id('t') is not null
    drop table t;

create table t(i int primary key, j char(100))

set nocount on
declare @n int = 400000
while @n > 0
begin
    insert into t values(@n, 'A')
	set @n = @n-1
end

-- ponto 13

ALTER TABLE t SET  (LOCK_ESCALATION = TABLE)
checkpoint 1
dbcc dropcleanbuffers

set transaction isolation level  serializable
begin tran 

-- ponto 14
set statistics time on

 update t set i = i-400000
  -- ponto 15 (anotar tempos de execução -  CPU time e elapsed time)
  /*
  SQL Server parse and compile time: 
   CPU time = 0 ms, elapsed time = 4 ms.
SQL Server parse and compile time: 
   CPU time = 0 ms, elapsed time = 0 ms.

 SQL Server Execution Times:
   CPU time = 1875 ms,  elapsed time = 3699 ms.
  */
set statistics time off
commit
-- ponto 16

 ALTER TABLE t SET  (LOCK_ESCALATION = DISABLE)

checkpoint 1
dbcc dropcleanbuffers
-- ponto 17



set transaction isolation level serializable
begin tran

-- ponto 18
set statistics time on

 update t set i = i+400000
  -- ponto 19 (anotar tempos de execução - CPU time e elapsed time)
  /*
  SQL Server parse and compile time: 
   CPU time = 0 ms, elapsed time = 0 ms.
SQL Server parse and compile time: 
   CPU time = 0 ms, elapsed time = 1 ms.
SQL Server parse and compile time: 
   CPU time = 0 ms, elapsed time = 0 ms.

 SQL Server Execution Times:
   CPU time = 1719 ms,  elapsed time = 3604 ms.
  */
set statistics time off
commit
-- ponto 20 (comparar tempos obtidos com as duas opções de lock escalation)
/*
Os tempos são mais ao menos iguais porque o nível de isolamento aumentou.
E o serializable tem que dar mais garantias do que o Repeatable read.
*/




