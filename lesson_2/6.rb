basket = {}

loop do
  print "Введите название товара (или 'стоп' для завершения покупок): "
  prod_name = gets.strip.downcase
  
  break if prod_name == 'стоп'

  print "Введите цену за единицу товара: "
  price = gets.to_f

  print "Введите количество товара: "
  amount = gets.to_i

  basket[prod_name] = { price: price, amount: amount }
end

puts

total = 0
basket.each do |key, value|
  cost = value[:price] * value[:amount]
  puts "Наименование: #{key}\tЦена за ед.: #{value[:price]}\tКол-во.: #{value[:amount]}\tИтого: #{cost}"
  total += cost
end

puts "\nОбщая стоимость: #{total}"
