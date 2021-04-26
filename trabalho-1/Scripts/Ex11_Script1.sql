use GSI_Ap1

if exists (select object_id from sys.objects where name = 'tc')
    drop table tc

create table tc (i int primary key,
                 j char(5000),
				 k varchar(8000)
                 )

    
set nocount on           
declare @i int
set @i = 0
while @i < 10000
begin
   insert into tc values(@i, cast(@i as char), REPLICATE(cast(@i as char(10)),800))
   set @i = @i + 1
end   




alter table tc rebuild

checkpoint

GO
if exists (select object_id from sys.objects where name = 'getPagesAux')
    drop proc getPagesAux

Go	
create proc getPagesAux
as
begin
      DBCC IND ('GSI_AP1',Tc,-1) --with tableresults;
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




