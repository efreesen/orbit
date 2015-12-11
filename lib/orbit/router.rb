module Orbit
  class Router < Singleton
    attr_accessor :routes

    def initialize
      instantiate

      @routes = {}
    end

    def self.match(verb, path)
      instance.match(verb, path)
    end

    def match(verb, path)
      verb = verb.downcase.to_sym

      matching_route(verb, path)
    end

    def routes_for_verb(verb)
      @routes_for_verb ||= {}

      @routes_for_verb[verb] ||= routes.fetch(verb, {})
    end

    def matching_route(verb, path)
      routes_for_verb = routes_for_verb(verb)
      route = routes_for_verb.fetch(path, nil)

      unless route
        route = routes_for_verb.find do |pattern, options|
          options[:route].path.regex.match(path)
        end

        route = route.last
      end

      route
    end

    def self.routes
      instance.routes
    end

    def self.add(verb, path, controller, action)
      instance.add(verb, path, controller, action)
    end

    def add(verb, path, controller, action)
      verb = verb.downcase.to_sym
      path = path.gsub('//', '/')

      routes[verb] ||= {}
      routes[verb][path] = { class: controller, action: action, route: Orbit::Config.route_class.new(path) }

      re_sort_routes(verb)
    end

    private
    def re_sort_routes(verb)
      return unless routes[verb]

      root = []

      verb_routes = routes[verb].sort do |a, b|
        root.push(a) if a.first == "/"
        b.first <=> a.first
      end

      new_routes = {}

      (root + (verb_routes - root)).each { |key, value| new_routes[key] = value }

      routes[verb] = new_routes
    end
  end
end
