use gsi_ap1


if exists (select object_id from sys.objects where name = 't')
    drop table t

if exists (select object_id from sys.objects where name = 't1')
    drop table t1

create table t (i int, j char(1000))

create table t1 (i int, j char(1000))


GO

set statistics IO off

GO


set nocount on
declare @i int
set @i = 1
while @i <= 20
begin

    insert into t values(@i*2,CAST(@i*2 as CHAR(1000)))
    insert into t1 values(@i*2,CAST(@i*2 as CHAR(1000)))
    set @i = @i+1
end

