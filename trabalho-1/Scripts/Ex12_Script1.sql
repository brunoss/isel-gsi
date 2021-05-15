use master;
drop database GSI_AP1;

CREATE DATABASE GSI_AP1 ON PRIMARY (NAME='GSI_AP1_PRI', FILENAME='D:\gsi\GSI_AP1_PRI.mdf', SIZE=64MB, FILEGROWTH=8MB) 
LOG ON (NAME='GSI_AP1_LOG', FILENAME='D:\gsi\GSI_AP1.ldf', SIZE=64MB, FILEGROWTH=8MB);

use GSI_AP1;

if exists (select object_id from sys.objects where name = 't')
    drop table t;
if exists (select object_id from sys.objects where name = 't')
    drop table t1;


create table t (i int primary key,
                j int not null,
		k char(1000) not null
		);


set nocount on
declare @n int = 1
while @n <= 800*800
begin
    insert into t values(@n,@n,'A')
    set @n = @n+1
end

--a)

/*
GO
if exists (select object_id from sys.objects where name = 'getPagesAux')
    drop proc getPagesAux

Go	
create proc getPagesAux
as
begin
      DBCC IND ('GSI_AP1',t,-1) --with tableresults;
end

GO
if exists (select object_id from sys.objects where name = 'getPages')
    drop proc getPages

Go
create proc getPages
as 
begin
-- get number of pages of each IAM CHAIN type
   declare @tb table(PageFID int, PagePID int, IAMFID int, IAMPID int, ObjectId int, IndxID int, PartitionBymber int, PartitionId numeric(17),
                     iam_chain_type varchar(20), PageType int, IndexLevel int, NextPageFID int, NextPagePID int,
					  PrevPageFID int, PrevPagePID int);
   insert into  @tb exec  getPagesAux
   select PageType,iam_chain_type, count(*) as Contagem  from @tb group by PageType,iam_chain_type
end

*/
create unique index i1 on t(j);

/*
--Espaço ocupado = 4 (header) +  1008 (fixo) = 1012 bytes
-- LPP = 8096 / (1012+2) = 7.98 -> 7
-- NPF = nº Páginas = 800 * 800 / 7 = 91,428.57 -> 91,429
-- NPF = R/LPP

/Clustered
-- ETFI - Espaço total ocupado pelas colunas fixas do índice = 4
-- ETVI - Espaço total ocupado pelas colunas variáveis do índice, incluindo uniqueifier = 0
-- NBI - 2 + (Num colunas do índice,incl. uniquifier + 7) div 8. = 0
-- VBI - Variable Block do índice (VBI) 2 + 2* Num colunas variáveis do índice = 0
-- DLI - ETFI + ETVI + VBI + NBI + 1 (header das linhas de índice) + 6 (apontador para filho). 
-- DLI = 4 + 0 + 0 + 0 + 1 + 6 = 11
-- LIPP = 8096 / (DLI + 2) = 622.769 = 622
-- NNA = 1 + ROUNDUP(log(LIPP) NPF/LIPP)) = 1 + ceil(log(622, 91429/622)) = 1 + ceil(0.77575) = 1 + 1 = 2
-- (NPI) = SUM N=1 N=NNA ROUNDUP((NPF/LIPP^N)) = ROUNDUP((NPF/LIPPN^1) + ROUNDUP((NPF/LIPPN^2)
-- NPI = ceil(91,429 / 622^1) + ceil(91,429 / 622^2) = 147 + 1 = 148.

/Non Clustered
ETF - Espaço total ocupado pelas várias colunas Fixas = 4 
ENB - Espaço Null Block = 0
ENB = ENB = 2 + (Numero de colunas nas folhas do índice (excluindo locator do tipo RID) + 7) div 8
ENB = 2 + (1 + 7) / 8 = 3
EVT - Espaço colunas variáveis = 0
EVT = EV + 2 + Nº colunas variáveis * 2 = 0
LIPS - nº de linhas de índice por página nos níveis superiores
DLIS - A dimensão de uma linha do índice nos níveis superiores
EAPF - Espaço com o apontador para a página filha = 6
DLIS = 1 (header) + ETF + ENB + EVT + EAPF + espaço devido a locator (uniquifier para índices non-clustered quando se usam RID)
DLIF = 1 (header) + ETF + ENB + EVT + espaço devido a locator (quando se usam RID)
DLIF = 1 + 4 + 3 + 0 + 8  = 16 
DLIS = DLIF + 6 = 22
LIPF - nº de linhas de índice por página nas folhas
LIPF = (8096 * (FILLFACTOR)/100)  / DLIF + 2) ) = 8096 / 18 = 449.77 = 449
NPFI = R / LIPF = 640000 / 449 = 1425.389 = 1426

LIPS = 8096 / DLIS + 2 = 8096 / 24 = 337.33 = 337
NNA = 1 + ROUNDUP( log(LIPS) NPFI /LIPS)) 
NNA = 1 + ceil( log(337) 1188 / 337) = 1 + ceil( log(337) 3.5252) = 2

Calculamos NPFI = 1426, está perto das 1451 páginas criadas pelo SQL server para o índice
--2	In-row data	1451
*/

select * from t
DBCC IND ('GSI_AP1', t,-1)

dbcc checktable('t')
/*
There are 640000 rows in 91429 pages for object "t".
*/


--b)

create index i2 on t(j)
exec getPages
/*
1	In-row data	91429
10	In-row data	2
2	In-row data	1452

É criada uma página dicional em relação ao índice unique.
*/