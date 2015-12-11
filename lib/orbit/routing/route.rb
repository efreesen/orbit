module Orbit
  module Routing
    class Route
      attr_reader :path

      def initialize(path)
        @path = Config.path_class.new(path)
      end
    end
  end
end
