SELECT qp.plan_id,
  qp.query_id,
  convert(varchar(max),qp.query_plan_hash, 2) AS QueryPlanHash,
  qp.force_failure_count,
  qp.last_force_failure_reason_desc,
  qp.compatibility_level,
  qp.engine_version,
  --qp.plan_forcing_type_desc,
  --qp.plan_forcing_type,
  qt.query_sql_text,
  qp.count_compiles,
  qp.initial_compile_start_time,
  qp.last_compile_start_time,
  qp.avg_compile_duration,
  qp.last_compile_duration
FROM sys.query_store_plan qp
INNER JOIN sys.query_store_query q ON q.query_id = qp.query_id
INNER JOIN sys.query_store_query_text qt ON qt.query_text_id = q.query_text_id
WHERE qp.is_forced_plan = 1;
