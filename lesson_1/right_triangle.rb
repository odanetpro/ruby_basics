triangle = []

1.upto(3) do |i|
  print "Введите #{i} сторону треугольника: "
  triangle << gets.to_f
end

triangle.sort! {|a, b| b <=> a}

if triangle.uniq.size == 1
  puts 'Треугольник равносторонний и равнобедренный'
elsif triangle.uniq.size == 2
  puts 'Треугольник равнобедренный'
elsif triangle[0] ** 2 == triangle[1] ** 2 + triangle[2] ** 2
  puts 'Треугольник прямоугольный'
else
  puts 'Треугольник обычный'
end