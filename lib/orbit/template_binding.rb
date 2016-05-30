module Orbit
  class TemplateBinding
    def initialize(hash)
      @variables = binding

      hash.each do |key, value|
        @variables.local_variable_set(key.to_sym, value)
      end
    end

    def self.locals(hash)
      new(hash).locals
    end

    def locals
      self
    end

    def variables
      binding.tap do |bind|
        @variables.local_variables.each do |var|
          binding.local_variable_set(var, @variables.local_variable_get(var))
        end
      end
    end

    def method_missing(method, *args, &block)
      if method.to_s[-1] == '='
        var_name = method.to_s[0..-2].to_sym
        @variables.local_variable_set(var_name, args.first)
      end
    end
  end
end
