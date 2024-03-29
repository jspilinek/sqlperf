WITH ticks AS (SELECT cpu_ticks / (cpu_ticks/ms_ticks) AS ts_now from sys.dm_os_sys_info)     
select record_id,
      FORMAT(dateadd(ms, -1 * (ticks.ts_now - [timestamp]), GetDate()) AT TIME ZONE 'ENTER_TIME_ZONE', 'ENTER_DATE_FORMAT') AS EventTime,
      SQLProcessUtilization,
      SystemIdle,
      100 - SystemIdle - SQLProcessUtilization as OtherProcessUtilization
from (
      select
            record.value('(./Record/@id)[1]', 'int') as record_id,
            record.value('(./Record/SchedulerMonitorEvent/SystemHealth/SystemIdle)[1]', 'int') as SystemIdle,
            record.value('(./Record/SchedulerMonitorEvent/SystemHealth/ProcessUtilization)[1]', 'int') as SQLProcessUtilization,
            timestamp
      from (
            select timestamp, convert(xml, record) as record
            from sys.dm_os_ring_buffers
            where ring_buffer_type = N'RING_BUFFER_SCHEDULER_MONITOR'
            and record like '%<SystemHealth>%') as x
      ) as y, ticks
order by record_id desc;