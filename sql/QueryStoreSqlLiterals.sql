WITH queryHash AS (
SELECT q.query_hash, COUNT(*) as "Count", MAX(q.query_id) AS query_id
FROM sys.query_store_query q
GROUP BY q.query_hash
HAVING COUNT(*) > 49)

SELECT qh.Count, '0x' + convert(varchar(max),qh.query_hash, 2) AS QueryHash, qh.query_id, qt.query_sql_text AS text
FROM queryHash qh
INNER JOIN sys.query_store_query q ON q.query_id = qh.query_id
INNER JOIN sys.query_store_query_text qt ON q.query_text_id = qt.query_text_id
WHERE qt.query_sql_text NOT LIKE 'SELECT StatMan%'
ORDER BY qh.Count DESC;
