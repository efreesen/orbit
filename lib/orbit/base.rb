module Orbit
  module Controller
    class Base
      attr_reader :request

      def initialize(request)
        @request = request
      end

      def self.path(path)
        @base_path ||= superclass != Orbit::Controller::Base ? superclass.base_path : ''
        @base_path += path
      end

      def self.base_path
        @base_path ||= '/'
      end

      def self.routes
        @routes ||= {}
      end

      def self.get(action, &handler)
        add_route("GET", action, &handler)
      end

      def self.post(action, &handler)
        add_route("POST", action, &handler)
      end

      def self.put(action, &handler)
        add_route("PUT", action, &handler)
      end

      def self.patch(action, &handler)
        add_route("PATCH", action, &handler)
      end

      def self.delete(action, &handler)
        add_route("DELETE", action, &handler)
      end

      def self.head(action, &handler)
        add_route("HEAD", action, &handler)
      end

      def self.add_route(verb, action, &handler)
        method = (action == '/') ? "root" : action
        method = "#{verb.downcase}_#{method}".to_sym

        define_method method, &handler

        full_path = "#{@base_path}/#{action}"

        Orbit::Router.add(verb, full_path, self, method)
      end

      protected
      def params
        @request.params
      end
    end
  end
end
