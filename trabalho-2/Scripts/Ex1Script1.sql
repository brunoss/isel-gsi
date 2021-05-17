use GSI_AP2;


create table contas (num int primary key, saldo float not null)

insert into contas values(1,1000)
insert into contas values(2,2000)
insert into contas values(3,5000)

BEGIN TRAN
update contas set Saldo = Saldo + 5000 where Saldo = 2000

-- ponto 0 (ir para Ex1Script2, ponto 1)

update contas set Saldo = Saldo + 5000 where Saldo = 1000
COMMIT TRAN;
--ponto 2  (ver e explicar resultados de Ex1Script2)

delete from contas
insert into contas values(1,1000)
insert into contas values(2,2000)
insert into contas values(3,5000)
CREATE NONCLUSTERED INDEX Ix on Contas(Saldo)
GO

BEGIN TRAN
update contas set Saldo = Saldo + 5000 where Saldo = 2000

-- ponto 3  (ir para Ex1Script2, ponto 4)

update contas set Saldo = Saldo + 5000 where Saldo = 1000
COMMIT TRAN;
--ponto 5 (ver e explicar resultados de Ex1Script2)



