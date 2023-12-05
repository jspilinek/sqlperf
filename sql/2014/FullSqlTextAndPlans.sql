WITH sqlstats AS (
SELECT qs.query_hash,
  SUM(qs.execution_count) AS Executions, 
  SUM(qs.total_elapsed_time/1000000) AS TotalSec,
  SUM(qs.total_elapsed_time)/1000000 / SUM(qs.execution_count) AS AvgSec,
  SUM(qs.total_worker_time/1000000) / SUM(qs.execution_count) AS AvgCpuSec,
  SUM(qs.total_logical_reads) / SUM(qs.execution_count) AS AvgLogicalReads,
  SUM(qs.total_physical_reads) / SUM(qs.execution_count) AS AvgPhysicalReads,
  SUM(qs.total_rows) / SUM(qs.execution_count) AS AvgRows,
  MAX(qs.last_execution_time) AS last_execution_time
FROM sys.dm_exec_query_stats AS qs
WHERE qs.execution_count > 0
group by qs.query_hash
),

top_elapsed_time AS (
  SELECT top 100 *
  FROM sqlstats
  WHERE TotalSec >= 1 -- nothing less than 1 sec
  ORDER BY TotalSec DESC),

top_elap_per_exec AS (
  SELECT top 100 *
  FROM sqlstats
  WHERE AvgSec >= 1 -- nothing less than 1 sec
  ORDER BY AvgSec DESC),

top_logical_reads AS (
  SELECT top 100 *
  FROM sqlstats
  WHERE AvgLogicalReads > 10000
  ORDER BY AvgLogicalReads DESC),

top_physical_reads AS (
  SELECT top 100 *
  FROM sqlstats
  WHERE AvgPhysicalReads > 10000
  ORDER BY AvgPhysicalReads DESC),

top_executions AS (
  SELECT top 100 *
  FROM sqlstats
  WHERE Executions > 1000
  ORDER BY Executions DESC),

top_rows_per_exec AS (
  SELECT top 100 *
  FROM sqlstats
  WHERE AvgRows > 10000
  ORDER BY AvgRows DESC)

SELECT B.QueryHash, B.query_hash,
	B.Executions, B.TotalSec, B.AvgSec, B.AvgCpuSec,
	B.AvgLogicalReads, B.AvgPhysicalReads,
	B.AvgRows, FORMAT(B.last_execution_time, 'yyyy-MM-dd HH:mm:ss') AS last_execution_time,
	B.text,
  LEFT(B.text, 120) AS shortText 
FROM (
SELECT convert(varchar(max),qs.query_hash, 2) AS QueryHash,
  A.*, 
  replace(
    replace(
      replace(
        replace(
          replace(
            replace(
              replace(
                replace(
                  substring(st.text, 
                  (qs.statement_start_offset/2)+1, 
                  ((case qs.statement_end_offset
                    when -1 then datalength(st.text)
                    else qs.statement_end_offset
                    end - qs.statement_start_offset)/2) + 1),
                          char(13), ' '), --Replace carriage return with space
                        char(10), ' '),   --Replace line feed with space
                      char(9), ' '),      --Replace tab with space
                    '  ',' '+CHAR(7)),    --Changes 2 spaces to the OX model
                  CHAR(7)+' ',''),        --Changes the XO model to nothing
                CHAR(7),''),              --Changes the remaining X's to nothing
                '( ', '('),               --Remove space after open parenthesis
              ' )', ')')                  --Remove space before close parenthesis
  AS text
FROM (
  SELECT * FROM top_elapsed_time 
  UNION SELECT * FROM top_elap_per_exec 
  UNION SELECT * FROM top_logical_reads 
  UNION SELECT * FROM top_physical_reads 
  UNION SELECT * FROM top_executions 
  UNION SELECT * FROM top_rows_per_exec) A
INNER JOIN sys.dm_exec_query_stats qs
  ON qs.query_hash = A.query_hash 
  AND qs.last_execution_time = A.last_execution_time
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) as st
) B
ORDER BY query_hash;
