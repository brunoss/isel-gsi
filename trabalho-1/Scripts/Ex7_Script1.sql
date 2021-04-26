use GSI_AP1

create table Tpart1 (i int, j int) on ps(i)

  set nocount on
  declare @i int
  set @i = 0
  while @i < 1000000
  begin
     insert into tpart1 values(@i,-@i)
     set @i = @i+1
  end
  Go

  checkpoint

