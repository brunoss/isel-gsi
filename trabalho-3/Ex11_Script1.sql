-- ponto 0
use GSI_AP3;


IF EXISTS (SELECT * FROM sys.tables where name = 't')
    drop table t;

create table t (x int, y int, lixo char(6000))
set nocount on
declare @n int = 100
while @n > 0
begin
     insert into t values(@n % 40, (@n % 40)+30000,'x')
	 set @n = @n-1
end


-- ponto 1
-- Explicar o plano de execução para a seguinte instrução
select x,y from t where x = 30 or y = 30030  

-- ponto 2
create nonclustered index ix on t(x)
-- Explicar o plano de execução para a seguinte instrução
select x,y from t where x = 30 or y = 30030    


-- ponto 3
create nonclustered index iy on t(y)

-- Explicar o plano de execução para a seguinte instrução
select x,y from t where x = 30 or y = 30030 


-- ponto 4
-- O que é que torna possível a utilização do operador merge join para a concatenação
-- no plano obtido no ponto 3?
