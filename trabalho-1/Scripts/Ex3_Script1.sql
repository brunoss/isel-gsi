use GSI_AP1


GO

drop table t


create table t (i int, j int, k int)

GO

set nocount on
declare @i int
set @i = 1
while @i < 2000
begin
  insert into t values(@i,@i,@i)
  set @i = @i+1
end
