require "rack"

require "./lib/orbit/singleton"
require "./lib/orbit/routing/route"
require "./lib/orbit/routing/path"
require "./lib/orbit/router"
require "./lib/orbit/config"
require "./lib/orbit/router"
require "./lib/orbit/controller"

module Orbit
  class Application < Singleton
    def initialize
      instantiate

      load_files
    end

    def load_files
      retries = 0
      files = Dir["#{Dir.pwd}/#{config.app_path}/**/*.rb"]

      while retries < 3 && files.any?
        files_with_exception = []
        
        files.each do |file|
          begin
            require file
          rescue NameError
            files_with_exception.push(file)
          end
        end

        files = files_with_exception
        retries += 1
      end

      if files.any?
        puts "[Warning] some files could not be loaded:"
        files_with_exception.each { |file| puts " - #{file}" }
        puts ""
      end
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
