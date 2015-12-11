module Orbit
  class Config < Singleton
    attr_accessor :app_path, :path_class, :route_class, :router_class

    def initialize
      instantiate

      set_default_config
    end

    def set_default_config
      @app_path     = 'app'

      # Classes
      @path_class   = Orbit::Routing::Path
      @route_class  = Orbit::Routing::Route
      @router_class = Orbit::Router
    end

    def self.app_path
      @instance.app_path
    end

    def self.path_class
      @instance.path_class
    end

    def self.route_class
      @instance.route_class
    end

    def self.router_class
      @instance.router_class
    end
  end
end
