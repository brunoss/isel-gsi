use GSI_AP2;


select @@spid -- anotar valor
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

update t set j = @x where i = 1


-- ponto 3  (ir para Ex6Script1.sql, ponto 4)

commit -- pode não ser necessário

-- ponto 5 (comentar o que observou)




set transaction isolation level repeatable read
declare @x int
begin tran
select @x = j from t with(UPDLOCK) where i = 1
set @x = @x+30000
waitfor delay '00:00:20'
update t set j = @x where i = 1

-- ponto 7  (ir para Ex6Script1.sql, ponto 8)

commit

-- ponto 9