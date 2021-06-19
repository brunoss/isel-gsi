
-- ponto 0
use GSI_AP3

create  table t2(x int, a char(1000), y nvarchar(2000), y1 nvarchar(2000), z decimal(6,2))


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
PageFID	PagePID	IAMFID	IAMPID	ObjectID	IndexID	PartitionNumber	PartitionID	iam_chain_type	PageType	IndexLevel	NextPageFID	NextPagePID	PrevPageFID	PrevPagePID
1	362	NULL	NULL	1221579390	0	1	72057594044350464	In-row data	10	NULL	0	0	0	0
1	8560	1	362	1221579390	0	1	72057594044350464	In-row data	1	0	0	0	0	0
*/
-- ponto 2
-- ver estrutura dos slots na 1.ª página de dados
DBCC PAGE ('GSI_AP3',1, 8480,3) 
/*

*/


-- ponto 3
update t2 set y = replicate('e' ,2000), y1 = replicate('v' ,2000) where x % 2 = 0


-- ponto 4
-- anotar estrutura de páginas
DBCC IND ('GSI_AP3', 't2',1)
/*
1	362	NULL	NULL	1221579390	0	1	72057594044350464	In-row data	10	NULL	0	0	0	0
1	8560	1	362	1221579390	0	1	72057594044350464	In-row data	1	0	0	0	0	0
1	8561	1	362	1221579390	0	1	72057594044350464	In-row data	1	0	0	0	0	0
1	8562	1	362	1221579390	0	1	72057594044350464	In-row data	1	0	0	0	0	0
1	8563	1	362	1221579390	0	1	72057594044350464	In-row data	1	0	0	0	0	0
1	363	NULL	NULL	1221579390	0	1	72057594044350464	Row-overflow data	10	NULL	0	0	0	0
1	384	1	363	1221579390	0	1	72057594044350464	Row-overflow data	3	0	0	0	0	0
1	385	1	363	1221579390	0	1	72057594044350464	Row-overflow data	3	0	0	0	0	0
*/

-- ponto 5
-- ver estrutura dos slots na 1.ª página de dados
DBCC PAGE ('GSI_AP3',1, 8480,3) 
-- usar DBCC PAGE para determinar quais as páginas onde se encontram os dados referentes a x = 2
-- apontar ocorrências de row chaining ou row migration



-- ponto 6

alter table t2 rebuild


-- ponto 7
-- anotar estrutura de páginas
DBCC IND ('GSI_AP3', 't2',1)
/*
1	364	NULL	NULL	1237579447	0	1	72057594044481536	In-row data	10	NULL	0	0	0	0
1	8496	1	364	1237579447	0	1	72057594044481536	In-row data	1	0	1	8497	0	0
1	8497	1	364	1237579447	0	1	72057594044481536	In-row data	1	0	1	8498	1	8496
1	8498	1	364	1237579447	0	1	72057594044481536	In-row data	1	0	0	0	1	8497
1	365	NULL	NULL	1237579447	0	1	72057594044481536	Row-overflow data	10	NULL	0	0	0	0
1	392	1	365	1237579447	0	1	72057594044481536	Row-overflow data	3	0	0	0	0	0
1	400	1	365	1237579447	0	1	72057594044481536	Row-overflow data	3	0	0	0	0	0
1	401	1	365	1237579447	0	1	72057594044481536	Row-overflow data	3	0	0	0	0	0
*/

-- ponto 8
-- ver estrutura dos slots na 1.ª página de dados
DBCC PAGE ('GSI_AP3',1, 8496,3) 
-- usar DBCC PAGE para determinar quais as páginas onde se encontram os dados referentes a x = 2
-- apontar ocorrências de row chaining ou row migration 

/*
y1 = [BLOB Inline Root] Slot 1 Column 4 Offset 0x139e Length 24 Length (physical) 24

Level = 0                           Unused = 0                          UpdateSeq = 1
TimeStamp = 2143354880              Type = 2                            
Link 0

Size = 4000                         RowId = (1:400:0)                   

Slot 1 Column 5 Offset 0x3f0 Length 5 Length (physical) 5
*/

-- ponto 9
drop table t2
