DECLARE @login_time as DATETIME
DECLARE @DatedDiff as INT

SELECT @login_time = login_time FROM master..sysprocesses (NOLOCK) WHERE spid = 1
SELECT @DatedDiff = DATEDIFF(mi, @login_time, GETDATE())

SELECT FORMAT(GETDATE(), 'ENTER_DATE_FORMAT') AS CurrentTime,
FORMAT(@login_time, 'ENTER_DATE_FORMAT') AS LastStartup,
CONVERT(VARCHAR(4),@DatedDiff/60/24) + 'd ' + CONVERT(VARCHAR(4),@DatedDiff/60%24) + 'hr ' + CONVERT(VARCHAR(4),@DatedDiff%60) + 'min' AS Uptime;
