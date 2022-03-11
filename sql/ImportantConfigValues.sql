SELECT name, value, 
  value_in_use, 
  minimum, 
  maximum, 
  is_dynamic,
  is_advanced,
  description
FROM sys.configurations
WHERE name IN ('max server memory (MB)', 
               'min server memory (MB)',
               'max degree of parallelism',
               'cost threshold for parallelism')
ORDER BY name;