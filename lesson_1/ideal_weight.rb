print 'Введите ваше имя: '
name = gets.strip.capitalize

print 'Введите ваш рост (в см.): '
height = gets.to_f

ideal_weight = (height - 110) * 1.15

if ideal_weight > 0 
	puts "#{name}, ваш идеальный вес: #{ideal_weight.round(2)} кг."
else  
	puts 'Ваш вес уже оптимальный'
end