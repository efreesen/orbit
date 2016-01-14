module Orbit
  module Loaders
    class FileReloader
      def initialize(files)
        @files = files
        @last_updated = {}
        set_last_updated_dates
      end

      def set_last_updated_dates
        @files.each do |file|
          @last_updated[file] = File.mtime(file).to_i
        end
      end

      def reload
        @files.each do |file|
          was_updated = File.mtime(file).to_i > @last_updated[file]

          if was_updated
            p "reloading #{file}"
            
            load file
            @last_updated[file] = File.mtime(file).to_i
          end
        end
      end
    end
  end
end
