use GSI_AP2;

if exists (select * from sys.objects where name = 't')
   drop table t
create table t (i int primary key, j int)

insert into t values(1,1)
insert into t values(30,30)

SELECT TOP(5) sys.fn_PhysLocFormatter(t.%% physloc %%) as Address,
 t.%% lockres %% as LockHashValue,
 t.* FROM t

-- ponto -1 (anotar resultado)


set transaction isolation level serializable
begin tran
select * from t where i < 15

--ponto 0 (ir para Ex3Script2, ponto 1)

  exec verLocks 62 --<sessão onde corre Ex3Script2>
  -- ponto 3 (anotar e comentar os locks)

rollback
-- ponto 4  (ir para Ex3Script2, ponto 5)