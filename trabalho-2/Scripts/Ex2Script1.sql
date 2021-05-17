use GSI_AP2

if exists (select * from sys.objects where name = 't')
   drop table t
create table t (i int, j int)

insert into t values(1,1)
insert into t values(30,30)

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
select spid, object_name(obid) as obname, resource,type, mode, status from  @t 
                         where object_name(obid) is not null 
						 and	type in ('KEY ', 'PAG', 'TAB', 'RID','DB')
end



