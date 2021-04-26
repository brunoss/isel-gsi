use GSI_AP1
create  table tpart (i int, j int) on ps(i)
-- ponto 0 (executar apenas)


SELECT * FROM tpart1 WHERE $partition.pf(i) = 1
SELECT * FROM tpart WHERE $partition.pf(i) = 1
-- ponto 1 (observer os resultados das interrogações anteriores)

SET STATISTICS TIME ON
--ponto 2 (executar apenas)

dbcc dropcleanbuffers
insert into tpart select * from tpart1 WHERE $partition.pf(i) = 1
-- ponto 3 (anote o tempo de cpu para a execução)

SET STATISTICS time Off
delete from tpart
SET STATISTICS time ON
-- pont 4 (executar apenas)

dbcc dropcleanbuffers
ALTER TABLE tpart1 SWITCH PARTITION 1 TO tpart PARTITION 1

-- ponto 5 (anote o tempo de cpu para a execução)
-- comparar com o ponto 3)

SET STATISTICS TIME Off
-- ponto 6 (executar apenas)

SELECT * FROM tpart1 WHERE $partition.pf(i) = 1
SELECT * FROM tpart WHERE $partition.pf(i) = 1
-- ponto 7 (confirme a troca)


ALTER TABLE tpart SWITCH PARTITION 1 TO tpart1 PARTITION 1
-- ponto 8 (execute apenas)

