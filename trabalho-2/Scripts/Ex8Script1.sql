use GSI_AP2;

set transaction isolation level read committed
delete from contas
insert into contas values(1,1000)
insert into contas values(2,2000)
insert into contas values(3,3000)
--ponto 0




BEGIN TRAN
update contas set Num = Num + 5000 where Num = 2
-- ponto 1
-- ir para utilizador2 (ponto 2)


update contas set Num = Num + 5000 where Num = 1 
COMMIT 
select * from contas
-- ponto 3
-- ir para utilizador2 (ponto 4)


