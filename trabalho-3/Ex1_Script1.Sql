use AdventureWorks2019

---------------- Exercicio 1 -------------------
--ponto 1
-- Execute as seguinte instução e anote os valores do histograma para ProductId = 852 e para ProductId = 790
dbcc show_statistics ('Sales.SalesOrderDetail',IX_SalesOrderDetail_ProductID)
dbcc freeproccache

set statistics io on
/*
790	0	377	0	1
852	0	422	0	1
*/


--ponto 2
-- observe qual o plano de execução produzido para a instrução seguinte
-- execute a instrução e anote o número de logical reads
select * from Sales.SalesOrderDetail where ProductID = 852 
dbcc freeproccache
/*
(422 rows affected)
Table 'SalesOrderDetail'. Scan count 1, logical reads 1248, physical reads 3, page server reads 0, read-ahead reads 1244, page server read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob page server reads 0, lob read-ahead reads 0, lob page server read-ahead reads 0.
DBCC execution completed. If DBCC printed error messages, contact your system administrator.
*/

--ponto 3
-- observe qual o plano de execução produzido para a instrução seguinte
-- explique a razão porque o plano é diferente do do ponto anterior
-- execute a instrução e anote o número de logical reads
select * from Sales.SalesOrderDetail where ProductID = 790
/*
(377 rows affected)
Table 'SalesOrderDetail'. Scan count 1, logical reads 1166, physical reads 0, page server reads 0, read-ahead reads 0, page server read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob page server reads 0, lob read-ahead reads 0, lob page server read-ahead reads 0.

Os planos são diferentes porque o produto 852 tem 422 linhas associadas e o SGBD preferiu fazer um Index Scan, lendo todos os dados da tabela.
O produto 790 tem 377 linhas e o SGBD decidiu tirar partido do indice e fazer o Key Lookup.
*/
--checkpoint 1
dbcc freeproccache

--ponto 4
-- observe qual o plano de execução produzido para a instrução seguinte
-- execute a instrução e anote o número de logical reads.
-- compare-o com o número obtido no ponto 2
select * from Sales.SalesOrderDetail where ProductID = 852
option(use plan N'<?xml version="1.0" encoding="utf-16"?>
<ShowPlanXML xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" Version="1.6" Build="14.0.1000.169" xmlns="http://schemas.microsoft.com/sqlserver/2004/07/showplan">
  <BatchSequence>
    <Batch>
      <Statements>
        <StmtSimple StatementCompId="1" StatementEstRows="377" StatementId="1" StatementOptmLevel="FULL" CardinalityEstimationModelVersion="130" StatementSubTreeCost="1.07958" StatementText="SELECT * FROM [Sales].[SalesOrderDetail] WHERE [ProductID]=@1" StatementType="SELECT" QueryHash="0xE539D25E273EFB6A" QueryPlanHash="0x868CD53978198943" RetrievedFromCache="false" StatementSqlHandle="0x09005E07CBE977F128861483BFC26933E9580000000000000000000000000000000000000000000000000000" DatabaseContextSettingsId="3" ParentObjectId="0" StatementParameterizationType="0" SecurityPolicyApplied="false">
          <StatementSetOptions ANSI_NULLS="true" ANSI_PADDING="true" ANSI_WARNINGS="true" ARITHABORT="true" CONCAT_NULL_YIELDS_NULL="true" NUMERIC_ROUNDABORT="false" QUOTED_IDENTIFIER="true" />
          <QueryPlan DegreeOfParallelism="1" CachedPlanSize="48" CompileTime="1" CompileCPU="1" CompileMemory="408">
            <MemoryGrantInfo SerialRequiredMemory="0" SerialDesiredMemory="0" />
            <OptimizerHardwareDependentProperties EstimatedAvailableMemoryGrant="208218" EstimatedPagesCached="104109" EstimatedAvailableDegreeOfParallelism="4" MaxCompileMemory="4854448" />
            <OptimizerStatsUsage>
              <StatisticsInfo Database="[AdventureWorks2017]" Schema="[Sales]" Table="[SalesOrderDetail]" Statistics="[IX_SalesOrderDetail_ProductID]" ModificationCount="0" SamplingPercent="100" LastUpdate="2015-11-16T13:04:11.84" />
            </OptimizerStatsUsage>
            <QueryTimeStats CpuTime="1" ElapsedTime="1" />
            <RelOp AvgRowSize="112" EstimateCPU="3.77E-05" EstimateIO="0" EstimateRebinds="0" EstimateRewinds="0" EstimatedExecutionMode="Row" EstimateRows="377" LogicalOp="Compute Scalar" NodeId="0" Parallel="false" PhysicalOp="Compute Scalar" EstimatedTotalSubtreeCost="1.07958">
              <OutputList>
                <ColumnReference Database="[AdventureWorks2017]" Schema="[Sales]" Table="[SalesOrderDetail]" Column="SalesOrderID" />
                <ColumnReference Database="[AdventureWorks2017]" Schema="[Sales]" Table="[SalesOrderDetail]" Column="SalesOrderDetailID" />
                <ColumnReference Database="[AdventureWorks2017]" Schema="[Sales]" Table="[SalesOrderDetail]" Column="CarrierTrackingNumber" />
                <ColumnReference Database="[AdventureWorks2017]" Schema="[Sales]" Table="[SalesOrderDetail]" Column="OrderQty" />
                <ColumnReference Database="[AdventureWorks2017]" Schema="[Sales]" Table="[SalesOrderDetail]" Column="ProductID" />
                <ColumnReference Database="[AdventureWorks2017]" Schema="[Sales]" Table="[SalesOrderDetail]" Column="SpecialOfferID" />
                <ColumnReference Database="[AdventureWorks2017]" Schema="[Sales]" Table="[SalesOrderDetail]" Column="UnitPrice" />
                <ColumnReference Database="[AdventureWorks2017]" Schema="[Sales]" Table="[SalesOrderDetail]" Column="UnitPriceDiscount" />
                <ColumnReference Database="[AdventureWorks2017]" Schema="[Sales]" Table="[SalesOrderDetail]" Column="rowguid" />
                <ColumnReference Database="[AdventureWorks2017]" Schema="[Sales]" Table="[SalesOrderDetail]" Column="ModifiedDate" />
                <ColumnReference Database="[AdventureWorks2017]" Schema="[Sales]" Table="[SalesOrderDetail]" Column="LineTotal" ComputedColumn="true" />
              </OutputList>
              <ComputeScalar>
                <DefinedValues>
                  <DefinedValue>
                    <ColumnReference Database="[AdventureWorks2017]" Schema="[Sales]" Table="[SalesOrderDetail]" Column="LineTotal" ComputedColumn="true" />
                    <ScalarOperator ScalarString="[AdventureWorks2017].[Sales].[SalesOrderDetail].[LineTotal]">
                      <Identifier>
                        <ColumnReference Database="[AdventureWorks2017]" Schema="[Sales]" Table="[SalesOrderDetail]" Column="LineTotal" ComputedColumn="true" />
                      </Identifier>
                    </ScalarOperator>
                  </DefinedValue>
                </DefinedValues>
                <RelOp AvgRowSize="112" EstimateCPU="0.00157586" EstimateIO="0" EstimateRebinds="0" EstimateRewinds="0" EstimatedExecutionMode="Row" EstimateRows="377" LogicalOp="Inner Join" NodeId="1" Parallel="false" PhysicalOp="Nested Loops" EstimatedTotalSubtreeCost="1.07954">
                  <OutputList>
                    <ColumnReference Database="[AdventureWorks2017]" Schema="[Sales]" Table="[SalesOrderDetail]" Column="SalesOrderID" />
                    <ColumnReference Database="[AdventureWorks2017]" Schema="[Sales]" Table="[SalesOrderDetail]" Column="SalesOrderDetailID" />
                    <ColumnReference Database="[AdventureWorks2017]" Schema="[Sales]" Table="[SalesOrderDetail]" Column="CarrierTrackingNumber" />
                    <ColumnReference Database="[AdventureWorks2017]" Schema="[Sales]" Table="[SalesOrderDetail]" Column="OrderQty" />
                    <ColumnReference Database="[AdventureWorks2017]" Schema="[Sales]" Table="[SalesOrderDetail]" Column="ProductID" />
                    <ColumnReference Database="[AdventureWorks2017]" Schema="[Sales]" Table="[SalesOrderDetail]" Column="SpecialOfferID" />
                    <ColumnReference Database="[AdventureWorks2017]" Schema="[Sales]" Table="[SalesOrderDetail]" Column="UnitPrice" />
                    <ColumnReference Database="[AdventureWorks2017]" Schema="[Sales]" Table="[SalesOrderDetail]" Column="UnitPriceDiscount" />
                    <ColumnReference Database="[AdventureWorks2017]" Schema="[Sales]" Table="[SalesOrderDetail]" Column="LineTotal" ComputedColumn="true" />
                    <ColumnReference Database="[AdventureWorks2017]" Schema="[Sales]" Table="[SalesOrderDetail]" Column="rowguid" />
                    <ColumnReference Database="[AdventureWorks2017]" Schema="[Sales]" Table="[SalesOrderDetail]" Column="ModifiedDate" />
                  </OutputList>
                  <RunTimeInformation>
                    <RunTimeCountersPerThread Thread="0" ActualRows="377" Batches="0" ActualEndOfScans="1" ActualExecutions="1" ActualExecutionMode="Row" ActualElapsedms="1" ActualCPUms="1" />
                  </RunTimeInformation>
                  <NestedLoops Optimized="false" WithUnorderedPrefetch="true">
                    <OuterReferences>
                      <ColumnReference Database="[AdventureWorks2017]" Schema="[Sales]" Table="[SalesOrderDetail]" Column="SalesOrderID" />
                      <ColumnReference Database="[AdventureWorks2017]" Schema="[Sales]" Table="[SalesOrderDetail]" Column="SalesOrderDetailID" />
                      <ColumnReference Column="Expr1003" />
                    </OuterReferences>
                    <RelOp AvgRowSize="19" EstimateCPU="0.0005717" EstimateIO="0.003125" EstimateRebinds="0" EstimateRewinds="0" EstimatedExecutionMode="Row" EstimateRows="377" EstimatedRowsRead="377" LogicalOp="Index Seek" NodeId="3" Parallel="false" PhysicalOp="Index Seek" EstimatedTotalSubtreeCost="0.0036967" TableCardinality="121317">
                      <OutputList>
                        <ColumnReference Database="[AdventureWorks2017]" Schema="[Sales]" Table="[SalesOrderDetail]" Column="SalesOrderID" />
                        <ColumnReference Database="[AdventureWorks2017]" Schema="[Sales]" Table="[SalesOrderDetail]" Column="SalesOrderDetailID" />
                        <ColumnReference Database="[AdventureWorks2017]" Schema="[Sales]" Table="[SalesOrderDetail]" Column="ProductID" />
                      </OutputList>
                      <RunTimeInformation>
                        <RunTimeCountersPerThread Thread="0" ActualRows="377" ActualRowsRead="377" Batches="0" ActualEndOfScans="1" ActualExecutions="1" ActualExecutionMode="Row" ActualElapsedms="0" ActualCPUms="0" ActualScans="1" ActualLogicalReads="3" ActualPhysicalReads="0" ActualReadAheads="0" ActualLobLogicalReads="0" ActualLobPhysicalReads="0" ActualLobReadAheads="0" />
                      </RunTimeInformation>
                      <IndexScan Ordered="true" ScanDirection="FORWARD" ForcedIndex="false" ForceSeek="false" ForceScan="false" NoExpandHint="false" Storage="RowStore">
                        <DefinedValues>
                          <DefinedValue>
                            <ColumnReference Database="[AdventureWorks2017]" Schema="[Sales]" Table="[SalesOrderDetail]" Column="SalesOrderID" />
                          </DefinedValue>
                          <DefinedValue>
                            <ColumnReference Database="[AdventureWorks2017]" Schema="[Sales]" Table="[SalesOrderDetail]" Column="SalesOrderDetailID" />
                          </DefinedValue>
                          <DefinedValue>
                            <ColumnReference Database="[AdventureWorks2017]" Schema="[Sales]" Table="[SalesOrderDetail]" Column="ProductID" />
                          </DefinedValue>
                        </DefinedValues>
                        <Object Database="[AdventureWorks2017]" Schema="[Sales]" Table="[SalesOrderDetail]" Index="[IX_SalesOrderDetail_ProductID]" IndexKind="NonClustered" Storage="RowStore" />
                        <SeekPredicates>
                          <SeekPredicateNew>
                            <SeekKeys>
                              <Prefix ScanType="EQ">
                                <RangeColumns>
                                  <ColumnReference Database="[AdventureWorks2017]" Schema="[Sales]" Table="[SalesOrderDetail]" Column="ProductID" />
                                </RangeColumns>
                                <RangeExpressions>
                                  <ScalarOperator ScalarString="(790)">
                                    <Const ConstValue="(790)" />
                                  </ScalarOperator>
                                </RangeExpressions>
                              </Prefix>
                            </SeekKeys>
                          </SeekPredicateNew>
                        </SeekPredicates>
                      </IndexScan>
                    </RelOp>
                    <RelOp AvgRowSize="99" EstimateCPU="1E-07" EstimateIO="0" EstimateRebinds="376" EstimateRewinds="0" EstimatedExecutionMode="Row" EstimateRows="1" LogicalOp="Compute Scalar" NodeId="5" Parallel="false" PhysicalOp="Compute Scalar" EstimatedTotalSubtreeCost="1.07427">
                      <OutputList>
                        <ColumnReference Database="[AdventureWorks2017]" Schema="[Sales]" Table="[SalesOrderDetail]" Column="LineTotal" ComputedColumn="true" />
                        <ColumnReference Database="[AdventureWorks2017]" Schema="[Sales]" Table="[SalesOrderDetail]" Column="CarrierTrackingNumber" />
                        <ColumnReference Database="[AdventureWorks2017]" Schema="[Sales]" Table="[SalesOrderDetail]" Column="OrderQty" />
                        <ColumnReference Database="[AdventureWorks2017]" Schema="[Sales]" Table="[SalesOrderDetail]" Column="SpecialOfferID" />
                        <ColumnReference Database="[AdventureWorks2017]" Schema="[Sales]" Table="[SalesOrderDetail]" Column="UnitPrice" />
                        <ColumnReference Database="[AdventureWorks2017]" Schema="[Sales]" Table="[SalesOrderDetail]" Column="UnitPriceDiscount" />
                        <ColumnReference Database="[AdventureWorks2017]" Schema="[Sales]" Table="[SalesOrderDetail]" Column="rowguid" />
                        <ColumnReference Database="[AdventureWorks2017]" Schema="[Sales]" Table="[SalesOrderDetail]" Column="ModifiedDate" />
                      </OutputList>
                      <ComputeScalar>
                        <DefinedValues>
                          <DefinedValue>
                            <ColumnReference Database="[AdventureWorks2017]" Schema="[Sales]" Table="[SalesOrderDetail]" Column="LineTotal" ComputedColumn="true" />
                            <ScalarOperator ScalarString="isnull(CONVERT_IMPLICIT(numeric(19,4),[AdventureWorks2017].[Sales].[SalesOrderDetail].[UnitPrice],0)*((1.0)-CONVERT_IMPLICIT(numeric(19,4),[AdventureWorks2017].[Sales].[SalesOrderDetail].[UnitPriceDiscount],0))*CONVERT_IMPLICIT(numeric(5,0),[AdventureWorks2017].[Sales].[SalesOrderDetail].[OrderQty],0),(0.000000))">
                              <Intrinsic FunctionName="isnull">
                                <ScalarOperator>
                                  <Arithmetic Operation="MULT">
                                    <ScalarOperator>
                                      <Arithmetic Operation="MULT">
                                        <ScalarOperator>
                                          <Convert DataType="numeric" Precision="19" Scale="4" Style="0" Implicit="true">
                                            <ScalarOperator>
                                              <Identifier>
                                                <ColumnReference Database="[AdventureWorks2017]" Schema="[Sales]" Table="[SalesOrderDetail]" Column="UnitPrice" />
                                              </Identifier>
                                            </ScalarOperator>
                                          </Convert>
                                        </ScalarOperator>
                                        <ScalarOperator>
                                          <Arithmetic Operation="SUB">
                                            <ScalarOperator>
                                              <Const ConstValue="(1.0)" />
                                            </ScalarOperator>
                                            <ScalarOperator>
                                              <Convert DataType="numeric" Precision="19" Scale="4" Style="0" Implicit="true">
                                                <ScalarOperator>
                                                  <Identifier>
                                                    <ColumnReference Database="[AdventureWorks2017]" Schema="[Sales]" Table="[SalesOrderDetail]" Column="UnitPriceDiscount" />
                                                  </Identifier>
                                                </ScalarOperator>
                                              </Convert>
                                            </ScalarOperator>
                                          </Arithmetic>
                                        </ScalarOperator>
                                      </Arithmetic>
                                    </ScalarOperator>
                                    <ScalarOperator>
                                      <Convert DataType="numeric" Precision="5" Scale="0" Style="0" Implicit="true">
                                        <ScalarOperator>
                                          <Identifier>
                                            <ColumnReference Database="[AdventureWorks2017]" Schema="[Sales]" Table="[SalesOrderDetail]" Column="OrderQty" />
                                          </Identifier>
                                        </ScalarOperator>
                                      </Convert>
                                    </ScalarOperator>
                                  </Arithmetic>
                                </ScalarOperator>
                                <ScalarOperator>
                                  <Const ConstValue="(0.000000)" />
                                </ScalarOperator>
                              </Intrinsic>
                            </ScalarOperator>
                          </DefinedValue>
                        </DefinedValues>
                        <RelOp AvgRowSize="82" EstimateCPU="0.0001581" EstimateIO="0.003125" EstimateRebinds="376" EstimateRewinds="0" EstimatedExecutionMode="Row" EstimateRows="1" LogicalOp="Clustered Index Seek" NodeId="6" Parallel="false" PhysicalOp="Clustered Index Seek" EstimatedTotalSubtreeCost="1.07423" TableCardinality="121317">
                          <OutputList>
                            <ColumnReference Database="[AdventureWorks2017]" Schema="[Sales]" Table="[SalesOrderDetail]" Column="CarrierTrackingNumber" />
                            <ColumnReference Database="[AdventureWorks2017]" Schema="[Sales]" Table="[SalesOrderDetail]" Column="OrderQty" />
                            <ColumnReference Database="[AdventureWorks2017]" Schema="[Sales]" Table="[SalesOrderDetail]" Column="SpecialOfferID" />
                            <ColumnReference Database="[AdventureWorks2017]" Schema="[Sales]" Table="[SalesOrderDetail]" Column="UnitPrice" />
                            <ColumnReference Database="[AdventureWorks2017]" Schema="[Sales]" Table="[SalesOrderDetail]" Column="UnitPriceDiscount" />
                            <ColumnReference Database="[AdventureWorks2017]" Schema="[Sales]" Table="[SalesOrderDetail]" Column="rowguid" />
                            <ColumnReference Database="[AdventureWorks2017]" Schema="[Sales]" Table="[SalesOrderDetail]" Column="ModifiedDate" />
                          </OutputList>
                          <RunTimeInformation>
                            <RunTimeCountersPerThread Thread="0" ActualRows="377" ActualRowsRead="377" Batches="0" ActualEndOfScans="0" ActualExecutions="377" ActualExecutionMode="Row" ActualElapsedms="0" ActualCPUms="0" ActualScans="0" ActualLogicalReads="1067" ActualPhysicalReads="0" ActualReadAheads="0" ActualLobLogicalReads="0" ActualLobPhysicalReads="0" ActualLobReadAheads="0" />
                          </RunTimeInformation>
                          <IndexScan Lookup="true" Ordered="true" ScanDirection="FORWARD" ForcedIndex="false" ForceSeek="false" ForceScan="false" NoExpandHint="false" Storage="RowStore">
                            <DefinedValues>
                              <DefinedValue>
                                <ColumnReference Database="[AdventureWorks2017]" Schema="[Sales]" Table="[SalesOrderDetail]" Column="CarrierTrackingNumber" />
                              </DefinedValue>
                              <DefinedValue>
                                <ColumnReference Database="[AdventureWorks2017]" Schema="[Sales]" Table="[SalesOrderDetail]" Column="OrderQty" />
                              </DefinedValue>
                              <DefinedValue>
                                <ColumnReference Database="[AdventureWorks2017]" Schema="[Sales]" Table="[SalesOrderDetail]" Column="SpecialOfferID" />
                              </DefinedValue>
                              <DefinedValue>
                                <ColumnReference Database="[AdventureWorks2017]" Schema="[Sales]" Table="[SalesOrderDetail]" Column="UnitPrice" />
                              </DefinedValue>
                              <DefinedValue>
                                <ColumnReference Database="[AdventureWorks2017]" Schema="[Sales]" Table="[SalesOrderDetail]" Column="UnitPriceDiscount" />
                              </DefinedValue>
                              <DefinedValue>
                                <ColumnReference Database="[AdventureWorks2017]" Schema="[Sales]" Table="[SalesOrderDetail]" Column="rowguid" />
                              </DefinedValue>
                              <DefinedValue>
                                <ColumnReference Database="[AdventureWorks2017]" Schema="[Sales]" Table="[SalesOrderDetail]" Column="ModifiedDate" />
                              </DefinedValue>
                            </DefinedValues>
                            <Object Database="[AdventureWorks2017]" Schema="[Sales]" Table="[SalesOrderDetail]" Index="[PK_SalesOrderDetail_SalesOrderID_SalesOrderDetailID]" TableReferenceId="-1" IndexKind="Clustered" Storage="RowStore" />
                            <SeekPredicates>
                              <SeekPredicateNew>
                                <SeekKeys>
                                  <Prefix ScanType="EQ">
                                    <RangeColumns>
                                      <ColumnReference Database="[AdventureWorks2017]" Schema="[Sales]" Table="[SalesOrderDetail]" Column="SalesOrderID" />
                                      <ColumnReference Database="[AdventureWorks2017]" Schema="[Sales]" Table="[SalesOrderDetail]" Column="SalesOrderDetailID" />
                                    </RangeColumns>
                                    <RangeExpressions>
                                      <ScalarOperator ScalarString="[AdventureWorks2017].[Sales].[SalesOrderDetail].[SalesOrderID]">
                                        <Identifier>
                                          <ColumnReference Database="[AdventureWorks2017]" Schema="[Sales]" Table="[SalesOrderDetail]" Column="SalesOrderID" />
                                        </Identifier>
                                      </ScalarOperator>
                                      <ScalarOperator ScalarString="[AdventureWorks2017].[Sales].[SalesOrderDetail].[SalesOrderDetailID]">
                                        <Identifier>
                                          <ColumnReference Database="[AdventureWorks2017]" Schema="[Sales]" Table="[SalesOrderDetail]" Column="SalesOrderDetailID" />
                                        </Identifier>
                                      </ScalarOperator>
                                    </RangeExpressions>
                                  </Prefix>
                                </SeekKeys>
                              </SeekPredicateNew>
                            </SeekPredicates>
                          </IndexScan>
                        </RelOp>
                      </ComputeScalar>
                    </RelOp>
                  </NestedLoops>
                </RelOp>
              </ComputeScalar>
            </RelOp>
            <ParameterList>
              <ColumnReference Column="@1" ParameterDataType="smallint" ParameterCompiledValue="(790)" ParameterRuntimeValue="(790)" />
            </ParameterList>
          </QueryPlan>
        </StmtSimple>
      </Statements>
    </Batch>
  </BatchSequence>
</ShowPlanXML>')

select * from Sales.SalesOrderDetail where ProductID = 852 
/*
Foi utilizada uma query hint com o mesmo plano da query com where ProductID = 790 e o SGBD executou o plano indicado.
O SGBD estima um custo um bocado maior em relação à query sem o uso de indice.
*/

-- ponto 5

exec sp_configure 'show advanced options',1
GO
RECONFIGURE
GO
sp_configure 'optimize for ad hoc workloads', 1
GO
RECONFIGURE
GO



ALTER DATABASE AdventureWorks2019 SET PARAMETERIZATION SIMPLE

/* se for necessário, fazer:
use  master

ALTER AUTHORIZATION ON DATABASE::AdventureWorks2019 to <user> 
*/

--checkpoint 1
dbcc freeproccache
-- ponto 6
-- executar e verificar plano para a seguinte e instrução e executá-la
select * from Sales.SalesOrderDetail where ProductID = 852
/*
Como o plano de execução está a usar um valor parametrizado por obrigação (PARAMETERIZATION FORCED), 
então o SGBD estima que na maior parte dos casos é melhor fazer um index scan e não utilizar o índice.
*/

-- ponto 7
-- executar e verificar plano e número de logical reads para a seguinte e instrução e compará-los com os obtidos no ponto 3
select * from Sales.SalesOrderDetail where ProductID = 790
/*
O plano utilizado é o plano com o primeiro valor
*/

-- esta query permite verificar quais são os planos existentes na cache
SELECT c.usecounts
,c.cacheobjtype
,c.objtype
,t.text
FROM sys.dm_exec_cached_plans c
CROSS APPLY sys.dm_exec_sql_text(c.plan_handle) t
WHERE t.text LIKE 'select * from Sales.SalesOrderDetail where ProductID%' or t.text LIKE 
    '(@0 int)select * from Sales . SalesOrderDetail where ProductID = @0'


set statistics io off
/*
Com SET PARAMETERIZATION FORCED é criado uma plano de execução parametrizado.
Com SET PARAMETERIZATION SIMPLE esse plano não tem que ser criado.
*/
