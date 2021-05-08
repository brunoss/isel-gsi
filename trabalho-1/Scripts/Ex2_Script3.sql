use GSI_AP1

DBCC IND ('GSI_Ap1','t',1)
DBCC IND ('GSI_Ap1','t1',1)
-- ponto 1: verificar estruturas dos clustered indexes

--t1 P�gina de IAM 329, P�gina de Indice 331, 3 p�ginas de dados
--t2 P�gina de IAM 334, P�gina de Indice 305, 5 p�ginas de dados devido ao Fill Factor de 50%

SELECT sys.fn_PhysLocFormatter(%%physloc%%), * FROM t where i BETWEEN 2 AND 20
SELECT sys.fn_PhysLocFormatter(%%physloc%%), * FROM t1 where i BETWEEN 2 AND 20
-- ponto 2 -- verificar estruturas das primeiras p�ginas das folhas
-- Na tabela t existem at� 7 entradas por p�gina, conforme os calculos efetuados anteriormente
-- Na tabela t1 existem at� 4 entradas por p�gina, conforme os calculos efetuados anteriormente

set statistics io on
insert into t values(3,'A')
insert into t1 values(3,'A')
set statistics io off
-- ponto 3 -- verificar n.� de logical reads
--Na tabela t
--Table 't'. Scan count 0, logical reads 7, physical reads 0, page server reads 0, read-ahead reads 0, page server read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob page server reads 0, lob read-ahead reads 0, lob page server read-ahead reads 0.

--Na tabela t1
--Table 't1'. Scan count 0, logical reads 2, physical reads 0, page server reads 0, read-ahead reads 0, page server read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob page server reads 0, lob read-ahead reads 0, lob page server read-ahead reads 0.

--O Fill Factor de 50% resultou num n�mero inferior de logical reads porque existem menos dados na tabela e por isso quando o indice � utilizado � mais f�cil encontrar a entrada respetiva

DBCC IND ('GSI_Ap1','t',1)
DBCC IND ('GSI_Ap1','t1',1)
-- ponto 4: verificar novas estruturas dos clustered indexes

-- Foi criada uma nova p�gina para a tabela t. Porque uma linha ocupa 1013 bytes e a nova linha n�o vai caber nas p�ginas existentes
-- N�o foi criada uma nova p�gina para a tabela t1 Porque a linha cabe numa p�gina e o SGBD pode inserir a linha numa das p�ginas existentes
-- Quando for feito um rebuild ent�o o Fill Factor ser� respeitado novamente e ser� criada uma nova p�gina

SELECT sys.fn_PhysLocFormatter(%%physloc%%), * FROM t where i BETWEEN 2 AND 20
SELECT sys.fn_PhysLocFormatter(%%physloc%%), * FROM t1 where i BETWEEN 2 AND 20
-- ponto 5 -- verificar estruturas das primeiras p�ginas das folhas

-- Na tabela t a nova linha foi inserida na p�gina 328
-- Na tabela t1 a nova linha foi inserida na p�gina 333

insert into t values(15,'B')

-- ponto 6: verificar estrutura do clustered index
DBCC IND ('GSI_Ap1','t',1)

-- N�o foi necess�rio criar uma nova p�gina porque a entrada cabe na p�gina que foi criada anteriormente