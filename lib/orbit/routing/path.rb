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
          
        if name.respond_to?(:keys) && name.respond_to?(:match)
          [name, name.keys]
        elsif name.respond_to?(:names) && name.respond_to?(:match)
          [name, name.names]
        elsif name.respond_to? :match
          [name, []]
        else
          raise TypeError, name
        end
      end

      private
      attr_accessor :ignore, :keys

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
            # Key handling.
            #
            array = pattern(segment).gsub(/((:\w+)|\*)/).to_a
            pattern(segment).gsub(/((:\w+)|\*)/) do |match|
              if match == "*"
                keys << 'splat'
                "(.*?)"
              else
                keys << $2[1..-1]
                safe_ignore
              end
            end
          end
        end
      end

      # Special character handling.
      #
      def pattern(segment)
        segment.to_str.gsub(/[^\?\%\\\/\:\*\w]|:(?!\w)/) do |c|
          ignore.push(escaped(c).join) if c.match(/[\.@]/)
          patt = encoded(c)
          patt.gsub(/%[\da-fA-F]{2}/) do |match|
            match.split(//).map! {|char| char =~ /[A-Z]/ ? "[#{char}#{char.tr('A-Z', 'a-z')}]" : char}.join
          end
        end
      end

      def safe_ignore
        unsafe_ignore = []
        local_ignore = ignore.uniq.join.gsub(/%[\da-fA-F]{2}/) do |hex|
          unsafe_ignore << hex[1..2]
          ''
        end
        unsafe_patterns = unsafe_ignore.map! do |unsafe|
          chars = unsafe.split(//).map! do |char|
            if char =~ /[A-Z]/
              char <<= char.tr('A-Z', 'a-z')
            end
            char
          end

          "|(?:%[^#{chars[0]}].|%[#{chars[0]}][^#{chars[1]}])"
        end
        if unsafe_patterns.length > 0
          "((?:[^#{local_ignore}/?#%]#{unsafe_patterns.join()})+)"
        else
          "([^#{local_ignore}/?#]+)"
        end
      end
    end
  end
end
