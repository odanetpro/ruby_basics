print 'Введите a: '
a = gets.to_f

print 'Введите b: '
b = gets.to_f

print 'Введите c: '
c = gets.to_f

d = b * b - 4 * a * c

if d < 0
  puts 'Корней нет'
else
  sqrt = Math.sqrt(d)
  x1 = (-b + sqrt)/2 * a
  x2 = (-b - sqrt)/2 * a

  puts x1 == x2 ? "x = #{x1}" : "x1 = #{x1}, x2 = #{x2}"
end
