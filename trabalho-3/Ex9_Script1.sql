-- ponto 0
use GSI_AP3


create  table t2(x int primary key, a char(1000), y nvarchar(2000), y1 nvarchar(2000), z decimal(6,2))


insert into t2 values(1,'a','b','c',2.8)
insert into t2 values(2,'a','b','c',2.8)
insert into t2 values(3,'a','b','c',2.8)
insert into t2 values(4,'a','b','c',2.8)
insert into t2 values(5,'a','b','c',2.8)
insert into t2 values(6,'a','b','c',2.8)
insert into t2 values(7,'a','b','c',2.8)




DBCC TRACEON (3604);


-- ponto 1
-- anotar estrutura de páginas
DBCC IND ('GSI_AP3', 't2',1)
/*
1	362	NULL	NULL	1253579504	1	1	72057594044547072	In-row data	10	NULL	0	0	0	0
1	8504	1	362	1253579504	1	1	72057594044547072	In-row data	1	0	0	0	0	0
*/

-- ponto 2
-- ver estrutura dos slots na 1.ª página de dados
DBCC PAGE ('GSI_AP3',1, 8504,3) 



-- ponto 3
-- anotar percentagem de fragmentação
SELECT alloc_unit_type_desc,index_depth,avg_fragmentation_in_percent
FROM sys.dm_db_index_physical_stats(DB_ID(N'GSI_AP3'),OBJECT_ID(N'T2'),
                                    DEFAULT,DEFAULT,'DETAILED')
WHERE index_level = 0;
/*
alloc_unit_type_desc	index_depth	avg_fragmentation_in_percent
IN_ROW_DATA	1	0
*/

-- ou:
DBCC SHOWCONTIG ('t2')
/*
DBCC SHOWCONTIG scanning 't2' table...
Table: 't2' (1253579504); index ID: 1, database ID: 11
TABLE level scan performed.
- Pages Scanned................................: 1
- Extents Scanned..............................: 1
- Extent Switches..............................: 0
- Avg. Pages per Extent........................: 1.0
- Scan Density [Best Count:Actual Count].......: 100.00% [1:1]
- Logical Scan Fragmentation ..................: 0.00%
- Extent Scan Fragmentation ...................: 0.00%
- Avg. Bytes Free per Page.....................: 900.0
- Avg. Page Density (full).....................: 88.88%
DBCC execution completed. If DBCC printed error messages, contact your system administrator.
*/

-- ponto 4
update t2 set y = replicate('e' ,2000), y1 = replicate('v', 2000) where x % 2 = 0


-- ponto 5
-- anotar estrutura de páginas
DBCC IND ('GSI_AP3', 't2',1)
/*
PageFID	PagePID	IAMFID	IAMPID	ObjectID	IndexID	PartitionNumber	PartitionID	iam_chain_type	PageType	IndexLevel	NextPageFID	NextPagePID	PrevPageFID	PrevPagePID
1	362	NULL	NULL	1253579504	1	1	72057594044547072	In-row data	10	NULL	0	0	0	0
1	8504	1	362	1253579504	1	1	72057594044547072	In-row data	1	0	1	8506	0	0
1	8505	1	362	1253579504	1	1	72057594044547072	In-row data	2	1	0	0	0	0
1	8506	1	362	1253579504	1	1	72057594044547072	In-row data	1	0	1	8507	1	8504
1	8507	1	362	1253579504	1	1	72057594044547072	In-row data	1	0	1	8508	1	8506
1	8508	1	362	1253579504	1	1	72057594044547072	In-row data	1	0	1	8509	1	8507
1	8509	1	362	1253579504	1	1	72057594044547072	In-row data	1	0	0	0	1	8508
1	363	NULL	NULL	1253579504	1	1	72057594044547072	Row-overflow data	10	NULL	0	0	0	0
1	384	1	363	1253579504	1	1	72057594044547072	Row-overflow data	3	0	0	0	0	0
1	385	1	363	1253579504	1	1	72057594044547072	Row-overflow data	3	0	0	0	0	0
*/
-- ponto 6
-- ver estrutura dos slots na 1.ª página de dados
DBCC PAGE ('GSI_AP3', 1, 8504, 3) 
-- usar DBCC PAGE para determinar quais as páginas onde se encontram os dados referentes a x = 2
-- apontar ocorrências de row chaining ou row migration



-- ponto 7
-- anotar percentagem de fragmentação
-- comparar com ponto 3, indicando consequências para o desempenho
SELECT alloc_unit_type_desc,index_depth,avg_fragmentation_in_percent
FROM sys.dm_db_index_physical_stats(DB_ID(N'GSI_AP3'),OBJECT_ID(N'T2'),
                                    DEFAULT,DEFAULT,'DETAILED')
WHERE index_level = 0;
/*
alloc_unit_type_desc	index_depth	avg_fragmentation_in_percent
IN_ROW_DATA	2	20
ROW_OVERFLOW_DATA	1	0
*/
-- ou:
DBCC SHOWCONTIG ('t2')

-- ponto 8

alter table t2 rebuild


-- ponto 9
-- anotar estrutura de páginas
DBCC IND ('GSI_AP3', 't2',1)
/*
PageFID	PagePID	IAMFID	IAMPID	ObjectID	IndexID	PartitionNumber	PartitionID	iam_chain_type	PageType	IndexLevel	NextPageFID	NextPagePID	PrevPageFID	PrevPagePID
1	364	NULL	NULL	1253579504	1	1	72057594044612608	In-row data	10	NULL	0	0	0	0
1	400	1	364	1253579504	1	1	72057594044612608	In-row data	1	0	1	401	1	8480
1	401	1	364	1253579504	1	1	72057594044612608	In-row data	1	0	0	0	1	400
1	440	1	364	1253579504	1	1	72057594044612608	In-row data	2	1	0	0	0	0
1	8480	1	364	1253579504	1	1	72057594044612608	In-row data	1	0	1	400	0	0
1	365	NULL	NULL	1253579504	1	1	72057594044612608	Row-overflow data	10	NULL	0	0	0	0
1	392	1	365	1253579504	1	1	72057594044612608	Row-overflow data	3	0	0	0	0	0
1	393	1	365	1253579504	1	1	72057594044612608	Row-overflow data	3	0	0	0	0	0
*/
-- ponto 10
-- ver estrutura dos slots na 1.ª página de dados
DBCC PAGE ('GSI_AP3',1, 400, 3) 
-- usar DBCC PAGE para determinar quais as páginas onde se encontram os dados referentes a x = 2
-- apontar ocorrências de row chaining ou row migration 



-- ponto 11
-- anotar percentagem de fragmentação
-- comparar com pontos 7 e 3, indicando consequências para o desempenho
SELECT alloc_unit_type_desc,index_depth,avg_fragmentation_in_percent
FROM sys.dm_db_index_physical_stats(DB_ID(N'GSI_AP3'),OBJECT_ID(N'T2'),
                                    DEFAULT,DEFAULT,'DETAILED')
WHERE index_level = 0;
/*
alloc_unit_type_desc	index_depth	avg_fragmentation_in_percent
IN_ROW_DATA	2	33.3333333333333
ROW_OVERFLOW_DATA	1	0
*/

-- ou:
DBCC SHOWCONTIG ('t2')


-- ponto 12
drop table t2
create table t2(x int primary key, a char(1000), y nvarchar(2000), y1 nvarchar(2000), z decimal(6,2))

set nocount on
declare @n int = 1
while @n <= 1000
begin
   insert into t2 values(@n,'a','b','c',2.8)
   set @n = @n+1
end

-- ponto 13
-- anotar estrutura de páginas
DBCC IND ('GSI_AP3', 't2',1)
/*
PageFID	PagePID	IAMFID	IAMPID	ObjectID	IndexID	PartitionNumber	PartitionID	iam_chain_type	PageType	IndexLevel	NextPageFID	NextPagePID	PrevPageFID	PrevPagePID
1	362	NULL	NULL	1285579618	1	1	72057594044678144	In-row data	10	NULL	0	0	0	0
1	8536	1	362	1285579618	1	1	72057594044678144	In-row data	1	0	1	8538	0	0
1	8537	1	362	1285579618	1	1	72057594044678144	In-row data	2	1	0	0	0	0
1	8538	1	362	1285579618	1	1	72057594044678144	In-row data	1	0	1	8539	1	8536
1	8539	1	362	1285579618	1	1	72057594044678144	In-row data	1	0	1	8540	1	8538
1	8540	1	362	1285579618	1	1	72057594044678144	In-row data	1	0	1	8541	1	8539
1	8541	1	362	1285579618	1	1	72057594044678144	In-row data	1	0	1	8542	1	8540
1	8542	1	362	1285579618	1	1	72057594044678144	In-row data	1	0	1	8543	1	8541
1	8543	1	362	1285579618	1	1	72057594044678144	In-row data	1	0	1	8544	1	8542
*/
-- ponto 14
-- ver estrutura dos slots na 1.ª página de dados
DBCC PAGE ('GSI_AP3',1, 8536,3) 


-- ponto 15
-- anotar percentagem de fragmentação
SELECT alloc_unit_type_desc,index_depth,avg_fragmentation_in_percent
FROM sys.dm_db_index_physical_stats(DB_ID(N'GSI_AP3'),OBJECT_ID(N'T2'),
                                    DEFAULT,DEFAULT,'DETAILED')
WHERE index_level = 0;
/*
alloc_unit_type_desc	index_depth	avg_fragmentation_in_percent
IN_ROW_DATA	2	0.699300699300699
*/
-- ou:
DBCC SHOWCONTIG ('t2')


-- ponto 16
update t2 set y = replicate('e' ,2000), y1 = replicate('v' ,2000) where x % 2 = 0


-- ponto 17
-- anotar estrutura de páginas
DBCC IND ('GSI_AP3', 't2',1)
/*
PageFID	PagePID	IAMFID	IAMPID	ObjectID	IndexID	PartitionNumber	PartitionID	iam_chain_type	PageType	IndexLevel	NextPageFID	NextPagePID	PrevPageFID	PrevPagePID
1	362	NULL	NULL	1285579618	1	1	72057594044678144	In-row data	10	NULL	0	0	0	0
1	392	1	362	1285579618	1	1	72057594044678144	In-row data	1	0	1	393	1	8536
1	393	1	362	1285579618	1	1	72057594044678144	In-row data	1	0	1	394	1	392
1	394	1	362	1285579618	1	1	72057594044678144	In-row data	1	0	1	395	1	393
1	395	1	362	1285579618	1	1	72057594044678144	In-row data	1	0	1	8538	1	394
1	396	1	362	1285579618	1	1	72057594044678144	In-row data	1	0	1	397	1	8538
1	397	1	362	1285579618	1	1	72057594044678144	In-row data	1	0	1	398	1	396
1	398	1	362	1285579618	1	1	72057594044678144	In-row data	1	0	1	399	1	397
*/
-- ponto 18
-- ver estrutura dos slots na 1.ª página de dados
DBCC PAGE ('GSI_AP3', 1, 392, 3) 


-- ponto 19
-- anotar percentagem de fragmentação
SELECT alloc_unit_type_desc,index_depth,avg_fragmentation_in_percent
FROM sys.dm_db_index_physical_stats(DB_ID(N'GSI_AP3'),OBJECT_ID(N'T2'),
                                    DEFAULT,DEFAULT,'DETAILED')
WHERE index_level = 0;
/*
alloc_unit_type_desc	index_depth	avg_fragmentation_in_percent
IN_ROW_DATA	3	36.3867684478371
ROW_OVERFLOW_DATA	1	0
*/
-- ou:
DBCC SHOWCONTIG ('t2')

-- ponto 20

alter table t2 rebuild




-- ponto 21
-- anotar estrutura de páginas
DBCC IND ('GSI_AP3', 't2',1)
/*
PageFID	PagePID	IAMFID	IAMPID	ObjectID	IndexID	PartitionNumber	PartitionID	iam_chain_type	PageType	IndexLevel	NextPageFID	NextPagePID	PrevPageFID	PrevPagePID
1	364	NULL	NULL	1285579618	1	1	72057594044743680	In-row data	10	NULL	0	0	0	0
1	1296	1	364	1285579618	1	1	72057594044743680	In-row data	1	0	1	1297	0	0
1	1297	1	364	1285579618	1	1	72057594044743680	In-row data	1	0	1	1298	1	1296
1	1298	1	364	1285579618	1	1	72057594044743680	In-row data	1	0	1	1299	1	1297
1	1299	1	364	1285579618	1	1	72057594044743680	In-row data	1	0	1	1300	1	1298
1	1300	1	364	1285579618	1	1	72057594044743680	In-row data	1	0	1	1301	1	1299
1	1301	1	364	1285579618	1	1	72057594044743680	In-row data	1	0	1	1302	1	1300
*/
-- ponto 22
-- ver estrutura dos slots na 1.ª página de dados
DBCC PAGE ('GSI_AP3',1, 1296, 3) 



-- ponto 23
-- anotar percentagem de fragmentação
-- comparar com o observado no ponto 11
SELECT alloc_unit_type_desc,index_depth,avg_fragmentation_in_percent
FROM sys.dm_db_index_physical_stats(DB_ID(N'GSI_AP3'),OBJECT_ID(N'T2'),
                                    DEFAULT,DEFAULT,'DETAILED')
WHERE index_level = 0;
/*
alloc_unit_type_desc	index_depth	avg_fragmentation_in_percent
IN_ROW_DATA	2	0
ROW_OVERFLOW_DATA	1	0
*/
-- ou:
DBCC SHOWCONTIG ('t2')


-- ponto 24
drop table t2


--(ver informação sobre em )
-- para mais informaçã, ver: https://docs.microsoft.com/en-us/sql/relational-databases/system-dynamic-management-views/sys-dm-db-index-physical-stats-transact-sql?view=sql-server-ver15 e
                  https://docs.microsoft.com/en-us/sql/t-sql/database-console-commands/dbcc-showcontig-transact-sql?view=sql-server-ver15


