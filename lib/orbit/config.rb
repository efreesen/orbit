require 'rack'
require 'rack/protection'

module Orbit
  class Config
    include Singleton
    attr_accessor :app_path, :logger_class, :path_class, :request_class, :response_class, :route_class, :router_class, :session_secret

    def initialize
      instantiate

      set_default_config
    end

    def set_default_config
      @app_path     = 'app'
      @session_secret = 'session_secret'

      # Classes
      @logger_class = Rack::Logger
      @path_class   = Orbit::Routing::Path
      @request_class = Orbit::Request
      @response_class = Orbit::Response
      @route_class  = Orbit::Routing::Route
      @router_class = Orbit::Router
    end

    def self.app_path
      @instance.app_path
    end

    def self.logger_class
      @instance.logger_class
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
