--ponto 0:
use GSI_Ap3


create table t (i int primary key, j int, lixo varchar(6000))


set nocount on
declare @n int = 1
while @n < 100
begin
    insert into t values(@n, @n+50000, 'l')
	set @n = @n+1
end


-- ponto 1
set statistics io on
-- verifique o número de leituras lógicas para a seguinte instrução:
select * from t where i < 20


-- ponto 2
-- execute o seguinte código:
set statistics io off
declare @n int = 1
while @n < 100
begin
    update t set lixo = replicate('l',6000) where i = @n
	set @n = @n+1
end

set statistics io on

-- ponto 3
-- verifique o número de leituras lógicas para a seguinte instrução:
-- compare com o que observou no ponto 1
select * from t where i < 20

set statistics io off

-- ponto 4
delete from t
set nocount on
declare @n int = 1
while @n < 10
begin
    insert into t values(@n, @n, 'l')
	set @n = @n+1
end
--Verifique e compare os planos gerados para as seguintes instruções
update t set j = j+10 where i < 50
update t set i = i+10 where i < 50


-- ponto 5
delete from t
set nocount on
declare @n int = 1
while @n < 10
begin
    insert into t values(@n, @n, 'l')
	set @n = @n+1
end

declare @j int
declare c cursor for select j from t where i < 50
open c
fetch next from c into @j
while @@FETCH_STATUS = 0
begin
    update t set j = @j+10 where current of c
    fetch next from c into @j
end
close c
deallocate c

-- ponto 6 (ver output)
select * from t 

delete from t
set nocount on
declare @n int = 1
while @n < 10
begin
    insert into t values(@n, @n, 'l')
	set @n = @n+1
end

declare @i int
declare c cursor for select i from t where i < 50
open c
fetch next from c into @i
while @@FETCH_STATUS = 0
begin
    update t set i = @i+10 where current of c
    fetch next from c into @i
end
close c
deallocate c

-- ponto 7 (ver output)
select * from t 

-- ponto 8
drop table t

-- ponto 9 justificar a diferença no comportamento nas atualizações nos dois casos


