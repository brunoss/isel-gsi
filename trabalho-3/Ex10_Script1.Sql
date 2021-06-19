


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
/*
SQL Server parse and compile time: 
   CPU time = 0 ms, elapsed time = 1 ms.
Table 't3'. Scan count 1, logical reads 1436, physical reads 0, page server reads 0, read-ahead reads 1436, page server read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob page server reads 0, lob read-ahead reads 0, lob page server read-ahead reads 0.

 SQL Server Execution Times:
   CPU time = 15 ms,  elapsed time = 641 ms.
*/
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
/*
SQL Server parse and compile time: 
   CPU time = 0 ms, elapsed time = 1 ms.
Table 't3'. Scan count 1, logical reads 11426, physical reads 4991, page server reads 0, read-ahead reads 1436, page server read-ahead reads 0, lob logical reads 5000, lob physical reads 2500, lob page server reads 0, lob read-ahead reads 0, lob page server read-ahead reads 0.

 SQL Server Execution Times:
   CPU time = 266 ms,  elapsed time = 7568 ms.

Completion time: 2021-06-19T15:20:41.3038493+01:00

*/
-- ponto 4.2: Ver extent scan fragmentation
DBCC SHOWCONTIG('t3')
/*
SQL Server parse and compile time: 
   CPU time = 0 ms, elapsed time = 0 ms.
DBCC SHOWCONTIG scanning 't3' table...
Table: 't3' (1317579732); index ID: 0, database ID: 11
TABLE level scan performed.
- Pages Scanned................................: 6427
- Extents Scanned..............................: 804
- Extent Switches..............................: 803
- Avg. Pages per Extent........................: 8.0
- Scan Density [Best Count:Actual Count].......: 100.00% [804:804]
- Extent Scan Fragmentation ...................: 39.18%
- Avg. Bytes Free per Page.....................: 3351.2
- Avg. Page Density (full).....................: 58.60%
DBCC execution completed. If DBCC printed error messages, contact your system administrator.

 SQL Server Execution Times:
   CPU time = 0 ms,  elapsed time = 11 ms.

Completion time: 2021-06-19T15:21:04.1453853+01:00
*/
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
/*
SQL Server parse and compile time: 
   CPU time = 0 ms, elapsed time = 2 ms.
Table 't3'. Scan count 1, logical reads 5000, physical reads 0, page server reads 0, read-ahead reads 5000, page server read-ahead reads 0, lob logical reads 5000, lob physical reads 2500, lob page server reads 0, lob read-ahead reads 0, lob page server read-ahead reads 0.

 SQL Server Execution Times:
   CPU time = 63 ms,  elapsed time = 1549 ms.
*/
-- ponto 6.2: Ver extent scan fragmentation
DBCC SHOWCONTIG('t3')
/*
SQL Server parse and compile time: 
   CPU time = 0 ms, elapsed time = 0 ms.
DBCC SHOWCONTIG scanning 't3' table...
Table: 't3' (1317579732); index ID: 0, database ID: 11
TABLE level scan performed.
- Pages Scanned................................: 5000
- Extents Scanned..............................: 625
- Extent Switches..............................: 624
- Avg. Pages per Extent........................: 8.0
- Scan Density [Best Count:Actual Count].......: 100.00% [625:625]
- Extent Scan Fragmentation ...................: 24.96%
- Avg. Bytes Free per Page.....................: 2020.0
- Avg. Page Density (full).....................: 75.04%
DBCC execution completed. If DBCC printed error messages, contact your system administrator.

 SQL Server Execution Times:
   CPU time = 15 ms,  elapsed time = 215 ms.

Completion time: 2021-06-19T15:21:42.9605112+01:00
*/

--ponto 7
drop table t3

/*
O rebuild diminiu o número de páginas e optimizou o número de linhas por página.
*/


-- para mais informaçãO, ver: https://docs.microsoft.com/en-us/sql/t-sql/database-console-commands/dbcc-showcontig-transact-sql?view=sql-server-ver15

