SELECT qe.codeC5 AS [QueueEntry State], 
  pq.name AS [Queue Name], 
  count(qe.idA2A2) AS [Count]
FROM [ENTER_WINDCHILL_SCHEMA].QueueEntry qe 
INNER JOIN [ENTER_WINDCHILL_SCHEMA].ProcessingQueue pq ON qe.idA3A5 = pq.idA2A2 
GROUP BY qe.codeC5, pq.name 
ORDER BY [Count] DESC, [QueueEntry State];
