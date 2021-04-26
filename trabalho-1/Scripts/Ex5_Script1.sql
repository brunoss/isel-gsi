


--USE master ;  
--ALTER DATABASE GSI_AP1 SET RECOVERY SIMPLE
--GO

use GSI_AP1;
GO

IF object_id('t') IS NOT NULL 
   DROP TABLE t;

create table t (i int primary key, j char(1000))




