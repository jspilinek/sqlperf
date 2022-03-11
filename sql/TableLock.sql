select t.name, t.lock_escalation, t.lock_escalation_desc, 
'ALTER TABLE ' + QUOTENAME(s.name) + '.' + QUOTENAME(t.name) + ' SET (LOCK_ESCALATION = DISABLE);' as stmt
from sys.tables t
inner join sys.schemas s
on t.schema_id = s.schema_id
WHERE t.lock_escalation <> 1
ORDER BY t.name;