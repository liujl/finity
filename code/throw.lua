--抛异常
return function(errno)
  error('{err=' .. errno .. '}', 2)
end