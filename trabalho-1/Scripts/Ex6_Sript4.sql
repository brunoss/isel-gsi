use gsi_ap1;

DBCC TRACEON (3604);

IF EXISTS (SELECT * FROM sys.tables where name = 't')
    drop table t;

create table t(i int, j int)

exec getBtLsn
-- ponto 0 -- anotar valor de boot lsn
-- ou:
--SELECT [Current LSN] FROM fn_dblog (NULL, NULL) where Operation = 'LOP_BEGIN_CKPT';
-- anotar último valor de [Current LSN]
-- 37:126:27 (0x00000025:0000007e:001b)

begin tran
insert into t values(1,1)
exec getBtLsn
-- ponto 1 -- anotar valor de boot lsn
-- 37:126:27 (0x00000025:0000007e:001b)

dbcc ind('gsi_ap1','t',-1) 
dbcc page('gsi_ap1', 1, 328, 3) -- anotar m_lsn da página 1.ª página de dados
-- ponto 2 -- anotar valor de boot m_lsn
-- m_lsn = (37:176:49)

insert into t values(2,2)
exec getBtLsn
-- ponto 3 -- anotar valor de boot lsn
-- 37:126:27 (0x00000025:0000007e:001b)
dbcc page('gsi_ap1', 1, 328, 3) -- anotar m_lsn da página 1.ª página de dados
-- ponto 4 -- anotar valor de m_lsn
-- m_lsn = (37:176:53)

commit
exec getBtLsn
-- ponto 5 -- anotar valor de boot lsn
-- 37:126:27 (0x00000025:0000007e:001b)

-- desconectar esta janela
-- noutra janela fazer:
-- SHUTDOWN WITH NOWAIT 
-- fazer restart ao sql server
-- ponto 6

--reconectar a janela 
use GSI_AP1;
select * from t
-- ponto 7
-- verificar que a tabela contém os 2 registos

-- A tabela tem 2 registos porque o commit foi feito
