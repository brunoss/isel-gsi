use master;
DROP DATABASE GSI_AP1;

CREATE DATABASE GSI_AP1
ON PRIMARY (NAME=GSI_AP1_dat, FILENAME='D:\gsi\GSI_AP1.mdf',SIZE=5MB),
FILEGROUP FG1(NAME=FG1_dat,FILENAME='H:\gsi\GSI_AP1_G1.ndf',SIZE=2MB),
FILEGROUP FG2(NAME=FG2_dat,FILENAME='E:\gsi\GSI_AP1_G2.ndf',SIZE=2MB)
LOG ON (NAME=GSI_AP1_log,FILENAME='D:\gsi\GSI_AP1_LOG.mdf',SIZE=2MB,FILEGROWTH=10%)

use GSI_AP1
CREATE PARTITION FUNCTION pf (int) AS RANGE LEFT FOR VALUES (500000)
CREATE PARTITION SCHEME ps AS PARTITION pf TO ([FG1], [FG2])

create table Tpart1 (i int, j int) on ps(i)

  set nocount on
  declare @i int
  set @i = 0
  while @i < 250000
  begin
     insert into tpart1 values(@i,-@i)
     set @i = @i+1
  end
  Go

  checkpoint

