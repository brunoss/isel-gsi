use GSI_AP1

DBCC IND ('GSI_Ap1','t',1)
DBCC IND ('GSI_Ap1','t1',1)
-- ponto 1: verificar estruturas dos clustered indexes

--t1 Página de IAM 329, Página de Indice 331, 3 páginas de dados
--t2 Página de IAM 334, Página de Indice 305, 5 páginas de dados devido ao Fill Factor de 50%

SELECT sys.fn_PhysLocFormatter(%%physloc%%), * FROM t where i BETWEEN 2 AND 20
SELECT sys.fn_PhysLocFormatter(%%physloc%%), * FROM t1 where i BETWEEN 2 AND 20
-- ponto 2 -- verificar estruturas das primeiras páginas das folhas
-- Na tabela t existem até 7 entradas por página, conforme os calculos efetuados anteriormente
-- Na tabela t1 existem até 4 entradas por página, conforme os calculos efetuados anteriormente

set statistics io on
insert into t values(3,'A')
insert into t1 values(3,'A')
set statistics io off
-- ponto 3 -- verificar n.º de logical reads
--Na tabela t
--Table 't'. Scan count 0, logical reads 7, physical reads 0, page server reads 0, read-ahead reads 0, page server read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob page server reads 0, lob read-ahead reads 0, lob page server read-ahead reads 0.

--Na tabela t1
--Table 't1'. Scan count 0, logical reads 2, physical reads 0, page server reads 0, read-ahead reads 0, page server read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob page server reads 0, lob read-ahead reads 0, lob page server read-ahead reads 0.

--O Fill Factor de 50% resultou num número inferior de logical reads porque existem menos dados na tabela e por isso quando o indice é utilizado é mais fácil encontrar a entrada respetiva

DBCC IND ('GSI_Ap1','t',1)
DBCC IND ('GSI_Ap1','t1',1)
-- ponto 4: verificar novas estruturas dos clustered indexes

-- Foi criada uma nova página para a tabela t. Porque uma linha ocupa 1013 bytes e a nova linha não vai caber nas páginas existentes
-- Não foi criada uma nova página para a tabela t1 Porque a linha cabe numa página e o SGBD pode inserir a linha numa das páginas existentes
-- Quando for feito um rebuild então o Fill Factor será respeitado novamente e será criada uma nova página

SELECT sys.fn_PhysLocFormatter(%%physloc%%), * FROM t where i BETWEEN 2 AND 20
SELECT sys.fn_PhysLocFormatter(%%physloc%%), * FROM t1 where i BETWEEN 2 AND 20
-- ponto 5 -- verificar estruturas das primeiras páginas das folhas

-- Na tabela t a nova linha foi inserida na página 328
-- Na tabela t1 a nova linha foi inserida na página 333

insert into t values(15,'B')

-- ponto 6: verificar estrutura do clustered index
DBCC IND ('GSI_Ap1','t',1)

-- Não foi necessário criar uma nova página porque a entrada cabe na página que foi criada anteriormente