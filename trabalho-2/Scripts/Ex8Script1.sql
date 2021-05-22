use GSI_AP2;

--create table contas (num int primary key, saldo float not null)

set transaction isolation level Repeatable Read 
delete from contas
insert into contas values(1,1000)
insert into contas values(2,2000)
insert into contas values(3,3000)
--ponto 0




BEGIN TRAN
update contas set Num = Num + 5000 where Num = 1 --or Num = 1
-- ponto 1
-- ir para utilizador2 (ponto 2)


update contas set Num = Num + 5000 where Num = 2 
COMMIT 
select * from contas
/*
3	3000
5001	1000
5002	2000
*/
-- ponto 3
-- ir para utilizador2 (ponto 4)


