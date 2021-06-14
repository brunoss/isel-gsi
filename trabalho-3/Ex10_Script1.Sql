


-- ponto 0
use GSI_AP3

DBCC TRACEON (3604);


IF EXISTS (SELECT * FROM sys.tables where name = 't3')
    drop table t3;

create table t3(x int, a char(1000), y nvarchar(2000), y1 nvarchar(2000), z decimal(6,2))


declare @n int = 10000
set nocount on
while @n > 0
begin
   insert into t3 values(@n,'a','b','c',2.8)
   set @n = @n-1
end

-- ponto 1
checkpoint 
dbcc dropcleanbuffers
set statistics io on
set statistics time on


-- ponto 2
-- ponto 2.1: Executar e anotar tempos de execução (CPU e elapsed) e número de leituras de páginas
select * from t3

-- ponto 2.2: ver Extent Scan fragmantation
DBCC SHOWCONTIG('t3')

-- ponto 3
set statistics time off
set statistics io off
update t3 set y = replicate('e' ,2000), y1 = replicate('v' ,2000) where x % 2 = 0

checkpoint 
dbcc dropcleanbuffers
set statistics io on
set statistics time on


--  ponto 4: 
-- ponto 4.1: Executar e anotar tempos de execução (CPU e elapsed) e número de leituras de páginas
select * from t3

-- ponto 4.2: Ver extent scan fragmentation
DBCC SHOWCONTIG('t3')

-- ponto 5
set statistics time off
set statistics io off
alter table t3 rebuild

checkpoint 
dbcc dropcleanbuffers
set statistics io on
set statistics time on


-- ponto 6: 
-- ponto 6.1: Executar e anotar tempos de execução (CPU e elapsed) e número de leituras de páginas
select * from t3

-- ponto 6.2: Ver extent scan fragmentation
DBCC SHOWCONTIG('t3')


--ponto 7
drop table t3




-- para mais informaçãO, ver: https://docs.microsoft.com/en-us/sql/t-sql/database-console-commands/dbcc-showcontig-transact-sql?view=sql-server-ver15

