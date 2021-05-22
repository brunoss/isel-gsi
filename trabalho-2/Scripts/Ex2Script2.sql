use GSI_AP2


SELECT TOP(5) sys.fn_PhysLocFormatter(t.%% physloc %%) as Address,
 t.%% lockres %% as LockHashValue,
 t.* FROM t

-- ponto -1 (anotar resultado)
/*
Address	LockHashValue	i	j
(1:360:0)	1:360:0	1	1
(1:360:1)	1:360:1	30	30
*/

set transaction isolation level serializable
begin tran
select * from t where i < 1
-- ponto 0 (ir para Ex2Script3, ponto 1)


  exec verLocks 53 --<spid da sess�o onde corre Ex2Script3>
  -- ponto 3 (anotar e comentar os locks)
  /*spid	obname	resource	type	mode	status
	54	t	                                	TAB 	S	GRANT
	53	t	                                	TAB 	IX	WAIT
	lock a nivel da tabela. Porque n�o � possivel fazer por gama, uma vez que n�o h� indices.
  */
rollback
  
  -- ponto 4 (ir para Ex2Script3, ponto 5)

if exists (select * from sys.objects where name = 't')
   drop table t
create table t (i int primary key, j int)

insert into t values(1,1)
insert into t values(30,30)

SELECT TOP(5) sys.fn_PhysLocFormatter(t.%% physloc %%) as Address,
 t.%% lockres %% as LockHashValue,
 t.* FROM t

-- ponto 6 (anotar resultado)
/*
(1:360:0)	(8194443284a0)	1	1
(1:360:1)	(8034b699f2c9)	30	30
*/
set transaction isolation level serializable
begin tran
select * from t where i < 1

-- ponto 7 (ir para Ex2Script3, ponto 8)

  exec verLocks 53 --<spid da sess�o onde corre Ex8Script23>

  -- ponto 9  (anotar e comentar os locks. Ir para Ex2Script3,ponto 10)
  /*
	53	t	1:360                           	PAG 	IX	GRANT
	54	t	1:360                           	PAG 	IS	GRANT
	54	t	(8194443284a0)                  	KEY 	RangeS-S	GRANT
	53	t	(f1de2a205d4a)                  	KEY 	X	GRANT
	53	t	                                	TAB 	IX	GRANT
	54	t	                                	TAB 	IS	GRANT

	H� um lock IX (da sess�o 53 que escreve o valor) e IS (que l� o valor) � p�gina 360.
	Estes locks s�o compat�veis e n�o h� bloqueio

	H� um lock IX e IS a n�vel da tabela. Estes locks s�o compat�veis e n�o h� bloqueio.

	H� um lock RangeS-S, lock por gama, para a chave 8194443284a0 (registo 1, 1). 
	H� um lock X, lock exclusivo, para a escrita da entrada (15, 15).
  */
rollback

-- ponto 11 