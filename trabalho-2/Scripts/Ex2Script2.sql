use GSI_AP2


SELECT TOP(5) sys.fn_PhysLocFormatter(t.%% physloc %%) as Address,
 t.%% lockres %% as LockHashValue,
 t.* FROM t

-- ponto -1 (anotar resultado)


set transaction isolation level serializable
begin tran
select * from t where i < 1
-- ponto 0 (ir para Ex2Script3, ponto 1)


  exec verLocks 63 --<spid da sessão onde corre Ex2Script3>

  -- ponto 3 (anotar e comentar os locks)

rollback
  
  -- ponto 4 (ir para Ex2Script3, ponto 5)

if exists (select * from sys.objects where name = 't')
   drop table t
create table t (i int primary key, j int)

insert into t values(1,1)
insert into t values(30,30)

SELECT TOP(5) sys.fn_PhysLocFormatter(t.%% physloc %%) as Address,
 t.%% lockres %% as LockHashValue,
 t.* FROM t

-- ponto 6 (anotar resultado)

set transaction isolation level serializable
begin tran
select * from t where i < 1

-- ponto 7 (ir para Ex2Script3, ponto 8)

  exec verLocks 63 --<spid da sessão onde corre Ex8Script23>

  -- ponto 9  (anotar e comentar os locks. Ir para Ex2Script3,ponto 10)

rollback

-- ponto 11 