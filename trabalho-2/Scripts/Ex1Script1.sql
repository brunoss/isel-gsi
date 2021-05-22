CREATE DATABASE GSI_AP2 ON PRIMARY (NAME='GSI_AP2_PRI', FILENAME='D:\gsi\GSI_AP2_PRI.mdf', SIZE=64MB, FILEGROWTH=8MB) 
LOG ON (NAME='GSI_AP2_LOG', FILENAME='D:\gsi\GSI_AP2.ldf', SIZE=64MB, FILEGROWTH=8MB);


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
/*
O nivel de isolamento por omissão é read Commited e isso quer dizer que após
o update do ponto 0 não foi possível fazer a leitura saldo >= 1000

Num	Saldo
1	1000
2	7000
3	5000
*/

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
/*
O nivel de isolamento por omissão é read Commited e isso quer dizer que após
o update do ponto 0 não foi possível fazer a leitura saldo >= 1000

Além disso foi a query retornou uma entrada "phantom" porque foi criado
um índice sobre o Saldo. E o Saldo 1000 foi atualizado para 7000.
Apareceu o valor antigo e o valor atualizado

Num	Saldo
1	1000
3	5000
1	6000
2	7000
*/


