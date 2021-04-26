use GSI_Ap1
-- ponto 0 (executar apenas)


select i,k from t where  i between 100 and 200
select I,K from t where k = 200
--ponto 1 (ver planos de execução)


create index i1 on t(i,k)
-- ponto 2 (executar apenas)


select i,k from t where  i between 100 and 200

select i,j from t where  i between 100 and 200

select I,K from t where k = 200

select j from t where i = 200 and k = 200
--ponto 3 (ver planos de execução)




drop index i1 on t
create index i1 on t(i)include(k)
-- ponto 4 (executar apenas)


select i,k from t where  i between 100 and 200

select i,j from t where  i between 100 and 200

select I,K from t where k = 200

select j from t where i = 200 and k = 200
--ponto 5 (ver planos de execução)
