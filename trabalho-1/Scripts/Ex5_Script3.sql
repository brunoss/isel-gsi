use gsi_Ap1;
GO

SELECT object_name as Object, counter_name as counter, instance_name as instance, cntr_value as value
   FROM sys.dm_os_performance_counters 
   WHERE counter_name IN 
   ( 
       --'Data File(s) Size (KB)', 
       'Log File(s) Size (KB)', 
       'Log File(s) Used Size (KB)', 
       'Percent Log Used' 
   ) 
     AND instance_name = 'GSI_AP1'  

/*
DBCC SQLPERF (logspace)
*/
