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
--Espa�o ocupado = 4 (header) +  1008 (fixo) = 1012 bytes
-- LPP = 8096 / (1012+2) = 7.98 -> 7
-- NPF = n� P�ginas = 800 * 800 / 7 = 91,428.57 -> 91,429
-- NPF = R/LPP

/Clustered
-- ETFI - Espa�o total ocupado pelas colunas fixas do �ndice = 4
-- ETVI - Espa�o total ocupado pelas colunas vari�veis do �ndice, incluindo uniqueifier = 0
-- NBI - 2 + (Num colunas do �ndice,incl. uniquifier + 7) div 8. = 0
-- VBI - Variable Block do �ndice (VBI) 2 + 2* Num colunas vari�veis do �ndice = 0
-- DLI - ETFI + ETVI + VBI + NBI + 1 (header das linhas de �ndice) + 6 (apontador para filho). 
-- DLI = 4 + 0 + 0 + 0 + 1 + 6 = 11
-- LIPP = 8096 / (DLI + 2) = 622.769 = 622
-- NNA = 1 + ROUNDUP(log(LIPP) NPF/LIPP)) = 1 + ceil(log(622, 91429/622)) = 1 + ceil(0.77575) = 1 + 1 = 2
-- (NPI) = SUM N=1 N=NNA ROUNDUP((NPF/LIPP^N)) = ROUNDUP((NPF/LIPPN^1) + ROUNDUP((NPF/LIPPN^2)
-- NPI = ceil(91,429 / 622^1) + ceil(91,429 / 622^2) = 147 + 1 = 148.

/Non Clustered
ETF - Espa�o total ocupado pelas v�rias colunas Fixas = 4 
ENB - Espa�o Null Block = 0
ENB = ENB = 2 + (Numero de colunas nas folhas do �ndice (excluindo locator do tipo RID) + 7) div 8
ENB = 2 + (1 + 7) / 8 = 3
EVT - Espa�o colunas vari�veis = 0
EVT = EV + 2 + N� colunas vari�veis * 2 = 0
LIPS - n� de linhas de �ndice por p�gina nos n�veis superiores
DLIS - A dimens�o de uma linha do �ndice nos n�veis superiores
EAPF - Espa�o com o apontador para a p�gina filha = 6
DLIS = 1 (header) + ETF + ENB + EVT + EAPF + espa�o devido a locator (uniquifier para �ndices non-clustered quando se usam RID)
DLIF = 1 (header) + ETF + ENB + EVT + espa�o devido a locator (quando se usam RID)
DLIF = 1 + 4 + 3 + 0 + 8  = 16 
DLIS = DLIF + 6 = 22
LIPF - n� de linhas de �ndice por p�gina nas folhas
LIPF = (8096 * (FILLFACTOR)/100)  / DLIF + 2) ) = 8096 / 18 = 449.77 = 449
NPFI = R / LIPF = 640000 / 449 = 1425.389 = 1426

LIPS = 8096 / DLIS + 2 = 8096 / 24 = 337.33 = 337
NNA = 1 + ROUNDUP( log(LIPS) NPFI /LIPS)) 
NNA = 1 + ceil( log(337) 1188 / 337) = 1 + ceil( log(337) 3.5252) = 2

Calculamos NPFI = 1426, est� perto das 1451 p�ginas criadas pelo SQL server para o �ndice
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

� criada uma p�gina dicional em rela��o ao �ndice unique.
*/