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
  insert into t values(@i,1,@i)
  set @i = @i+1
end


GO

create unique index i1 on t(i)
      where k >= 100 and k <= 200


GO

-- ponto 0 (executar apenas)



select i from  t where k = 40 and i = 40
-- Foi feito um Table Scan porque o indice está limitado à gama k >= 100 and k <= 200

select j from  t with (index=i1) where k = 140 and i = 140
-- É feito um Index Seek da chave e o lookup do valor. A clasula where usa a coluna i e k. 
-- A coluna i faz parte do indice e a coluna k respeita a condição indicada no indice. 
-- É como se a coluna k estivesse incluida para a gama k >= 100 and k <= 200.

-- ponto 1 (ver planos de execução)



