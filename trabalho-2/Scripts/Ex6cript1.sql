use GSI_AP2;


if object_id('t') is not null
    drop table t;

create table t(i int primary key, j int)


insert into t values(1, 1)

-- ponto -1

select @@spid -- anotar valor
-- ponto 0 (ir para Ex6Script2.sql, ponto 1)


set transaction isolation level repeatable read
declare @x int
begin tran
select @x = j from t where i = 1
set @x = @x+10000
waitfor delay '00:00:20'

SELECT [request_session_id], [resource_type], [resource_description], [request_mode],
[request_type], [request_status] FROM sys.dm_tran_locks WHERE resource_type = 'KEY'

update t set j = @x where i = 1

-- ponto 2 (ir para Ex6Script2.sql, ponto 3)


SELECT [request_session_id], [resource_type], [resource_description], [request_mode],
[request_type], [request_status] FROM sys.dm_tran_locks WHERE resource_type = 'KEY'

commit



-- ponto 4 (ir para Ex6Script2.sql, ponto 5)


set transaction isolation level repeatable read
declare @x int
begin tran
select @x = j from t with(UPDLOCK) where i = 1 
set @x = @x+10000
waitfor delay '00:00:20'
update t set j = @x where i = 1
-- ponto 6 (ir para Ex6Script2.sql, ponto 7)

waitfor delay '00:00:10'
exec verLocks  52 --<spid da sessão onde se executa o código Ex6Script2.sql>

commit

exec verLocks  52 --<spid da sessão onde se executa o código Ex6Script2.sql>
-- ponto 8 (ir para Ex6Script2.sql, ponto 9)

