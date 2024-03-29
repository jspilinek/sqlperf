SELECT
  CASE 
     WHEN CONVERT(VARCHAR(100), SERVERPROPERTY('Edition')) = 'SQL Azure' THEN 'AzureSQL'
     WHEN CONVERT(VARCHAR(128), SERVERPROPERTY ('ProductVersion')) like '8%' THEN 'SQL2000'
     WHEN CONVERT(VARCHAR(128), SERVERPROPERTY ('ProductVersion')) like '9%' THEN 'SQL2005'
     WHEN CONVERT(VARCHAR(128), SERVERPROPERTY ('ProductVersion')) like '10.0%' THEN 'SQL2008'
     WHEN CONVERT(VARCHAR(128), SERVERPROPERTY ('ProductVersion')) like '10.5%' THEN 'SQL2008 R2'
     WHEN CONVERT(VARCHAR(128), SERVERPROPERTY ('ProductVersion')) like '11%' THEN 'SQL2012'
     WHEN CONVERT(VARCHAR(128), SERVERPROPERTY ('ProductVersion')) like '12%' THEN 'SQL2014'
     WHEN CONVERT(VARCHAR(128), SERVERPROPERTY ('ProductVersion')) like '13%' THEN 'SQL2016'
     WHEN CONVERT(VARCHAR(128), SERVERPROPERTY ('ProductVersion')) like '14%' THEN 'SQL2017'
     WHEN CONVERT(VARCHAR(128), SERVERPROPERTY ('ProductVersion')) like '15%' THEN 'SQL2019'
     WHEN CONVERT(VARCHAR(128), SERVERPROPERTY ('ProductVersion')) like '16%' THEN 'SQL2022'
     ELSE 'unknown'
  END AS ProductName,
  CASE
    WHEN CONVERT(VARCHAR(100), SERVERPROPERTY('Edition')) = 'SQL Azure' THEN SERVERPROPERTY('ResourceVersion')
    ELSE SERVERPROPERTY('ProductVersion')
  END AS ProductVersion,
  SERVERPROPERTY('Edition') AS Edition;
