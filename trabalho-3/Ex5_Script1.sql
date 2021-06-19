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
/*
Table 't1'. Scan count 1, logical reads 302, physical reads 0, page server reads 0, read-ahead reads 0, page server read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob page server reads 0, lob read-ahead reads 0, lob page server read-ahead reads 0.
*/

-- ponto 3
-- verificar número de leituras lógicas
-- comparar com o número obtido no exemplo anterior
select k from  t2 where i between 10 and 20
/*
Table 't2'. Scan count 1, logical reads 37, physical reads 0, page server reads 0, read-ahead reads 0, page server read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob page server reads 0, lob read-ahead reads 0, lob page server read-ahead reads 0.

A tabela t1 tem um indice criado sobre as colunas j e i. 
Mas a ordem é imporante e como é feita uma pesquisa pelo i o SGBD não consegue tirar partido do indice e faz um index scan.
Enquanto a tabela t2 tem um indice criado sobre as colunas i e j em que o i é o primeiro coluna do indice.
E é feito um Index Seek.
*/

DBCC DROPCLEANBUFFERS
-- ponto 4
-- verificar plano e número de leituras lógicas sobre t2
select t2.j from t 
inner join t2 on t.i = t2.i 
where t.i = 20
/*
Table 't2'. Scan count 1, logical reads 7, physical reads 1, page server reads 0, read-ahead reads 0, page server read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob page server reads 0, lob read-ahead reads 0, lob page server read-ahead reads 0.
Table 't'. Scan count 0, logical reads 2, physical reads 1, page server reads 0, read-ahead reads 0, page server read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob page server reads 0, lob read-ahead reads 0, lob page server read-ahead reads 0.
*/


-- ponto 5
-- verificar plano e número de leituras lógicas sobre t1
-- Explicar a diferença do número de leituras lógicas relativamente ao exemplo anterior
-- Propor uma solução que mantendo a chave primária permita reduzir o número de leituras lógicas sobre t1
-- Compare os resultados a que chegar com os obtidos no ponto anterior
select t1.j from t 
inner join t1 on t.i = t1.i 
where t.i = 20
/*
Table 't1'. Scan count 1, logical reads 302, physical reads 0, page server reads 0, read-ahead reads 0, page server read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob page server reads 0, lob read-ahead reads 0, lob page server read-ahead reads 0.
Table 't'. Scan count 0, logical reads 2, physical reads 0, page server reads 0, read-ahead reads 0, page server read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob page server reads 0, lob read-ahead reads 0, lob page server read-ahead reads 0.

Na tabela t2 o indice é construído sobre as colunas i e j e o SGBD consegue tirar partido do indice fazendo um Index Seek.
Na tabela t1 o indice é construído sobre as colunas j e i e o SGBD não consegue tirar partido do indice.
*/

create index IXT1I on t1(i)
drop index IXT1I on t1

drop table t1
drop table t2
drop table t