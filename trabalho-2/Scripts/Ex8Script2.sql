use GSI_AP2;


SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
SELECT Num, Saldo from Contas where Num >= 1 ;
--ponto 2
-- ir para utilizador1 (ponto 3)

--ponto 4
--Justificar os resultados do Select
--Deve ter verificado um problema designado "double reads".
-- Diga como o resolveria

