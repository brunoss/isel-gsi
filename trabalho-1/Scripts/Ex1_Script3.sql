use gsi_ap1



if exists (select object_id from sys.tables where name = 't')
    drop table t

if exists (select object_id from sys.tables where name = 't1')
    drop table t1


create table t (i int, j varchar(2) check (j in ('O','A','B','AB')))
create table t1 (i int, j char(2) check (j in ('O','A','B','AB')))


set statistics IO Off


set nocount on
declare @i int
set @i = 1
while @i <= 2000
begin

    insert into t values(@i,'O')
    insert into t1 values(@i,'O')
    set @i = @i+1
end

alter table t rebuild
alter table t1 rebuild

dbcc checktable('t')
-- ponto 1 (anotar n.º de páginas)
-- 8 páginas
-- Espaço ocupado = 4 (header) + 4 (fixo) + _ (Null Block) + 2*1 + 2 (colunas variáveis)  = 12 bytes
-- 2 + (2 + 7) / 8 = 3 = 15 bytes
-- LPP = 8096 / (15+2) = 476
-- 2000 / 476 = 4.2 -> 5 páginas

dbcc checktable('t1')
-- ponto 2 (anotar n.º de páginas e comparar com o ponto 1)
-- 8 páginas
-- Espaço ocupado = 4 (header) + (4 + 2) (fixo ) + 3 = 13
-- LPP = 8096 / (13+2) = 622
-- 2000 / 540 = 3.7 -> 4 páginas