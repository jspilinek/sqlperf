SELECT DATABASEPROPERTYEX (DB_NAME(DB_ID()), 'Edition') AS [Database Edition],
       DATABASEPROPERTYEX (DB_NAME(DB_ID()), 'ServiceObjective') AS [Service Objective];
