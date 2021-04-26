use gsi_ap1;
Go
create proc btPgeInfo
as 
begin
  -- GET BOOT PAGE INFO
  DBCC TRACEON (3604);
  DBCC PAGE ('GSI_AP1',1,9,3) with tableresults;
end
Go
create proc getBtLsn
as 
begin
   -- GET BOOT PAGE LAST CHECKPOINT LSN
   declare @tb table(ParentObject varchar(200), Object varchar(300), Field varchar(200), VALUE varchar(300));
   insert into  @tb exec btPgeInfo
   select VALUE from @tb where Field = 'dbi_checkptLSN'
end
Go
