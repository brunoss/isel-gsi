use GSI_AP2;



if object_id('t') is not null
    drop table t;

GO

create table t(i int primary key, j int, k int)


insert into t values(1, 1, 1)
insert into t values(2, 2, 2)
insert into t values(3, 3, 3)

create unique nonclustered index i1 on t(j) include(k);

SELECT TOP(5) sys.fn_PhysLocFormatter(t.%% physloc %%) as Address,
 t.%% lockres %% as LockHashValue,
 t.* FROM t -- anotar valores
 /*
 Address	LockHashValue	i	j	k
(1:8104:0)	(8194443284a0)	1	1	1
(1:8104:1)	(61a06abd401c)	2	2	2
(1:8104:2)	(98ec012aa510)	3	3	3
 */

 
if not exists (select * from sys.table_types where name = 'tTAb')
   create type tTab as table (
      spid int, dbid int, obid int, IndId int, type nchar(4), resource nchar(32), mode nvarchar(8),
       status nvarchar(5));

if object_id('verLocks') is not null
   drop proc verLocks;

GO

create proc verLocks @s2 int
as
begin
declare @t tTab
insert into @t  exec sp_lock @spid1 = @@spid, @spid2 = @s2
select spid, object_name(obid) as obname, resource,type, indId, mode, status  from  @t 
                         where object_name(obid) is not null 
						 and	type in ('KEY ', 'PAG', 'TAB', 'RID','DB')
end
-- ponto 0 (executar apenas)

set transaction isolation level repeatable read
begin transaction 
select * from t where j = 1

exec verLocks null
/*
54	t	(8194443284a0)                  	KEY 	2	S	GRANT
54	t	1:16200                         	PAG 	2	IS	GRANT
54	t	                                	TAB 	0	IS	GRANT
É adquirido um lock shared para j=1 (8194443284a0).
Adquirido um lock IS para apágina e para a tabela
*/

-- ponto 1 (anotar e explicar os locks observados)

exec sp_lock @spid1 = @@spid, @spid2 = 54 

rollback


drop table t
GO
create table t(i int primary key, j int, k int, l int)


insert into t values(1, 1, 1, 1)
insert into t values(2, 2, 2, 1)
insert into t values(3, 3, 3, 1)

create unique nonclustered index i1 on t(j) include(k);

SELECT TOP(5) sys.fn_PhysLocFormatter(t.%% physloc %%) as Address,
 t.%% lockres %% as LockHashValue,
 t.* FROM t
-- ponto 2 (executar apenas)
/*
Address	LockHashValue	i	j	k	l
(1:328:0)	(8194443284a0)	1	1	1	1
(1:328:1)	(61a06abd401c)	2	2	2	1
(1:328:2)	(98ec012aa510)	3	3	3	1
*/

set transaction isolation level repeatable read
begin transaction 
select * from t where j = 1


exec verLocks null
/*
spid	obname	resource	type	indId	mode	status
54	t	1:328                           	PAG 	1	IS	GRANT
54	t	                                	TAB 	0	IS	GRANT
54	t	(8194443284a0)                  	KEY 	2	S	GRANT
54	t	(8194443284a0)                  	KEY 	1	S	GRANT
54	t	1:8424                          	PAG 	2	IS	GRANT

2 Locks Shared de leitura para o registo 
2 Locks IS para a página 
1 Lock IS para a tabelã

Ao contrario de anteriormente é necessário ter dois locks, um para cada indice, porque a coluna l não faz parte de nenhum dos índices.
*/
-- ponto 3 (anotar e explicar os locks observados)

rollback


set transaction isolation level repeatable read
begin transaction 
select k from t where j = 1

exec verLocks null
/*
spid	obname	resource	type	indId	mode	status
54	t	                                	TAB 	0	IS	GRANT
54	t	(8194443284a0)                  	KEY 	2	S	GRANT
54	t	1:8424                          	PAG 	2	IS	GRANT

A coluna l não é selecionada e já não é preciso os dois locks do ponto 3.
O k está incluido no indice da coluna j e a coluna j é utilizada no where.
*/
-- ponto 4 (anotar e explicar os locks observados)

rollback



drop table t
GO
create table t(i int, j int, k int)


insert into t values(1, 1, 1)
insert into t values(2, 2, 2)
insert into t values(3, 3, 3)

create unique nonclustered index i1 on t(j) include(k);

SELECT TOP(5) sys.fn_PhysLocFormatter(t.%% physloc %%) as Address,
 t.%% lockres %% as LockHashValue,
 t.* FROM t
 /*
Address	LockHashValue	i	j	k
(1:16520:0)	1:16520:0	1	1	1
(1:16520:1)	1:16520:1	2	2	2
(1:16520:2)	1:16520:2	3	3	3
 */
-- ponto 5 (executar apenas)


set transaction isolation level repeatable read
begin transaction 
select * from t where j = 1

exec verLocks null
/*
spid	obname	resource	type	indId	mode	status
54	t	1:328                           	PAG 	2	IS	GRANT
54	t	(8194443284a0)                  	KEY 	2	S	GRANT
54	t	                                	TAB 	0	IS	GRANT
54	t	1:16520:0                       	RID 	0	S	GRANT
54	t	1:16520                         	PAG 	0	IS	GRANT

1 Lock Shared de leitura dobre a entrada 8194443284a0 j = 1
2 lock IS à página 
1 lock IS à tabela
1 lock Shared RID para ir buscar a coluna i
*/

-- ponto 6 (anotar e explicar os locks observados)

rollback

set transaction isolation level repeatable read
begin transaction 
select k from t where j = 1

exec verLocks null
/*
spid	obname	resource	type	indId	mode	status
54	t	1:328                           	PAG 	2	IS	GRANT
54	t	(8194443284a0)                  	KEY 	2	S	GRANT
54	t	                                	TAB 	0	IS	GRANT

Já não é necessário o lock do RID porque o k é incluido na chave e o j faz parte do indice
*/
-- ponto 7 (anotar e explicar os locks observados)

rollback


-- ponto 8 (comentar a razão porque, na perspectiva do controlo de concorrência com locks,
--          não se devem usar instruções do tipo select * from t where ...

/*
Se fizermos select * vão ser criados mais locks e por isso vai haver mais contenção de dados.
*/