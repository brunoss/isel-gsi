use GSI_AP2;


select @@spid -- anotar valor

-- ponto 1

begin tran
  insert into t values(31,31)

  -- ponto 2 (is para Ex3Script1, ponto 3)

rollback
-- ponto 5
