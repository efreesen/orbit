module Orbit
  module Session
    class Cookie < Rack::Session::Cookie
      def initialize(controller, cookies, options={})
        @controller = controller
        @cookies = cookies
        options[:secret] = Orbit::Config.session_secret
        super(cookies, options)
      end

      def [](key)
        @cookies[key]
      end

      def []=(key, value)
        @cookies[key] = value
      end

      def delete(key, options)
      end
    end
  end
end
