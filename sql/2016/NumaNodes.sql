SELECT n.node_id,
  n.node_state_desc,
  n.memory_node_id,
  n.cpu_affinity_mask,
  n.online_scheduler_count,
  n.idle_scheduler_count,
  n.active_worker_count,
  n.avg_load_balance,
  n.timer_task_affinity_mask,
  n.permanent_task_affinity_mask,
  n.resource_monitor_state,
  n.online_scheduler_mask,
  n.processor_group
FROM sys.dm_os_nodes n;