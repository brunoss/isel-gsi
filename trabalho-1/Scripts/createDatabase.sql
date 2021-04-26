CREATE DATABASE GSI_AP1 ON PRIMARY (NAME='GSI_AP1_PRI', FILENAME='D:\gsi\GSI_AP1_PRI.mdf', SIZE=8MB, FILEGROWTH=1MB) 
LOG ON (NAME='GSI_AP1_LOG', FILENAME='D:\gsi\GSI_AP1.ldf', SIZE=8MB, FILEGROWTH=0MB)

/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [database_name]
      ,[kb_used]
  FROM [GSI_AP1].[dbo].[bufferPool_DB]

  /****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [object_name]
      ,[object_type_description]
      ,[buffer_cache_pages]
      ,[buffer_cache_used_KB]
  FROM [GSI_AP1].[dbo].[bufferPool_Object]

  /****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [cpu_ticks]
      ,[ms_ticks]
      ,[cpu_count]
      ,[hyperthread_ratio]
      ,[physical_memory_kb]
      ,[virtual_memory_kb]
      ,[committed_kb]
      ,[committed_target_kb]
      ,[visible_target_kb]
      ,[stack_size_in_bytes]
      ,[os_quantum]
      ,[os_error_mode]
      ,[os_priority_class]
      ,[max_workers_count]
      ,[scheduler_count]
      ,[scheduler_total_count]
      ,[deadlock_monitor_serial_number]
      ,[sqlserver_start_time_ms_ticks]
      ,[sqlserver_start_time]
      ,[affinity_type]
      ,[affinity_type_desc]
      ,[process_kernel_time_ms]
      ,[process_user_time_ms]
      ,[time_source]
      ,[time_source_desc]
      ,[virtual_machine_type]
      ,[virtual_machine_type_desc]
      ,[softnuma_configuration]
      ,[softnuma_configuration_desc]
      ,[process_physical_affinity]
      ,[sql_memory_model]
      ,[sql_memory_model_desc]
      ,[socket_count]
      ,[cores_per_socket]
      ,[numa_node_count]
      ,[container_type]
      ,[container_type_desc]
  FROM [GSI_AP1].[dbo].[osInfo]