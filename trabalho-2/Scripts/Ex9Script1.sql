
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

drop table t
create table t (i int)
create clustered index ix on t(i)
insert into t values (1)
insert into t values (2)
declare c /*sensitive*/ cursor for select I from t where i < 7 for update
open c
declare @v int
fetch next from c into @v
while @@FETCH_STATUS = 0
begin
    update t set i = @v+2 where CURRENT of c
	--update t set i = @v+2 where i = @v
    fetch next from c into @v
end
close c
deallocate  c

select * from t

-- ponto 1 (
-- Comentar o resultado
-- Resolver qualquer situação anómala que tenha detetado.









