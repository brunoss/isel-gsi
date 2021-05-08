use gSI_Ap1
GO
checkpoint
-- ponto 0
/*
Log File(s) Size (KB)	   GSI_AP1 8184
Log File(s) Used Size (KB) GSI_AP1 499
Percent Log Used		   GSI_AP1 6
*/
begin tran
insert into t values (0,CAST (0 as CHAR(1000)))
--ponto 1
/*
Log File(s) Size (KB)	   GSI_AP1 8184
Log File(s) Used Size (KB) GSI_AP1 499
Percent Log Used		   GSI_AP1 6
*/
checkpoint
-- ponto 2
/*
Log File(s) Size (KB)	   GSI_AP1 8184
Log File(s) Used Size (KB) GSI_AP1 515
Percent Log Used		   GSI_AP1 6
*/
declare @i int
set @i = 1
while @i < 20
begin
   insert into t values (@i,CAST (@i as CHAR(1000)))
   set @i = @i+1
end
-- ponto 3
/*
Log File(s) Size (KB)	   GSI_AP1 8184
Log File(s) Used Size (KB) GSI_AP1 515
Percent Log Used		   GSI_AP1 6
*/
checkpoint
--ponto 4
/*
Log File(s) Size (KB)	   GSI_AP1 8184
Log File(s) Used Size (KB) GSI_AP1 548
Percent Log Used		   GSI_AP1 6
*/
insert into t values(100,'100')
--ponto 5
/*
Log File(s) Size (KB)	   GSI_AP1 8184
Log File(s) Used Size (KB) GSI_AP1 548
Percent Log Used		   GSI_AP1 6
*/
checkpoint
-- ponto 6
/*
Log File(s) Size (KB)	   GSI_AP1 8184
Log File(s) Used Size (KB) GSI_AP1 551
Percent Log Used		   GSI_AP1 6
*/
commit
-- ponto 7

/*
Log File(s) Size (KB)	   GSI_AP1 8184
Log File(s) Used Size (KB) GSI_AP1 534
Percent Log Used		   GSI_AP1 6
*/
checkpoint
-- ponto 8
/*
Log File(s) Size (KB)	   GSI_AP1 8184
Log File(s) Used Size (KB) GSI_AP1 536
Percent Log Used		   GSI_AP1 6
*/

-- Semepre que há um checlpoint o valor do log cresce. 
-- Porque todas as transações são escritas no log