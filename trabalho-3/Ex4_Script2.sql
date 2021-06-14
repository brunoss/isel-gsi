
-- ponto 0:
use GSI_Ap3

-- ponto 1
-- criar a tabela seguinte
create table tpart (i int, j int) on ps(i)

  set nocount on
  declare @i int
  set @i = 0
  while @i < 10000
  begin
     insert into tpart values(@i,-@i)
     set @i = @i+1
  end


-- ponto 2
-- criar a tabela seguinte
create table t (i int, j int)
  set nocount on
  declare @i int
  set @i = 0
  while @i < 10000
  begin
     insert into t values(@i,-@i)
     set @i = @i+1
  end


  -- ponto 3
   set statistics io on
  -- verificar número de leituras lógicas
  select * from t where i = 1000


  -- ponto 4
  -- verificar número de leituras lógicas e comparar
  -- com o número do ponto anterior
  select * from tpart where i = 1000

set statistics io off
drop table t
drop table tpart



