# frozen_string_literal: false

module Validation
  def self.included(base)
    base.extend ClassMethods
    base.send(:include, InstanceMethods)
  end

  module ClassMethods
    attr_reader :validations

    def validate(attr_name, validation_type, *arg)
      @validations ||= []
      @validations << { attr_name: attr_name, validation_type: validation_type, arg: arg }
    end
  end

  module InstanceMethods
    def valid?
      validate!
      true
    rescue RuntimeError
      false
    end

    def validate!
      self.class.validations.each do |validation|
        attr_value = instance_variable_get("@#{validation[:attr_name].to_sym}")
        send("#{validation[:validation_type]}_validation".to_sym, { attr_value: attr_value, arg: validation[:arg] })
      end
    end

    private

    def presence_validation(options = {})
      attr_value = options[:attr_value]
      raise 'Пустое значение' if attr_value.nil? || attr_value == ''
    end

    def format_validation(options = {})
      attr_value = options[:attr_value]
      regex = options[:arg][0]
      raise 'Несоответствие формату' if attr_value !~ regex
    end

    def type_validation(options = {})
      attr_value = options[:attr_value]
      attr_class = options[:arg][0]
      raise 'Несоответствие типов' unless attr_value.is_a?(attr_class)
    end
  end
end
