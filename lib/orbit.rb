require "rack"

require "./lib/orbit/singleton"
require "./lib/orbit/routing/route"
require "./lib/orbit/routing/path"
require "./lib/orbit/router"
require "./lib/orbit/config"
require "./lib/orbit/router"
require "./lib/orbit/base"

module Orbit
  class Application < Singleton
    def initialize
      instantiate

      Dir["#{Dir.pwd}/#{config.app_path}/**/*.rb"].each {|file| require file }
    end

    def self.config
      @config ||= Orbit::Config.instance
    end

    def config
      self.class.config
    end

    def self.configure
      yield config
    end

    def call(env)
      @request = Rack::Request.new(env)
      verb = @request.request_method
      requested_path = @request.path_info

      route = Config.router_class.match(verb, requested_path)

      if route
        route_params = route[:route].path.get_params(requested_path) || {}

        @request.params.merge!(route_params)

        result = route[:class].new(@request).send(route[:action])
        if result.class == String
          [200, {}, [result]]
        else
          result
        end
      else
        [404, {}, ["Oops! No route for #{verb} #{requested_path}"]]
      end
    end
  end
end
