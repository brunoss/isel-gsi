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

begin tran
exec getBtLsn
-- ponto 1 -- anotar valor de boot lsn

insert into t values(1,1)
exec getBtLsn
-- ponto 2 -- anotar valor de boot lsn

dbcc ind('gsi_ap1','t',-1) 
dbcc page('gsi_ap1',1,<1.ª página de dados>,3) -- anotar m_lsn da página 1.ª página de dados
-- ponto 3 -- anotar valor de boot m_lsn

insert into t values(2,2)
exec getBtLsn
-- ponto 4 -- anotar valor de boot lsn
dbcc page('gsi_ap1',1,<1.ª página de dados>,3) -- anotar m_lsn da página 1.ª página de dados
-- ponto 5 -- anotar valor de m_lsn

checkpoint
exec getBtLsn
-- ponto 6 -- anotar valor de boot lsn
commit
exec getBtLsn
-- ponto 7 -- anotar valor de boot lsn

checkpoint
exec getBtLsn
-- ponto 8 -- anotar valor de boot lsn




