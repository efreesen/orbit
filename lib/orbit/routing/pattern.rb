module Orbit
  module Routing
    class Pattern
      def initialize(segment)
        @segment = segment
        @ignore = []
        @keys = []
      end

      def self.resolve(segment)
        new(segment).resolve
      end

      def resolve
        result = pattern.gsub(/((:\w+)|\*)/) do |match|
          if match == "*"
            keys << 'splat'
            "(.*?)"
          else
            keys << $2[1..-1]
            safe_ignore
          end
        end

        [keys, ignore, result]
      end

      private
      attr_accessor :segment, :keys, :ignore

      def pattern
        segment.to_str.gsub(/[^\?\%\\\/\:\*\w]|:(?!\w)/) do |char|
          ignore.push(escaped(char).join) if char.match(/[\.@]/)
          define_pattern(char)
        end
      end

      def define_pattern(ch)
        encoded(ch).gsub(/%[\da-fA-F]{2}/) do |match|
          match.split(//).map! {|char| char =~ /[A-Z]/ ? "[#{char}#{char.tr('A-Z', 'a-z')}]" : char}.join
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
