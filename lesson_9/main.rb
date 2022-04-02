# frozen_string_literal: false

require_relative 'accessors'
require_relative 'validation'

class Test
  include Accessors
  include Validation
  attr_accessor :name

  attr_accessor_with_history :number, :type
  strong_attr_accessor :amount, Numeric

  validate :name, :presence
  validate :name, :format, /^\D*$/
  validate :name, :type, String
end

test = Test.new

test.number = 123
test.number = 456

puts test.number
puts test.number_history

puts

test.type = :cargo
test.type = :passenger

puts test.type
puts test.type_history

puts

test.amount = 10
puts test.amount
# test.amount = 's'

test.name = 'abc'
test.validate!
