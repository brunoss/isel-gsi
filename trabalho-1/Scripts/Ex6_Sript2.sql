use gsi_ap1;
DBCC TRACEON (3604);

IF EXISTS (SELECT * FROM sys.tables where name = 't')
    drop table t;

create table t(i int, j int)

exec getBtLsn
-- ou:
--SELECT [Current LSN],Operation FROM fn_dblog (NULL, NULL) where Operation in('LOP_BEGIN_CKPT','LOP_XACT_CKPT','LOP_BEGIN_XACT');
-- anotar último valor de [Current LSN] para LOP_BEGIN_CKPT

-- ponto 0 -- anotar valor de boot lsn
-- 37:46:179 (0x00000025:0000002e:00b3)

begin tran
exec getBtLsn
-- ponto 1 -- anotar valor de boot lsn
-- 37:46:179 (0x00000025:0000002e:00b3)

insert into t values(1,1)
exec getBtLsn
-- ponto 2 -- anotar valor de boot lsn
-- 37:46:179 (0x00000025:0000002e:00b3)

dbcc ind('gsi_ap1', 't',-1) 
dbcc page('gsi_ap1', 1, 328, 3) -- anotar m_lsn da página 1.ª página de dados
-- ponto 3 -- anotar valor de boot m_lsn
--m_lsn = (37:148:26)

insert into t values(2,2)
exec getBtLsn
-- ponto 4 -- anotar valor de boot lsn
-- 37:46:179 (0x00000025:0000002e:00b3)

dbcc page('gsi_ap1', 1, 328, 3) -- anotar m_lsn da página 1.ª página de dados
-- ponto 5 -- anotar valor de m_lsn
-- m_lsn = (37:148:28)

checkpoint
exec getBtLsn
-- ponto 6 -- anotar valor de boot lsn
-- 37:148:186 (0x00000025:00000094:00ba)

commit
exec getBtLsn
-- ponto 7 -- anotar valor de boot lsn
-- 37:148:186 (0x00000025:00000094:00ba)

checkpoint
exec getBtLsn
-- ponto 8 -- anotar valor de boot lsn
-- 37:221:1 (0x00000025:000000dd:0001)

-- À medida que os checkpoints vão sendo feitos o valor do Lsn vai aumentando
-- À medida que vão sendo inserindo dados nas páginas o LSN da oágina vai aumentando

