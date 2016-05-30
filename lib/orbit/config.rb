require 'rack'
require 'rack/protection'
require 'logger'

module Orbit
  class Config
    include Singleton

    attr_accessor :app_path, :static_files_path, :rack_logger_class,
                  :logger_class, :log_level, :log_appname, :log_file,
                  :path_class, :request_class, :response_class, :route_class,
                  :router_class, :session_secret

    def initialize
      instantiate

      set_default_config
    end

    def set_default_config
      @app_path          = 'app'
      @static_files_path = ["/media"]
      @session_secret    = 'session_secret'

      # Logging options
      @logger_class = Logger
      @log_level = Logger::DEBUG
      @log_file = STDOUT
      @log_appname = 'Orbit App'

      # Classes
      @rack_logger_class = Rack::Logger
      @path_class   = Orbit::Routing::Path
      @request_class = Orbit::Request
      @response_class = Orbit::Response
      @route_class  = Orbit::Routing::Route
      @router_class = Orbit::Router
    end

    def self.app_path
      @instance.app_path
    end

    def self.static_files_path
      @instance.static_files_path
    end

    def self.logger_class
      @instance.logger_class
    end

    def self.logger
      @_logger ||= begin
        logger_class.new(@instance.log_file).tap do |logger|
          logger.level = @instance.log_level
          logger.progname = @instance.log_appname
        end
      end
    end

    def self.path_class
      @instance.path_class
    end

    def self.request_class
      @instance.request_class
    end

    def self.response_class
      @instance.response_class
    end

    def self.route_class
      @instance.route_class
    end

    def self.router_class
      @instance.router_class
    end

    def self.session_secret
      @instance.session_secret
    end
  end
end
