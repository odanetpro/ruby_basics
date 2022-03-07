fibo = [0, 1]

(2..100).each do |i|
  fibo[i] = fibo[i-1] + fibo[i-2]
end
