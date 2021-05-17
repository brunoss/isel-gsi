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


ALTER DATABASE GSI_AP2
SET ALLOW_SNAPSHOT_ISOLATION ON
GO

set transaction isolation level snapshot
begin tran
select * from t where i < 15
-- ponto 0 (ir para Ex4Script2,ponto 1)

exec verLocks 53 -- <spid da sessão onde corre Ex2Script1>

-- ponto 3  (ir para Ex4Script2, ponto 4)

exec verLocks 53 -- <spid da sessão onde corre Ex2Script1>
-- ponto 5

update t set j = j+1 where i = 1

-- ponto 6 (ir para Ex4Script2 , ponto 7)


-- ponto 8  (ver a janela de mensagens desta sessão)