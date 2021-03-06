module Orbit
  module Loaders
    class DirectoryLoader
      attr_reader :reloader

      def initialize
        base_path = "#{Dir.pwd}"
        @files = []

        if Orbit::Config.app_path.is_a?(String)
          @files.push Dir["#{base_path}/#{Orbit::Config.app_path}/**/*.rb"]
        else
          Orbit::Config.app_path.each do |path|
            @files.push Dir["#{base_path}/#{path}/**/*.rb"]
          end
        end

        @retries = 0
        @files = @files.flatten
        @reloader = FileReloader.new(files)
      end

      def self.load
        new.tap do |instance|
          instance.load
        end
      end

      def load
        files_with_exception = []

        while retries < 3 && files.any?
          @files = load_files
          @retries += 1
        end

        if files.any?
          puts "[Warning] some files could not be loaded:"
          files_with_exception.each { |file| puts "  - #{file}" }
          puts ""
        end
      end

      private
      attr_accessor :retries, :files

      def load_files
        [].tap do |files_with_exception|
          files.each do |file|
            begin
              require file
            rescue NameError
              files_with_exception.push(file)
            end
          end
        end
      end
    end
  end
end
