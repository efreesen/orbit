module Orbit
  module Interceptors
    class Base < Rack::Response
      def initialize
        super
        redirect_status 302
      end

      def self.execute
        new.intercept
      end

      def execute
        @intercept = redirect(intercept, status)

        @intercept ? self : nil
      end

      def intercept
        raise NotImplementedError.new("#intercept method must be implemented on #{self.class.name}")
      end

      def redirect_status(code)
        @status = code
      end
    end
  end
end
