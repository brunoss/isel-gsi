use gSI_Ap1
GO
checkpoint
-- ponto 0
begin tran
insert into t values (0,CAST (0 as CHAR(1000)))
--ponto 1
checkpoint
-- ponto 2
declare @i int
set @i = 1
while @i < 20
begin
   insert into t values (@i,CAST (@i as CHAR(1000)))
   set @i = @i+1
end
-- ponto 3
checkpoint
--ponto 4
insert into t values(100,'100')
--ponto 5
checkpoint
-- ponto 6
commit
-- ponto 7
checkpoint
-- ponto 8
