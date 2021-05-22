use GSI_AP2;


SET TRANSACTION ISOLATION LEVEL Repeatable Read;
begin tran
SELECT Num, Saldo from Contas where Num >= 1 ;
commit
--ponto 2
-- ir para utilizador1 (ponto 3)

--ponto 4
--Justificar os resultados do Select
--Deve ter verificado um problema designado "double reads".
-- Diga como o resolveria

/*
Uma solução é meter o nível de isolamento Repeatable Read em ambas as transações.
E deixar uma das transações abortar.
Se eu não quiser deixar a transação abortar, posso trocar a order das escritas.
Porque dessa forma os locks são adquiridos e libertos pela mesma ordem.

Outra solução é ter o nível de isolamento Read commited.
E fazer a atualização das duas contas num único update
update contas set Num = Num + 5000 where Num = 2 or Num = 1
*/

/*Porque é que com o Repeatable Read não há o phantom?*/