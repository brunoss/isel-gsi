use GSI_AP2;

if exists (select * from sys.objects where name = 't')
   drop table t
create table t (i int primary key, j int)

insert into t values(1,1)
insert into t values(30,30)

SELECT TOP(5) sys.fn_PhysLocFormatter(t.%% physloc %%) as Address,
 t.%% lockres %% as LockHashValue,
 t.* FROM t

-- ponto -1 (anotar resultado)
/*
(1:360:0)	(8194443284a0)	1	1
(1:360:1)	(8034b699f2c9)	30	30
*/

set transaction isolation level serializable
begin tran
select * from t where i <= 1

--ponto 0 (ir para Ex3Script2, ponto 1)

  exec verLocks 53 --<sess�o onde corre Ex3Script2>
  -- ponto 3 (anotar e comentar os locks)
	  /*
	53	t	1:360                           	PAG 	IX	GRANT
	52	t	1:360                           	PAG 	IS	GRANT
	52	t	(8194443284a0)                  	KEY 	RangeS-S	GRANT
	52	t	(8034b699f2c9)                  	KEY 	RangeS-S	GRANT
	53	t	(8034b699f2c9)                  	KEY 	RangeIn-	WAIT
	53	t	                                	TAB 	IX	GRANT
	52	t	                                	TAB 	IS	GRANT

	Lock IX (a sess�o que escreve o valor) a n�vel da p�gina.
	Lock IS (a sess�o que l� o valor) a n�vel da p�gina
	Lock RangeS-S para as dua entradas para a sess�o que l� o valor.

	Lock RangeIn para a entrada (30, 30) pela sess�o que escreve o valor.
	Este lock n�o � compat�vel com o lock anterior.
  */
rollback
-- ponto 4  (ir para Ex3Script2, ponto 5)