use GSI_AP2;

if object_id('verLocks') is not null
   drop proc verLocks;

GO

if not exists (select * from sys.table_types where name = 'tTAb')
   create type tTab as table (
      spid int, dbid int, obid int, IndId int, type nchar(4), resource nchar(32), mode nvarchar(8),
       status nvarchar(5));

GO

create proc verLocks @s2 int
as
begin
declare @t tTab
insert into @t  exec sp_lock @spid1 = @@spid, @spid2 = @s2
select spid, object_name(obid) as obname, resource,type, indId, mode, status  from  @t 
                         where object_name(obid) is not null 
						 and	type in ('KEY ', 'PAG', 'TAB', 'RID','DB')
end

if object_id('t') is not null
    drop table t;

create table t(i int primary key, j int)


insert into t values(1, 1)

-- ponto -1

select @@spid -- anotar valor
-- 58
-- ponto 0 (ir para Ex6Script2.sql, ponto 1)


set transaction isolation level repeatable read
declare @x int
begin tran
select @x = j from t where i = 1
set @x = @x+10000
waitfor delay '00:00:20'

SELECT [request_session_id], [resource_type], [resource_description], [request_mode],
[request_type], [request_status] FROM sys.dm_tran_locks WHERE resource_type = 'KEY'
/*
request_session_id	resource_type	resource_description	request_mode	request_type	request_status
61	KEY	(8194443284a0)                                                                                                                                                                                                                                                  	S	LOCK	GRANT
58	KEY	(8194443284a0)                                                                                                                                                                                                                                                  	S	LOCK	GRANT
*/

update t set j = @x where i = 1
/*
Msg 1205, Level 13, State 51, Line 29
Transaction (Process ID 58) was deadlocked on lock resources with another process and has been chosen as the deadlock victim. Rerun the transaction.
*/

-- ponto 2 (ir para Ex6Script2.sql, ponto 3)


SELECT [request_session_id], [resource_type], [resource_description], [request_mode],
[request_type], [request_status] FROM sys.dm_tran_locks WHERE resource_type = 'KEY'
/*
61	KEY	(8194443284a0)                                                                                                                                                                                                                                                  	X	LOCK	GRANT
*/
commit
/*
Msg 3902, Level 16, State 1, Line 48
The COMMIT TRANSACTION request has no corresponding BEGIN TRANSACTION.
*/


-- ponto 4 (ir para Ex6Script2.sql, ponto 5)


set transaction isolation level repeatable read
declare @x int
begin tran
select @x = j from t with(UPDLOCK) where i = 1 
set @x = @x+10000
waitfor delay '00:00:20'
update t set j = @x where i = 1
/*
(1 row affected)
*/
-- ponto 6 (ir para Ex6Script2.sql, ponto 7)

waitfor delay '00:00:10'
exec verLocks  58 --<spid da sessão onde se executa o código Ex6Script2.sql>

commit
/*
58	t	(8194443284a0)                  	KEY 	1	X	GRANT
58	t	1:8424                          	PAG 	1	IX	GRANT
58	t	                                	TAB 	0	IX	GRANT
*/

exec verLocks  58 --<spid da sessão onde se executa o código Ex6Script2.sql>
-- ponto 8 (ir para Ex6Script2.sql, ponto 9)
--Não há locks