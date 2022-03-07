hh = {}

alphabet = ('a'..'z').to_a
vowels = ['a', 'e', 'i', 'u', 'y', 'o']

alphabet.each_with_index { |letter, index|  hh[letter] = index if vowels.include?(letter) }
