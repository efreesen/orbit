module Orbit
  module Interceptors
    class Base < Rack::Response
      def initialize
        super
        @status = 302
      end

      def self.execute
        new.execute
      end

      def execute
        @intercept = redirect(intercept, status)
        

        @intercept ? self : nil
      end

      def intercept
        raise NotImplementedError.new("#intercept method must be implemented on #{self.class.name}")
      end
    end
  end
end
