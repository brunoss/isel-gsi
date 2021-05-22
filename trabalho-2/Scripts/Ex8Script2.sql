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
Uma solu��o � meter o n�vel de isolamento Repeatable Read em ambas as transa��es.
E deixar uma das transa��es abortar.
Se eu n�o quiser deixar a transa��o abortar, posso trocar a order das escritas.
Porque dessa forma os locks s�o adquiridos e libertos pela mesma ordem.

Outra solu��o � ter o n�vel de isolamento Read commited.
E fazer a atualiza��o das duas contas num �nico update
update contas set Num = Num + 5000 where Num = 2 or Num = 1
*/

/*Porque � que com o Repeatable Read n�o h� o phantom?*/