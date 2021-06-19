--ponto 0:
use GSI_Ap3

-- ponto 1
-- crie as seguinte tabelas
create table t (i int primary key, j int, lixo varchar(6000))
create table t1 (i int primary key nonclustered, j int, lixo varchar(6000))

set nocount on
declare @n int = 1
while @n < 100
begin
    insert into t values(@n, @n+50000, 'l')
	insert into t1 values(@n, @n+50000, 'l')
	set @n = @n+1
end


-- ponto 2
-- Observe os planos de execução das seguintes instruções
--compare e tente explicar o que leva o Sql Server a produzir esses planos
select * from t where i = 20
select * from t1 where i = 20
/*
A tabela t tem um indice clustered e não precisa de obter as restantes colunas.
Já a tabela t1 tem um indice non clustered e precisa de fazer um RID lookup.
*/

-- ponto 3
-- idem para as seguintes instruções
-- explique também qualquer mudança de estratégia que tenha notado
-- do ponto anterior para este
select * from t where i < 50
select * from t1 where i < 50
/*
A tabela t tem um indice clustered e por isso é feito um Index seek
A tabela t1 tem um indice non clustered e por isso é feito um table scan.
*/

-- ponto 4
drop table t
drop table t1
