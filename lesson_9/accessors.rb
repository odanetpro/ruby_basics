# frozen_string_literal: false

module Accessors
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def attr_accessor_with_history(*names)
      names.each do |name|
        var_name = "@#{name}".to_sym
        method_name = "#{name}_history".to_sym
        var_history = "@#{method_name}".to_sym

        define_method(method_name) do
          instance_variable_set(var_history, []) unless instance_variable_get(var_history)
          instance_variable_get(var_history)
        end

        define_method(name) { instance_variable_get(var_name) }

        define_method("#{name}=".to_sym) do |value|
          instance_variable_set(var_name, value)
          send(method_name).push(value)
        end
      end
    end

    def strong_attr_accessor(name, name_class)
      var_name = "@#{name}".to_sym

      define_method(name) { instance_variable_get(var_name) }
      define_method("#{name}=".to_sym) do |value|
        value.is_a?(name_class) ? instance_variable_set(var_name, value) : (raise 'Несовпадение типов')
      end
    end
  end
end
