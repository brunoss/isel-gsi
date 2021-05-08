
use master
drop database GSI_AP1;

CREATE DATABASE GSI_AP1 ON PRIMARY (NAME='GSI_AP1_PRI', FILENAME='D:\gsi\GSI_AP1_PRI.mdf', SIZE=8MB, FILEGROWTH=1MB) 
LOG ON (NAME='GSI_AP1_LOG', FILENAME='D:\gsi\GSI_AP1.ldf', SIZE=8MB, FILEGROWTH=0MB)



--USE master ;  
--ALTER DATABASE GSI_AP1 SET RECOVERY SIMPLE
--GO

use GSI_AP1;
GO

IF object_id('t') IS NOT NULL 
   DROP TABLE t;

create table t (i int primary key, j char(1000))




