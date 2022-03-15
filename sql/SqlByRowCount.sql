SELECT TOP 100
  convert(varchar(max),qs.query_hash, 2) AS QueryHash,
  qs.execution_count,
  qs.total_rows,
  ISNULL(qs.total_rows/qs.execution_count, 0) AS AvgRows,
  FORMAT(last_execution_time, 'ENTER_DATE_FORMAT') AS last_execution_time, 
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
WHERE qs.total_rows > 10000
ORDER BY qs.total_rows DESC;
