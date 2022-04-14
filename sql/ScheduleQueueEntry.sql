SELECT qe.codeC5 AS [QueueEntry State], 
  sq.name AS [Queue Name], 
  count(qe.idA2A2) AS [Count]
FROM [ENTER_WINDCHILL_SCHEMA].ScheduleQueueEntry qe 
INNER JOIN [ENTER_WINDCHILL_SCHEMA].ScheduleQueue sq ON qe.idA3A5 = sq.idA2A2 
GROUP BY qe.codeC5, sq.name 
ORDER BY [Count] DESC, [QueueEntry State];
