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

DBCC DROPCLEANBUFFERS
-- ponto 1
set statistics io on
-- verifique o n�mero de leituras l�gicas para a seguinte instru��o:
select * from t where i < 20
/*
Table 't'. Scan count 1, logical reads 3, physical reads 0, page server reads 0, read-ahead reads 0, page server read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob page server reads 0, lob read-ahead reads 0, lob page server read-ahead reads 0.
*/

-- ponto 2
-- execute o seguinte c�digo:
set statistics io off
declare @n int = 1
while @n < 100
begin
    update t set lixo = replicate('l',6000) where i = @n
	set @n = @n+1
end

set statistics io on

-- ponto 3
-- verifique o n�mero de leituras l�gicas para a seguinte instru��o:
-- compare com o que observou no ponto 1
select * from t where i < 20
/*
Table 't'. Scan count 1, logical reads 22, physical reads 0, page server reads 0, read-ahead reads 0, page server read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob page server reads 0, lob read-ahead reads 0, lob page server read-ahead reads 0.
Na primeira situa��o a coluna lixo da tabela t tinha s� um caracter e por isso s� foi necess�rio haver 3 leituras.
Na segunda situa��o a coluna lixo tinha 6000 caracters e foi necess�rio haver 22 leituras.
*/
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
--Verifique e compare os planos gerados para as seguintes instru��es
update t set j = j + 10 where i < 50
update t set i = i + 10 where i < 50
/*
Atualizar a chave duma tabela � mais complexo do que atualizar uma coluna que n�o fa�a parte da chave.
*/

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
/*
Table 't'. Scan count 1, logical reads 11, physical reads 0, page server reads 0, read-ahead reads 0, page server read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob page server reads 0, lob read-ahead reads 0, lob page server read-ahead reads 0.
Table 't'. Scan count 0, logical reads 2, physical reads 0, page server reads 0, read-ahead reads 0, page server read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob page server reads 0, lob read-ahead reads 0, lob page server read-ahead reads 0.
Table 't'. Scan count 0, logical reads 2, physical reads 0, page server reads 0, read-ahead reads 0, page server read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob page server reads 0, lob read-ahead reads 0, lob page server read-ahead reads 0.
Table 't'. Scan count 0, logical reads 2, physical reads 0, page server reads 0, read-ahead reads 0, page server read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob page server reads 0, lob read-ahead reads 0, lob page server read-ahead reads 0.
Table 't'. Scan count 0, logical reads 2, physical reads 0, page server reads 0, read-ahead reads 0, page server read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob page server reads 0, lob read-ahead reads 0, lob page server read-ahead reads 0.
Table 't'. Scan count 0, logical reads 2, physical reads 0, page server reads 0, read-ahead reads 0, page server read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob page server reads 0, lob read-ahead reads 0, lob page server read-ahead reads 0.
Table 't'. Scan count 0, logical reads 2, physical reads 0, page server reads 0, read-ahead reads 0, page server read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob page server reads 0, lob read-ahead reads 0, lob page server read-ahead reads 0.
Table 't'. Scan count 0, logical reads 2, physical reads 0, page server reads 0, read-ahead reads 0, page server read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob page server reads 0, lob read-ahead reads 0, lob page server read-ahead reads 0.
Table 't'. Scan count 0, logical reads 2, physical reads 0, page server reads 0, read-ahead reads 0, page server read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob page server reads 0, lob read-ahead reads 0, lob page server read-ahead reads 0.
Table 't'. Scan count 0, logical reads 2, physical reads 0, page server reads 0, read-ahead reads 0, page server read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob page server reads 0, lob read-ahead reads 0, lob page server read-ahead reads 0.

*/
-- ponto 6 (ver output)
select * from t 
/*
i	j	lixo
1	11	l
2	12	l
3	13	l
4	14	l
5	15	l
6	16	l
7	17	l
8	18	l
9	19	l
*/
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
/*
51	1	l
52	2	l
53	3	l
54	4	l
55	5	l
56	6	l
57	7	l
58	8	l
59	9	l
*/

-- ponto 8
drop table t

-- ponto 9 justificar a diferen�a no comportamento nas atualiza��es nos dois casos
/*
No segundo caso � atualizada a chave da tabela e por isso � verificado o problema do Halloween em que as atualiza��es s�o feitas at� a condi��o da query deixar de ocorroer
*/

