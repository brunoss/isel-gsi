

USE GSI_AP2;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
SELECT Num, Saldo from Contas where Saldo >= 1000 ;

-- ponto 1 (ir para Ex1Script1, ponto 2)


SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
SELECT Num, Saldo from Contas where Saldo >= 1000 ;

-- ponto 4  (ir para Ex1Script1, ponto 5)
