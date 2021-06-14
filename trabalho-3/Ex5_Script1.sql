--ponto 0:
use GSI_AP3


-- ponto 1
-- cria as seguintes tabelas



create table t (i int primary key, lixo char(6000))

create table t1 (i int references t, j int, k int, lixo char(6000), primary key(j,i))

create table t2 (i int references t, j int, k int, lixo char(6000), primary key(i,j))


set nocount on
declare @n int = 100
while @n > 0
begin
    insert into t values(@n,'l')
	insert into t1 values(@n,1,5,'l'),(@n,2,6,'l'),(@n,3,7,'l')
	insert into t2 values(@n,1,5,'l'),(@n,2,6,'l'),(@n,3,7,'l')
	set @n = @n -1
end


--ponto 2
set statistics io on
-- verificar número de leituras lógicas
select k from  t1 where i between 10 and 20

-- ponto 3
-- verificar número de leituras lógicas
-- comparar com o número obtido no exemplo anterior
select k from  t2 where i between 10 and 20


-- ponto 4
-- verificar plano e número de leituras lógicas sobre t2
select t2.j from t inner join t2 on t.i = t2.i where t.i = 20



-- ponto 5
-- verificar plano e número de leituras lógicas sobre t1
-- Explicar a diferença do número de leituras lógicas relativamente ao exemplo anterior
-- Propor uma solução que mantendo a chave primária permita reduzir o número de leituras lógicas sobre t1
-- Compare os resultados a que chegar com os obtidos no ponto anterior
select t1.j from t inner join t1 on t.i = t1.i where t.i = 20



drop table t1
drop table t2
drop table t