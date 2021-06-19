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
-- Explicar o plano de execu��o para a seguinte instru��o
select x,y from t where x = 30 or y = 30030  
/*
N�o existe indice nenhum e por isso � necess�rio fazer um table scan.
*/
-- ponto 2
create nonclustered index ix on t(x)
-- Explicar o plano de execu��o para a seguinte instru��o
select x,y from t where x = 30 or y = 30030    
/*
O SGBD optou por fazer um table scan porque o y � utilizado na clausula where e n�o faz parte do indice
*/

-- ponto 3
create nonclustered index iy on t(y)

-- Explicar o plano de execu��o para a seguinte instru��o
select x,y from t where x = 20 or y = 30030 
/*
Foi feito um index seek para cada um dos indices e foi feito o merge dos resultados.
*/

-- ponto 4
-- O que � que torna poss�vel a utiliza��o do operador merge join para a concatena��o
-- no plano obtido no ponto 3?
/*
A utiliza��o do operador merge join � poss�vel porque h� ordem nos registos utilizados. 
O operador percorre os registos por ordem de valores.  Um exemplo mais interessante de analisar seria o seguinte

select x, y from t where x = 20 or x = 39
x	y
20	30020
20	30020
20	30020
39	30039
39	30039

select x, y from t where y = 30030 or y =30027
x	y
27	30027
27	30027
30	30030
30	30030

O que o Merge faz � retornar os primeiros 3 registos da primeira query, depois os 2 primeiros registos da segunda query.
De seguida os dois �ltimos registos da segunda query e por fim os 2 �ltimos registos da primeira query.

*/

select x, y from t where x = 20 or x = 39
/*
20	30020
20	30020
20	30020
*/
select x, y from t where y = 30030 or y =30027
/*
30	30030
30	30030
*/
