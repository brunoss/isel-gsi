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
/*
(1:360:0)	(8194443284a0)	1	1
(1:360:1)	(8034b699f2c9)	30	30
*/

ALTER DATABASE GSI_AP2
SET ALLOW_SNAPSHOT_ISOLATION ON
GO

set transaction isolation level snapshot
begin tran
select * from t where i < 15
-- ponto 0 (ir para Ex4Script2,ponto 1)

exec verLocks 53 -- <spid da sessão onde corre Ex2Script1>
-- ponto 3  (ir para Ex4Script2, ponto 4)
/*
53	t	1:360                           	PAG 	IX	GRANT
53	t	(600098163675)                  	KEY 	X	GRANT
53	t	                                	TAB 	IX	GRANT

-- Não há locks da sessão do Snapshot!
*/

exec verLocks 53 -- <spid da sessão onde corre Ex2Script1>
-- ponto 5
/*
53	t	1:360                           	PAG 	IX	GRANT
53	t	                                	TAB 	IX	GRANT
53	t	(8194443284a0)                  	KEY 	X	GRANT
53	t	(600098163675)                  	KEY 	X	GRANT

-- Não há locks da sessão do Snapshot!
*/

select * from t
/*
i  j
1	1
30	30
*/
update t set j = j+1 where i = 1
--Fica bloqueado
-- ponto 6 (ir para Ex4Script2 , ponto 7)


-- ponto 8  (ver a janela de mensagens desta sessão)
/*
Msg 3960, Level 16, State 2, Line 49
Snapshot isolation transaction aborted due to update conflict. You cannot use snapshot isolation to access table 'dbo.t' directly or indirectly in database 'GSI_AP2' to update, delete, or insert the row that has been modified or deleted by another transaction. 
Retry the transaction or change the isolation level for the update/delete statement.
*/

select * from t where i = 1

rollback