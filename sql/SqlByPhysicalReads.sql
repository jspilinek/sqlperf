SELECT TOP 100
  convert(varchar(max),qs.query_hash, 2) AS QueryHash,
  qs.total_logical_reads,
  qs.total_physical_reads,
  qs.execution_count,
  ISNULL(qs.total_logical_reads / qs.execution_count, 0) AS AvgLogicalReads,
  ISNULL(qs.total_physical_reads / qs.execution_count, 0) AS AvgPhysicalReads,
  CAST(ROUND((CAST(qs.total_logical_reads - qs.total_physical_reads AS float) / CAST (qs.total_logical_reads AS float) * 100.00), 2) AS numeric(7,2)) AS CacheHit,
  qs.total_rows,
  FORMAT(last_execution_time AT TIME ZONE 'ENTER_TIME_ZONE', 'ENTER_DATE_FORMAT') AS last_execution_time, 
  CAST(replace(
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
  AS VARCHAR(128)) AS text,
  convert(varchar(64),qs.sql_handle, 2) AS sql_handle,
  convert(varchar(64),qs.plan_handle, 2) AS plan_handle
FROM sys.dm_exec_query_stats AS qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) AS st
WHERE qs.total_physical_reads > 1000
ORDER BY total_physical_reads DESC;
