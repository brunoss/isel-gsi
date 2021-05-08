use GSI_Ap1
-- ponto 0 (executar apenas)


select i,k from t where i between 100 and 200
select I,K from t where k = 200
--ponto 1 (ver planos de execução)
-- Os planos de execução são os mesmos e é feito um full table scan porque não existe indice.

create index i1 on t(i,k)
-- ponto 2 (executar apenas)


select i,k from t where i between 100 and 200
-- Index Seek (NonClustered) porque a clausula where usa uma das colunas do indice e são retornadas as colunas que pertencem ao indice

select i,j from t where i between 100 and 200
-- Table Scan o where usa uma das colunas do indice mas é retornada a coluna j que não pertence ao indice

select i, k from t where k = 200
-- Index Scan o where usa uma das colunas do indice e são retornadas as colunas que pertencem ao indice
-- É feito um Scan porque o k não tem que estar ordenado, enquanto o i está ordenado

select j from t where i = 200 and k = 200
-- Index Seek da chave (i, k) e faz um lookup da entrada para retornar os dados respetivos (coluna j)

--ponto 3 (ver planos de execução)



drop index i1 on t
create index i1 on t(i)include(k)
-- ponto 4 (executar apenas)


select i,k from t where i between 100 and 200
-- Index Scan o where usa a coluna i, que é a chave, e são retornadas as colunas que pertencem ao indice. Neste caso o k é incluido

select i,j from t where  i between 100 and 200
-- Table Scan porque o j não faz parte da chave

select I,K from t where k = 200
-- Index Scan. A coluna k é incluida na chave. É feito um index Scan pelos mesmos motivos de anteriormente. A coluna k não está ordenada sózinha.

select j from t where i = 200 and k = 200
-- Index Seek da chave (i, k) e faz um lookup da entrada para retornar os dados respetivos (coluna j)
