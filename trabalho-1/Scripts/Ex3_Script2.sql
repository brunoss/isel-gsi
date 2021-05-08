use GSI_Ap1
-- ponto 0 (executar apenas)


select i,k from t where i between 100 and 200
select I,K from t where k = 200
--ponto 1 (ver planos de execu��o)
-- Os planos de execu��o s�o os mesmos e � feito um full table scan porque n�o existe indice.

create index i1 on t(i,k)
-- ponto 2 (executar apenas)


select i,k from t where i between 100 and 200
-- Index Seek (NonClustered) porque a clausula where usa uma das colunas do indice e s�o retornadas as colunas que pertencem ao indice

select i,j from t where i between 100 and 200
-- Table Scan o where usa uma das colunas do indice mas � retornada a coluna j que n�o pertence ao indice

select i, k from t where k = 200
-- Index Scan o where usa uma das colunas do indice e s�o retornadas as colunas que pertencem ao indice
-- � feito um Scan porque o k n�o tem que estar ordenado, enquanto o i est� ordenado

select j from t where i = 200 and k = 200
-- Index Seek da chave (i, k) e faz um lookup da entrada para retornar os dados respetivos (coluna j)

--ponto 3 (ver planos de execu��o)



drop index i1 on t
create index i1 on t(i)include(k)
-- ponto 4 (executar apenas)


select i,k from t where i between 100 and 200
-- Index Scan o where usa a coluna i, que � a chave, e s�o retornadas as colunas que pertencem ao indice. Neste caso o k � incluido

select i,j from t where  i between 100 and 200
-- Table Scan porque o j n�o faz parte da chave

select I,K from t where k = 200
-- Index Scan. A coluna k � incluida na chave. � feito um index Scan pelos mesmos motivos de anteriormente. A coluna k n�o est� ordenada s�zinha.

select j from t where i = 200 and k = 200
-- Index Seek da chave (i, k) e faz um lookup da entrada para retornar os dados respetivos (coluna j)
