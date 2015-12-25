module Orbit
  module Singleton
    def self.included(base)
        base.extend(ClassMethods)
    end

    def instantiate
      raise ArgumentError.new("Cannot instantiate a Singleton twice") if self.class.instantiated?

      self.class.instance = self
    end

    module ClassMethods
      def instance
        @instance ||= new
      end

      def instance=(instance)
        @instance = instance
      end

      def instantiated?
        !!@instance
      end
    end
  end
end
