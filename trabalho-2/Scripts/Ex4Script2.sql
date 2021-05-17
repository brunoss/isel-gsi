use GSI_AP2;

select @@spid -- anotar valor

-- ponto 1

begin tran 
insert into t values(29,29)

-- ponto 2 (ir para Ex4Script1, ponto 3)

update t set j = j+1 where i = 1

-- ponto 4 (ir para Ex4Script1, ponto 5)

commit 

-- ponto 7 (ir para Ex4Script1, ponto 8)

