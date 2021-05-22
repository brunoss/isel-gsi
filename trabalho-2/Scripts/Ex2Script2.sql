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


  exec verLocks 53 --<spid da sessão onde corre Ex2Script3>
  -- ponto 3 (anotar e comentar os locks)
  /*spid	obname	resource	type	mode	status
	54	t	                                	TAB 	S	GRANT
	53	t	                                	TAB 	IX	WAIT
	lock a nivel da tabela. Porque não é possivel fazer por gama, uma vez que não há indices.
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

  exec verLocks 53 --<spid da sessão onde corre Ex8Script23>

  -- ponto 9  (anotar e comentar os locks. Ir para Ex2Script3,ponto 10)
  /*
	53	t	1:360                           	PAG 	IX	GRANT
	54	t	1:360                           	PAG 	IS	GRANT
	54	t	(8194443284a0)                  	KEY 	RangeS-S	GRANT
	53	t	(f1de2a205d4a)                  	KEY 	X	GRANT
	53	t	                                	TAB 	IX	GRANT
	54	t	                                	TAB 	IS	GRANT

	Há um lock IX (da sessão 53 que escreve o valor) e IS (que lê o valor) À página 360.
	Estes locks são compatíveis e não há bloqueio

	Há um lock IX e IS a nível da tabela. Estes locks são compatíveis e não há bloqueio.

	Há um lock RangeS-S, lock por gama, para a chave 8194443284a0 (registo 1, 1). 
	Há um lock X, lock exclusivo, para a escrita da entrada (15, 15).
  */
rollback

-- ponto 11 