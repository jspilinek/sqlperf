with PerfTableAge AS (
select 'CacheStatistics' as Table_Name, min(LE_Timestamp) as Oldest_Entry, max(LE_Timestamp) as Newest_Entry from [ENTER_WINDCHILL_SCHEMA].CacheStatistics UNION 
select 'JmxNotifications' as Table_Name, min(LE_Timestamp) as Oldest_Entry, max(LE_Timestamp) as Newest_Entry from [ENTER_WINDCHILL_SCHEMA].JmxNotifications UNION 
select 'Log4JavascriptEvents' as Table_Name, min(LE_Timestamp) as Oldest_Entry, max(LE_Timestamp) as Newest_Entry from [ENTER_WINDCHILL_SCHEMA].Log4JavascriptEvents UNION 
select 'MethodContexts', min(LE_Timestamp) as Oldest_Entry, max(LE_Timestamp) as Newest_Entry from [ENTER_WINDCHILL_SCHEMA].MethodContexts UNION
select 'MethodContextStats', min(LE_Timestamp) as Oldest_Entry, max(LE_Timestamp) as Newest_Entry from [ENTER_WINDCHILL_SCHEMA].MethodContextStats UNION
select 'MethodServerInfo', min(LE_Timestamp) as Oldest_Entry, max(LE_Timestamp) as Newest_Entry from [ENTER_WINDCHILL_SCHEMA].MethodServerInfo UNION
select 'MiscLogEvents', min(LE_Timestamp) as Oldest_Entry, max(LE_Timestamp) as Newest_Entry from [ENTER_WINDCHILL_SCHEMA].MiscLogEvents UNION 
select 'MSHealthStats', min(LE_Timestamp) as Oldest_Entry, max(LE_Timestamp) as Newest_Entry from [ENTER_WINDCHILL_SCHEMA].MSHealthStats UNION 
select 'RawMethodContextStats', min(LE_Timestamp) as Oldest_Entry, max(LE_Timestamp) as Newest_Entry from [ENTER_WINDCHILL_SCHEMA].RawMethodContextStats UNION
select 'RawServletRequestStats', min(LE_Timestamp) as Oldest_Entry, max(LE_Timestamp) as Newest_Entry from [ENTER_WINDCHILL_SCHEMA].RawServletRequestStats UNION
select 'RemoteCacheServerCalls', min(LE_Timestamp) as Oldest_Entry, max(LE_Timestamp) as Newest_Entry from [ENTER_WINDCHILL_SCHEMA].RemoteCacheServerCalls UNION
select 'RequestHistograms', min(LE_Timestamp) as Oldest_Entry, max(LE_Timestamp) as Newest_Entry from [ENTER_WINDCHILL_SCHEMA].RequestHistograms UNION
select 'RmiHistograms', min(LE_Timestamp) as Oldest_Entry, max(LE_Timestamp) as Newest_Entry from [ENTER_WINDCHILL_SCHEMA].RmiHistograms UNION
select 'RmiPerfData', min(LE_Timestamp) as Oldest_Entry, max(LE_Timestamp) as Newest_Entry from [ENTER_WINDCHILL_SCHEMA].RmiPerfData UNION
select 'SampledMethodContexts', min(LE_Timestamp) as Oldest_Entry, max(LE_Timestamp) as Newest_Entry from [ENTER_WINDCHILL_SCHEMA].SampledMethodContexts UNION
select 'SampledServletRequests', min(LE_Timestamp) as Oldest_Entry, max(LE_Timestamp) as Newest_Entry from [ENTER_WINDCHILL_SCHEMA].SampledServletRequests UNION
select 'ServerManagerInfo', min(LE_Timestamp) as Oldest_Entry, max(LE_Timestamp) as Newest_Entry from [ENTER_WINDCHILL_SCHEMA].ServerManagerInfo UNION
select 'ServletRequests', min(LE_Timestamp) as Oldest_Entry, max(LE_Timestamp) as Newest_Entry from [ENTER_WINDCHILL_SCHEMA].ServletRequests UNION
select 'ServletRequestStats', min(LE_Timestamp) as Oldest_Entry, max(LE_Timestamp) as Newest_Entry from [ENTER_WINDCHILL_SCHEMA].ServletRequestStats UNION
select 'ServletSessionStats', min(LE_Timestamp) as Oldest_Entry, max(LE_Timestamp) as Newest_Entry from [ENTER_WINDCHILL_SCHEMA].ServletSessionStats UNION
select 'SMHealthStats', min(LE_Timestamp) as Oldest_Entry, max(LE_Timestamp) as Newest_Entry from [ENTER_WINDCHILL_SCHEMA].SMHealthStats UNION
select 'TopSQLStats', min(LE_Timestamp) as Oldest_Entry, max(LE_Timestamp) as Newest_Entry from [ENTER_WINDCHILL_SCHEMA].TopSQLStats UNION
select 'UserAgentInfo', min(LE_Timestamp) as Oldest_Entry, max(LE_Timestamp) as Newest_Entry from [ENTER_WINDCHILL_SCHEMA].UserAgentInfo)
SELECT Table_Name,
    FORMAT(Oldest_Entry, 'ENTER_DATE_FORMAT') AS Oldest_Entry,
    DATEDIFF(day, Oldest_Entry, GETDATE()) Days_Old,
    FORMAT(Newest_Entry, 'ENTER_DATE_FORMAT') AS Newest_Entry
FROM PerfTableAge;
