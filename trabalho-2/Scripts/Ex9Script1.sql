
use GSI_AP2;

if exists (select * from sys.tables where name = 't')
drop table t

create table t (i int)
create clustered index ix on t(i)

insert Into t values (1)
insert into t values (2)

update t set i = i+2 where i < 7

select * from t
-- ponto 0 (anotar o resultado)
/*
i
3
4
*/

drop table t
create table t (i int)
create clustered index ix on t(i)
insert into t values (1)
insert into t values (2)
declare c cursor KEYSET for select I from t where i < 7 for update
open c
declare @v int
fetch next from c into @v
while @@FETCH_STATUS = 0
begin
    --update t set i = @v+2 where CURRENT of c
	update t set i = @v+2 where i = @v
    fetch next from c into @v
end
close c
deallocate  c

select * from t

-- ponto 1 (
-- Comentar o resultado
-- H� o problema do Halloween. Onde a clausula where � sempre avaliada at� deixar de ser verdade.
-- O update t set i = @v+2 where CURRENT of c n�o atualiza o valor do cursor e por isso a condi��o vai continuar a verificar-se.
-- O problema pode ser resolvido com a op��o Keyset que coloca os registos numa tabela tempor�ria.