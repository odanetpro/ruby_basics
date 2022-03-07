print 'Введите день: '
day = gets.to_i

print 'Введите месяц: '
month = gets.to_i

print 'Введите год (yyyy): '
year = gets.to_i

days_in_february = (year % 4 == 0 && year % 100 != 0) || (year % 100 == 0 && year % 400 == 0) ? 29 : 28
days_in_months = [31, days_in_february, 31, 30 ,31, 30, 31, 31, 30, 31, 30, 31]

ordinal = day
(month-1).times { |i| ordinal += days_in_months[i] }

puts "#{day}.#{month}.#{year} - #{ordinal} день в году"
