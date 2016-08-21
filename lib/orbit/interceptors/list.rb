module Orbit
  module Interceptors
    class List
      include Singleton
      attr_reader :interceptors

      def initialize(interceptors=[])
        @interceptors = interceptors
      end

      def self.add_interceptor(path, interceptor_class, excludes=[])
        interceptor = Item.new(path, interceptor_class, excludes)

        instance.interceptors.push(interceptor)
      end

      def self.interceptors
        instance.interceptors
      end

      def interceptors_for_path(path)
        return [] unless path

        interceptors.select do |item|
          item.match_path?(path)
        end
      end

      def self.intercept_path(request)
        path = request.path_info

        instance.interceptors_for_path(path).each do |hash|
          result = hash.interceptor_class.execute(request)

          return result if result
        end

        nil
      end
    end
  end
end
