
use GSI_AP1
set statistics IO off
set statistics time off
GO
set showplan_text on
-- ponto 0 (executar apenas)





select * from tpart1 where I = 20
-- ponto 1 (execute a instrução anterior e anote e justifique o plano gerado)

select * from tpart1 where I = 20 or I = 60
-- ponto 2(execute a instrução anterior e anote e justifique o plano gerado)


select * from tpart1 where I = 700000
-- ponto 3(execute a instrução anterior e anote e justifique o plano gerado)

select * from tpart1 where I = 20 or I = 700000
-- ponto 4(execute a instrução anterior e anote e justifique o plano gerado)

set showplan_text off
-- ponto 5 (executar apenas)
