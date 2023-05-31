SELECT qt.query_sql_text
FROM sys.query_store_query q
INNER JOIN sys.query_store_query_text qt
  ON q.query_text_id = qt.query_text_id
WHERE q.query_id = ENTER_QUERY_ID;
