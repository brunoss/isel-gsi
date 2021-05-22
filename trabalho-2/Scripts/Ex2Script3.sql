use GSI_AP2


select @@spid -- anotar valor
--53

-- ponto 1

begin tran
  insert into t values(15,15)

 
  -- ponto 2 (ir para Ex2Script2, ponto 3)

rollback

-- ponto 5 (ir para Ex2Script2, ponto 6)

begin tran
  insert into t values(15,15)
  -- ponto 8  (ir para Ex2Script2, ponto 9)

rollback

-- ponto 10 (ir para Ex2Script2, ponto 11)