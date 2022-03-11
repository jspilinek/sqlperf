SELECT name, 
  value, 
  value_in_use, 
  minimum, 
  maximum, 
  is_dynamic,
  is_advanced,
  description
FROM sys.configurations
ORDER BY name;