SELECT sj.name AS [JobName], sj.[description] AS [JobDescription], SUSER_SNAME(sj.owner_sid) AS [JobOwner],
sj.date_created, sj.[enabled], sj.notify_email_operator_id, sj.notify_level_email, sc.name AS [CategoryName],
js.next_run_date, js.next_run_time
FROM msdb.dbo.sysjobs AS sj
INNER JOIN msdb.dbo.syscategories AS sc
ON sj.category_id = sc.category_id
LEFT OUTER JOIN msdb.dbo.sysjobschedules AS js
ON sj.job_id = js.job_id
ORDER BY sj.name;
