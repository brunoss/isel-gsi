use GSI_AP2

if object_id('verLocks1') is not null
   drop proc verLocks1;

GO

if not exists (select * from sys.table_types where name = 'tTAb')
   create type tTab as table (
      spid int, dbid int, obid int, IndId int, type nchar(4), resource nchar(32), mode nvarchar(8),
       status nvarchar(5));

create proc verLocks1 @s2 int, @tipo char(3)
as
begin
declare @t tTab
insert into @t  exec sp_lock @spid1 = @@spid, @spid2 = @s2
select spid, object_name(obid) as obname, resource,type, mode, status  from  @t 
                         where object_name(obid) is not null 
						 and	type = @tipo

end