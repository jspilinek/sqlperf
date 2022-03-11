SELECT CAST(t.name AS VARCHAR(55)) AS [Table Name], p.rows, i.type_desc
FROM sys.tables t
INNER JOIN sys.partitions p ON t.object_id = p.object_id
INNER JOIN sys.indexes i ON t.object_id = i.object_id AND p.index_id = i.index_id
WHERE i.index_id < 2
AND (t.name = 'CacheStatistics'
OR t.name = 'CollectorCache'
OR t.name = 'ExtendedPageResults'
OR t.name = 'JmxNotifications'
OR t.name = 'Log4JavascriptEvents'
OR t.name = 'MethodContexts'
OR t.name = 'MethodContextStats'
OR t.name = 'MethodServerInfo'
OR t.name = 'MiscLogEvents'
OR t.name = 'MSHealthStats'
OR t.name = 'PageResults'
OR t.name = 'QueueEntry'
OR t.name = 'RawMethodContextStats'
OR t.name = 'RawServletRequestStats'
OR t.name = 'RecentUpdate'
OR t.name = 'RemoteCacheServerCalls'
OR t.name = 'RequestHistograms'
OR t.name = 'RmiHistograms'
OR t.name = 'RmiPerfData'
OR t.name = 'SampledMethodContexts'
OR t.name = 'SampledServletRequests'
OR t.name = 'ServerManagerInfo'
OR t.name = 'ServletRequests'
OR t.name = 'ServletRequestStats'
OR t.name = 'ServletSessionStats'
OR t.name = 'SMHealthStats'
OR t.name = 'TopSQLStats'
OR t.name = 'UserAgentInfo')
ORDER BY p.rows DESC;
