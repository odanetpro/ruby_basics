fibo = [0, 1]

i = 2
loop do
  n = fibo[i-1] + fibo[i-2]
  
  break if n > 100  
  
  fibo[i] = n
  i += 1
end
