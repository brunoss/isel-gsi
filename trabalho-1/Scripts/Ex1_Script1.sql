
drop database GSI_AP1;

CREATE DATABASE GSI_AP1 ON PRIMARY (NAME='GSI_AP1_PRI', FILENAME='D:\gsi\GSI_AP1_PRI.mdf', SIZE=8MB, FILEGROWTH=1MB) 
LOG ON (NAME='GSI_AP1_LOG', FILENAME='D:\gsi\GSI_AP1.ldf', SIZE=8MB, FILEGROWTH=0MB)


use gsi_ap1;

--------- NOTA ------------------------
--Para uma explicação do código destas vistas
-- ver https://www.sqlshack.com/insight-into-the-sql-server-buffer-cache/

IF EXISTS (SELECT * FROM SYS.views WHERE NAME = 'bufferPool_Object')
   drop view bufferPool_Object
Go

create view bufferPool_Object 
as
SELECT
	objects.name AS object_name,
	objects.type_desc AS object_type_description,
	COUNT(*) AS buffer_cache_pages,
	--COUNT(*) * 8 / 1024  AS buffer_cache_used_MB
	COUNT(*) * 8 AS buffer_cache_used_KB -- alterado por Walter Vieira
FROM sys.dm_os_buffer_descriptors
INNER JOIN sys.allocation_units
ON allocation_units.allocation_unit_id = dm_os_buffer_descriptors.allocation_unit_id
INNER JOIN sys.partitions
ON ((allocation_units.container_id = partitions.hobt_id AND type IN (1,3))
OR (allocation_units.container_id = partitions.partition_id AND type IN (2)))
INNER JOIN sys.objects
ON partitions.object_id = objects.object_id
WHERE allocation_units.type IN (1,2,3)
AND objects.is_ms_shipped = 0
AND dm_os_buffer_descriptors.database_id = DB_ID()
GROUP BY objects.name,
		 objects.type_desc
--ORDER BY COUNT(*) DESC;
Go


IF EXISTS (SELECT * FROM SYS.views WHERE NAME = 'bufferPool_DB')
   drop view bufferPool_DB
Go

create view bufferPool_DB
as
-- ESTA QUERY FOI RETIRADA DE: 
SELECT
    databases.name AS database_name,
    --COUNT(*) * 8 / 1024 AS mb_used
	COUNT(*) * 8  AS kb_used -- alterado por Walter Vieira
FROM sys.dm_os_buffer_descriptors
INNER JOIN sys.databases
ON databases.database_id = dm_os_buffer_descriptors.database_id
--where databases.name = 'GSI_AP1'
GROUP BY databases.name
--ORDER BY COUNT(*) DESC
Go


IF EXISTS (SELECT * FROM SYS.views WHERE NAME = 'osInfo')
   drop view osInfo
Go

create view osInfo
as
select * FROM sys.dm_os_sys_info;
Go

------- Fim de nota ------------------------
---------------------------------------------------------------------------

 /*
Alternativas:

IF EXISTS (SELECT * FROM sys.tables where name = 't')
    drop table t;

IF EXISTS (SELECT * FROM sys.objects where name = 't')
    drop table t;

IF object_id('t') IS NOT NULL 
   DROP TABLE t;
*/

if exists (select object_id from sys.objects where name = 't')
    drop table t

if exists (select object_id from sys.objects where name = 't1')
    drop table t1




create table t (i int primary key, j char(5000))
create table t1 (i int, j char(5000))


set statistics IO Off


set nocount on
declare @i int
set @i = 1
while @i <= 20
begin
    insert into t values(@i,REPLICATE('a',5000))
    insert into t1 values(@i,REPLICATE('a',5000))
    set @i = @i+1
end

alter table t rebuild
alter table t1 rebuild

select * from t1 where i = 15
select * from t where i = 15

select * from bufferPool_Object

CHECKPOINT
DBCC DROPCLEANBUFFERS

select * from bufferPool_Object


