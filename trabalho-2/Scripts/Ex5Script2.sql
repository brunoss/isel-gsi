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
exec verLocks1 null, 'PAG'
-- ponto 1.2 (observar e comentar locks)
exec verLocks1 null, 'TAB'
-- ponto 1.3 (observar e comentar locks)

update t set i=i+20000 where i >= 50 and i < 5000
exec verLocks1 null, 'RID'
-- ponto 2.1 (observar e comentar locks)
exec verLocks1 null, 'PAG'
-- ponto 2.2 (observar e comentar locks)
exec verLocks1 null, 'TAB'
-- ponto 2.3 (observar e comentar locks)

update t set i=i+20000 where i >= 6000 
exec verLocks1 null, 'RID'
-- ponto 3.1 (observar e comentar locks)
exec verLocks1 null, 'PAG'
-- ponto 3.2 (observar e comentar locks)
exec verLocks1 null, 'TAB'
-- ponto 3.3 (observar e comentar locks)

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

set statistics time off
commit
-- ponto 12 (comparar tempos obtidos com as duas opções de lock escalation)



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

set statistics time off
commit
-- ponto 20 (comparar tempos obtidos com as duas opções de lock escalation)





