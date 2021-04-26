use GSI_AP1

if exists (select object_id from sys.objects where name = 't')
    drop table t
if exists (select object_id from sys.objects where name = 't')
    drop table t1


create table t (i int primary key,
                j int not null,
		k char(1000) not null
		)


set nocount on
declare @n int = 1
while @n <= 800*800
begin
    insert into t values(@n,@n,'A')
    set @n = @n+1
end

