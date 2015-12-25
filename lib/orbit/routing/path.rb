module Orbit
  module Routing
    class Path
      attr_reader :name, :regex, :keys

      def initialize(path)
        @name = path
        @regex, @keys = compile
      end

      def get_params(path)
        matches = regex.match(path)
        {}.tap do |params|
          keys.each_with_index do |key, index|
            match_index = index + 1

            params[key.to_sym] = (matches[match_index]) if matches && matches.size > match_index
          end
        end
      end

      def compile
        return compile_string if name.respond_to? :to_str
          
        if is_hash?
          [name, name.keys]
        elsif is_object?
          [name, name.names]
        elsif name.respond_to? :match
          [name, []]
        else
          raise TypeError, name
        end
      end

      private
      attr_accessor :ignore, :keys

      def is_hash?
        name.respond_to?(:keys) && name.respond_to?(:match)
      end

      def is_object?
        name.respond_to?(:names) && name.respond_to?(:match)
      end

      def compile_string
        # Special case handling.
        #
        last_segment = segments.last

        if last_segment.match(/\[\^\\\./)
          parts = last_segment.rpartition(/\[\^\\\./)
          parts[1] = '[^'
          segments[-1] = parts.join
        end

        [/\A#{segments.join('/')}\z/, keys]
      end

      # Split the path into pieces in between forward slashes.
      # A negative number is given as the second argument of path.split
      # because with this number, the method does not ignore / at the end
      # and appends an empty string at the end of the return value.
      #
      def segments
        @segments = begin
          @keys = []
          @ignore = []

          name.split('/', -1).map! do |segment|
            pattern_keys, pattern_ignore, result = Pattern.resolve(segment)
            
            @keys += pattern_keys
            @ignore += pattern_ignore

            result
          end
        end
      end
    end
  end
end
