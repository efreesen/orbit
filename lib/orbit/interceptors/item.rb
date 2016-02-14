module Orbit
  module Interceptors
    class Item
      attr_accessor :path, :interceptor_class, :excludes

      def initialize(path, interceptor_class, excludes=[])
        @path = path
        @interceptor_class = interceptor_class
        @excludes = excludes
      end

      def match_path?(requested_path)
        requested_path.match("^#{path}") && !excludes.include?(requested_path)
      end
    end
  end
end
