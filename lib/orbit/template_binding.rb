module Orbit
  class TemplateBinding
    def initialize(hash)
      @variables = {}

      hash.each do |key, value|
        @variables[key.to_sym] = value
      end
    end

    def self.locals(hash)
      new(hash).locals
    end

    def locals
      @variables
    end

    def variables
      binding.tap do |bind|
        @variables.each do |key, value|
          bind.local_variable_set(key.to_sym, value)
        end
      end
    end

    def method_missing(method, *args, &block)
      if method.to_s[-1] == '='
        var_name = method.to_s[0..-2].to_sym
        @variables[var_name] = args.first
      end
    end
  end
end
