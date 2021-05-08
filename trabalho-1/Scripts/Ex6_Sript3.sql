use GSI_AP1;
DBCC TRACEON (3604);

IF EXISTS (SELECT * FROM sys.tables where name = 't')
    drop table t;

create table t(i int, j int)

exec getBtLsn
-- ponto 0 -- anotar valor de boot lsn
-- ou:
--SELECT [Current LSN] FROM fn_dblog (NULL, NULL) where Operation = 'LOP_BEGIN_CKPT';
-- anotar último valor de [Current LSN]
--37:46:179 (0x00000025:0000002e:00b3)

begin tran
insert into t values(1,1)
exec getBtLsn
-- ponto 1 -- anotar valor de boot lsn
-- 37:46:179 (0x00000025:0000002e:00b3)

dbcc ind('gsi_ap1','t',-1) 
dbcc page('gsi_ap1', 1, 328, 3) -- anotar m_lsn da página 1.ª página de dados
-- ponto 2 -- anotar valor de boot m_lsn
-- m_lsn = (37:148:26)

insert into t values(2,2)
exec getBtLsn
-- ponto 3 -- anotar valor de boot lsn
dbcc page('gsi_ap1', 1, 328, 3) -- anotar m_lsn da página 1.ª página de dados
-- ponto 4 -- anotar valor de m_lsn
-- m_lsn = (37:153:1)

checkpoint
exec getBtLsn
-- ponto 5 -- anotar valor de boot lsn
-- desconectar esta janela
-- noutra janela fazer:
-- SHUTDOWN WITH NOWAIT 
-- fazer restart ao sql server
-- ponto 6
-- 37:153:159 (0x00000025:00000099:009f)

--reconectar esta janela

use GSI_AP1;
select * from t
-- ponto 7
-- verificar que a tabela está vazia

-- A tabela está vazia porque não foi feito nenhum commit
