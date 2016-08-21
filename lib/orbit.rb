require "rack"

require "orbit/version"
require "orbit/singleton"

Dir[File.dirname(__FILE__) + "/orbit/**/*.rb"].each { |file| require file }

module Orbit
  class Application
    include Singleton
    attr_reader :builder

    def initialize
      instantiate

      setup_builder
      load_middleware

      loader = Loaders::DirectoryLoader.load
      @reloader = loader.reloader
    end

    def setup_builder
      @builder = Rack::Builder.new
    end

    def load_middleware
      builder.use Rack::MethodOverride
      builder.use Rack::Head
      builder.use Rack::Static, :urls => Config.static_files_path
      builder.use config.rack_logger_class

      use_session(config.session_options)
      use_protection
    end

    def use_session(options)
      options[:secret] = config.session_secret

      builder.use Rack::Session::Cookie, options
    end

    def use_protection
      options = {}
      options[:except] = Array options[:except]
      options[:except] += [:session_hijacking, :remote_token]
      options[:reaction] ||= :drop_session
      builder.use Rack::Protection, options
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

    def self.start
      instance || new

      instance.start
    end

    def start
      builder.run self
      builder
    end

    def call(env)
      @reloader.reload
      @request = config.request_class.new(env)
      verb = @request.request_method
      requested_path = @request.path_info

      route = Config.router_class.match(verb, requested_path)

      if route
        intercepted = Interceptors::List.intercept_path(@request)

        return intercepted if intercepted

        route_params = route[:route].path.get_params(requested_path) || {}

        @request.params.merge!(route_params)

        begin
          route[:class].execute_action(@request, route[:action])
        rescue Exception => exception
          Config.response_class.server_error(exception, verb, requested_path)
        end
      else
        Config.response_class.not_found(verb, requested_path)
      end
    end
  end
end
