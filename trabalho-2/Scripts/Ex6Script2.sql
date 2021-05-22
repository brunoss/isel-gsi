use GSI_AP2;


select @@spid -- anotar valor
--61
create table #temp ([request_session_id] varchar(50), [resource_type] varchar(50), [resource_description] varchar(50),
                    [request_mode]  varchar(50), [request_type] varchar(50), [request_status] varchar(50))
-- ponto 1 (ir para Ex6Script1.sql, ponto 2)


set transaction isolation level repeatable read
declare @x int
begin tran
select @x = j from t where i = 1
set @x = @x+30000
waitfor delay '00:00:20'

SELECT [request_session_id], [resource_type], [resource_description], [request_mode],
[request_type], [request_status] FROM sys.dm_tran_locks WHERE resource_type = 'KEY'
/*
61	KEY	(8194443284a0)                                                                                                                                                                                                                                                  	S	LOCK	GRANT
58	KEY	(8194443284a0)                                                                                                                                                                                                                                                  	S	LOCK	GRANT
58	KEY	(8194443284a0)                                                                                                                                                                                                                                                  	X	LOCK	CONVERT
*/
update t set j = @x where i = 1
--(1 row affected)

-- ponto 3  (ir para Ex6Script1.sql, ponto 4)

commit -- pode não ser necessário

-- ponto 5 (comentar o que observou)
-- Esta transação deu deadlock e a outra atualizou o valor



set transaction isolation level repeatable read
declare @x int
begin tran
select @x = j from t with(UPDLOCK) where i = 1
set @x = @x+30000
waitfor delay '00:00:20'
update t set j = @x where i = 1

-- ponto 7  (ir para Ex6Script1.sql, ponto 8)
/*
Msg 1205, Level 13, State 51, Line 40
Transaction (Process ID 61) was deadlocked on lock resources with another process and has been chosen as the deadlock victim. Rerun the transaction.
*/
commit
/*
Msg 3902, Level 16, State 1, Line 50
The COMMIT TRANSACTION request has no corresponding BEGIN TRANSACTION.
*/
-- ponto 9