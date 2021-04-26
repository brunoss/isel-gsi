use GSI_AP1

DBCC IND ('GSI_Ap1','t',1)
DBCC IND ('GSI_Ap1','t1',1)
-- ponto 1: verificar estruturas dos clustered indexes


SELECT sys.fn_PhysLocFormatter(%%physloc%%), * FROM t where i BETWEEN 2 AND 20
SELECT sys.fn_PhysLocFormatter(%%physloc%%), * FROM t1 where i BETWEEN 2 AND 20
-- ponto 2 -- verificar estruturas das primeiras páginas das folhas



set statistics io on
insert into t values(3,'A')
insert into t1 values(3,'A')
set statistics io off
-- ponto 3 -- verificar n.º de logical reads



DBCC IND ('GSI_Ap1','t',1)
DBCC IND ('GSI_Ap1','t1',1)
-- ponto 4: verificar novas estruturas dos clustered indexes



SELECT sys.fn_PhysLocFormatter(%%physloc%%), * FROM t where i BETWEEN 2 AND 20
SELECT sys.fn_PhysLocFormatter(%%physloc%%), * FROM t1 where i BETWEEN 2 AND 20
-- ponto 5 -- verificar estruturas das primeiras páginas das folhas




insert into t values(15,'B')

-- ponto 6: verificar estrutura do clustered index
DBCC IND ('GSI_Ap1','t',1)
