use GSI_AP2;



if object_id('t') is not null
    drop table t;

GO

create table t(i int primary key, j int, k int)


insert into t values(1, 1, 1)
insert into t values(2, 2, 2)
insert into t values(3, 3, 3)

create unique nonclustered index i1 on t(j) include(k);

SELECT TOP(5) sys.fn_PhysLocFormatter(t.%% physloc %%) as Address,
 t.%% lockres %% as LockHashValue,
 t.* FROM t -- anotar valores


 
if not exists (select * from sys.table_types where name = 'tTAb')
   create type tTab as table (
      spid int, dbid int, obid int, IndId int, type nchar(4), resource nchar(32), mode nvarchar(8),
       status nvarchar(5));

if object_id('verLocks') is not null
   drop proc verLocks;

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
-- ponto 0 (executar apenas)

set transaction isolation level repeatable read
begin transaction 
select * from t where j = 1

exec verLocks null


-- ponto 1 (anotar e explicar os locks observados)

rollback


drop table t
GO
create table t(i int primary key, j int, k int, l int)


insert into t values(1, 1, 1, 1)
insert into t values(2, 2, 2, 1)
insert into t values(3, 3, 3, 1)

create unique nonclustered index i1 on t(j) include(k);

SELECT TOP(5) sys.fn_PhysLocFormatter(t.%% physloc %%) as Address,
 t.%% lockres %% as LockHashValue,
 t.* FROM t
-- ponto 2 (executar apenas)


set transaction isolation level repeatable read
begin transaction 
select * from t where j = 1


exec verLocks null

-- ponto 3 (anotar e explicar os locks observados)

rollback


set transaction isolation level repeatable read
begin transaction 
select k from t where j = 1

exec verLocks null

-- ponto 4 (anotar e explicar os locks observados)

rollback



drop table t
GO
create table t(i int, j int, k int)


insert into t values(1, 1, 1)
insert into t values(2, 2, 2)
insert into t values(3, 3, 3)

create unique nonclustered index i1 on t(j) include(k);

SELECT TOP(5) sys.fn_PhysLocFormatter(t.%% physloc %%) as Address,
 t.%% lockres %% as LockHashValue,
 t.* FROM t

-- ponto 5 (executar apenas)


set transaction isolation level repeatable read
begin transaction 
select * from t where j = 1

exec verLocks null


-- ponto 6 (anotar e explicar os locks observados)

rollback

set transaction isolation level repeatable read
begin transaction 
select k from t where j = 1

exec verLocks null

-- ponto 7 (anotar e explicar os locks observados)

rollback


-- ponto 8 (comentar a razão porque, na perspectiva do controlo de concorrência com locks,
--          não se devem usar instruções do tipo select * from t where ...