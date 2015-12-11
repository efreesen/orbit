module Orbit
  class Singleton
    def self.instance
      @instance ||= new
    end

    def self.instance=(instance)
      @instance = instance
    end

    def self.instantiated?
      !!@instance
    end

    def instantiate
      raise ArgumentError.new("Cannot instantiate a Singleton twice") if self.class.instantiated?

      self.class.instance = self
    end
  end
end
