module Orbit
  class Router
    attr_accessor :routes

    def initialize
      @routes = {}
    end

    def self.instance
      @instance ||= new
    end

    def self.routes
      instance.routes
    end

    def self.add(verb, path, controller, action)
      instance.add(verb, path, controller, action)
    end

    def add(verb, path, controller, action)
      path = path.gsub('//', '/')

      routes[verb] ||= {}
      routes[verb][path] = { class: controller, action: action }
    end
  end
end
